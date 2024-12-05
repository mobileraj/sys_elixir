- (*Already partially answered*): Message data passed seems like it would need to be very small for efficiency, since it is always copied. How would big data be handled effectively? It seems like you would need some sort of shared resource.
- Can state machines be modeled as a system? 
- I'm curious about mnesia (their database management system). How can it efficiently store and perform queries in a distributed system, especially since nodes can be assumed to be unreliable? Would it be confined to the storage of the device it is on or some other specific node? 
- Systems thinking attempts to model relationships with causal links between elements. It seems especially challenge not only to connect different elements but to find the elements which affect. What methods would be used to effectively find the right elements for the system, as there are many possible factors which affect each other? What about elements which are difficult to gather statistics on?
- Could / how would systems with non-deterministic transitions be modeled? Systems where a stock has the random chance to increase or decrease another stock.