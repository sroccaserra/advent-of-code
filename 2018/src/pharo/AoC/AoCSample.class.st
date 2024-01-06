"
no comment
"
Class {
	#name : #AoCSample,
	#superclass : #Object,
	#instVars : [
		'before',
		'instruction',
		'after'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCSample >> after: fourNumbers [

	after := fourNumbers
]

{ #category : #accessing }
AoCSample >> before: fourNumbers [

	before := fourNumbers
]

{ #category : #counting }
AoCSample >> countMatching [

	^ AoCInstruction implementations values count: [ :implementation | 
		  self matches: implementation ]
]

{ #category : #accessing }
AoCSample >> instruction: anInstruction [

	instruction := anInstruction
]

{ #category : #counting }
AoCSample >> matches: anImplementation [

	| state |
	state := AoCState fromNumbers: before.
	instruction
		implementation: anImplementation;
		executeOn: state.
	^ state values = after
]

{ #category : #accessing }
AoCSample >> numericalOpcode [

	^ instruction numericalOpcode
]
