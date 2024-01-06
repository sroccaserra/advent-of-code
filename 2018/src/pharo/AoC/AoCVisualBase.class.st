"
no comment
"
Class {
	#name : #AoCVisualBase,
	#superclass : #AoCBase,
	#category : #'AoC-Base'
}

{ #category : #running }
AoCVisualBase class >> ! filename [

	| aoc result |
	aoc := self new.
	result := aoc run: filename.
	aoc show.
	^ result
]

{ #category : #testing }
AoCVisualBase class >> isAbstract [

	^ self == AoCVisualBase
]

{ #category : #showing }
AoCVisualBase >> show [

	self subclassResponsibility
]
