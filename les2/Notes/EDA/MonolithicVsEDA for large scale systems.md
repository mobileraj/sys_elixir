**Abstract:** comparing performance for monolithic vs event driven architectures, case study ("the income deduction")
- Three main problems when complexity rises: waits for data access, long sequential executions, and potential loss of data

**1 Intro**
- Monolithic = single application layer (business logic + data manipulation logic)
- EDA = decouple systems that run in response to events (event = change in state or update in program)
**2 Background**
- Domain Driven Design (DDD)
	- Basically means that the code you develop reflects and aligns with the problem domain.
- Microservices:
	- set of lossely coupled (largely isolated and indepdent) services.
	- common response to monolithic problems
- EDA: extension of microservice architecture (includes the web of events wihich connect different services)
	- three main components: 
		- event producers
			- detects event and broadcasts through event router
		- event router
			- broad casts events to make available to consumers.
		- event consumer 
			- process event 
6 **Results Discussion**
- scenario 1 (first time imports; process large set of data): EDA slower, however there is no wait time (startup) so in theory could be better than monolithic
	- monolithic requires starting whole system, EDA just sends events
- scenario 2 (external systems send in information to record in the data from 1)
	- both work relatively the same way, very similar speeds as well.
	- event driven misses some events (author error in impl?)
- scenario 3 (re-evaluating data from 1 after 2, updating)
	- 49% improvment in EDA
	- 
**7 Conclusion**
- Event driven allows to avoid blocking waits (asyncrhonous execution and responding to events)