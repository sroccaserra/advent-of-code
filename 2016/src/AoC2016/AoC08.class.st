"
nc
"
Class {
	#name : #AoC08,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC08 >> column: args on: screen [

	| x amount points vals shifted |
	x := args key.
	amount := args value % self h.
	points := (0 to: self h - 1) collect: [ :y | x @ y ].
	vals := points collect: [ :p | screen at: p ].
	shifted := (vals last: amount) , (vals first: self h - amount).
	points with: shifted do: [ :p :v | screen at: p put: v ]
]

{ #category : #running }
AoC08 >> h [

	^ 6
]

{ #category : #running }
AoC08 >> parseLine: line [

	| words |
	words := line substrings.
	words first = 'rect' ifTrue: [ ^ self parseRect: words ].
	^ self parseRotation: words
]

{ #category : #running }
AoC08 >> parseRect: words [

	| parts |
	parts := words second substrings: 'x'.
	^ {
		  #rect:on:.
		  (parts first asInteger @ parts second asInteger) }
]

{ #category : #running }
AoC08 >> parseRotation: words [

	| pos value |
	pos := (words third substrings: '=') second asInteger.
	value := words last asInteger.
	^ {
		  (words second , ':on:') asSymbol.
		  (pos -> value) }
]

{ #category : #running }
AoC08 >> printScreen: screen [

	| chars |
	chars := {
		         (0 -> $.).
		         (1 -> $#) } asDictionary.
	Transcript cr.
	0 to: 5 do: [ :y |
		0 to: 49 do: [ :x | Transcript show: (chars at: (screen at: x @ y)) ].
		Transcript cr ]
]

{ #category : #running }
AoC08 >> rect: aPoint on: screen [

	0 to: aPoint y - 1 do: [ :y |
	0 to: aPoint x - 1 do: [ :x | screen at: x @ y put: 1 ] ]
]

{ #category : #running }
AoC08 >> row: args on: screen [

	| y amount points vals shifted |
	y := args key.
	amount := args value % self w.
	points := (0 to: self w - 1) collect: [ :x | x @ y ].
	vals := points collect: [ :p | screen at: p ].
	shifted := (vals last: amount) , (vals first: self w - amount).
	points with: shifted do: [ :p :v | screen at: p put: v ]
]

{ #category : #running }
AoC08 >> run: filename [

	| lines commands |
	lines := self loadLines: filename.
	commands := lines collect: [ :line | self parseLine: line ].

	^ self solve: commands
]

{ #category : #running }
AoC08 >> solve: commands [

	| screen |
	screen := Dictionary new.
	0 to: self h - 1 do: [ :y |
	0 to: self w - 1 do: [ :x | screen at: x @ y put: 0 ] ].
	commands do: [ :c |
		self perform: (c at: 1) with: (c at: 2) with: screen ].
	self printScreen: screen.
	^ screen sum
]

{ #category : #running }
AoC08 >> w [

	^ 50
]
