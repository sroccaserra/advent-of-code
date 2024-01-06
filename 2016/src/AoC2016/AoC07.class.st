"
nc
"
Class {
	#name : #AoC07,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC07 >> findAbas: aString [

	| result |
	result := OrderedCollection new.
	aString size < 3 ifTrue: [ ^ result ].
	1 to: aString size - 2 do: [ :i |
		| aa ab |
		aa := (aString at: i) = (aString at: i + 2).
		ab := (aString at: i) ~= (aString at: i + 1).
		(aa and: [ ab ]) ifTrue: [
			result add: (aString copyFrom: i to: i + 2) ] ].
	^ result
]

{ #category : #running }
AoC07 >> hasAbba: aString [

	aString size < 4 ifTrue: [ ^ false ].
	1 to: aString size - 3 do: [ :i |
		| aa ab bb |
		aa := (aString at: i) = (aString at: i + 3).
		ab := (aString at: i) ~= (aString at: i + 1).
		bb := (aString at: i + 1) = (aString at: i + 2).
		(aa and: [ ab and: [ bb ] ]) ifTrue: [ ^ true ] ].
	^ false
]

{ #category : #running }
AoC07 >> run: filename [

	| lines parts outsideValues insideValues |
	lines := self loadLines: filename.
	parts := lines collect: [ :line | line substrings: '[]' ].
	outsideValues := parts collect: [ :e |
		                 e withIndexSelect: [ :_ :i | i odd ] ].
	insideValues := parts collect: [ :e |
		                e withIndexSelect: [ :_ :i | i even ] ].
	^ {
		  (self solvePartOne: {
				   outsideValues.
				   insideValues }).
		  (self solvePartTwo: {
				   outsideValues.
				   insideValues }) }
]

{ #category : #running }
AoC07 >> solvePartOne: params [

	| outsideValues insideValues result |
	outsideValues := params first.
	insideValues := params second.
	result := 0.
	1 to: outsideValues size do: [ :i |
		| outsideStrings insideStrings |
		outsideStrings := outsideValues at: i.
		insideStrings := insideValues at: i.

		((outsideStrings anySatisfy: [ :s | self hasAbba: s ]) and: [
			 insideStrings noneSatisfy: [ :s | self hasAbba: s ] ]) ifTrue: [
			result := result + 1 ] ].
	^ result
]

{ #category : #running }
AoC07 >> solvePartTwo: params [

	| outsideValues insideValues result |
	outsideValues := params first.
	insideValues := params second.
	result := 0.
	1 to: outsideValues size do: [ :i |
		| outsideAbas insideAbas |
		outsideAbas := (outsideValues at: i) flatCollect: [ :s |
			               self findAbas: s ].
		insideAbas := (insideValues at: i) flatCollect: [ :s |
			              self findAbas: s ].

		(outsideAbas anySatisfy: [ :aba |
			 | bab |
			 bab := (aba copyFrom: 2 to: 3) , (aba at: 2) asString.
			 insideAbas includes: bab ]) ifTrue: [ result := result + 1 ] ].
	^ result
]
