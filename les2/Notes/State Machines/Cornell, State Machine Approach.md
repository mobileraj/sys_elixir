**Abstract:** State machines can be used for fault tolerance and decentralized control in distributed systems. Identifies the abstractions for coordinating state machines.

- state machine approach = general method for managing replication (where proceessors replicate computation, so effects of failure are not seen; inputs and outputs are gathered and coordinated). --> Failures cannot lead to increased time ---> ideal for real time
- Permits separation of fault tolerance from rest of system logic (how?)

**2 State Machine**
State machine: set of states (does not need to be finite) with atomic deterministic commands (which execute based on state):
- Defining characteristic: not syntax, but that it specifices a deterministic computation that reads a stream of requests and processes each. - state machine is very generla concept; similar to abstract data type. 
- **Semantics:** outputs are completely determined by the sequence requests, independent of sys environment.
	-  Two guaranttes:
		- Requests processed in order they were issued
		- If request r could've caused request r', r is processed before r;
	- State machine impls procedure, requests call procedure
	- *Any program that satisfies this is a state machine*
![[Pasted image 20250109124753.png]]
- examples:
	- mutex:
		- state:
			- current user of resource (nil or client)
			- other users waiting (conceptually a queue)
		- commands:
			- acquire
				- user == nil: ---> user = client
				- user != nil: ---> waiting.add(client)
			- release
				- waiting == nil: ---> user = nil
				- wating != nil: ---> user = waiting.pop()

