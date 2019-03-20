# Stream Event Viewer

This is a coding assignment project. I decided to build it using Elixir, and leverage BEAM VM incredible ability to parallelize. It has a rather simple architecture, does not use DB and keeps data flow as uni-directional as possible. It also uses Phoenix LiveView which was released liek 3 days ago so it runs incredibly well and doesn't use much JS.

## Rough architecture

Every client watching a stream creates a LiveView process which alerts StreamerRouter genserver, and it checks if according twitch subscription process (Streamer process) already exists. If it does, it sends it client LiveView pid, to get notified, whenever webhook gets invoked. If it does not, it creates a new Streamer process, adds it to a routing registry and created a twitch webhook sub, which uses StreamerRouter to notify appropriate process.

![The diagram migth explain more.](/diagram.png?raw=true "The diagram migth explain more.")

## How would I deploy it to AWS?

I'd setup a CloudFormation to pickup code from the repo, build it into a docker container (dockerfile included) and deploy it into a k8s cluster with the same cookie. 

## Where do I see bottlenecks and how would I scale following architecture

I'd say it's quite fast, almost every webhook trigger on my pc takes about 300 microseconds, and approx 1ms on my weakling server. So 100 rpm shouldn't be too much of a problem, however when we start to hit the numbers of about 60k rpm I'd start thinking about horizontal scaling. Right now, the router process is not global, which poses problems of duplicate subs and slower response times. I'd use peerage to discover nodes on the network, swarn to handoff processes to another nodes, and manifold for large subscripton list notification, and sharding global router processes. This should work great even on biggest of clusters with dynamic number of nodes.