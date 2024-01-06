"
I am the base class for daily problems.

Run my instances with:

`AoC01 new run: 'Developer/github/aoc2016/input/01'`
"
Class {
	#name : #AoCBase,
	#superclass : #Object,
	#category : #AoC2016
}

{ #category : #running }
AoCBase >> loadLines: filename [

	| file |
	file := FileSystem disk workingDirectory / filename.
	^ file contents lines
]

{ #category : #running }
AoCBase >> run: filename [

	self subclassResponsibility
]
