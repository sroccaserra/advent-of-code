"
Le volume définit par un nanobot en manhatan distance est un octaèdre (octahedron). En 2d, c'est une surface, un carré à 45 degrés.
"
Class {
	#name : #AoC2018Day23,
	#superclass : #AoCBase,
	#instVars : [
		'nanobots'
	],
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day23 >> findCliqueFor: aNanobot [
	"Simplest clique algo, works in my case if nanobots are sorted from most colliding to least colliding.
	See Bron Kerbosh for an efficient algorithm.
	- https://en.wikipedia.org/wiki/Bron%E2%80%93Kerbosch_algorithm
	"

	| result |
	result := OrderedCollection new.
	nanobots do: [ :e |
		(result allSatisfy: [ :fromClique | fromClique overlapsWith: e ])
			ifTrue: [ result add: e ] ].
	^ result
]

{ #category : #running }
AoC2018Day23 >> parseLine: aString [

	| numbers center |
	numbers := ((RxMatcher forString: '[-0-9]+') matchesIn: aString)
		           collect: #asInteger.
	center := G3DCoordinates
		          x: numbers first
		          y: numbers second
		          z: numbers third.

	^ AoCNanobot new
		  center: center;
		  radius: numbers fourth;
		  yourself
]

{ #category : #running }
AoC2018Day23 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	nanobots := lines collect: [ :l | self parseLine: l ].
	^ {
		  (self solvePartOne).
		  (self solvePartTwo) }
]

{ #category : #running }
AoC2018Day23 >> solvePartOne [

	| mainBot |
	mainBot := (nanobots sort: [ :bot1 :bot2 | bot1 radius > bot2 radius ])
		           first.
	^ nanobots count: [ :other | mainBot isInRange: other center ]
]

{ #category : #running }
AoC2018Day23 >> solvePartTwo [

	| nbOfCollisions clique |
	nbOfCollisions := (nanobots collect: [ :each |
		                   each
		                   ->
		                   (nanobots count: [ :other |
			                    each overlapsWith: other ]) ]) asDictionary.

	nanobots sort: [ :e1 :e2 |
		(nbOfCollisions at: e1) > (nbOfCollisions at: e2) ].

	clique := self findCliqueFor: nanobots first.
	^ (clique collect: [ :e | e distanceToOrigin ]) max
]
