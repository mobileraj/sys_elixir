Here, I will compare the aspects various languages for the task of building the Event Engine.
The languages which will be compared are:
- Erlang
- Elixir
- Java

## Erlang
Erlang was originally developed in the 1980s as a niche language for the telecom industry. At the time, there was no language/platform which effectively met the requirements of telecom programs (such as support for high numbers of connections on the same device, fault tolerance/isolation between different calls, etc.). 

---
## Elixir
Elixir was developed and released around 2010. Elixir was built on the same runtime as Erlang (and the two are interoperable) and provides very similar semantics. Besides syntax differences, there a few important features: lisp-like macros;

--- 
## Java
Java is a general purpose object-oriented (imperative) language.  It is primarily designed as a synchronous language.
Java was originally built in the 1990s by Sun Microsystems. It's main marketing point was its VM ("compile once, run anywhere"), which allowed the same "bytecode" to be run and distributed on vastly different devices and architectures. 
#### Community
Java has a very broad range of well-maintained tools and packages, along with a large community of support. Thus, implementing certain features might be easier in Java. More developers could also contribute to and maintain the codebase of the engine. On the other hand, more developers would likely mean less specialized and lower quality developers for this type of application.
#### Event Support
Java provides basic built-in support for events, although this support is relatively minimal (providing generic `EventObject` and `EventListener` base classes). These are very primitive and inherently synchronous, likely proving little use.
#### Concurrency
Java provides access to heavyweight (os-level), shared-memory threads. For reasons discussed in previous assignments, these are not ideal for distributed applications which require a high number of concurrent connections, so Java's threads and other builtin concurrency support probably would not be used.
There is an interesting java extension library called Kilim (see http://kilim.malhar.net/) which implements a highly similar design to Erlang processes. The authors of the library even claimed that, within a local environment, **they were able to surpass Erlang's runtime in performance.**

## Lisp ?
----
# My Pick
First I will go over the different categories, along with my own thoughts. 