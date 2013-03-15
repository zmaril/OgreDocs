![Gremlin](https://github.com/tinkerpop/gremlin/raw/master/doc/images/gremlin-logo.png)

**WARNING OgreDocs is obviously still under development**

[Ogre](http://github.com/zmaril/ogre) is a domain specific language
for traversing property graphs in Clojure. Ogre wraps
[Gremlin](https://github.com/tinkerpop/gremlin/wiki), a language which
has application in the areas of graph query, analysis, and
manipulation. This page is a fork of [GremlinDocs](http://gremlindocs.com/).

Ogre is an open source project maintained by
[Zack Maril](http://zacharymaril.com). Please join the Gremlin users
group at http://groups.google.com/group/gremlin-users for any Ogre or
Gremlin related discussions.

Unless otherwise noted, all samples are derived from the TinkerPop "toy" graph generated with: 

```clojure
(use 'ogre.tinkergraph)
```

This produces a hardcoded representation of the graph diagrammed [here](http://github.com/tinkerpop/blueprints/wiki/Property-Graph-Model).  

The documentation and samples presented here attempt to stay current
with the most current, stable release of Ogre. Please note that this
is the *official* Ogre documentation.

OgreDocs is a
[GitHub repository](https://github.com/spmallette/OgreDocs). Pull
requests will be celebrated.

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

## Transform

Transform steps take an object and emit a transformation of it.

*** 

### cap

Gets the side-effect of the pipe prior.  In other words, it emits the value of the previous step and not the values that flow through it.

[top](#)

***

### gather

Collect all objects up to that step and process the gathered list with the provided closure.

#### See Also

* [scatter](#transform/scatter)

[top](#)

***

### id

Gets the unique identifier of the element.  

[top](#)

***

### key

Get the property value of an element.  The property value can be obtained by simply appending the name to the end of the element or by referencing it as a Groovy map element with square brackets.  For best performance, drop down to the Blueprints API and use `getProperty(key)`.

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

### memoize

Remembers a particular mapping from input to output.  Long or expensive expressions with no side effects can use this step to remember a mapping, which helps reduce load when previously processed objects are passed into it.

For situations where memoization may consume large amounts of RAM, consider using an embedded key-value store like [JDBM](http://code.google.com/p/jdbm2/) or some other persistent Map implementation.

[top](#)

***

### order

Order the items in the stream according to the closure if provided.  If no closure is provided, then a default sort order is used.

[top](#)

***

### orderMap

For every incoming map, sort with supplied closure or `T.decr` or `T.incr` and emit keys.

[top](#)

***

### path

Gets the path through the pipeline up to this point, where closures are post-processing for each object in the path.  If the path step is provided closures then, in a round robin fashion, the closures are evaluated over each object of the path and that post-processed path is returned.

[top](#)

***

### scatter

Unroll all objects in the iterable at that step. Gather/Scatter is good for breadth-first traversals where the gather closure filters out unwanted elements at the current radius.

#### See Also

* [gather](#transform/gather)

[top](#)

***

### select

Select the named steps to emit after select with post-processing closures.

[top](#)

***

### shuffle

Collect all objects up to that step into a list and randomize their order.

#### See Also

* [random](#filter/random)

[top](#)

***

### transform

Transform emits the result of a closure.

[top](#)

***

## Filter

Filter steps decide whether to allow an object to pass to the next step or not.


### [i..j]

A range filter that emits the objects within a range.

[top](#)

***

### back

Go back to the results from n-steps ago or go back to the results of a named step.

```text
gremlin> g.V.out('knows').has('age', T.gt, 30).back(2).age
==>29
gremlin> g.V.as('x').outE('knows').inV.has('age', T.gt, 30).back('x').age
==>29
```

[top](#)

***

### dedup

Emit only incoming objects that have not been seen before with an optional closure being the object to check on.

[top](#)

***

### except

Emit everything to pass except what is in the supplied collection.

#### See Also

* [retain](#filter/retain)

[top](#)

***

### filter

Decide whether to allow an object to pass.  Return true from the closure to allow an object to pass.

[top](#)

***

### has

Allows an element if it has a particular property.  Utilizes several options for comparisons through `T`:

* T.gt - greater than 
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

It is worth noting that the syntax of `has` is similar to `g.V("name", "marko")`, which has the difference of being a [key index](https://github.com/tinkerpop/blueprints/wiki/Graph-Indices) lookup and as such will perform faster. In contrast, this line, `g.V.has("name", "marko")`, will iterate over all vertices checking the `name` property of each vertex for a match and will be significantly slower than the key index approach.

#### See Also

* [hasNot](#filter/hasnot)

[top](#)

***

### hasNot

Allows an element if it does not have a particular property.  Utilizes several options for comparisons on through `T`:

* T.gt - greater than 
* T.gte - greater than or equal to
* T.eq - equal to
* T.neq - not equal to
* T.lte - less than or equal to
* T.lt - less than

[top](#)

***

### interval

Allow elements to pass that have their property in the provided start and end interval.

#### See Also

* [has](#filter/has)

[top](#)

***

### random

Emits the incoming object if biased coin toss is heads.

[top](#)

***

### retain

Allow everything to pass except what is not in the supplied collection.

#### See Also

* [except](#filter/except)

[top](#)

***

### simplePath

Emit the object only if the current path has no repeated elements.

[top](#)

***

## Side Effect

Side Effect steps pass the object, but yield some kind of side effect while doing so.

### as

Emits input, but names the previous step.

[top](#)

***

### groupBy

Emits input, but groups input after processing it by provided key-closure and value-closure.  It is also possible to supply an optional reduce-closure.  

#### See Also

* [groupCount](#side-effect/groupcount)

[top](#)

***

### groupCount

Emits input, but updates a map for each input, where closures provides generic map update.

#### See Also

* [groupBy](#side-effect/groupby)

[top](#)

***

### optional

Behaves similar to `back` except that it does not filter. It will go down a particular path and back up to where it left off. As such, its useful for yielding a sideeffect down a particular branch.

#### See Also

* [back](#filter/back)

[top](#)

***

### sideEffect

Emits input, but calls a side effect closure on each input.

[top](#)

***

### store

Emits input, but adds input to collection, where provided closure processes input prior to insertion (lazy).  In being "lazy", 'store' will keep element as they are being requested.

#### See Also

* [aggregate](#side-effect/aggregate)
* [fill](#methods/pipe-fill)

[top](#)

***

### table

Emits input, but stores row of as values (constrained by column names if provided) in a table.  Accepts an optional set of closures that are applied in round-robin fashion to each column of the table.

### tree

[top](#)

***

Emit input, but stores the tree formed by the traversal as a map.  Accepts an optional set of closures to be applied in round-robin fashion over each level of the tree.

## Branch

Branch steps decide which step to take.

### copySplit

Copies incoming object to internal pipes.

#### See Also

* [exhaustMerge](#branch/exhaustmerge)
* [fairMerge](#branch/fairmerge)

[top](#)

***

### exhaustMerge

Used in combination with a `copySplit`, merging the parallel traversals by exhaustively getting the objects of the first, then the second, etc.

#### See Also

* [copySplit](#branch/copysplit)
* [fairMerge](#branch/fairmerge)

[top](#)

***

### fairMerge

Used in combination with a `copySplit`, merging the parallel traversals in a round-robin fashion.

#### See Also

* [copySplit](#branch/copysplit)
* [exaustMerge](#branch/exhaustmerge)

[top](#)

***

### ifThenElse

Allows for if-then-else conditional logic.

[top](#)

***

### loop 

Loop over a particular set of steps in the pipeline.  The first argument is either the number of steps back in the pipeline to go or a named step.  The second argument is a while closure evaluating the current object.  The `it` component of the loop step closure has three properties that are accessible. These properties can be used to reason about when to break out of the loop.

* `it.object`: the current object of the traverser.
* `it.path`: the current path of the traverser.
* `it.loops`: the number of times the traverser has looped through the loop section.

The final argument is known as the "emit" closure. This boolean-based closure will determine wether the current object in the loop structure is emitted or not. As such, it is possible to emit intermediate objects, not simply those at the end of the loop.

[top](#)

***

## Recipes

Recipes are common patterns that are seen in using Gremlin.

### Duplicate Edges

Strictly speaking, you cannot have duplicated egdes with the same id.  This example finds edges with same `outV/inV/label` properties.

[top](#)

***

### Hiding Console Output

The Gremlin Console automatically iterates the pipe and outputs the results to the console.  In some cases, this can lead to lots of screen output that isn't terribly useful.  To suppress the output, consider the following:

#### See Also

* [Pipe.iterate](#methods/pipe-iterate)
* [Pipe.next](#methods/pipe-next)

[top](#)

***

### Paging Results

It is sometimes desireable to not return an entire results set.  Results can be paged or limited as follows:

[top](#)

***

### Paths Between Two Vertices

First, paths for a directed graph:

Then, undirected:

Use the value of `it.loops<=3`to control the depth of the traversal:

[top](#)

***

### Reading From a File

Reading data from an edge file formatted as CSV is easy to do with Gremlin.

[top](#)

***

### Sampling

It is sometimes useful to grab a random sample of the items in a collection.  That can be done to some degree with the [random](#filter.random) step, but getting an explicit number of items is not supported using that step.

[top](#)

***

### Shortest Path

Find the shortest path between two vertices:

[top](#)

***
