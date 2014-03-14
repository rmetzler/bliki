# Stop Building Synchronous Web Containers

Seriously, stop it. It's surreally difficult to build a sane ansynchronous service on top of a synchronous API, but building a synchronous service on top of an asynchronous API is easy.

* WSGI: container calls the application as a function, and uses the return
  value for the response body. Asynchronous apps generally use a non-WSGI
  base (see for example [Bottle](http://bottlepy.org/docs/dev/async.html)).

* Rack: container calls the application as a method, and uses the return
  value for the complete response. Asynchronous apps generally use a non-Rack
  base (see [this Github ticket](https://github.com/rkh/async-rack/issues/5)).

* Java Servlets: container calls the application as a method, passing a
  callback-bearing object as a parameter. The container commits and closes
  the response as soon as the application method returns. Asynchronous apps
  can use a standard API that operates by _re-invoking_ the servlet method as
  needed.

* What does .Net do?

vs

* ExpressJS: container calls the application as a function, passing a
  callback-bearing object as a parameter. The application is responsible for
  indicating that the response is complete.

## Synchronous web containers are bad API design

* Make the easy parts easy (this works)

* Make the hard parts possible (OH SHIT)

## Writing synchronous adapters for async APIs is easy

    def adapter(request, response_callback):
        synchronous_response = synchronous_entry_point(request)
        return response_callback(synchronous_response)

Going the other way is more or less impossible, which is why websocket
support, HTML5 server-sent event support, and every other async tool for the
web has an awful server interface.
