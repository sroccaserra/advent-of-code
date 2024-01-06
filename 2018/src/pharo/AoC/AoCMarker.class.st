"
no comment
"
Class {
	#name : #AoCMarker,
	#superclass : #Object,
	#category : #'AoC-Base'
}

{ #category : #testing }
AoCMarker class >> isAbstract [

	^ self == AoCMarker
]

{ #category : #drawing }
AoCMarker >> drawOn: aCanvas [

	self subclassResponsibility
]
