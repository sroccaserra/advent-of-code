"
no comment
"
Class {
	#name : #AoC2018DayWithVM,
	#superclass : #AoCVisualBase,
	#instVars : [
		'ipReg',
		'program',
		'state',
		'view',
		'instructionCount'
	],
	#category : #'AoC-2018'
}

{ #category : #testing }
AoC2018DayWithVM class >> isAbstract [

	^ self == AoC2018DayWithVM
]

{ #category : #running }
AoC2018DayWithVM >> debug [

	[ state isNotNil ] assert.
	self show.
	view on: #mouseUp send: #value to: [
		self step.
		Clipboard clipboardText: state asString.
		self show ]
]

{ #category : #running }
AoC2018DayWithVM >> initializeFromInput: filename [

	| lines |
	lines := self loadLines: filename.
	ipReg := (lines at: 1) last asInteger - $0 asInteger.
	program := lines allButFirst collect: [ :line | self parseLine: line ].
	instructionCount := 0
]

{ #category : #running }
AoC2018DayWithVM >> isHalted [

	^ (state at: ipReg) < 0 or: [ program size <= (state at: ipReg) ]
]

{ #category : #parsing }
AoC2018DayWithVM >> parseLine: aString [

	| parts mnemonic args |
	parts := aString substrings.
	mnemonic := parts first.
	args := parts allButFirst collect: #asInteger.
	^ (AoCInstruction named: mnemonic)
		  a: args first;
		  b: args second;
		  c: args third;
		  yourself
]

{ #category : #running }
AoC2018DayWithVM >> pc [

	^ state at: ipReg
]

{ #category : #running }
AoC2018DayWithVM >> pc: aNumber [

	state at: ipReg put: aNumber
]

{ #category : #showing }
AoC2018DayWithVM >> show [

	| programLines |
	view ifNil: [
		view := SpRubScrolledTextMorph new.
		view extent: 400 @ 800.
		view openInWindowLabeled: self className ].

	programLines := program collectWithIndex: [ :each :i |
		                | prefix pc |
		                pc := state at: ipReg.
		                prefix := i - 1 = pc
			                          ifTrue: [ '>' ]
			                          ifFalse: [ (i - 1) asString ].
		                prefix , Character tab asString , each asString ].
	view setText: (Character cr join: programLines , ' ' , {
				 state asString.
				 instructionCount.
				 self isHalted })
]

{ #category : #running }
AoC2018DayWithVM >> step [

	| instruction |
	instruction := program at: self pc + 1.
	instruction executeOn: state.
	self pc: self pc + 1.
	instructionCount := instructionCount + 1
]
