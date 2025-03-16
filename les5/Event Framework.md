This document contains an exploration of the design of an event framework in Elixir. The requirements are described in the [[README]]
## Overall Architecture
The models given consideration by this document are Pub/Sub and Event Streaming models. There are two main differences between these models:
- *Event Persistence* - 
	- Pub/Sub: a published event is popped off the event queue after it is sent to its subscribers. 
	- Event Streaming: Events are stored in a central log, which clients can read until the event expires
- *Subscribers* - 
	- Pub/Sub: to receive an event, a client must subscribe to that event
	- Event Streaming: Events 

The purpose and use of the event framework would dictate which architectural model would be used. For starting an event framework, it would possibly be easiest to create an event framework around pub/sub, since Phoenix already has a pub/sub implementation

## REST Endpoints
Phoenix conveniently provides `socket` endpoints for establishing websocket connections. Phoenix provides [Channels](https://hexdocs.pm/phoenix/channels.html). The client's javascript can use phoenixes libraries to easily connect to the endpoint and maintain the connection.

## How are events sent?
Events are specified to be sent via callbacks.

 A client can, after connecting to a socket, subscribe to a channel. Channels contain callbacks for joining a call, handling sent events, and broadcasting these events to other listeners in the channel.
## How are events received?
After connecting to a socket, the clients can join a channel, causing all events in that channel to be broadcast to the clients as specified by the channel logic.

### Websocket
A Websocket is a type of two-way connection in which both participants can send and receive messages independently/asynchronously of each other. This is in contrast to a typical Request/Response model, where the client makes requests which wait for a server response. At the start of the connection, the communicating participants  perform a handshake and establish a connection. Headers are sent over with a websocket which contain the essential information to communicate, including the origin, protocol, and a key. Data and commands are sent in frames (independent of the network layer's frames) with minimal metadata. 

#### Elixir:

##### Server

- We could use Cowboy. This would be quite a bit lower level
- Phoenix is built on top of cowboy. Phoenix provides high-level websocket functionality. We could start with that, and then if need be go lower level. 

Clients would send in events to the phoenix genserver, which then broadcasts to any subscribers

We would create rest api endpoints for subscribing and unsubscribing websocket connections. 
Rest api for sending message, or just sent in frame?
##### Client:
- Websockex library looks promising and simple.
- An alternative would be gun which was designed to work with cowboy. This library appears to be a bit more difficult to work with and a little more complicated; however, eventually we might find that we need the additional features

##### Horizontal Scaling:
Here we would scale by increasing the number of servers (with a load balancer in between). Here I think we could have the load balancer to hold the rest api and manage the different connections. However, communication might be an issue. We would need to set up the phoenix pub sub so that each server can communicate with all the others. 

### Callbacks
- phoenix has callbacks within their web socket behavior which would be implemented by the server web socket. 
