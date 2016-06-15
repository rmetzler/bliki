# A Compiler For The Web

“Compilation” - the translation of code from one language into another - is the manufacturing step of software development. During compilation, the source code, which is written with a human reader in mind and which uses human-friendly abstractions, becomes something the machine can execute. It is during this manufacturing step that a specific design (the application's source code) is realized in a form that can be delivered to users (or rather, executed by their browsers).

Historically, Javascript has had no compilation process. Design and manufacturing were a single process: the browser environment allows developers to write scripts exactly as they'll be delivered by the browser, with no intervening steps. That's a useful property: most notably, it enables the “edit, save, and reload” iteration process that's so popular and so pleasant to work with. However, Javascript's target environment has a few weaknesses that limit the scale of the project you can write this way:

* There's no built-in way to do modular development. All code shares a single, global namespace, and all dependencies have to be resolved and loaded - in the right order - by the developer. If you include third-party code in your project, as a developer you have to obtain that code from somewhere, and insert that into the page. You have to constantly evaluate the tradeoffs between the convenience of third-party content delivery networks versus the reliability of including third-party code direclty in your app's files as-is versus the performance of concatenating it and minifying it into your main script.

* Javascript as a language evolves much faster than browsers do. (Given the break-neck pace of browser evolution, that's really saying something.) Programs written using newer Javascript features, such as the `import` statement (see above) or the compact arrow notation for function literals, require some level of translation before a browser can make sense of the code. Developers targetting the browser directly must balance the convenience offered by new language features against the operational complexity of the translation process.

Historically, the Javascript community has been fairly reluctant to move away from the rapid iteration process provided by the native Javascript ecosystem in the browser. In the last few years, web application development has reached a stage of maturity where those two problems have much more influence over culture and decision-making than they have in the past, so that attitude has started to change. In the last few years we've seen the rise of numerous Javascript translators (compilers, by another name), and frameworks for executing those translators in a repeatable, reproducible way.

# An Aside About Metaphors

Physical manufacturing processes tend to have cost structures where the design step is, unit-wise, expensive, but happens once, while manufacturing is unit-wise quite cheap, but happens endlessly often over the life of the product. Software manufacturing processes are deeply weird by comparison. In software, the design step is, unit-wise, _even more_ expensive, and it happens repeatedly to what is notionally the same product, over most of its life, while the manufacturing step happens a single time, for so little cost that it's rarely worth accounting for.

It's taken a long time to teach manufacturing-trained business people to stop treating development - the design step - like a manufacturing step, but we're finally getting there. Unfortunately, unlike physical manufacturing, software manufacturing is so highly automated that it produces no jobs, even though it's complex enough to support an entire ecosystem of sophisticated, high-quality tools. A software “factory,” for all intents and purposes, operates for free

# Webpack

Webpack is a [compiler system](https://www.destroyallsoftware.com/talks/the-birth-and-death-of-javascript) for the web.

Webpack's compilation process ingests human-friendly source code in a number of languages: primarily Javascript, but in principle any language that can be run by _some_ service the browser provides, including CSS, images, text, and markup. With the help of extensions, it can even ingest things the browser _can't_ serve, such as ES2015 Javascript, or Sass files. It emits, as a target, “bundles” of code which can be loaded using the native tools provided by the browser platform: script tags, stylesheet links, and so on.

It provides, out of the box, solutions to the two core problems of browser development. Webpack provides a lightweight, non-novel module system to allow developers to write applications as a system of modules with well-defined interfaces, even though the browser environment does not have a module loader. Webpack also provides a system of “loaders” which can apply transformations to the input code, which can include the replacement of novel language features with their more-complex equivalents in the browser.

Webpack differentiates itself from its predecessors in a few key ways:

* It targets the whole browser runtime, rather than Javascript specifically. This allows it to include non-Javascript resources, such as stylesheets, in a coherent and consistent way; having a single tool that processes all of your source assets drastically reduces the complexity costs developers have to spend to maintain their asset processing system.

    Targetting the browser as a whole also allows Webpack to offer some fairly sophisticated features. Code splitting, for example, allows developers to partition their code so that rarely-used sections are only loaded when actually needed to handle a situation.

* Webpack's output format is, by default, extremely readable and easy to diagnose. The correspondences between source code and the running application are clear, which allows defects found in the running application to be addressed in the original code without introducing extra effort to work backwards from Webpack's output. (It also handles source maps quite well.)

* Webpack's hooks into the application's source code are straight-forward and non-novel. Webpack can ingest sources written using any of three pre-existing Javascript module systems - AMD, CommonJS, and UMD - without serious (or, often, any) changes. Where Webpack offers novel features, it offers them as unobtrusive extensions of existing ideas, rather than inventing new systems from scratch.

* Finally, Webpack's human factors are quite good. The Webpack authors clearly understand the value of the human element; the configuration format is rich without being overly complex, and the watch system works well to keep the “edit, save, and reload” workflow functional and fast while adding a compile step to the Javascript development process.

Webpack is not without tradeoffs, however.

* Webpack's design makes it difficult to link external modules without copying them into the final application. While a classic Javascript app can, for example, reuse a library like jQuery from a CDN, a Webpack application effectively must contain its own copy of that library. There are workarounds for this, such as presuming that the `$` global will be available even without an appropriate `require`, but they're awkward to work with and difficult to reason about in larger codebases.

* The module abstraction can hide a really amazing amount of [code bloat](http://idlewords.com/talks/website_obesity.htm) from developers, and Webpack doesn't provide much tooling for diagnosing or eliminating that bloat. For example, on a personal project, adding `var _ = require('lodash')` to my app caused the Webpack output to grow by a whopping half a megabyte. Surprise!

    Worse, given the proliferation of modules on NPM (which are almost all installable via Webpack), an app using a higher-level framework and a few third-party libraries is almost certain to contain multiple modules with overlapping capabilities or even overlapping APIs. When you have to vet every module by hand, this problem becomes apparent to the developer very quickly, but when it's handled automatically, it's very easy for module sets to grow staggeringly large.

* Webpack doesn't eliminate modules during compilation. Instead, it injects a small module loader into your app (the “runtime”, by analogy with the runtime libraries for other languages) to stitch your modules together inside the browser. This code is generated at compile time, and can contain quite a bit of logic if you use the right plugins. In most cases, the cost of sending the Webpack runtime to your users is small, but it's worth being aware of.

* Finally, Webpack's configuration system is behaviour-oriented rather than process-oriented, which gives it a very rigid structure. Most of the exceptions from its canned process are either buried in loaders or provided by plugins, so the plugin system ends up acting as a way to wedge arbitary complexity back in after Webpack's core designed it out.

On the balance, I've been very impressed with Webpack, and have found it to be a pretty effective way to work with browser applications. If you're not using something like Ember that comes with a pre-baked toolkit, then you can probably improve your week by using Webpack to build your Javascript apps.

# Tiny Decisions

To give a sense of what using Webpack is like, here's my current `webpack.config.js`, annotated with the decisions I've made so far and some of the rationales behind them.

This setup allows me to run `webpack` on the CLI to compile my sources into a working app, or `webpack --watch` to leave Webpack running to recompile my app for me as I make changes to the sources. The application is written using the React framework, and uses both React's JSX syntax for components and many ES2105 language features that are unavailable in the browser. It also uses some APIs that are available in some browsers but not in others, and includes polyfills for those interfaces.

You can see the un-annotated file [on Github](https://github.com/unreasonent/distant-shore-html5-client/blob/a273deb87823f4bea0d1407b9752cea5bf632730/webpack.config.js).

    'use strict';

    var path = require('path');
    var keys = require('lodash.keys');

I want to call this `require` out - I've used a similar pattern in the actual app code. Lodash, specifically, has capability bundles that are much smaller than the full Lodash codebase, and using them is exactly how I kept the 500kb library down to a reasonable size in my app.

    var webpack = require('webpack');
    var HtmlWebpackPlugin = require('html-webpack-plugin');

    var thisPackage = require('./package.json');

We'll see where all of these requires get used later on.

    module.exports = {
      entry: {
        app: ['babel-polyfill', 'whatwg-fetch', "app.js"],
        vendor: keys(thisPackage.dependencies),
      },

Make two bundles:

* One for application code (linked with various polyfills to provide ES6 features as if the app were running in a native ES6 environment).

* One for “vendor” code, computed from `package.json`, so that app changes don't _always_ force every client to re-download all of React + Lodash + yada yada. In `package.json`, the `dependencies` key holds only dependencies that should appear in the vendor bundle. All other deps (including polyfill dependencies for the `app` entry point) appear in `devDependencies`, instead. Subverting the dependency conventions like this lets me specify the vendor bundle exactly once, rather than having to duplicate part of the dependency list here in `webpack.config.js`.

We actually invent a third bundle, below. I'll talk about that when I get there.

A lot of this is motivated by the gargantuan size of the libraries I'm using. The vendor bundle is approximately two megabytes, so reusing the vendor bundle between versions helps cut down on the number of times users have to download all of that code. I need to address this, but being conscious of browser caching behaviours helps for now.

      resolve: {
        root: [
          path.resolve("js"),
        ],

Some project layout:

* `PROJECT/js`: Javascript and Javascript-like source code.

I kept it flat. A `src` or `src/main` prefix could be useful, but the value is limited and we're not tied to pre-existing practices, here.

        // Automatically resolve JSX modules, like JS modules.
        extensions: ["", ".webpack.js", ".web.js", ".js", ".jsx"],
      },

This is a React app, so I've added `.jsx` to the list of default suffixes. This allows constructs like `var MyComponent = require('MyComponent')` to behave as developers expect, without requiring the consuming developer to keep track of which language `MyComponent` was written in.

I could also have addressed this by treating all `.js` files as JSX sources. This felt like a worse option; the JSX preprocessing step _looks_ safe on pure-JS sources, but why worry about it when you can be explicit about which parser to use?

      output: {
        path: path.resolve("dist/js"),
        publicPath: "/js/",

More project layout:

* `PROJECT/dist`: the content root of the web app. Files in `/dist` are expected to be served by the web server or placed in a CDN, at the root path.

    * `PROJECT/dist/js`: Browser Javascript files for the app. A separate directory makes it easier to set JS-specific rules in web servers, which we exploit in a moment.

I've set `publicPath` so that dynamically-loaded chunks end up with the right URLs, too.

        filename: "[name].[chunkhash].js",

Include a stable version hash in the name of each output file, so that we can safely set `Cache-Control` headers to have browsers store JS for a long time without fucking up the ability to redeploy the app. Setting a long cache expiry for these means that the user only pays the transfer cost (power, bandwidth) for the script files on the first pageview after a deployment, or after their browser cache forgets the site.

For each bundle, so long as the contents of that bundle don't change, neither will the hash. Since we split vendor code into its own chunk, _often_ the vendor bundle will end up with the same hash even in different versions of the app, further cutting down the number of times the user has to download the (again, massive) dependencies.

      },

      module: {
        loaders: [
          {
            test: /\.js$/,
            exclude: /node_modules/,
            loader: "babel",
            query: {
              presets: ['es2015'],
              plugins: ['transform-object-rest-spread'],
            },
          },

You don't need this if you don't want it, but I've found ES2015 to be a fairly reasonable improvement over Javascript. Using an exclude, we treat _local_ JS files as ES2015 files, translating them with Babel before including them in the bundle; I leave modules included from third-party dependencies alone, because I have no idea whether I should trust Babel to do the right thing with someone else's code, or whether it already did the right thing.

I've added `transform-object-rest-spread` because the app I'm working on makes extensive use of `return {...state, modified: field}` constructs and that syntax is way easier to work with than the equivalent `return Object.assign({}, state, {modified: field})`.

          {
            test: /\.jsx$/,
            exclude: /node_modules/,
            loader: "babel",
            query: {
              presets: ['react', 'es2015'],
              plugins: ['transform-object-rest-spread'],
            },
          },

Do the same for _local_ `.jsx` files, but additionally parse them using Babel's React driver, to translate `<SomeComponent />` into approprate React calls. Once again, leave the parsing of third-party code alone.

          {
            test: /\.yaml$/,
            exclude: /node_modules/,
            loader: "json!yaml",
          },

I have some static data files, which are YAML. This allows me to load them at build time using `var data = require('some-data.yaml')`; the chained loaders first convert YAML to JSON, then return the resulting JSON object directly from `require`.

          {
            test: /node_modules[\\\/]auth0-lock[\\\/].*\.js$/,
            loaders: [
              'transform-loader/cacheable?brfs',
              'transform-loader/cacheable?packageify',
            ],
          },
          {
            test: /node_modules[\\\/]auth0-lock[\\\/].*\.ejs$/,
            loader: 'transform-loader/cacheable?ejsify',
          },
          {
            test: /\.json$/,
            loader: 'json',
          },

These loaders are specific to [Auth0](https://github.com/auth0/lock#webpack)'s Javascript libraries. I've done this so that all of the app's code is delivered from a single origin (either the web server directly, or via a content delivery network), rather than being gathered from various CDNs and third-party sites.

        ],
      },

      plugins: [
        new webpack.optimize.OccurrenceOrderPlugin(/* preferEntry=*/true),

This plugin causes webpack to order bundled modules such that the most frequently used modules have the shortest identifiers (lexically; 9 is shorter than 10 but the same length as 2) in the resulting bundle. Providing a predictable ordering is irrelevant semantically, but it helps keep the vendor bundle ordered predictably.

        new webpack.optimize.CommonsChunkPlugin({
          name: 'vendor',
          minChunks: Infinity,
        }),

Move all the modules the `vendor` bundle depends on into the `vendor` bundle, even if they would otherwise be placed in the `app` bundle. (Trust me: this is a thing. Webpack's algorithm for locating modules is surprising, but consistent.)

        new webpack.optimize.CommonsChunkPlugin({
          name: 'boot',
          chunks: ['vendor'],
        }),

Hoo boy. This one's tricky to explain, and doesn't work very well regardless.

The facts:

1. This creates the third bundle (“boot.[chunkhash].js”) I mentioned above, and makes the contents of the `vendor` bundle “children” of it.

2. This plugin will also put the runtime code, which includes both its module loader (which is the same from build to build) and a table of bundle hashes (which is not, unless the bundles are the same), in the root-most bundle.

3. I really don't want the hash of the `vendor` bundle changing without a good reason, because the `vendor` bundle is grotesquely bloated.

This code effectively moves the Webpack runtime to its own bundle, which loads quickly (it's only a couple of kilobytes long). This bundle's hash changes on nearly every build, so it doesn't get reused between releases, but by moving that change to this tiny bundle, we get to reuse the vendor bundle as-is between releases a lot more often.

Unfortunately, code changes in the app bundle _can_ cause the vendor bundle's constituent modules to be reordered or renumbered, so it's not perfect: sometimes the `vendor` bundle's hash changes between versions even though it contains an identical module list with different identifiers. So it goes: the right fix here is probably to shrink the bundle and to re-merge it into the `app` bundle.

        new HtmlWebpackPlugin({
          title: "Distant Shore",
          // escape the js/ subdir
          filename: '../index.html',
          template: 'html/index.html',
          inject: 'head',
          chunksSortMode: 'dependency',
        }),

Generate the entry point page from a template (`PROJECT/html/index.html`), rather than writing it entirely by hand.

You may have noticed that _all three_ of the bundles include generated chunk hashes in their filenames. This plugin generates the correct `<script>` tags to load those bundles and places them in `dist/index.html`, so that I don't have to manually correct the index page every time I rebuild the app.

One thing to note: I've moved the script tags from the generator's default of “immediately before `</body>`” back to “immediately before `</head>`.” This is a matter of personal preference; the app bundle contains some logic (not shown here) to run the app only after the DOM has fully loaded.

      ],

      devtool: '#source-map',

Make it possible to run browser debuggers against the bundled code as if it were against the original, unbundled module sources. This generates the source maps as separate files and annotates the bundle with a link to them, so that the (bulky) source maps are only downloaded when a user actually opens the debugger. (Thanks, browser authors! That's a nice touch.)

The source maps contain the original, unmodified code, so that the browser doesn't need to have access to a source tree to make sense of them. I don't care if someone sees my sources, since the same someone can already see the code inside the webpack bundles.

    };

Things yet to do:

* Figure out how to have webpack build a stylesheet bundle, too. The `ExtractTextPlugin` is supposed to make it pretty feasible, but I have some Bootstrap-related roadblocks to solve.

    * Then I can apply the same caching dynamics to stylesheets that I do to Javascript. Since I'm using Bootstrap, the stylesheet is gargantuan.

* Webpack 2's “Tree Shaking” mode exploits the static nature of ES2015 `import` statements to fully eliminate unused symbols from ES2105-style modules. This could potentially cut out a lot of the code in the `vendor` bundle.

