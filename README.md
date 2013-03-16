<img src="ogre.png" height="250"></img>

**WARNING OgreDocs is still being written.**

[Ogre](http://github.com/zmaril/ogre) is a domain specific language
for traversing property graphs in [Clojure](http://clojure.org/). Ogre
wraps [Gremlin](https://github.com/tinkerpop/gremlin/wiki), a library
which enables all sorts of neat operations on graphs. 

The documentation and samples presented here attempt to stay current
with the most current, stable release of Ogre. Please join the
[Gremlin users group](http://groups.google.com/group/gremlin-users)
for any Ogre related discussions. Please use the
[Ogre issue page](https://github.com/zmaril/ogre/issues) for reporting
bugs and discussing features. For any errors or corrections with
OgreDocs, please use the
[Orge docs issue page](https://github.com/zmaril/ogredocs).

Pull requests will be celebrated, scrutinized, and hopefully accepted.
If the pull request is really solid, then I'll probably [give you commit
access](http://felixge.de/2013/03/11/the-pull-request-hack.html) to
Ogre and cross my fingers. 

Ogre currently powers
[Archimedes](https://github.com/zmaril/archimedes), a Clojure library
for blueprints, and [Hermes](https://github.com/zmaril/hermes), a
Clojure library built on top of Archimedes for working with
[Titan](http://thinkaurelius.github.com/titan/).

Ogre is an open source project maintained by
[Zack Maril](http://zacharymaril.com). 

***

## Getting started

### The Tinkerpop stack

Before gooing down the rabbit hole, I offer the briefest of warnings:
the [Tinkerpop folks](https://github.com/tinkerpop?tab=members) have
been working on Gremlin,
[Pipes](https://github.com/tinkerpop/pipes/wiki), and
[Blueprints](https://github.com/tinkerpop/blueprints/wiki) for a few
years now and the stack has become incredibly intertwined. Ogre and
[Archimedes](https://github.com/zmaril/archimedes) try to hide all of
this from you at some hide level, but every abstraction leaks. Your
stack traces will speak of `com.tinkerpop.X` and there is nothing I
want to do about that. With that, let's get started! 

### leiningen

The version scheme for Ogre is as follows:
`[Full Gremlin version].[Ogre major version]`. Philosophically, the
authors of Gremlin are the ones who will be causing most of the
changes to Ogre. Ogre is a mere wrapper around their work and the
version scheme acknowledges that directly. Thus, the first and current
release is `0.2.2.0`, meaning that Ogre uses Gremlin `0.2.2` and has
undergone zero major versions itself so far. 

To get started with Ogre right away, include the following
dependency for leiningen: `[zmaril/ogre "0.2.2.0"]`.

### The TinkerGraph

Unless otherwise noted, all samples rely on the TinkerPop "toy" graph.

```clojure 
(use 'ogre.tinkergraph) 

(use-new-tinkergraph!)
```

`use-new-tinkergraph` creates the following graph and secretly
squirrels it away somewhere: (image from
[here](http://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model)):

<img src="https://github.com/tinkerpop/blueprints/raw/master/doc/images/graph-example-1.jpg"></img>

I recommend that you open this image up into a
[new tab](https://github.com/tinkerpop/blueprints/raw/master/doc/images/graph-example-1.jpg).
It will serve as the main reference for the majority of the examples below. 

***

### So what does Ogre actually do? 

The one question every library hates. It does so much! Look at all the
neat features in here! Look at this, 

## Traversal

### --> / out

Gets the out adjacent vertices to the vertex.

[top](#)

***

### --E> / out-edges

Gets the outgoing edges to the vertex.

[top](#)

***

### out-vertex

Get both outgoing tail vertex of the edge.

[top](#)

***

### <-- / in

Gets the adjacent vertices to the vertex.

[top](#)

***

### <E-- / in-vertices

Gets the incoming edges of the vertex.

[top](#)

***

### in-vertex

Get both incoming head vertex of the edge.

[top](#)

***

### <-> / both

Get both adjacent vertices of the vertex, the in and the out.

[top](#)

***

### <->

Get both incoming and outgoing edges of the vertex.

[top](#)

***

### both-vertices

Get both incoming and outgoing vertices of the edge.

[top](#)

***

## Map

Transform steps take an object and emit a transformation of it.

***

### id

Gets the unique identifier of the element.

[top](#)

***

### property

Get the property value of an element. The property value can be
obtained by simply appending the name to the end of the element or by
referencing it as a Groovy map element with square brackets. For best
performance, drop down to the Blueprints API and use
`getProperty(key)`.

[top](#)

***

### label

Gets the label of an edge.

[top](#)

***

### map

Gets the property map of the graph element.

[top](#)

***

### select

Select the named steps to emit after select with post-processing
closures.

[top](#)

***

### select-only

Select the named steps to emit after select with post-processing
closures.

[top](#)

***


### path

Gets the path through the pipeline up to this point, where closures
are post-processing for each object in the path. If the path step is
provided closures then, in a round robin fashion, the closures are
evaluated over each object of the path and that post-processed path is
returned.

[top](#)

***

### transform

Transform emits the result of a closure.

[top](#)

***

## Converters

Ogre cannot do everything for you. You still have to ask to do things.

### to-list

[top](#)

***

### into-vec

[top](#)

***

### into-set

[top](#)

***

### first-of

[top](#)

***

### first-into-vec

[top](#)

***

### first-into-set

[top](#)

***


### first-into-map

[top](#)

***

### all-into-vecs

[top](#)

***

### all-into-sets

[top](#)

***

### all-into-maps

[top](#)

***

## Reduce

These functions act like reduce.

### order

Order the items in the stream according to the closure if provided. If
no closure is provided, then a default sort order is used.

[top](#)

***

### shuffle

Collect all objects up to that step into a list and randomize their
order.

[top](#)

***

### gather

Collect all objects up to that step and process the gathered list with
the provided closure.

[top](#)

***

### scatter

Unroll all objects in the iterable at that step. Gather/Scatter is
good for breadth-first traversals where the gather closure filters out
unwanted elements at the current radius.

[top](#)

***

## Filter

Filter steps decide whether to allow an object to pass to the next
step or not.


### range

A range filter that emits the objects within a range.

[top](#)

***

### dedup

Emit only incoming objects that have not been seen before with an
optional closure being the object to check on.

[top](#)

***

### except

Emit everything to pass except what is in the supplied collection.

#### See Also

* [retain](#filter/retain)

[top](#)

***

### filter

Decide whether to allow an object to pass. Return true from the
closure to allow an object to pass.

[top](#)

***

### has

Allows an element if it has a particular property. Utilizes several
options for comparisons through `T`:

* T.gt - greater than
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

It is worth noting that the syntax of `has` is similar to `g.V("name",
"marko")`, which has the difference of being a
[key index](https://github.com/tinkerpop/blueprints/wiki/Graph-Indices)
lookup and as such will perform faster. In contrast, this line,
`g.V.has("name", "marko")`, will iterate over all vertices checking
the `name` property of each vertex for a match and will be
significantly slower than the key index approach.

#### See Also

* [hasNot](#filter/hasnot)

[top](#)

***

### has-not

Allows an element if it does not have a particular property. Utilizes
several options for comparisons on through `T`:

* T.gt - greater than
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

[top](#)

***

### interval

Allow elements to pass that have their property in the provided start
and end interval.

#### See Also

* [has](#filter/has)

[top](#)

***

### random

Emits the incoming object if biased coin toss is heads.

[top](#)

***

### retain

Allow everything to pass except what is not in the supplied
collection.

[top](#)

***

### simplePath

Emit the object only if the current path has no repeated elements.

[top](#)

***

## Annotations

### as

Emits input, but names the previous step.

[top](#)

***

### back

Go back to the results from n-steps ago or go back to the results of a
named step.

[top](#)

***

### back-to

Go back to the results from n-steps ago or go back to the results of a
named step.

[top](#)

***

### optional

Behaves similar to `back` except that it does not filter. It will go
down a particular path and back up to where it left off. As such, its
useful for yielding a sideeffect down a particular branch.

[top](#)

***

### loop

Loop over a particular set of steps in the pipeline. The first
argument is either the number of steps back in the pipeline to go or a
named step. The second argument is a while closure evaluating the
current object. The `it` component of the loop step closure has three
properties that are accessible. These properties can be used to reason
about when to break out of the loop.

* `it.object`: the current object of the traverser.
* `it.path`: the current path of the traverser.
* `it.loops`: the number of times the traverser has looped through the
  loop section.

The final argument is known as the "emit" closure. This boolean-based
closure will determine wether the current object in the loop structure
is emitted or not. As such, it is possible to emit intermediate
objects, not simply those at the end of the loop.

[top](#)

***

### loop-to

Loop over a particular set of steps in the pipeline. The first
argument is either the number of steps back in the pipeline to go or a
named step. The second argument is a while closure evaluating the
current object. The `it` component of the loop step closure has three
properties that are accessible. These properties can be used to reason
about when to break out of the loop.

* `it.object`: the current object of the traverser.
* `it.path`: the current path of the traverser.
* `it.loops`: the number of times the traverser has looped through the
  loop section.

The final argument is known as the "emit" closure. This boolean-based
closure will determine wether the current object in the loop structure
is emitted or not. As such, it is possible to emit intermediate
objects, not simply those at the end of the loop.

[top](#)

***


## Side Effect

Side Effect steps pass the object, but yield some kind of side effect
while doing so.

### get-grouped-by

Emits input, but groups input after processing it by provided
key-closure and value-closure. It is also possible to supply an
optional reduce-closure.

[top](#)

***

### get-group-count

Emits input, but updates a map for each input, where closures provides
generic map update.

[top](#)

***

### cap

Gets the side-effect of the pipe prior. In other words, it emits the
value of the previous step and not the values that flow through it.

[top](#)

***


### side-effect

Emits input, but calls a side effect closure on each input.

[top](#)

***

### get-table

Emits input, but stores row of as values (constrained by column names
if provided) in a table. Accepts an optional set of closures that are
applied in round-robin fashion to each column of the table.

### get-tree

[top](#)

***

Emit input, but stores the tree formed by the traversal as a map.
Accepts an optional set of closures to be applied in round-robin
fashion over each level of the tree.

## Branch

Branch steps decide which step to take.

### copy-split

Copies incoming object to internal pipes.

***

### exhaust-merge

Used in combination with a `copySplit`, merging the parallel
traversals by exhaustively getting the objects of the first, then the
second, etc.

***

### fair-merge

Used in combination with a `copySplit`, merging the parallel
traversals in a round-robin fashion.

***

### if-then-else

Allows for if-then-else conditional logic.

[top](#)

***

### memoize

Remembers a particular mapping from input to output. Long or expensive
expressions with no side effects can use this step to remember a
mapping, which helps reduce load when previously processed objects are
passed into it.

For situations where memoization may consume large amounts of RAM,
consider using an embedded key-value store like
[JDBM](http://code.google.com/p/jdbm2/) or some other persistent Map
implementation.

[top](#)

***

## Recipes

Recipes are common patterns that are seen in using Gremlin.

### Duplicate Edges

Strictly speaking, you cannot have duplicated egdes with the same id.
This example finds edges with same `outV/inV/label` properties.

[top](#)

***

### Paging Results

It is sometimes desireable to not return an entire results set.
Results can be paged or limited as follows:

[top](#)

***

### Paths Between Two Vertices

First, paths for a directed graph:

Then, undirected:

Use the value of `it.loops<=3`to control the depth of the traversal:

[top](#)

***

### Reading From a File

Reading data from an edge file formatted as CSV is easy to do with
Gremlin.

[top](#)

***

### Sampling

It is sometimes useful to grab a random sample of the items in a
collection. That can be done to some degree with the
[random](#filter.random) step, but getting an explicit number of items
is not supported using that step.

[top](#)

***

### Shortest Path

Find the shortest path between two vertices:

[top](#)

***
