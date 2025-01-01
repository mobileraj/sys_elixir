
Event driven architectures (EDAs) are built to handle and react to large amounts of data in real time. stores a series of events (sometimes known as "behavioral data"). An event records a change or occurrence in the system. Each event has a timestamp, an action, and data. Whenever an event is produced, an event notification is sent to event consumers, who can handle the event asynchronously. The event producer does not need to know about its consumers or their implementation, the producer only needs to worry about publishing events (the producer and consumer are decoupled).

As opposed to storing/processing a stream of events, relational models store the "now", the current state of the DB, within highly-structured tables. Relational models store/process data; EDAs store/process events. 

