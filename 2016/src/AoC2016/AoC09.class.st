"
nc
"
Class {
	#name : #AoC09,
	#superclass : #AoCBase,
	#instVars : [
		'isRecursive'
	],
	#category : #AoC2016
}

{ #category : #running }
AoC09 >> expandExpressionFrom: i and: aString on: counter [

	| di expandExp numbers expressionLength partToRepeat |
	di := 1.
	expandExp := String streamContents: [ :s |
		             [
		             | c |
		             c := aString at: i + di.
		             c ~= $) ifTrue: [ s nextPut: c ].
		             di := di + 1.
		             c ~= $) ] whileTrue ].
	numbers := (expandExp substrings: 'x') collect: #asInteger.
	expressionLength := numbers first.
	partToRepeat := aString
		                copyFrom: i + di
		                to: i + di + expressionLength - 1.
	counter value: numbers second * (isRecursive
			 ifTrue: [ self expandLine: partToRepeat ]
			 ifFalse: [ partToRepeat size ]).
	^ di + expressionLength
]

{ #category : #running }
AoC09 >> expandLine: aString [

	| counterMaker |
	counterMaker := [
	                | n |
	                n := 0.
	                [ :inc |
	                n := n + inc.
	                n ] ].
	^ self expandLine: aString on: counterMaker value
]

{ #category : #running }
AoC09 >> expandLine: aString on: counter [

	| i |
	i := 1.
	[ i <= aString size ] whileTrue: [
		| c |
		c := aString at: i.
		c = $(
			ifTrue: [
				i := i
				     +
				     (self expandExpressionFrom: i and: aString on: counter) ]
			ifFalse: [
				counter value: 1.
				i := i + 1 ] ].
	^ counter value: 0
]

{ #category : #running }
AoC09 >> run: filename [

	| lines |
	lines := self loadLines: filename.

	^ {
		  (self solvePartOne: lines).
		  (self solvePartTwo: lines) }
]

{ #category : #running }
AoC09 >> solvePartOne: lines [

	isRecursive := false.
	^ (lines collect: [ :line | self expandLine: line ]) sum
]

{ #category : #running }
AoC09 >> solvePartTwo: lines [

	isRecursive := true.
	^ (lines collect: [ :line | self expandLine: line ]) sum
]
