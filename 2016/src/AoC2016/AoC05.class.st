"
Super super slow, be prepared to wait 10+ minutes.
"
Class {
	#name : #AoC05,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC05 >> run: filename [

	| id |
	id := (self loadLines: filename) first.
	^ {
		  (self solvePartOne: id).
		  (self solvePartTwo: id) }
]

{ #category : #solving }
AoC05 >> solvePartOne: id [

	| chars n m |
	chars := OrderedCollection new.
	n := 0.
	m := MD5 new.
	[ chars  < 8 ] whileTrue: [
		| h |
		h := (m hashMessage: id , n asString) hex.
		"h := ZnDigestAuthenticator md5Hash: id , n asString."
		(h beginsWith: '00000') ifTrue: [ chars add: h sixth ].
		n := n + 1 ].
	^ '' join: chars
]

{ #category : #solving }
AoC05 >> solvePartTwo: id [

	| chars n m nbFound |
	chars := #( -1 -1 -1 -1 -1 -1 -1 -1 ) asOrderedCollection.
	n := 0.
	nbFound := 0.
	m := MD5 new.
	[ nbFound < 8 ] whileTrue: [
		| h |
		h := (m hashMessage: id , n asString) hex.
		((h beginsWith: '00000') and: [
			 h sixth charCode between: $0 charCode and: $7 charCode ]) ifTrue: [
			| pos |
			pos := h sixth charCode - $0 charCode + 1.
			(chars at: pos) = -1 ifTrue: [
				chars at: pos put: h seventh.
				nbFound := nbFound + 1 ] ].
		n := n + 1 ].
	^ '' join: chars
]
