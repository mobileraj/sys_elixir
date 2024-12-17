**

Brainstorm outline:
- DBMS are highly sophisticated and used for data storage
- Architecture of RDBMS:
- Overall: life of query:
	- First, the client connects to the relational DBMS through the client communications manager, which facilitates sessions, requests, and responds. Queries are then passed to the process manager. The process manager creates, schedules, and manages the workers of the DBMS. A worker will use the relational query processor (RQP) to compile and execute its SQL query. The RQP calls the transactional storage manager. The transactional store manager obtains and manipulates data as specified by the query. From here, the stack unwinds. Data and computations bubble up the stack until the results of the query, polished and organized, are sent back to the client. This represents the standard life of a query; client sends a message, message is processed, and data is returned back to the client. 
	- Client Comms
		- The client communications manager is the first tier in an RDBMS. This tier is responsible for (1) creating and maintaining sessions with clients; (2) receiving and delegating requests to the rest of the database; (3) responding to clients with query results. *
- Process models
	- After the client communications manager creates a session with the client, the process model must create, schedule, and maintain a worker which is responsible for handling the clients queries. The RDBMS must ultimately transfer data to and from the client. To do this, it employs two main buffers: the I/O buffer for the disk, and a communications buffer for queueing client data. The disk buffer writes to and reads from both the database and the query logs. The communications buffer is used when the client is fetching data in small chunks. The RDBMS, anticipating the client's future requests of the data, loads it into this buffer. These buffers are necessary for data transfer and manipulation, from client to server to client.
	- Often, RDBMS's are implemented around one of three main process models for creating workers. The first model creates an OS process for each worker. This model was often used in early RDBMS’s due to the lack of efficient and effective support for OS threads. Due to the isolated nature of processes, process-based workers are relatively easy to implement, as many of the common problems and bugs in multithreading only arise when using shared environments and resources. However, OS processes are expensive to create. The second model uses a process pool to limit the number of processes. Processes are reused instead of re-created. Thus, this model tends to be far more resource efficient than the first model. Latency problems arise, however, when there are not enough processes in the pool to handle the incoming requests. The final model speeds things up by running workers in threads instead of processes. Threads (whether they are OS threads or special DBMS-implemented threads) are much cheaper to create than processes and tend to be faster. However, due to the fact that threads share memory, multithreading introduces many possible bugs to the system, such as race conditions. This makes such systems much harder to implement correctly. Each process model comes with its own pros and cons. Often, an RDBMS will implement multiple strategies to provide the best performance and scalability.
	- Addresses simplified model: only one processor.
	- Worker = worker per query ? booted when request comes in 
	- (1) process per worker 
		- Each OS process gets assigned to a worker.
		- Easy implementation; most isolation. OS processes can still interact but do not have all the shared memory problems of thread.
		- However: slow, since OS processes tend to be expensive to create and schedule. 
		- Need interprocess shared memory
	- (2) thread per worker
		- Each thread gets assigned to a worker
		- More difficult; much less isolation. Shared memory (i.e. buffers) can be allocated on the heap. 
		- Faster. Threads fairly cheap.
		- Like said, comes with multithreading problems.
		- OS threads vs lightweight:
		- OS - created and managed by OS. only on Os’s with efficient thread management
		- Lightweight - either a simplified thread scheduler or a fiber like model.
	- (3) pool for workers
		- Similar to (1), except as opposed to creating a process for every worker, workers are assigned a process from a pool
		- This is much more memory efficient than (1) as you need less processes.
		- However, can be slow if the pool is not big enough (as lots of clients wait on pool).
