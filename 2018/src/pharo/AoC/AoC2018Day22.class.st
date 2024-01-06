"
no comment
"
Class {
	#name : #AoC2018Day22,
	#superclass : #AoCBase,
	#instVars : [
		'depth',
		'target',
		'types',
		'toolsForType'
	],
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day22 >> computeTypes [

	| geologicIndexes erosionLevels maxX maxY |
	maxX := target x * 2.
	maxY := target y * 2.
	geologicIndexes := Dictionary new.
	erosionLevels := Dictionary new.
	0 to: maxY do: [ :y |
		0 to: maxX do: [ :x |
			| pos |
			pos := x @ y.
			0 = y ifTrue: [
				| i |
				i := x * 16807.
				geologicIndexes at: pos put: i.
				erosionLevels at: pos put: i + depth % 20183 ].
			0 = x ifTrue: [
				| i |
				i := y * 48271.
				geologicIndexes at: pos put: i.
				erosionLevels at: pos put: i + depth % 20183 ].
			(x ~= 0 and: [ y ~= 0 ]) ifTrue: [
				| i |
				i := (erosionLevels at: pos - (1 @ 0))
				     * (erosionLevels at: pos - (0 @ 1)).
				geologicIndexes at: pos put: i.
				erosionLevels at: pos put: i + depth % 20183 ].
			x @ y = target ifTrue: [
				geologicIndexes at: target put: 0.
				erosionLevels at: target put: 0 + depth % 20183 ] ] ].

	types := Dictionary new.
	0 to: maxY do: [ :y |
		0 to: maxX do: [ :x |
			| pos type |
			pos := x @ y.
			type := (erosionLevels at: pos) % 3.
			types at: pos put: type ] ]
]

{ #category : #initialization }
AoC2018Day22 >> initialize [

	super initialize.
	toolsForType := {
		                (0 -> #( #climbingGear #torch )).
		                (1 -> #( #climbingGear #neither )).
		                (2 -> #( #torch #neither )) } asDictionary
]

{ #category : #running }
AoC2018Day22 >> isPositionAt: aPoint compatibleWith: aTool [

	^ (toolsForType at: (types at: aPoint)) includes: aTool
]

{ #category : #running }
AoC2018Day22 >> possibleMovesFrom: aPointAndTool [

	| point tool compatibleTools otherTool result neighbors type |
	point := aPointAndTool first.
	tool := aPointAndTool second.

	neighbors := (point fourNeighbors select: [ :n |
		              types includesKey: n ]) select: [ :n |
		             self isPositionAt: n compatibleWith: tool ].

	result := neighbors asOrderedCollection collect: [ :n |
		          {
			          n.
			          tool.
			          1 } ].

	type := types at: point.
	compatibleTools := toolsForType at: type.
	[ compatibleTools size = 2 ] assert.
	otherTool := compatibleTools first = tool
		             ifTrue: [ compatibleTools second ]
		             ifFalse: [ compatibleTools first ].
	result add: {
			point.
			otherTool.
			7 }.

	^ result
]

{ #category : #running }
AoC2018Day22 >> run: filename [

	| lines targetParts |
	lines := self loadLines: filename.
	depth := lines first substrings last asInteger.
	targetParts := lines second substrings last substrings: ','.
	target := targetParts first asInteger @ targetParts second asInteger.

	self computeTypes.

	^ {
		  self solvePartOne.
		  self solvePartTwo }
]

{ #category : #running }
AoC2018Day22 >> solvePartOne [

	^ types values sum
]

{ #category : #running }
AoC2018Day22 >> solvePartTwo [

	| start distances pq |
	start := {
		         (0 @ 0).
		         #torch }.
	distances := Dictionary new.
	distances at: start put: 0.

	pq := Heap new.
	pq sortBlock: [ :e1 :e2 | (distances at: e1) <= (distances at: e2) ].
	pq add: start.

	[ pq isEmpty ] whileFalse: [
		| posAndTool distance |
		posAndTool := pq removeFirst.
		distance := distances at: posAndTool.
		(self possibleMovesFrom: posAndTool) do: [ :move |
			| moveDist movePosAndTool |
			movePosAndTool := {
				                  move first.
				                  move second }.
			moveDist := distance + move third.
			moveDist < (distances at: movePosAndTool ifAbsent: 999999) ifTrue: [
				distances at: movePosAndTool put: moveDist.
				pq add: movePosAndTool ] ] ].
	^ distances at: {
			  target.
			  #torch }
]
