<img src="ogre.png" height="200"></img>

**WARNING OgreDocs is still being written.**

## Introduction

[Ogre](http://github.com/zmaril/ogre) is a domain specific language
for traversing property graphs in [Clojure](http://clojure.org/). Ogre
wraps [Gremlin](https://github.com/tinkerpop/gremlin/wiki), a library
which enables [all sorts of groovy operations on graphs](http://gremlindocs.com/). 

The documentation and samples presented here attempt to stay current
with the most current, stable release of Ogre. Please join the
[Gremlin users group](http://groups.google.com/group/gremlin-users)
for any Ogre related discussions. Please use the
[Ogre issue page](https://github.com/zmaril/ogre/issues) for
specifically reporting bugs and discussing features. For any errors or
corrections with OgreDocs, please use the
[OrgeDocs issue page](https://github.com/zmaril/ogredocs). This page
is a fork of [GremlinDocs](http://gremlindocs.com/).

Pull requests will be celebrated, scrutinized, and hopefully accepted.
If the pull request is really solid, then I'll probably [give you commit
access](http://felixge.de/2013/03/11/the-pull-request-hack.html) to
Ogre and cross my fingers. 

Ogre currently powers
[Archimedes](https://github.com/zmaril/archimedes), a Clojure library
for [Blueprints](https://github.com/tinkerpop/blueprints/wiki), and
[Hermes](https://github.com/zmaril/hermes), a Clojure library built on
top of Archimedes for working with
[Titan](http://thinkaurelius.github.com/titan/). Ogre, Archimedes, and
Hermes are all open source projects developed and maintained by
[Zack Maril](https://twitter.com/ZackMaril).

***

## Getting started

### The Tinkerpop stack

Before going down the rabbit hole, I offer the briefest of warnings:
the [Tinkerpop folks](https://github.com/tinkerpop?tab=members) have
been working on Gremlin,
[Pipes](https://github.com/tinkerpop/pipes/wiki), and
[Blueprints](https://github.com/tinkerpop/blueprints/wiki) for a few
years now and the stack has become incredibly intertwined. Ogre and
[Archimedes](https://github.com/zmaril/archimedes) try to hide all of
this from you at some hide level, but every abstraction leaks. Your
stack traces will speak of `com.tinkerpop.blueprints.Vertex` and
`com.tinkerpop.gremlin.GremlinPipeline`, and there is nothing I can
(well, should) do about it. The Tinkerpop stack is fantastic and
really well done, but I wanted to warn you that the following is just
the tip of the iceberg in terms of what you will need to know what is
really going on when you use Ogre. 

With that terribly encouraging thought, let's get started!

### leiningen

The version scheme for Ogre is as follows:
`[Full Gremlin version].[Ogre major version]`. Philosophically, the
authors of Gremlin are the ones who will be causing most of the
changes to Ogre. Ogre is a mere wrapper around their work and the
version scheme acknowledges that directly. Thus, the first and current
release is `0.2.2.0`, meaning that the current release uses Gremlin
`0.2.2` and has undergone zero major versions itself so far since
release.

To get started with Ogre, include the following dependency for
leiningen: `[zmaril/ogre "0.2.2.0"]`.

### The TinkerGraph

Unless otherwise noted, all samples reference `ogre.tinkergraph` and `ogre.core`.

```clojure 
(require '[ogre.tinkergraph :as g]) 
(require '[ogre.core :as q]) 

(g/use-new-tinker-graph!)
```

`g/use-new-tinker-graph!` creates the following graph and secretly
squirrels it away
[_somewhere_](https://github.com/zmaril/ogre/blob/master/src/ogre/tinkergraph.clj#L10)
(image from
[here](http://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model)):

<img src="https://github.com/tinkerpop/blueprints/raw/master/doc/images/graph-example-1.jpg"></img>

I recommend that you open this image up into a
[new tab](https://github.com/tinkerpop/blueprints/raw/master/doc/images/graph-example-1.jpg).
It will serve as the main reference for the majority of the examples below. 

### So what does Ogre actually do? 

At a high level, Ogre let's you easily ask complex questions about
certain types of graphs and get back answers. That's really all it
does. 

At a low level, Ogre is a library that takes in Blueprint Vertices and
Edges and let's you build up GremlinPipeline objects that ask
questions about those objects in the language of traversals,
transformations, filters, and branching on the graph. Ogre allows you
to annotate various steps of the pipeline to allow for incredibly
useful queries in a few terse lines. Ogre also carefully deals with some of
the side effects that the Gremlin library can perform. 

At the lowest level, Ogre is probably equivalent to some crazy Turing
machine. Man, I wonder if some poor grad student has ever tried to
write the JVM as a Turing machine. Poor guy. 

### Using OgreDocs

OgreDocs is organized to be read mostly linearly. That means that you
can probably read it from start to finish and understand what is going
on. That means it starts from the basics, traversals, maps,
conversions, and filters. Then it transitions into the more advanced
topics of annotations, side effects, branching, and recipes. At the
same time, it is meant to serve as a complete reference for anyone
using the library (ctrl+f is your friend). These examples were are
developed at the command line or inside emacs with a REPL, so they are
meant to be run and experimented with.


***

## Building queries 

Ogre let's you build up Gremlin queries from scratch. The main method
for doing this is `q/query`. Here is a simple query on the
Tinkergraph. It takes in the vertex with id `1`, finds the vertices
that the starting vertex points out to, and then returns the result in
a vector.

``` clojure
(require '[ogre.tinkergraph :as g]) 
(require '[ogre.core :as q]) 

(g/use-new-tinker-graph!)

(q/query (g/find-by-id 1)
         q/-->
         q/into-vec!)
;;[#<TinkerVertex v[2]> #<TinkerVertex v[4]> #<TinkerVertex v[3]>]
```

Let's break this down: 

* `q/query` is a macro that is
  [just a combination](https://github.com/zmaril/ogre/blob/master/src/ogre/util.clj#L13)
  of `->` and `(GremlinPipeline.)`. It takes in a single element or a
  Collection and creates a new pipeline around them. 
* `g/find-by-id` is a function that goes and asks the vertex for the
  element of id 1. 
* `q/-->` is a function which adds on an outwards traversal step to
  the pipe. This means that the Gremlin query will take all the
  vertices it is currently thinking about and then look for all the
  vertices that the previous vertices pointed to. 
* `q/into-vec!` executes the query and returns the results inside of a
  vector. Up until this call, the Gremlin query hasn't actually done
  anything yet. Only when a function that ends with a bang is passed
  in does anything actually happen beyond just a GremlinPipeline
  getting built up. 

So far so good. But, I wonder, who is the dashing rogue behind
`#<TinkerVertex v[2]>`?

``` clojure
(q/query (g/find-by-id 1)
         q/-->
         q/into-vec!
         first
         ((q/prop :name)))
;;"vadas"
```

`q/query` isn't just about running Gremlin queries. Remember,
it's really just a glorified `->` with helper functions. That means we
can stick a `first` in there to get the first vertex of the vector.
`(q/prop :name)` takes a property key and returns a function which
takes a vertex and returns the given property. Thus, `"vadas"` is the
charming face of `#<TinkerVertex v[2]>`.

***

## Traversal

Traversal functions allow you to explore around the graph and see how
vertices are connected. 

### out / -->

`-->` or `out` gets the out adjacent vertices (the functions do
exactly the same thing, one just looks cooler). Additionally, labels
can be supplied that makes the graph only traverse edges with those
labels. This also applies to the other traversal functions where it
makes sense (any function that is named with arrows).

``` clojure
(q/query (g/find-by-id 4)
         q/-->
         q/into-vec!)
;;[#<TinkerVertex v[5]> #<TinkerVertex v[3]>]

(q/query (g/find-by-id 4)
         q/out
         q/into-vec!)
;;[#<TinkerVertex v[5]> #<TinkerVertex v[3]>]

(q/query (g/find-by-id 4)
         (q/--> :created)
         q/into-vec!)
;;[#<TinkerVertex v[5]> #<TinkerVertex v[3]>]

(q/query (g/find-by-id 4)
         (q/--> :hates)
         q/into-vec!)
;;[]

(q/query (g/find-by-id 4)
         (q/--> :created :hates)
         q/into-vec!)
;;[#<TinkerVertex v[5]> #<TinkerVertex v[3]>]
```

### out-edges / --E>

Gets the outgoing edges of the vertex.

``` clojure
(q/query (g/find-by-id 4)
         q/--E>
         q/into-vec!)
;;[#<TinkerEdge e[10][4-created->5]> #<TinkerEdge e[11][4-created->3]>]

(q/query (g/find-by-id 4)
         q/out-edges
         q/into-vec!)
;;[#<TinkerEdge e[10][4-created->5]> #<TinkerEdge e[11][4-created->3]>]
```

### out-vertex

Get the outgoing tail vertex of the edge.

``` clojure
(q/query (g/find-by-id 4)
         q/--E>
         q/out-vertex
         q/into-vec!)
;;[#<TinkerVertex v[4]> #<TinkerVertex v[4]>]
```

Conceptually, this might seem same strange at first. Why does it
return the same vertex twice? The answer lies in the example queries
for `--E>`. Those queries return two edges. The current query is the
same as the `--E>` query except we are asking for the `out-vertex`.
That means, by the time we are asking for the `out-vertex`, we have
two objects "in the pipeline". Thus, we get two objects back. 

### in / <--

Gets the adjacent vertices to the vertex.

``` clojure
(q/query (g/find-by-id 3)
         q/<--
         q/into-vec!)
;;[#<TinkerVertex v[1]> #<TinkerVertex v[4]> #<TinkerVertex v[6]>]
```

### in-edges / <E--

Gets the incoming edges of the vertex.

``` clojure
(q/query (g/find-by-id 3)
         q/<E--
         q/into-vec!)
;;[#<TinkerEdge e[9][1-created->3]> 
;; #<TinkerEdge e[11][4-created->3]> 
;; #<TinkerEdge e[12][6-created->3]>]
```

### in-vertex

Get incoming head vertex of the edge.
``` clojure
(q/query (g/find-by-id 3)
         q/<E--
         q/in-vertex
         q/into-vec!)
;;[#<TinkerVertex v[3]> #<TinkerVertex v[3]> #<TinkerVertex v[3]>]
```

### both / <->

Get both adjacent vertices of the vertex, the in and the out.

``` clojure
(q/query (g/find-by-id 4)
         q/<->
         q/into-vec!)
;;[#<TinkerVertex v[1]> #<TinkerVertex v[5]> #<TinkerVertex v[3]>]
```

### both-edges / `<E>`

Get both incoming and outgoing edges of the vertex.

``` clojure
(q/query (g/find-by-id 4)
         q/<E>
         q/into-vec!)
;;[#<TinkerEdge e[8][1-knows->4]> 
;; #<TinkerEdge e[10][4-created->5]> 
;; #<TinkerEdge e[11][4-created->3]>]
```

### both-vertices

Get both incoming and outgoing vertices of the edge.
``` clojure
(q/query (g/find-by-id 4)
         q/<E>
         q/both-vertices
         q/into-vec!)
;;[#<TinkerVertex v[1]> #<TinkerVertex v[4]> 
;; #<TinkerVertex v[4]> #<TinkerVertex v[5]> 
;; #<TinkerVertex v[4]> #<TinkerVertex v[3]>]
```

***

## Map

The following functions are conceptually similar in scope to
`clojure.core/map` and so are grouped together. They all take in a
function and perform some transformation on it. 

### id

Gets the unique identifier of the element.

``` clojure
(q/query (g/find-by-id 1)
         q/id
         q/into-vec!)
;;["1"]

(q/query (g/find-by-id 1)
         q/-->
         q/id
         q/into-vec!)
;;["2" "4" "3"]

(q/query (g/find-by-id 1)
         q/id
         q/-->         
         q/into-vec!)
;;ClassCastException java.lang.String cannot be cast to  com.tinkerpop.blueprints.Vertex  
;;com.tinkerpop.gremlin.pipes.transform.VerticesVerticesPipe.processNextStart 
;;(VerticesVerticesPipe.java:37)
```

### property

Get the property value of an element. 

``` clojure
(q/query (g/find-by-id 1)
         (q/property :name)
         q/into-vec!)
;;["marko"]

(q/query (g/find-by-id 1)
         q/-->
         (q/property :name)
         q/into-vec!)
;;["vadas" "josh" "lop"]
```


### label

Gets the label of an edge.

``` clojure
(q/query (g/find-by-id 1)
         (q/property :name)
         q/into-vec!)
;;["marko"]

(q/query (g/find-by-id 1)
         q/-->
         (q/property :name)
         q/into-vec!)
;;["vadas" "josh" "lop"]
``` 

### map

Gets the property map of the graph element.

``` clojure
(q/query (g/find-by-id 1)
         q/map
         q/into-vec!)
;;[#<HashMap {name=marko, age=29}>]

(q/query (g/find-by-id 1)
         q/map
         q/first-into-map!)
;;{:name "marko", :age 29}

(q/query (g/find-by-id 1)
         q/-->
         q/map
         q/all-into-maps!)
;;({:name "vadas", :age 27} {:name "josh", :age 32} {:name "lop", :lang "java"})
``` 

We now see two new functions in addition to `q/map`: `first-into-map!`
and `all-into-maps!`. As you see, Gremlin doesn't return Clojure data
structures. The new functions execute the Gremlin query and then call
the correct conversion methods to ensure that you can work with the
returned objects without too much hassle. 

### path

Gets the path through the pipeline up to this point. If functions are
provided, they are applied round robin to each of the objects in the
path. 

``` clojure
(q/query (g/find-by-id 1)
         q/<->
         q/<->
         q/path
         q/all-into-vecs!)
;; ([#<TinkerVertex v[1]> #<TinkerVertex v[2]> #<TinkerVertex v[1]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[4]> #<TinkerVertex v[1]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[4]> #<TinkerVertex v[5]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[4]> #<TinkerVertex v[3]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[3]> #<TinkerVertex v[1]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[3]> #<TinkerVertex v[4]>] 
;;  [#<TinkerVertex v[1]> #<TinkerVertex v[3]> #<TinkerVertex v[6]>])         

(q/query (g/find-by-id 1)
         q/<->
         q/<->
         (q/path (q/prop :name))
         q/all-into-vecs!)
;;(["marko" "vadas" "marko"] 
;; ["marko" "josh" "marko"] 
;; ["marko" "josh" "ripple"] 
;; ["marko" "josh" "lop"] 
;; ["marko" "lop" "marko"] 
;; ["marko" "lop" "josh"] 
;; ["marko" "lop" "peter"])

(q/query (g/find-by-id 1)
         q/<->
         q/<->
         (q/path (q/prop :name) (fn [v] (count (.getProperty v "name"))))
         q/all-into-vecs!)
;;(["marko" 5 "marko"] 
;; ["marko" 4 "marko"] 
;; ["marko" 4 "ripple"] 
;; ["marko" 4 "lop"] 
;; ["marko" 3 "marko"] 
;; ["marko" 3 "josh"] 
;; ["marko" 3 "peter"])         
``` 

Note that again we have introduced a new function `all-into-vecs!`.
This takes in an ArrayList of ArrayLists and produces a list of
vectors. 

### transform

Transform emits the result of a function.

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

### select

Select the named steps to emit after select with post-processing
closures.



### select-only

Select the named steps to emit after select with post-processing
closures.

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
