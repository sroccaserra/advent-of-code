"
no comment
"
Class {
	#name : #AoCCellMarker,
	#superclass : #AoCMarker,
	#instVars : [
		'point'
	],
	#category : #'AoC-Base'
}

{ #category : #accessing }
AoCCellMarker class >> atPoint: aPoint [

	^ self new
		  point: aPoint;
		  yourself
]

{ #category : #drawing }
AoCCellMarker >> drawOn: aCanvas [

	| markerForm |
	markerForm := AoCGraphics markerForm.
	aCanvas
		image: markerForm
		at: 8 * (point - (1 @ 1))
		sourceRect: markerForm boundingBox
		rule: Form blend
]

{ #category : #accessing }
AoCCellMarker >> point: aPoint [

	point := aPoint
]
