Here, I will compare the aspects various languages for the task of building the Event Engine.
The languages which will be compared are:
- Erlang
- Elixir
- Java
*See https://github.com/Healthcare-EQ/siyo-patient/blob/main/designs/Events.md for an example of an events specification*
## Erlang
Erlang was originally developed in the 1980s as a niche language for the telecom industry. At the time, there was no language/platform which effectively met the requirements of telecom programs (such as support for high numbers of connections on the same device, fault tolerance/isolation between different calls, etc.). See [erlang.org](https://erlang.org)
#### Community
Being a niche language, Erlang has considerably less support than general purpose languages. It can integrate with hex.pm, a package manager made for the BEAM (although this pm is geared towards elixir). See the forum: https://erlangforums.com/.
#### Event Support
The OTP provides many common behaviors that (such as `gen_server` and `gen_fsm`) which are intended to address general solutions that occur in a wide range of problems. For example, the supervisor tree pattern is used to create highly fault-tolerant (and clean) designs for programs which implement a pattern similar to that of servers. OTP is known for being clean and well-designed; in [this poll](https://ferd.ca/poll-results-erlang-maintenance.html), Erlang developers ranked "respect of OTP principles" as the third most important factor in maintenance, more important than the presence tests or high-level documentation.
More specifically for events, the OTP includes the `gen_event` behavior. This behavior allows the program to create and serve event manager, to which event handlers can be added or removed. In addition, the process model of Erlang allows for event to be easily send and received (using language constructs such as the receive block). Thus, both the language and library of Erlang/OTP drastically simplify the task of creating an event engine by providing a natural clean structure/organization for the event system. 
Erlang also provides a [feature for distributed time](https://www.erlang.org/doc/apps/erts/time_correction.html) which could be used to determine the ordering of events within the engine. 
Erlang also has realtime capabilities baked into the language, which would be crucial for events which need to be instantly received.
#### Concurrency 
The concurrency model (often called the actor model) is where a large number isolated, lightweight processes communicate with a select few through message passing. This is in direct contrast to a more traditional thread-based model, where heavy-weight process contain multiple threads that live within a shared-memory environment. The benefits of this model have already been enumerated in previous documents/lessons (see in particular [The Importance of Erlang](https://github.com/mobileraj/sys_elixir/blob/main/les0/COMPLETED/Importance%20of%20Erlang%20(Joe's%20thesis).md)), and so will not be discussed here. This model overall benefits the fragmented, many-connections model for the event engine, in a similar way that it benefits telecom.
#### Deployment
Erlang needs to be run on a machine with the BEAM virtual machine (along with various tooling/administration).  It is typically built/developed using a tool such as [rebar](https://github.com/erlang/rebar3). Erlang has much less automated/cloud deployment support, being a niche language. Thus, it might be easier to deploy a Java program.
However, it is important to note that Erlang provides a powerful deployment feature: hot module swapping. This allows the event engine to be updated and released without any schedule down time or connections lost. This is a very important feature to the event engine (especially for a critical app like FUH), as it allows the event "webbing" to be updated without interrupting the doc's actions/calls/appointments. See also one developer opinion [here](https://ferd.ca/a-pipeline-made-of-airbags.html).
#### Additional Features
Erlang, being functional, relies heavily on pattern matching (which is simplified with its usage of tuples and atoms, see [here]()). Pattern matching allows 
One of Erlangs most important features (which is baked into the concurrency model) is its properties of fault tolerance and error isolation. An error in one process/connection would not affect the rest of the system. Along with the supervisor tree pattern, this could be used to ensure the "durability" of events
Erlang is also built with distributed systems in mind. Nodes on a single device are treated the same way as nodes split across multiple devices, making horizontal expansion of the server and system relatively easy. This feature of the language lends itself to a microservice architecture without requiring a pre-planned design; nodes which are all part of one program on the same machine can easily be separated on different machines.
Finally, Erlang comes with a distributed database management system (mnesia) which might be useful when storing information for processing nodes and event listeners within the system. 

---
## Elixir
Elixir was developed and released around 2010. Elixir was built on the same runtime as Erlang (and the two are interoperable) and provides very similar semantics. There are two main differences (see [this interview](https://youtu.be/ympW2bPGwDM?t=600)):
- Modern, easier syntax based on Ruby
- Lisp-like macros for metaprogramming.
Since most of the features and major benefits of Elixir are also present in Erlang, they will not be re-enumerated here. Instead, this section serves primarily to contrast Elixir with Erlang.
See https://elixir-lang.org
#### Community
Elixir has a similar community to Erlang (although according to  [stack overflow]( [How Complex Systems Fail](http://web.mit.edu/2.75/resources/random/How%20Complex%20Systems%20Fail.pdf) by Richard I. Cook), Elixir is used by twice as many developers) They have an active forum https://elixirforum.com and a package manager hex.pm.
#### Deployment
Elixir comes with the mix build tool, which makes build, packaging and deployment easier. Elixir also supports hot-swapping.
#### Event Support
(*In addition to Erlang's event support*) There is the [gen_stage](https://hexdocs.pm/gen_stage/GenStage.html) library (along with many others on hex.pm) which would likely simplify the creation of the event system by providing the basic behaviors for data processing and piping.
We could possibly use Phoenix's pub/sub as well.
#### Additional features
Elixir's major advantage over Erlang is its meta-programming capabilities, through macros. Elixir's macros allow for a hygenic, Lisp-like enhancement of the language (which enables the creation of [Domain Specific Languages](https://hexdocs.pm/elixir/main/domain-specific-languages.html)). Although this is a potentially dangerous feature, it could be used for a cleaner and more powerful design and architecture.
One key difference between Elixir and Java (along with similar OOP class-based languages) is its organizational structure (referencing jose's talk [here](https://www.youtube.com/watch?v=agkXUp0hCW8), particularly starting at 22:00). In java, objects couple three dimensions: behavior, data, and mutability. Behavior is the functionality of the object (which includes both the interface/contract and the implementation). State are the fields/data of the object. Mutability refers to the concept of time; an object at one point in time will have state at a different point in time. In Elixir, this coupling is broken; modules/behaviors implement the behavior, data and protocols implements the state, and processes implement the concept of time/mutability. This removes many of the necessary design patterns and class-based headaches to work around this coupling, allowing for cleaner design.

--- 
## Java
Java is a general purpose object-oriented (imperative) language.  It is primarily designed as a synchronous language.
Java was originally built in the 1990s by Sun Microsystems. It's main marketing point was its VM ("compile once, run anywhere"), which allowed the same "bytecode" to be run and distributed on vastly different devices and architectures. 
See https://www.java.com/en/
#### Community
Java ranks 7th as the most used programming language (according to [stack overflow](https://survey.stackoverflow.co/2024/technology#1-programming-scripting-and-markup-languages)) as opposed to Elixir, which ranked about 29th. Java has a very broad range of well-maintained tools and packages, along with a large community of support. Thus, implementing certain features might be easier in Java, given the amount of community support. More developers could also contribute to and maintain the codebase of the engine. 
#### Event Support
Java provides basic built-in support for events, although this support is relatively minimal (providing generic `EventObject` and `EventListener` base classes; see [here](https://medium.com/javajams/the-ultimate-guide-to-event-driven-programming-in-java-624c28bbfdf6) and [the docs](https://docs.oracle.com/javase/8/docs/api/java/util/EventObject.html)). These are very primitive and inherently synchronous, so may not be of much use.
#### Deployment
Java runs on the JVM. Being so widely supported, deployment would be a relatively easier task.
#### Concurrency
Java provides access to heavyweight (os-level), shared-memory threads. For reasons discussed in previous assignments, these are not ideal for distributed applications which require a high number of concurrent connections, so Java's threads and other builtin concurrency support probably would not be used.
There is an interesting java extension library called Kilim (see http://kilim.malhar.net/) which implements a highly similar design to Erlang processes. The authors of the library even claimed that, within a local environment, they were able to surpass Erlang's runtime in performance.
#### Additional Features
In contrast to Elixir and Erlang, Java provides a type system based on its class hierarchy. This enables greater static analysis, leading to less bugs and more well-defined contracts. 

----
# My Pick
I've already partially compared the languages in the body text above. Here, I will go over the features which I think are especially pertinent to the development of the event engine. I will start by comparing Erlang to Java. 

Being a niche language, Erlang has a small community and a lower level of support compared to Java. However, Erlang also comes with a very powerful process model, which fits the goals of the event engine very well. This is relatively unsurprising given Erlang's history as a telecom language. Telecom systems require devices to facilitate communication between thousands of different nodes without failure or long system-wide downtime. Similarly, the event engine will need to be able to mediate between thousands of event listeners and producers, efficiently pipelining and filtering events. While kilim implements a similar process model for Java, it is both relatively obscure and does not have the same library support that Erlang does built around its process model. Erlang comes packaged with the OTP library, which facilitates a clean overall architecture for the event engine. Additionally, Erlang comes with hot-swapping, which provides a major availability and development benefit over Java.

Another interesting difference between Erlang and Java is typing. Erlang is dyanmically typed language (nor do variables, although variables can't be reassigned). Java does have a type system which allow for static analysis and easier error detection. However, for the event engine, a type system would largely be unnecessary, especially due to the dynamic nature of the data handled (passed over the network, validated and parsed at runtime). [Here](https://youtu.be/yk9x3nX5MQo?t=511) also, Jose Valim explains why he thinks type systems are unnecessary for Erlang (and Elixir). Essentially, a type system could not effectively model all the possible states for a distributed system; thus, a type system would likely restrict/hinder the capabilities of the system. 

Now, considering Elixir vs Erlang: Elixir and Erlang are very similar, and being built on the back of the same virtual machine, they are interoperable. Thus, the event engine could use both languages. 

There are really three main differences between Elixir and Erlang: 1) syntax, 2) organization, and 3) metaprogramming capabilities. The syntax of Erlang is quite a bit different from modern languages, being based originally on prolog. Thus, for additional developers, it might be more difficult to learn and get used to Erlang as opposed to Elixir, which has a more modern syntax based off of Ruby. However, the syntax is a relatively minor point, especially given the simple, rudimentary syntax of Erlang. In addition, the concepts are essentially the same, and much of the data is in the same format. Thus, syntax is an unimportant point. 

The organization differs slightly in Elixir vs Erlang. In both cases the primary unit of organization is the module. In Erlang, each file defines exactly one module. A variety of preprocessors are used to define the overall properties of the module along with its connection and use of other modules. This lends to a simple, and clean design. Elixir, while still using modules as one of the base units for functionality, allows for a little more flexibility: multiple modules can be defined in the same file. Elixir also includes protocols, which allows the ability to add polymorphic behavior to different data types. Also, Elixir includes namespaces, which allow for the grouping of related modules and protocols. Without namespaces, Erlang typically requires the user to use prefixes on modules or functions, which is not logically represented in the program. Thus, I think Elixir has the benefit of organization.

Finally, Elixir includes macros which can be used to create domain specific languages and improve the overall design of the language. These macros allow for the possibility of extracting patterns in the code for higher expressiveness and maintainability. Erlang has no equivalent of this, thus, using Elixir might come with the later benefit of a cleaner architecture.

And so, I conclude that Elixir will be the chosen language for the event system.

