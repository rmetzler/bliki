# Configuring Browser Apps

I've found myself in he unexpected situation of having to write a lot of
browser apps/single page apps this year. I have some thoughts on configuration.

## Why Bother

* Centralize environment-dependent facts to simplify management & testing
* Make it easy to manage app secrets. (“Secrets”? What this means in a browser app is a bit different.)
* Keep config data & secrets out of app's source control
* Integration point for external config sources (Aerobatic, Heroku, etc)
* The forces described in [12 Factor App:
  Dependencies](http://12factor.net/dependencies) and, to a lesser extent, [12
  Factor App: Configuration](http://12factor.net/config) apply just as well to
  web client apps as they do to freestanding services.

## What Gets Configured

Yes:

* Base URLs of backend services
* Tokens and client IDs for various APIs

No:

* “Environments” (sorry, Ember folks - I know Ember thought this through carefully, but whole-env configs make it easy to miss settings in prod or test, and encourage patterns like “all devs use the same backends”)

## Delivering Configuration

There are a few ways to get configuration into the app.

### Globals

    <head>
        <script>window.appConfig = {
            "FOO_URL": "https://foo.example.com/",
            "FOO_TOKEN": "my-super-secret-token"
        };</script>
        <script src="/your/app.js"></script>
    </head>

* Easy to consume: it's just globals, so `window.appConfig.foo` will read them.
    * This requires some discipline to use well.
* Have to generate a script to set them.
    * This can be a `<script>window.appConfig = {some json}</script>` tag or a standalone config script loaded with `<script src="/config.js">`
    * Generating config scripts sets a minimum level of complexity for the deployment process: you either need a server to generate the script at request time, or a preprocessing step at deployment time.
    * It's code generation, which is easy to do badly. This is probably safe:

            var config = `<script>window.appConfig = ${JSON.stringify(appConfig)};</script>`;

      Good luck proving it.

### Data Attributes and Link Elements

    <head>
        <link rel="foo-url" href="https://foo.example.com/">
        <script src="/your/app.js" data-foo-token="my-super-secret-token"></script>
    </head>

* Flat values only. This is probably a good thing in the grand, since flat configurations are easier to reason about and much easier to document, but it makes namespacing trickier than it needs to be for groups of related config values (URL + token for a single service, for example).
* Have to generate the DOM to set them.
    * This is only practical given server-side templates or DOM rendering. You can't do this with bare nginx, unless you pre-generate pages at deployment time.

### Config API Endpoint

    fetch('/config') /* {"FOO_URL": …, "FOO_TOKEN": …} */
        .then(response => response.json())
        .then(json => someConfigurableService);

* Works even with “dumb” servers (nginx, CloudFront) as the endpoint can be a generated JSON file on disk. If you can generate files, you can generate a JSON endpoint.
* Requires an additional request to fetch the configuration, and logic for injecting config data into all the relevant configurable places in the code.
    * This request can't happen until all the app code has loaded.
    * It's very tempting to write the config to a global. This produces some hilarious race conditions.

### Cookies

See for example [clientconfig](https://github.com/henrikjoreteg/clientconfig):

    var config = require('clientconfig');

* Easy to consume given the right tools; tricky to do right from scratch.
* Requires server-side support to send the correct cookie. Some servers will allow you to generate the right cookie once and store it in a config file; others will need custom logic, which means (effectively) you need an app server.
* Cookies persist and get re-sent on subsequent requests, even if the server stops delivering config cookies. Client code has to manage the cookie lifecycle carefully (clientconfig does this automatically)
* Size limits constrain how much configuration you can do.
