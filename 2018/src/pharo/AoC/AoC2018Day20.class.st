"
Plan : passer de `^ENWWW(NEEE|SSE(EE|N))$` à

```text
{
	ENWWW: [
		{ NEEE: [] },
		{ SSE: [{ EE: [] }, { N: [] }] }
	]
}
```

Pb : traiter les cas `^ENNWSWW(NEWS|)SSSEEN(WNSE|)EE(SWEN|)NNN$`
"
Class {
	#name : #AoC2018Day20,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day20 >> computeDistances: adjacencyLists [

	| distances queue |
	distances := Dictionary new.
	distances at: 0 @ 0 put: 0.
	queue := OrderedCollection new.
	queue add: 0 @ 0.
	[ queue isEmpty ] whileFalse: [
		| pos neighbors d |
		pos := queue removeFirst.
		d := distances at: pos.
		neighbors := (adjacencyLists at: pos) reject: [ :n |
			             distances includesKey: n ].
		neighbors do: [ :n |
			distances at: n put: d + 1.
			queue add: n ] ].

	^ distances
]

{ #category : #running }
AoC2018Day20 >> parseEdges: line [
	"^ENWWW(NEEE|SSE(EE|N))$"

	| positions directions stack starts ends edges actions |
	positions := { (0 @ 0) } asSet.
	starts := { (0 @ 0) } asSet.
	ends := Set new.
	stack := Stack new.
	edges := Set new.

	directions := {
		              ($N -> (0 @ -1)).
		              ($S -> (0 @ 1)).
		              ($E -> (1 @ 0)).
		              ($W -> (-1 @ 0)) } asDictionary.
	actions := {
		           ($^ -> [  ]).
		           ($$ -> [  ]).
		           (#move -> [ :dir |
		            positions do: [ :pos |
			            | newPos |
			            newPos := pos + dir.
			            edges add: (pos corner: newPos) ].
		            positions := positions collect: [ :pos | pos + dir ] ]).
		           ($( -> [
		            stack push: {
				            starts.
				            ends }.
		            starts := positions.
		            ends := Set new ]).
		           ($) -> [
		            | prevs |
		            positions addAll: ends.
		            prevs := stack pop.
		            starts := prevs first.
		            ends := prevs second ]).
		           ($| -> [
		            ends addAll: positions.
		            positions := starts ]) } asDictionary.

	line do: [ :char |
		(directions includesKey: char)
			ifTrue: [
				| dir |
				dir := directions at: char.
				(actions at: #move) value: dir ]
			ifFalse: [ (actions at: char) value ] ].

	^ edges
]

{ #category : #running }
AoC2018Day20 >> run: filename [

	| lines edges adjacencyLists distances |
	lines := self loadLines: filename.
	edges := self parseEdges: lines first.

	adjacencyLists := Dictionary new.
	edges do: [ :rect |
		(adjacencyLists at: rect origin ifAbsentPut: Set new) add:
			rect corner.
		(adjacencyLists at: rect corner ifAbsentPut: Set new) add:
			rect origin ].

	distances := self computeDistances: adjacencyLists.

	^ {
		  (self solvePartOne: distances).
		  (self solvePartTwo: distances) }
]

{ #category : #running }
AoC2018Day20 >> solvePartOne: distances [

	^ distances values max
]

{ #category : #running }
AoC2018Day20 >> solvePartTwo: distances [

	^ (distances values select: [ :d | d >= 1000 ]) size
]
