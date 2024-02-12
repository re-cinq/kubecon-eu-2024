# Monolith Demo

This folder contains the Monolith Demo, we took the previously created
[Microservice Demo](../microservice-demo) created by google and restructered it
into a single deployable component.

All services are in a single pod, sharing the same CGroup and network
namespace. To scale you need to scale the entire setup. 

While we understand that you can use various practioces to optimize the setup
of a monolith, the comparison we are doing is not between Monoliths and
Microservices, but rather in which scenarios a Monolith produces less carbon
emissions, meaning that in this case our setup will provide the data that we
require for this hypothesis
