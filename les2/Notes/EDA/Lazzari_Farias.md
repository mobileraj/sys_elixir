**Abstract**: Investigates modularity (separation of concerns, coupling, cohesion, complexity, size, etc) of event driven architecture vs REST architectural style for enterprise. 

**2**
- EDA:
	- asynchronous
	- messaging system allows building loosely coupled services.
- REST
	- synchronous

**4**
- Comparison:
	- SoC
		- EDA scores beetter, as each service is indpenentn
	- coupling
		- REST scores better, as service independence requires additional structure and many auxiliary classess
	- complexity
		-  REST scores better
	- cohesion
		-  EDA scores better
	- size
		-  REST scores better, less elements
**5**
- EDAs are coordination free by design, thus it is difficult to control data consistency particularly in the case of writers.
- 