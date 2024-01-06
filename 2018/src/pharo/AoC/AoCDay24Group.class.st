"
no comment
"
Class {
	#name : #AoCDay24Group,
	#superclass : #Object,
	#instVars : [
		'nbUnits',
		'unitHitPoints',
		'attackDamage',
		'attackType',
		'initiative',
		'weaknesses',
		'immunities'
	],
	#category : #'AoC-2018'
}

{ #category : #testing }
AoCDay24Group >> <= other [

	self nbUnits isZero ifTrue: [ ^ false ].
	^ self effectivePower = other effectivePower
		  ifTrue: [ ^ self initiative > other initiative ]
		  ifFalse: [ self effectivePower > other effectivePower ]
]

{ #category : #accessing }
AoCDay24Group >> attack: other [

	| damages |
	damages := self damagesTo: other.
	^ other suffer: damages
]

{ #category : #accessing }
AoCDay24Group >> attackDamage: aNumber [

	attackDamage := aNumber
]

{ #category : #accessing }
AoCDay24Group >> attackType: aString [

	attackType := aString
]

{ #category : #accessing }
AoCDay24Group >> boost: anInteger [

	^ attackDamage := attackDamage + anInteger
]

{ #category : #accessing }
AoCDay24Group >> damagesTo: other [

	(other isImmuneTo: attackType) ifTrue: [ ^ 0 ].
	(other isWeakTo: attackType) ifTrue: [ ^ 2 * self effectivePower ].
	^ self effectivePower
]

{ #category : #accessing }
AoCDay24Group >> effectivePower [

	^ nbUnits * attackDamage
]

{ #category : #accessing }
AoCDay24Group >> immunities: strings [

	immunities := strings
]

{ #category : #accessing }
AoCDay24Group >> initiative [

	^ initiative
]

{ #category : #accessing }
AoCDay24Group >> initiative: aNumber [

	initiative := aNumber
]

{ #category : #testing }
AoCDay24Group >> isDefeated [

	[ nbUnits >= 0 ] assert.
	^ nbUnits = 0
]

{ #category : #testing }
AoCDay24Group >> isImmuneTo: anAttackType [

	^ immunities includes: anAttackType
]

{ #category : #testing }
AoCDay24Group >> isWeakTo: anAttackType [

	^ weaknesses includes: anAttackType
]

{ #category : #accessing }
AoCDay24Group >> nbUnits [

	^ nbUnits
]

{ #category : #accessing }
AoCDay24Group >> nbUnits: anInteger [

	^ nbUnits := anInteger
]

{ #category : #printing }
AoCDay24Group >> printOn: aStream [

	aStream
		nextPutAll: self className;
		nextPutAll: ' nbu: '.
	nbUnits printOn: aStream.
	aStream nextPutAll: ', uhp: '.
	unitHitPoints printOn: aStream.
	aStream nextPutAll: ', ep: '.
	self effectivePower printOn: aStream.
	aStream nextPutAll: ', ad: '.
	attackDamage printOn: aStream.
	aStream nextPutAll: ', at: '.
	attackType printOn: aStream.
	aStream nextPutAll: ', i: '.
	initiative printOn: aStream.
	aStream nextPutAll: ', ws: '.
	weaknesses printOn: aStream.
	aStream nextPutAll: ', is: '.
	immunities printOn: aStream
]

{ #category : #accessing }
AoCDay24Group >> suffer: damages [

	| nbUnitLost |
	nbUnitLost := damages // unitHitPoints.
	nbUnits := 0 max: nbUnits - nbUnitLost.
	^ nbUnitLost
]

{ #category : #accessing }
AoCDay24Group >> unitHitPoints: anInteger [

	^ unitHitPoints := anInteger
]

{ #category : #accessing }
AoCDay24Group >> weaknesses: strings [

	weaknesses := strings
]
