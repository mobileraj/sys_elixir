Using EDA for big data stream processing

**Abstract:** Choosing appropriate architecture; paper outlines EDA, pros & cons, for big data stream processing

**1. Intro**
- appropriate architecture for extensibility and maintainability. 
- Microservices natrual fit (complex applications), **but** it might be better to start with a Monolithic ---> transfer alter. 
	- communicate via REST or EDA
- EDA: "async processing of real time events" benefit of high throughput and high availability

**2. Microservices**
![[Pasted image 20250129163529.png]]
- Monolithic: all layers implemented together
	- Pros:
		- easy to start and deploy, easy to test when small
		- load balancing is easy
		- fast communication between modules.
	- Cons:
		- increased complexity
		- when becomes big, very difficult/expensive to deploy, changing near impossible, especially when trying to adopt new technologies.
		- error  in one module could bring down all others.
- Microservices: set of small, lossely couple services, **each service responsible for a single business capability**
	- Pros:
		- complexity solved by breaking into individual components
		- fast and easy deployment
		- fine grained scalable
		- fault tolerance
	- Cons:
		- Initial implmementaiton is slow, costly
		- communication overhaead
		- difficult to make changes which affect multiple services.
		- data/entities may be scattered, thus changes made in multiple places. 
- Tow commonly used design pattern
	- Api gateway
		- Facade/interface to aggregate data from multiple services to client. nice interface
		- cons: need to manage another application, may be bottleneck in future (as devs need to wait in order to make changes to it)
	- Service discovery
		- Problem: IP addrs of cloud based apps dynamic, constantly changing. 
		- Solution: Service registry plus one of the following techniques:
			- server side discovery
				- request to load balancer, which querys service registry and routes request
			- client side discovery 
				- client request service registry directly ,and routes request.

**3. EDA**
- Monolithic: easy data manage, one ACID relational DB
- Microservices: more difficutl, as service data private to each service, only accessed through apis thus:
	- need to figure out how to maintain consistency across multiple services
	- and How to effectively and efficiently get data from multiple services.
- EDA:
	- solves these. scalable flexible
	- events can implement business transaction that span multiple services, event = significatn change in state. 
	- Topologies:
		- Mediator
			- event --> queue --> mediator (which intercepts events and generates dditionanl ones) --> channel --> subscribers
			- good for multiple step events/processing
		- Broker
			- event --> channel --> subscribers --> publish event to notify others of performed action
			- good for simple event processing.

**4. Conclusions**
- microservices preferred for modern scalable applications