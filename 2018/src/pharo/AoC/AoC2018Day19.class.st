"
no comment
"
Class {
	#name : #AoC2018Day19,
	#superclass : #AoC2018DayWithVM,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day19 >> debugPartTwo [

	state := AoCState fromNumbers: #( 1 0 0 0 0 0 ).
	self debug
]

{ #category : #running }
AoC2018Day19 >> fastPartOne [

	| target sum j |
	sum := 0.
	target := 888.
	1 to: target do: [ :i |
		j := 1.
		[ i * j <= target ] whileTrue: [
			i * j = target ifTrue: [ sum := sum + i ].
			j := j + 1 ] ].
	^ sum
]

{ #category : #running }
AoC2018Day19 >> fastPartTwo [

	| target sum j |
	sum := 0.
	target := 10551288.
	1 to: target do: [ :i |
		j := 1.
		[ i * j <= target ] whileTrue: [
			i * j = target ifTrue: [ sum := sum + i ].
			j := j + 1 ] ].
	^ sum
]

{ #category : #running }
AoC2018Day19 >> rewrittenPartTwo [

	state := AoCState fromNumbers: #( 0 1 3 10551288 1 0 10550400 ).
	[ (state at: 4) <= (state at: 3) ] whileTrue: [
		state at: 1 put: 1.
		[ (state at: 1) <= (state at: 3) ] whileTrue: [
			(state at: 4) * (state at: 1) = 10551288 ifTrue: [
				state at: 0 put: (state at: 0) + (state at: 4) ].
			state at: 1 put: (state at: 1) + 1 ].
		state at: 4 put: (state at: 4) + 1 ].
	^ state at: 0
]

{ #category : #running }
AoC2018Day19 >> run: filename [

	self initializeFromInput: filename.
	^ {
		  self fastPartOne.
		  self fastPartTwo }
]

{ #category : #running }
AoC2018Day19 >> solvePartOne [

	state := AoCState fromNumbers: #( 0 0 0 0 0 0 ).
	[ self isHalted ] whileFalse: [ self step ].
	^ state at: 0
]
