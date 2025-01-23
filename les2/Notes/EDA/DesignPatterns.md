**Abstract:** Discussion of several of design patterns for event driven architecture, and general reference architecture derived from these design patterns

**Intro**
- EDA uses EP as central concept 
- CEP = complex EP, continuously analyzing stream of events to find complex sequence patterns of events according to a set of rules, then creating new events or triggering actions
- 

**Related Work**
- General patterns (like layers, messagee routing and transofrmation)
- Event processing patterns: processing networks.

**Patterens**
- Architectural
	- Layers
		- Problem: whole structure (top level and lower levels of EDA must be determeind, responsibilities and tasks separated)
		- Solution: three layers:
			- Monitoring
				- capturing events from different sources, preprocess raw events. 
			- Processing
				- pattern matching
			- Handling
				- appropriate reactions to matched event patterns
	- Agents:
		- Problem: processing events is highly complex
		- Solution: split processing logic into domain specific tasks
			- lightweight EP "Agents", conntected to form the EP Network. distributes processing logically, increases scalability and speed (by exploiting distributed systems)
	- Pipeline:
		- Problem: structure of Processing layer
		- Solution: structure into linear pipeline, each agent in the pipe only knowing the direct successor without knowing about further down the line.
- Design: general mechanisms
	- Event Consistency
		- Event data may be incorreect, meaningless or faulty
		- Soltuion:  explicit clenaing step
			- Discard invalid based on constraints (in EP rules)
			- Inconsistent events can be deleted completely.
			- Incorrect values ---> Default
	- Event Reduction
		- high volumes of data, so reduce events as early as possible
		- Solution:
			- Filtering: irrelevant events (to later processing stages) are logically removed 
			- Content Based routing: propagates events only to agents who are interested in this tpe of event (dispatching)
			- Sliding windows: snapshot of a finite view of the data  from the infinite history.
	- Event Transformation after event reduction, before intelligent processing
		- event data not optimized for future processing; doesn't contain al l the data and must make expensive calls to backend for complete processing.
		- Solution:
			- Translation: data format translated to other format
			- Content enrichment: additional structural info from backend (reduces number of requests to the backend in subsequent processing steps)
	- Event Synthesis
		- Stream of simple events must be synthesized into complex domain meaning so they can be interpreted and processed (as single event often cannot be interpreted on its own with any meaning or significance)
		- Solution:
			- Correlation sets: each set contains all events taht share a particular context (different dimentions: temporal, spatial, domain specific)
			- granularity shift
				- aggregate data (fine --> coarse)
			- semantic shift
				- complex processing to obtain meaning, higher abstraction; applying expert knowledge based rules


**Reference Architecture**
![[Pasted image 20250123150613.png]]
