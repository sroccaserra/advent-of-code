"
I represent an elf or a goblin unit for the advent of code 2018 day 15 puzzle.
"
Class {
	#name : #AoCDay15Unit,
	#superclass : #Object,
	#instVars : [
		'position',
		'hitPoints',
		'attackPower',
		'allies',
		'enemies'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCDay15Unit >> allies [

	^ allies
]

{ #category : #accessing }
AoCDay15Unit >> allies: anObject [

	allies := anObject
]

{ #category : #action }
AoCDay15Unit >> attack: aUnit [

	aUnit losesHP: attackPower.
]

{ #category : #accessing }
AoCDay15Unit >> attackPower: anInteger [

	attackPower := anInteger
]

{ #category : #updating }
AoCDay15Unit >> die [

	self allies removeKey: position
]

{ #category : #accessing }
AoCDay15Unit >> enemies [

	^ enemies
]

{ #category : #accessing }
AoCDay15Unit >> enemies: aDictionary [

	enemies := aDictionary
]

{ #category : #accessing }
AoCDay15Unit >> hasWon [

	^ enemies isEmpty
]

{ #category : #accessing }
AoCDay15Unit >> hitPoints [

	^ hitPoints
]

{ #category : #initialization }
AoCDay15Unit >> initialize [

	hitPoints := 200.
	attackPower := 3
]

{ #category : #accessing }
AoCDay15Unit >> isAlive [

	^ hitPoints > 0
]

{ #category : #updating }
AoCDay15Unit >> losesHP: anInteger [

	hitPoints := hitPoints - anInteger.
	hitPoints <= 0 ifTrue: [ self die ]
]

{ #category : #updating }
AoCDay15Unit >> moveTo: aPoint [

	allies removeKey: position.
	position := aPoint.
	allies at: position put: self
]

{ #category : #accessing }
AoCDay15Unit >> pointsInRange [

	^ Array
		  with: position + (0 @ -1)
		  with: position + (-1 @ 0)
		  with: position + (1 @ 0)
		  with: position + (0 @ 1)
]

{ #category : #accessing }
AoCDay15Unit >> position [

	^ position
]

{ #category : #accessing }
AoCDay15Unit >> position: aPoint [

	position := aPoint
]

{ #category : #accessing }
AoCDay15Unit >> targetInRange [

	| result minHP weakestTarget |
	minHP := 999999.
	weakestTarget := nil.
	result := OrderedCollection new.
	self pointsInRange do: [ :p | 
		(enemies includesKey: p) ifTrue: [ 
			| enemy |
			enemy := enemies at: p.
			enemy hitPoints < minHP ifTrue: [ 
				minHP := enemy hitPoints.
				weakestTarget := enemy ] ] ].
	^ weakestTarget
]
