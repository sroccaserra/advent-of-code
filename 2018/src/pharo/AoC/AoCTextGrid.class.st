"
I represent a text grid of dimensions w and h.

I am indexed by `x@y` (or `j@i`) points, with `1 <= x <= w` and `1 <= y <= h`.
"
Class {
	#name : #AoCTextGrid,
	#superclass : #Object,
	#instVars : [
		'dict',
		'w',
		'h',
		'origin',
		'margin'
	],
	#category : #'AoC-Base'
}

{ #category : #'instance creation' }
AoCTextGrid class >> fromLines: lines [

	| w h result |
	w := (lines at: 1) size.
	h := lines size.
	result := self new w: w h: h.
	lines withIndexDo: [ :line :i | 
		line withIndexDo: [ :char :j | result at: j @ i putChar: char ] ].
	^ result
]

{ #category : #'instance creation' }
AoCTextGrid class >> fromPoints: somePoints [

	| w h result xs ys origin margin |
	margin := 1 @ 1.
	xs := somePoints collect: [ :each | each x ].
	ys := somePoints collect: [ :each | each y ].
	w := 1 + xs max - xs min + (margin x * 2).
	h := 1 + ys max - ys min + (margin y * 2).
	origin := xs min @ ys min - margin.
	result := self new w: w h: h origin: origin margin: margin.
	somePoints do: [ :aPoint |
		result at: aPoint x @ aPoint y putChar: $# ].
	^ result
]

{ #category : #converting }
AoCTextGrid >> asString [

	^ String streamContents: [ :s | 
		  1 to: h do: [ :i | 
			  1 to: w do: [ :j | 
			  s nextPutAll: (dict at: j @ i ifAbsent: $x) asString ].
			  s cr ] ]
]

{ #category : #modifying }
AoCTextGrid >> at: aPoint ifAbsent: aValue [

	dict at: aPoint ifAbsent: aValue
]

{ #category : #modifying }
AoCTextGrid >> at: aPoint putChar: aChar [

	dict at: aPoint put: aChar
]

{ #category : #accessing }
AoCTextGrid >> charAt: aPoint [

	^ dict at: aPoint ifAbsent: $.
]

{ #category : #enumerating }
AoCTextGrid >> charsDo: aBlock [

	dict valuesDo: aBlock
]

{ #category : #modifying }
AoCTextGrid >> clearNonWallCells [

	self positionsDo: [ :pos | 
		(self charAt: pos) = $# ifFalse: [ self at: pos putChar: $. ] ]
]

{ #category : #accessing }
AoCTextGrid >> dict [

	^ dict
]

{ #category : #accessing }
AoCTextGrid >> dict: aDict [

	dict := aDict
]

{ #category : #accessing }
AoCTextGrid >> eightNeighborsAt: aPoint [

	^ aPoint eightNeighbors collect: [ :n | self charAt: n ]
]

{ #category : #accessing }
AoCTextGrid >> findChar: aChar [

	| result |
	result := OrderedCollection new.
	dict associationsDo: [ :assoc | 
		assoc value = aChar ifTrue: [ result addLast: assoc key ] ].
	^ result
]

{ #category : #accessing }
AoCTextGrid >> freeNeighborsAt: aPoint [

	| neighbors increments |
	increments := { 
		              (1 @ 0).
		              (-1 @ 0).
		              (0 @ 1).
		              (0 @ -1) }.
	neighbors := increments collect: [ :inc | aPoint + inc ].
	^ neighbors select: [ :neighbor | (self charAt: neighbor) = $. ]
]

{ #category : #accessing }
AoCTextGrid >> h [

	^ h
]

{ #category : #initialization }
AoCTextGrid >> initialize [

	dict := Dictionary new
]

{ #category : #accessing }
AoCTextGrid >> isWall: aPoint [

	^ (dict at: aPoint) = $#
]

{ #category : #accessing }
AoCTextGrid >> origin [

	^ origin
]

{ #category : #enumerating }
AoCTextGrid >> positions [

	| result |
	result := OrderedCollection new.
	1 to: h do: [ :i | 1 to: w do: [ :j | result add: j @ i ] ].
	^ result
]

{ #category : #enumerating }
AoCTextGrid >> positionsDo: aBlock [

	1 to: h do: [ :i | 1 to: w do: [ :j | aBlock value: j @ i ] ]
]

{ #category : #enumerating }
AoCTextGrid >> translation [

	^ origin - margin
]

{ #category : #accessing }
AoCTextGrid >> w [

	^ w
]

{ #category : #initialization }
AoCTextGrid >> w: wNumber h: hNumber [

	self
		w: wNumber
		h: hNumber
		origin: 1 @ 1
		margin: 0 @ 0
]

{ #category : #initialization }
AoCTextGrid >> w: wNumber h: hNumber origin: originPoint margin: marginPoint [

	w := wNumber.
	h := hNumber.
	origin := originPoint.
	margin := marginPoint.
]

{ #category : #enumerating }
AoCTextGrid >> worldPositionsDo: aBlock [

	| translation |
	translation := self translation.
	1 to: h do: [ :i |
	1 to: w do: [ :j | aBlock value: j @ i + translation ] ]
]
