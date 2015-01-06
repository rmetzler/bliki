# Webapps From The Ground Up

What does a web application do? It sequences side effects and computation. (This should sound familiar: it's what _every_ program does.)

Modern web frameworks do their level best to hide this from you, encouraging code to freely intermix computation, data access, event publishing, logging, responses, _asynchronous_ responses, and the rest. This will damn you to an eternity of debugging.
