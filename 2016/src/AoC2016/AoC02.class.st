"
nc
"
Class {
	#name : #AoC02,
	#superclass : #AoCBase,
	#instVars : [
		'incs'
	],
	#category : #AoC2016
}

{ #category : #running }
AoC02 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	^ {
		  (self solvePartOne: lines).
		  (self solvePartTwo: lines) }
]

{ #category : #solving }
AoC02 >> solvePartOne: lines [

	| pos keypad result |
	pos := 2 @ 2.
	incs := {
		        ($U -> (0 @ -1)).
		        ($D -> (0 @ 1)).
		        ($L -> (-1 @ 0)).
		        ($R -> (1 @ 0)) } asDictionary.
	keypad := #( 1 2 3 4 5 6 7 8 9 ).

	result := OrderedCollection new.
	lines do: [ :line |
		line do: [ :c |
			| inc |
			inc := incs at: c.
			pos := pos + inc.
			pos := (pos min: 3 @ 3) max: 1 @ 1 ].
		result add: (keypad at: pos y - 1 * 3 + pos x) ].
	^ result asArray
]

{ #category : #solving }
AoC02 >> solvePartTwo: lines [

	| pos keypad result keypadAt |
	pos := 1 @ 3.
	incs := {
		        ($U -> (0 @ -1)).
		        ($D -> (0 @ 1)).
		        ($L -> (-1 @ 0)).
		        ($R -> (1 @ 0)) } asDictionary.
	keypad := #( 0 0 1 0 0 0 2 3 4 0 5 6 7 8 9 0 $A $B $C 0 0 0 $D 0 0 ).
	keypadAt := [ :p | keypad at: p y - 1 * 5 + p x ifAbsent: 0 ].

	result := OrderedCollection new.
	lines do: [ :line |
		line do: [ :c |
			| inc |
			inc := incs at: c.
			pos := pos + inc.
			(keypadAt value: pos) = 0 ifTrue: [ pos := pos - inc ] ].
		result add: (keypadAt value: pos) ].
	^ result asArray
]