- Parallelism
	- There are three major parallelism models: the Shared-Memory, Shared-Disk, and Shared-Nothing models. In the Shared-Memory, multiple CPUs use the same RAM and Disk memory. The simplicity of this model is attractive; the DBMS as a whole behaves like a single multiprocessor device. All three process models (covered in the last paragraph) become easy to implement. Multiple independent SQL requests can be ran in parallel, or single complex queries can be be parallelized. Coordinating between CPUs is easy. However, if one device shuts down, the whole system will typically shut down as well, due to the interconnected nature of the CPUs. An alternative is the Shared-Disk model. Similarly to the previous, long-term disk memory is shared; RAM memory, however, is kept separate with each CPU. This model comes with the important benefit that the failure of one machine will not necessarily affect the others, and thus the DBMS can continue running in the event of a single CPU failure. However, coordination between devices can be difficult, as there is no shared RAM memory. Thus, systems with these models need two additional components: a distributed lock manager, and a protocol to manage the distributed, buffered caches. Shared-Memory and Shared-Disk models both come with the vulnerability to data corruption. In the third model, Shared-Nothing, a group of independent machines are used to run the DBMS. As the name implies, no memory is shared; data is communicated through message passing. Tables are stored piecewise throughout the various machines. A single query may will be run in part on all machines, the results of which are then aggregated. This allows for even load-balancing. Overall, this model tends to be highly scalable, as each processor can be considered its own machine. However, there are two main problems: complex cross-processor coordination is required, as they do not have shared memory. In addition, although one machine's failure may not affect directly affect the others, part of the database will become unavailable (given the partitioning scheme described). Thus, redundancy is required for reliability. As with the three process models, commercial DBMSs will typically use a hybrid of all three of these models, given their pros and cons. 

Databases are used throughout the technology space for a variety of applications.  ($Relational vs event-driven or other model)
—-----Notes—---------------------- 3
3.1 Shared Memory

![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXcKHpXTT7YYIAubvR9rCybboZG90nhopQv1ymr7u-iQrH9K3GErr1F9Vh8OT-ZJ6F_XRVvvZEjX3qYCJ3JaQ1x_-x-m95w8mYSPByib4y6WyIqzRMcOeRRomA_6XTI6gBcFpZKcUA?key=INRivZz378-AeEiLtzeDNww3)

The three process models are easy to implement; run well. Shared data continues to be shared and accessed by all. Execute multiple independent SQL requests in parallel. Challenge: modify query execution to parralelize single query. 
→ issues: 
- one down → shut down whole machine.

3.2 Shared-Nothing

