"
1@1 1@2 1@3
2@1 2@2 2@3
3@1 3@2 3@3
4@1 4@2 4@3
5@1 5@2 5@3
6@1 6@2 6@3

  1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17  18
1@1 1@2 1@3 2@1 2@2 2@3 3@1 3@2 3@3 4@1 4@2 4@3 5@1 5@2 5@3 6@1 6@2 6@3
  0   1   2   3   4   5   6   7   8   9  10  11  12  13  14  15  16  17

 0  3  6
 9 12 15
 1  4  7
10 13 16
 2  5  8
11 14 17
"
Class {
	#name : #AoC03,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC03 >> run: filename [

	| lines triangleSpecs |
	lines := self loadLines: filename.
	triangleSpecs := lines collect: [ :line |
		                 line substrings collect: #asNumber ].
	^ {
		  (self solvePartOne: triangleSpecs).
		  (self solvePartTwo: triangleSpecs) }
]

{ #category : #solving }
AoC03 >> solvePartOne: triangleSpecs [

	^ triangleSpecs count: [ :spec |
		  (spec at: 1) + (spec at: 2) > (spec at: 3) and: [
			  (spec at: 1) + (spec at: 3) > (spec at: 2) and: [
				  (spec at: 2) + (spec at: 3) > (spec at: 1) ] ] ]
]

{ #category : #solving }
AoC03 >> solvePartTwo: triangleSpecs [

	| nbRows nbColums flatSpecs result flatSpecsSize |
	nbColums := 3.
	nbRows := triangleSpecs size.
	[ (nbRows % 3) isZero ] assert.
	flatSpecs := triangleSpecs flattened.
	flatSpecsSize := flatSpecs size.
	result := OrderedCollection new.
	0 to: flatSpecsSize // 3 - 1 do: [ :n |
		| i |
		i := n * 9 + (n // (nbRows // 3)) % flatSpecsSize + 1.
		result add: {
				(flatSpecs at: i).
				(flatSpecs at: i + 3).
				(flatSpecs at: i + 6) } ].
	^ self solvePartOne: result
]
