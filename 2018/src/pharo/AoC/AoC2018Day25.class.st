"
no comment
"
Class {
	#name : #AoC2018Day25,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day25 >> computeAdjacencyLists: coordinates [

	| result |
	result := Dictionary new.
	coordinates do: [ :i |
		coordinates do: [ :j |
			(i manhattan: j) <= 3 ifTrue: [
				(result at: i ifAbsentPut: Set new) add: j ] ] ].

	^ result
]

{ #category : #running }
AoC2018Day25 >> run: filename [

	| coordinates numberArrays |
	numberArrays := (self loadLines: filename) collect: [ :line |
		                (line substrings: ',') collect: #asNumber ].
	coordinates := numberArrays collect: [ :each |
		               GCoordinates withCollection: each ].

	^ self solve: coordinates
]

{ #category : #running }
AoC2018Day25 >> solve: coordinates [

	| adjacencyLists seen result |
	adjacencyLists := self computeAdjacencyLists: coordinates.

	seen := Set new.
	result := 0.

	[ seen size = coordinates size ] whileFalse: [
		| root stack |
		result := result + 1.
		root := coordinates detect: [ :e | (seen includes: e) not ].
		stack := Stack new.
		stack push: root.
		seen add: root.
		[ stack notEmpty ] whileTrue: [
			| point |
			point := stack pop.
			((adjacencyLists at: point) reject: [ :e | seen includes: e ]) do: [
				:e |
				stack push: e.
				seen add: e ] ] ].

	^ result
]