**![](https://lh7-rt.googleusercontent.com/docsz/AD_4nXfrVIVD6K1LGDM-XvK3jI80FUTqnvz2Umluqcg62pBk5g8P-xqQmqX3SCo-USbhs40zvDDPEm_bRvB7tzk1v8qcf6iIPQe-9COARopA1Fn0Y3nH2ICm9Aa15ApsN98LzyOqnQWZWQ?key=INRivZz378-AeEiLtzeDNww3)**

Cluster of independent machines that pass messages. Each machine stores only a portion of the data. Execute query in parallel. Horizontal data partitioning. Each machine has tuple; horizontal “slicing” of table across machines.  Each machine like tis own.Good partitioning of data is required for good performance. Job partitioning. Overall very scalabel
→ issues:
- Explicit, complex cross-processor coord
- When one node goes down, fraction of database unavailable
	- To solve: redundancy schemes, maybe trade off availability vs consistency
- 
3.3 Shared Disk
![[Pasted image 20241213185611.png]]
Separate RAMs, same disk. Lower admin cost as compared to 3.2. Don't have to consider partitionting, although large dbs do. **Big goody:** failure of one node does not affecct the others at all. Two disadvantages:
- if data is corrupted, corrupted for eeveryong
- Nowhere to coordinate data sharing between machines. Need explicit coordination (adds overhead)

3.4 NUMA = middle ground between shared nothign and shared memory sys
- cluster of systems (or just a multiprocessor) with independent mem (fast access) and shared mem (slow access)
4 Notes:
**

RQP validates, optimizes SQL into dataflow plan and executes it on behalf on the client. Client then pulls the data tuples. =((for the most part) single user, single thread).
- Concurrency control handled by lower layers (mostly) unless db pages need to be pinned for critical ops. (4.4.5)
- Components:
	- SQL parser: parse query (--> internal format) & verify auth. 
	- Parse query: resolve names, etc.
		- Verify auth: make sure doesn’t violate constraints. 
		- Security checking: maybe compilation, execution (is it data dependent?)
	- query rewrite  
	- query optimize
	- query executor
    







**
- CONTINUED FROM GOOGLE DOCS; copy and paste here.
- 4.2 query rewrite: expand views, simplify and expand expressions, and normalize (---> break into simple SELECT-FROM-WHERE blocks that are easier to optimize) for query optimizer
- 4.3 Query Optimizer:
	- Overall goal: turn the query into an efficient plan/dataflow, or a tree of low-level commands 
		- Declarative -->(compiled to) imperative
		- Various different ways to optimize
		- Supports "query preparation"
			- Where a query is precompiled, stored in a plan cache, and then reused for identical (or very similar queries)
		- Read Seling's paper?
- 4.4 Query Executor
	- Overall goal: execute the query plan. 
		- Iterator model: forms a graph of nodes
		- As a class, looks like: ![[Pasted image 20241216082427.png]]
			- inputs represent edges in the graph:![[Pasted image 20241216082919.png]]
			- Each query operation is a subclass of the iterator
	- 4.4.1 Iterator's "couple dataflow with control flow"
		- get_next() == normal procdure. When pops off the stack (control flow transfres), tuple is returneed to parent in the graph. Thus, while the plan describes teh data flow, Iterators follow this flow in the control flow. 
	- 4.4.2 Where are the tuples stored
		- Each iterator has a "tuple descriptor" (reference) for each input and one output.
		- Buffer pool = tuples here are reference counted. 
		- Memory heap = can be copied into here from BP. avoids reference counting headaches. Used as a copy of the tuple or an operated-on tuple
	- 4.5 Access Methods
		- routins that manage access to the data structs on the disk.  (heaps, indexes=tree usually)
			- provides iterator api.
			- SARG = search argument. constraint/filter that tuple must satisfy
				- pass to iterator init (used by get_next(), and so in this way would only return a tuple that satisfies the search arg) instead of being checked by caller
					- prevents unnecessary pin logic, copying, and memory
					- Analogy:
						- checked by iter: `next(filter(SARG, data))`
						- checked by caller: `next(data).satisfies(SARG)`
			- Row referencing
				- either with physical address, or primary key, or both
					- problems with moving: physical address
					- slower: primary key; also needs to enforce uniqueness
	- 4.6 Data warehouses
		- Properties:
			- large,  historical 
			- loaded with new data on periodic basis.
			- Query optimization and execution engines preivously discussed do not work well
			- History
				- OLTP (online transaction processing ="the now") had replaced batch buisness data as dominant paradigm
				- computer operators submitting transaction ----> ATM (end user interactions)
					- needed high response time
				- Retailers: capture sales transactions
			- use Bitmap Indexes (fast access, expensive to update) instead of B+-trees (built for constant updates, deletes, etc.)
			- Must be bulk loadable very quickly 
				- Or, realtime dbs: avoid update in place, provide timestamped queries
			- Regular queries can be optimized by providing materialized views, or tables which contain a logical view in actual memory, thus speeding up queries.
			- Snowflake Schema: central record, join with other tables to get addtional information (think of GBT stuff)
		- 4.7 Extensibility
			- ADTs (abstract data types): typically has opaque type system with user defined operations on those types. 
			- Structured types (XML, JSON, etc): 
				- store as opaque ADT; however prevents optimization
				- or: as "shredded" data; foreign keys connecting different parts of structure
			- Full text search. Index on words, 
			- Additionally
				- Extensible query optimizers?
				- Polymorphism: wrapping external services as tables.

**

Databases are used throughout the technology space for a variety of applications.  ($Relational vs event-driven or other model)

**