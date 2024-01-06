Class {
	#name : #AoC2018Day20Test,
	#superclass : #TestCase,
	#category : #'AoC-2018'
}

{ #category : #tests }
AoC2018Day20Test >> assertDictToJson: result equals: expected [

	| serializable json |
	serializable := Dictionary new.
	result keysAndValuesDo: [ :key :value |
		serializable
			at: key asString
			put: (value collect: [ :each | each asString ]) asArray ].
	json := STONJSON toString: serializable.
	self assert: json equals: expected.
]

{ #category : #tests }
AoC2018Day20Test >> assertSetToJson: aSet equals: expected [

	| json |
	json := STONJSON toString: (aSet asArray collect: #asString).
	self assert: json equals: expected
]

{ #category : #tests }
AoC2018Day20Test >> testParsingEW [

	| day20 result |
	day20 := AoC2018Day20 new.
	result := day20 parseEdges: '^EW$'.
	self
		assertSetToJson: result
		equals: '["(0@0) corner: (1@0)"]'
]

{ #category : #tests }
AoC2018Day20Test >> testParsingNS [

	| day20 result |
	day20 := AoC2018Day20 new.
	result := day20 parseEdges: '^NS$'.
	self
		assertSetToJson: result
		equals: '["(0@ -1) corner: (0@0)"]'
]
