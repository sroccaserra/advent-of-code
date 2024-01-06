"
no comment
"
Class {
	#name : #AoC2018Day18,
	#superclass : #AoCVisualBase,
	#instVars : [
		'grid'
	],
	#category : #'AoC-2018'
}

{ #category : #showing }
AoC2018Day18 class >> groundGraphics [

	^ '[gfx]08081111111111111111111111111111111111111511111111111115111111111111[/gfx]'
]

{ #category : #showing }
AoC2018Day18 class >> lumberyardGraphics [

	^ '[gfx]08081141112114291429142914291249144912421242147912791797179711711171[/gfx]'
]

{ #category : #showing }
AoC2018Day18 class >> treesGraphics [

	^ '[gfx]080811b111b111b11bbb1bbb11b111b11bbb1bbb1141bbbbb1411141111111411111[/gfx]'
]

{ #category : #running }
AoC2018Day18 >> countResult [

	| nbTrees nbLumberyards |
	nbTrees := 0.
	nbLumberyards := 0.
	grid positionsDo: [ :pos |
		| c |
		c := grid charAt: pos.
		c = $| ifTrue: [ nbTrees := nbTrees + 1 ].
		c = $# ifTrue: [ nbLumberyards := nbLumberyards + 1 ] ].
	^ nbTrees * nbLumberyards
]

{ #category : #running }
AoC2018Day18 >> run: filename [

	| lines startDict partOne partTwo |
	lines := self loadLines: filename.
	grid := AoCTextGrid fromLines: lines.
	startDict := grid dict copy.
	partOne := self solvePartOne.
	grid dict: startDict.
	partTwo := self solvePartTwo.
	^ {
		  partOne.
		  partTwo }
]

{ #category : #showing }
AoC2018Day18 >> show [

	| forms frame canvas |
	forms := {
		         ($. -> self class groundGraphics).
		         ($# -> self class treesGraphics).
		         ($| -> self class lumberyardGraphics) } asDictionary
		         collect: [ :gfx | AoCGraphics pico8StringToForm: gfx ].

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	grid positionsDo: [ :pos |
		canvas
			drawImage: (forms at: (grid charAt: pos) ifAbsent: (forms at: $.))
			at: 8 * (pos - (1 @ 1)) ].

	(frame magnifyBy: 2) asMorph openInWindowLabeled: 'AoC 2018 Day 18'
]

{ #category : #running }
AoC2018Day18 >> solvePartOne [

	10 timesRepeat: [ grid := self step ].

	^ self countResult
]

{ #category : #running }
AoC2018Day18 >> solvePartTwo [

	| dictsSequence n target cycleStart cycleSize targetIndex |
	target := 1000000000.
	n := 0.
	dictsSequence := OrderedCollection new.
	[ dictsSequence includes: grid dict ] whileFalse: [
		dictsSequence add: grid dict.
		grid := self step.
		n := n + 1 ].

	cycleStart := dictsSequence indexOf: grid dict.
	cycleSize := dictsSequence size - cycleStart + 1.
	targetIndex := target - cycleStart % cycleSize + cycleStart + 1.
	grid dict: (dictsSequence at: targetIndex).
	^ self countResult
]

{ #category : #running }
AoC2018Day18 >> step [

	| result |
	result := AoCTextGrid new.
	result w: grid w h: grid h.
	grid positionsDo: [ :pos |
		| neighbors c |
		neighbors := ((grid eightNeighborsAt: pos) groupedBy: [ :v | v ])
			             collect: [ :v | v size ].
		c := grid charAt: pos.
		c = $. ifTrue: [
			result at: pos putChar: ((neighbors at: $| ifAbsent: 0) >= 3
					 ifTrue: [ $| ]
					 ifFalse: [ $. ]) ].
		c = $| ifTrue: [
			result at: pos putChar: ((neighbors at: $# ifAbsent: 0) >= 3
					 ifTrue: [ $# ]
					 ifFalse: [ $| ]) ].
		c = $# ifTrue: [
			result
				at: pos
				putChar: (((neighbors at: $# ifAbsent: 0) >= 1 and: [
						  (neighbors at: $| ifAbsent: 0) >= 1 ])
						 ifTrue: [ $# ]
						 ifFalse: [ $. ]) ] ].
	^ result
]
