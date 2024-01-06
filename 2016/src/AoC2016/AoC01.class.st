"
nc
"
Class {
	#name : #AoC01,
	#superclass : #AoCBase,
	#instVars : [
		'positions'
	],
	#category : #AoC2016
}

{ #category : #running }
AoC01 >> run: filename [

	| lines commands |
	lines := self loadLines: filename.
	commands := lines first substrings: ', '.
	^ {
		  (self solvePartOne: commands).
		  self solvePartTwo }
]

{ #category : #solving }
AoC01 >> solvePartOne: commands [

	| pos dir rotationMethods |
	pos := 0 @ 0.
	dir := 0 @ -1.
	rotationMethods := {
		                   ($R -> #rightRotated).
		                   ($L -> #leftRotated) } asDictionary.
	positions := OrderedCollection new.
	positions add: pos.
	commands do: [ :c |
		| dist |
		dist := c allButFirst asNumber.
		dir := dir perform: (rotationMethods at: c first).
		dist timesRepeat: [
			pos := pos + dir.
			positions add: pos ] ].

	^ pos x abs + pos y abs
]

{ #category : #solving }
AoC01 >> solvePartTwo [

	| seen |
	seen := Set new.
	positions do: [ :pos |
		(seen includes: pos) ifTrue: [ ^ pos x abs + pos y abs ].
		seen add: pos ].

	^ -1
]
