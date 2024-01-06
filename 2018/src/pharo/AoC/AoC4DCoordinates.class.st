"
no comment
"
Class {
	#name : #AoC4DCoordinates,
	#superclass : #GCoordinates,
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoC4DCoordinates class >> numberOfDimensions [
	^ 4
]

{ #category : #accessing }
AoC4DCoordinates class >> x: aNumber y: anotherNumber z: thirdNumber t: fourthNumber [

	^ self new
		  x: aNumber;
		  y: anotherNumber;
		  z: thirdNumber;
		  t: fourthNumber;
		  yourself
]

{ #category : #accessing }
AoC4DCoordinates >> manhattan: a4DCoordinates [

	| vec |
	vec := a4DCoordinates - self.
	^ vec x abs + vec y abs + vec z abs + vec t abs
]

{ #category : #accessing }
AoC4DCoordinates >> t [

	^ coordinates at: 4
]

{ #category : #accessing }
AoC4DCoordinates >> t: aNumber [

	coordinates at: 4 put: aNumber
]

{ #category : #accessing }
AoC4DCoordinates >> z [

	^ coordinates at: 3
]

{ #category : #accessing }
AoC4DCoordinates >> z: aNumber [

	coordinates at: 3 put: aNumber
]
