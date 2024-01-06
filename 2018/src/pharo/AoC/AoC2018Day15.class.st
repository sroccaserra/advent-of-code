"
AoC2018Day15 ! 'Developer/github/aoc2018/src/15.txt'

"
Class {
	#name : #AoC2018Day15,
	#superclass : #AoCVisualBase,
	#instVars : [
		'grid',
		'elves',
		'goblins',
		'markers',
		'elfStartPositions',
		'goblinStartPositions',
		'nbRounds'
	],
	#category : #'AoC-2018'
}

{ #category : #solving }
AoC2018Day15 >> findPathFromUnit: aUnit toClosestTarget: targets [

	| unitPosition q distances node d neighbors parents |
	unitPosition := aUnit position.
	q := OrderedCollection new.
	q add: unitPosition.
	distances := Dictionary new
		             at: unitPosition put: 0;
		             yourself.
	parents := Dictionary new.
	[ q isEmpty ] whileFalse: [
		node := q removeFirst.
		d := distances at: node.
		neighbors := (self freeNeighborsAt: node) reject: [ :n |
			             distances includesKey: n ].
		neighbors do: [ :n |
			parents at: n put: node.
			distances at: n put: d + 1.
			(targets includes: n)
				ifTrue: [ ^ self unwindPathFromNode: n withParents: parents ]
				ifFalse: [ q add: n ] ] ].
	^ LinkedList new
]

{ #category : #solving }
AoC2018Day15 >> freeNeighborsAt: aPoint [

	| orderedIncrements neighbors |
	orderedIncrements := { 
		                     (0 @ -1).
		                     (-1 @ 0).
		                     (1 @ 0).
		                     (0 @ 1) }.
	neighbors := orderedIncrements collect: [ :inc | aPoint + inc ].
	^ neighbors reject: [ :n | 
		  (grid isWall: n) or: [ 
			  (elves includesKey: n) or: [ goblins includesKey: n ] ] ]
]

{ #category : #showing }
AoC2018Day15 >> graphics [

	^ {
		  (#wall
		   ->
		   '[gfx]0808555555555666666d56ddddd25d22222255555555666d5666ddd256dd22225d22[/gfx]').
		  (#ground
		   ->
		   '[gfx]08081111111111111111111111111111111111111511111111111115111111111111[/gfx]').
		  (#elf
		   ->
		   '[gfx]0808118811111188811111aff11111aff111f78787f1118881111181811114414411[/gfx]').
		  (#goblin
		   ->
		   '[gfx]0808111111111b111b1111bbb111b11b11b11bbbbb1111bbb1111b111b111b111b11[/gfx]') }
		  asDictionary
]

{ #category : #initialization }
AoC2018Day15 >> initialize [

	self resetMarkers
]

{ #category : #showing }
AoC2018Day15 >> lookAt: aPoint [

	(elves includesKey: aPoint) ifTrue: [ ^ #elf ].
	(goblins includesKey: aPoint) ifTrue: [ ^ #goblin ].
	^ (grid isWall: aPoint)
		  ifTrue: [ ^ #wall ]
		  ifFalse: [ ^ #ground ]
]

{ #category : #solving }
AoC2018Day15 >> moveUnit: unit [

	| targetInRange |
	targetInRange := unit targetInRange.
	targetInRange ifNil: [ 
		| possibleTargets |
		possibleTargets := unit enemies flatCollect: [ :enemy | 
			                   self freeNeighborsAt: enemy position ].
		possibleTargets isEmpty ifFalse: [ 
			| path |
			path := self findPathFromUnit: unit toClosestTarget: possibleTargets.
			path isEmpty ifFalse: [ 
				path removeFirst.
				unit moveTo: path first.
				1 to: path size - 1 do: [ :n | 
				markers addLast: (AoCLineMarker from: (path at: n) to: (path at: n + 1)) ] ] ] ]
]

{ #category : #solving }
AoC2018Day15 >> playGameRound [

	| unitsToMove |
	self resetMarkers.
	unitsToMove := OrderedCollection new.
	grid positionsDo: [ :pos | 
		(elves includesKey: pos) ifTrue: [ unitsToMove addLast: (elves at: pos) ].
		(goblins includesKey: pos) ifTrue: [ unitsToMove addLast: (goblins at: pos) ] ].

	unitsToMove do: [ :unit | 
		unit isAlive ifTrue: [ 
			unit hasWon ifTrue: [ ^ false ].
			self playUnitTurn: unit ] ].
	nbRounds := nbRounds + 1.
	^ true
]

{ #category : #solving }
AoC2018Day15 >> playUnitTurn: unit [

	| targetInRange |
	self moveUnit: unit.
	targetInRange := unit targetInRange.
	targetInRange ifNotNil: [ unit attack: targetInRange ]
]

{ #category : #initialization }
AoC2018Day15 >> resetMarkers [
	markers := OrderedCollection new.
]

{ #category : #running }
AoC2018Day15 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	grid := AoCTextGrid fromLines: lines.
	elfStartPositions := grid findChar: $E.
	goblinStartPositions := grid findChar: $G.
	grid clearNonWallCells.

	^ { 
		  self solvePartOne.
		  self solvePartTwo }
]

{ #category : #showing }
AoC2018Day15 >> show [

	| forms frame canvas |
	forms := self graphics collect: [ :str | AoCGraphics pico8StringToForm: str ].

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	grid positionsDo: [ :pos | 
		canvas
			drawImage: (forms at: (self lookAt: pos) ifAbsent: (forms at: #ground))
			at: 8 * (pos - (1 @ 1)) ].

	markers do: [ :m | m drawOn: canvas ].
	(frame magnifyBy: 2) asMorph openInWindowLabeled:
		('AoC 2018 Day 15 round {1}' format: { nbRounds })
]

{ #category : #solving }
AoC2018Day15 >> solvePartOne [

	^ self solvePartOneWithElvesAttackPower: 3
]

{ #category : #solving }
AoC2018Day15 >> solvePartOneWithElvesAttackPower: anInteger [

	| remainingHP winners |
	self startGame: anInteger.
	[ self playGameRound ] whileTrue.
	remainingHP := 0.
	winners := goblins isEmpty
		           ifTrue: elves
		           ifFalse: goblins.
	winners do: [ :unit | remainingHP := remainingHP + unit hitPoints ].
	^ nbRounds * remainingHP
]

{ #category : #solving }
AoC2018Day15 >> solvePartTwo [

	| minRequiredPower |
	minRequiredPower := nil.
	(4 to: 100)
		findBinary: [ :elvesAttackPower | 
			self solvePartOneWithElvesAttackPower: elvesAttackPower.
			elves size = elfStartPositions size
				ifTrue: -1
				ifFalse: 1 ]
		ifNone: [ :a :b | minRequiredPower := b ].

	[ minRequiredPower isNotNil ] assert.
	^ self solvePartOneWithElvesAttackPower: minRequiredPower
]

{ #category : #solving }
AoC2018Day15 >> startGame: elvesAttackPower [

	nbRounds := 0.
	elves := Dictionary new.
	goblins := Dictionary new.

	elfStartPositions do: [ :pos | 
		| unit |
		unit := AoCDay15Unit new
			        position: pos;
			        attackPower: elvesAttackPower;
			        allies: elves;
			        enemies: goblins;
			        yourself.
		elves at: pos put: unit ].

	goblinStartPositions do: [ :pos | 
		| unit |
		unit := AoCDay15Unit new
			        position: pos;
			        allies: goblins;
			        enemies: elves;
			        yourself.
		goblins at: pos put: unit ]
]

{ #category : #solving }
AoC2018Day15 >> unwindPathFromNode: aNode withParents: parentDict [

	| result cursor |
	result := LinkedList new.
	cursor := aNode.
	[ cursor ] whileNotNil: [ 
		result addFirst: cursor.
		cursor := parentDict at: cursor ifAbsent: nil ].
	^ result
]
