"
AoC2018Day17 * 'Developer/github/aoc2018/ex'

"
Class {
	#name : #AoC2018Day17,
	#superclass : #AoCVisualBase,
	#instVars : [
		'grid',
		'wallPoints',
		'springPos',
		'bottom',
		'debug',
		'known',
		'top'
	],
	#category : #'AoC-2018'
}

{ #category : #'drawing - images' }
AoC2018Day17 class >> groundGraphics [

	^ '[gfx]08081111111111111111111111111111111111111511111111111115111111111111[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> springGraphics [

	^ '[gfx]08081111111111111111111111111166761116566761165567611655676165566676[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> wallGraphics [

	^ '[gfx]0808555555555666666d56ddddd25d22222255555555666d5666ddd256dd22225d22[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> waterGraphics [

	^ '[gfx]0808cccccccccc77cc7cc7cc77cccccccccccccccccccccccccccccccccccccccccc[/gfx]'
]

{ #category : #'drawing - images' }
AoC2018Day17 class >> waterPassedGraphics [

	^ '[gfx]0808115111151111511111c111c5c1151c1111111111151c15111111111c1c11c111[/gfx]'
]

{ #category : #solving }
AoC2018Day17 >> dropWaterFrom: aPoint [

	| waterPos nextDown overflows |
	nextDown := aPoint + (0 @ 1).
	[ self isFreeAt: nextDown ] whileTrue: [
		nextDown y > bottom ifTrue: [ ^ Association key: #oob value: #(  ) ].
		waterPos := nextDown.
		grid at: nextDown putChar: $|.
		nextDown := nextDown + (0 @ 1) ].
	waterPos ifNil: [
		^ Association key: #overflowing value: { (aPoint + (0 @ -1)) } ].
	overflows := self runWaterLineFrom: waterPos.
	overflows ifEmpty: [ ^ Association key: #filling value: #(  ) ].
	^ Association key: #overflowing value: overflows
]

{ #category : #solving }
AoC2018Day17 >> fillWaterFrom: aPoint [

	| dropResult overflows |
	(known includes: aPoint) ifTrue: [ ^ nil ].
	known add: aPoint.
	dropResult := Association key: #filling value: { aPoint }.
	[ dropResult key = #filling ] whileTrue: [
		dropResult := self dropWaterFrom: aPoint ].

	overflows := dropResult value.
	overflows do: [ :each | self fillWaterFrom: each ]
]

{ #category : #solving }
AoC2018Day17 >> flowFrom: aPoint by: aNumber [

	| flow next down status |
	next := aPoint.
	status := #flowing.

	[ status = #flowing ] whileTrue: [
		flow := next.
		grid at: flow putChar: $|.
		next := flow + (aNumber @ 0).
		down := flow + (0 @ 1).
		(self isFreeAt: down)
			ifTrue: [ status := #falling ]
			ifFalse: [ (self isFreeAt: next) ifFalse: [ status := #blocked ] ] ].
	^ Association key: status value: flow
]

{ #category : #running }
AoC2018Day17 >> freeNeighborsDownAt: aPoint [

	| down |
	down := aPoint + (0 @ 1).
	(self isFreeAt: down) ifTrue: [ ^ { down } ].
	^ #(  )
]

{ #category : #running }
AoC2018Day17 >> freeNeighborsSidesAt: aPoint [

	| down right left |
	down := aPoint + (0 @ 1).
	(self isFreeAt: down) ifTrue: [ ^ { down } ].
	right := aPoint + (1 @ 0).
	left := aPoint + (-1 @ 0).
	^ { 
		  right.
		  left } select: [ :each | self isFreeAt: each ]
]

{ #category : #initialization }
AoC2018Day17 >> initialize [

	springPos := 500 @ 0
]

{ #category : #running }
AoC2018Day17 >> isFreeAt: aPoint [

	^ '.|' includes: (grid charAt: aPoint)
]

{ #category : #running }
AoC2018Day17 >> parseWall: aString [

	| parts axis constant range rangeParts |
	parts := aString substrings: ','.
	axis := parts first first.
	constant := (parts first substrings: '=') second asInteger.
	rangeParts := parts second substrings: '=.'.
	range := rangeParts second asInteger @ rangeParts third asInteger.
	^ axis = $x
		  ifTrue: [ constant @ range x corner: constant + 0.5 @ (range y + 0.5) ]
		  ifFalse: [ range x @ constant corner: range y + 0.5 @ (constant + 0.5) ]
]

{ #category : #running }
AoC2018Day17 >> parseWallPoints: aString [

	| parts axis constant range rangeParts |
	parts := aString substrings: ','.
	axis := parts first first.
	constant := (parts first substrings: '=') second asInteger.
	rangeParts := parts second substrings: '=.'.
	range := rangeParts second asInteger @ rangeParts third asInteger.
	^ (range x to: range y) collect: [ :n | 
		  axis = $x
			  ifTrue: [ constant @ n ]
			  ifFalse: [ n @ constant ] ]
]

{ #category : #running }
AoC2018Day17 >> run: filename [

	| lines |
	lines := self loadLines: filename.
	wallPoints := lines flatCollect: [ :each |
		              self parseWallPoints: each ].
	wallPoints := OrderedCollection newFrom: wallPoints.

	"Set top and bottom values"
	top := 9999.
	bottom := 0.
	wallPoints do: [ :each |
		top := top min: each y.
		bottom := bottom max: each y ].

	"Add spring for image"
	wallPoints addLast: 500 @ 0.

	"Generate grid"
	grid := AoCTextGrid fromPoints: wallPoints.
	grid at: springPos putChar: $+.

	^ {
		  self solvePartOne.
		  self solvePartTwo }
]

{ #category : #solving }
AoC2018Day17 >> runWaterLineFrom: aPoint [
	"I return a collection of overflows that might be empty."

	| leftFlow rightFlow overflows leftX rightX y |
	leftFlow := self flowFrom: aPoint by: -1.
	rightFlow := self flowFrom: aPoint by: 1.

	overflows := OrderedCollection new.
	leftFlow key = #falling ifTrue: [ overflows addLast: leftFlow value ].
	rightFlow key = #falling ifTrue: [
		overflows addLast: rightFlow value ].
	overflows isEmpty ifFalse: [ ^ overflows ].

	leftX := leftFlow value x.
	rightX := rightFlow value x.
	y := aPoint y.
	leftX to: rightX do: [ :x | grid at: x @ y putChar: $~ ].
	^ #(  )
]

{ #category : #showing }
AoC2018Day17 >> show [

	| forms frame canvas translation pane |
	forms := {
		         ($. -> self class groundGraphics).
		         ($# -> self class wallGraphics).
		         ($+ -> self class springGraphics).
		         ($~ -> self class waterGraphics).
		         ($| -> self class waterPassedGraphics) } asDictionary
		         collect: [ :str | AoCGraphics pico8StringToForm: str ].

	frame := Form extent: 8 * (grid w @ grid h) depth: 32.
	canvas := frame getCanvas.
	translation := grid translation.
	grid positionsDo: [ :pos |
		| worldPos canvasPos tile |
		worldPos := pos + translation.
		canvasPos := 8 * (pos - (1 @ 1)).
		tile := forms at: (grid charAt: worldPos).
		canvas drawImage: tile at: canvasPos ].

	debug ifNotNil: [
		(AoCCellMarker atPoint: debug - translation) drawOn: canvas ].

	pane := ScrollPane new.
	pane extent: 1024 @ 800.
	pane scroller addMorph: (frame magnifyBy: 2) asMorph.
	pane openInWindowLabeled: 'AoC 2018 Day 17'
]

{ #category : #solving }
AoC2018Day17 >> solvePartOne [

	| dropResult result |
	known := Set new.
	dropResult := self fillWaterFrom: springPos.
	result := 0.
	grid worldPositionsDo: [ :each |
		(('~|' includes: (grid charAt: each)) and: [ each y >= top ])
			ifTrue: [ result := result + 1 ] ].
	^ result
]

{ #category : #solving }
AoC2018Day17 >> solvePartTwo [

	| result |
	result := 0.
	grid charsDo: [ :each |
		('~' includes: each) ifTrue: [ result := result + 1 ] ].
	^ result
]

{ #category : #running }
AoC2018Day17 >> step [

	grid at: 500 @ 1 putChar: $|
]
