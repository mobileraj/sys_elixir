**

#### Complexity
According to Armstrong, “all frameworks are growing to the point where they can be used by no one.” When developing Erlang/OTP, the core group decided that whenever a new feature would be added, another feature would be removed. Though perhaps extreme, this method allowed them to reduce the bloatware and complexity of the system.

Inherent complexity is complexity built into a problem. Accidental complexity arises from how you try to solve a problem. Inherent complexity cannot be avoided, but choosing the correct tool can eliminate accidental complexity.

#### Lead Up to Erlang
The language PLEX was used to develop AXE systems (a telecom switch). However, development in this language was extremely slow and expensive; about 2 lines of code per hour. Other existing languages, such as Ada and Pascal, did not work for telecom switch development. 

The future developers of Erlang, as they were investigating these options, came to realize that all programs have bugs in them, and thus fault-tolerance is essential for a large system. 

The development of Erlang was modeled around the design of telecom systems. Generally, such systems needed massive numbers of concurrent processes (given their widespread and distributed nature). As a specific example, when the voltage was dropped on the c-wire a part of the system restarted. This influenced the idea of linked fail-fast processes.

#### Programming Paradigms: Declarative vs Imperative, Functional vs OOP
*Note: I heard the videos mention these terms, which of course I had heard before but I did not fully understand the differences, especially after seeing Erlang code. I did additional research to fully understand these concepts.*

In simple terms, imperative programming focuses on “how to do it.” Imperative programs are essentially a series of commands which update the state of the program. They define their control flow using constructs such as gotos, loops, and branches. Declarative programming focuses on the high level “what to do.” Programs are a list of requirements of what the program should accomplish. It defines the end goal and the logical flow of the program. Object-oriented programming (or OOP) is a subset of imperative programming that models the program as the interaction of various “objects”, which store state and interact with each other through messages (in the form of object methods). Functional programming is a subset of declarative programming. It models programs as the composition of many functions. Functions in this style of programming are first-class citizens, and so can be treated like other data types.

According to Joe Armstrong, Erlang is the “only object-oriented programming language.” He explains that this refers to the fact that processes communicate the same way that objects do, by passing messages. The Erlang worldview is that “everything is a process”, and so treats “everything” like an object. In a way, modules (which define the code of a process) can even “inherit” functionality from a behavior (such as `gen_server`). The main difference between Erlang and most other OOP languages is the organization. In Erlang, the object is a process (an instance of a module) while popular OOP languages typically define an object as an instance of a class (a conceptual type). In addition, security is nearly impossible in most OOP languages due to the ease with which an object can be aliased. Processes do not have this problem, as they cannot be aliased and can only be referenced using their PID.

Armstrong’s thesis calls Erlang a concurrency-oriented programming (COP) language. Many popular languages are inherently sequential. Concurrency in these languages is implemented as an afterthought. In a COP language, concurrency is built into the language itself.

#### State Machines
State machines model event-driven state. State machines capture the logic of all the states, events, and transitions in a system. This makes finding undesirable transitions relatively easy. State machines also avoid the need to adopt a defensive approach to coding, where state flags must be checked to ensure that a requested action is valid. While not a silver bullet, state machines can effectively model systems which have a finite number of discrete states. 

New states and transitions can easily be added to an existing working state machine. Since each state handles its own events, adding a new state does not affect the others. Adding new transitions is equally trivial. Thus, the state of a system can easily be expanded to encompass new behavior. 

In Erlang, protocols define the specifications of state machines so as to ensure an api is correctly used and its client-server contract is upheld. The `gen_fsm` (general finite state machine) behavior is used to implement such a protocol. Modules then define the states and transitions using functions.