"
no comment
"
Class {
	#name : #AoCLineMarker,
	#superclass : #AoCMarker,
	#instVars : [
		'from',
		'to'
	],
	#category : #'AoC-Base'
}

{ #category : #'instance creation' }
AoCLineMarker class >> from: fromPoint to: toPoint [

	^ self new
		  from: fromPoint;
		  to: toPoint;
		  yourself
]

{ #category : #drawing }
AoCLineMarker >> drawOn: aCanvas [

	aCanvas
		line: 8 * from - (5 @ 4)
		to: 8 * to - (5 @ 4)
		width: 1
		color: (Color r: 1 g: 1 b: 0 alpha: 0.25)
]

{ #category : #accessing }
AoCLineMarker >> from: aPoint [

	from := aPoint
]

{ #category : #accessing }
AoCLineMarker >> to: aPoint [

	to := aPoint
]
