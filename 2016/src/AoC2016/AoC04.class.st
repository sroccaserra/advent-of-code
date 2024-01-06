"
nc
"
Class {
	#name : #AoC04,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC04 >> run: filename [

	| lines namesAndIdsWithChecksums |
	lines := self loadLines: filename.
	namesAndIdsWithChecksums := lines collect: [ :line |
		                            | parts |
		                            parts := line substrings: '[]'.
		                            {
			                            (parts first allButLast: 4).
			                            (parts first last: 3) asNumber.
			                            parts second } ].
	^ {
		  (self solvePartOne: namesAndIdsWithChecksums).
		  (self solvePartTwo: namesAndIdsWithChecksums) }
]

{ #category : #solving }
AoC04 >> solvePartOne: namesAndIdsWithChecksums [

	^ (self validRooms: namesAndIdsWithChecksums) sum: #second
]

{ #category : #solving }
AoC04 >> solvePartTwo: namesAndIdsWithChecksums [

	| rotateFn |
	rotateFn := [ :c :n |
	            | i |
	            i := c charCode - $a charCode.
	            i := i + n % 26.
	            (i + $a charCode) asCharacter ].
	^ ((namesAndIdsWithChecksums collect: [ :e |
		    | decrypted |
		    decrypted := '' join: (e first collect: [ :c |
				                  c = $-
					                  ifTrue: [ c ]
					                  ifFalse: [ rotateFn value: c value: e second ] ]).
		    {
			    decrypted.
			    e second } ]) select: [ :e |
		   e first includesSubstring: 'north' ]) first second
]

{ #category : #solving }
AoC04 >> validRooms: namesAndIdsWithChecksums [

	| checksumFn |
	checksumFn := [ :aString |
	              '' join:
		              ((((((aString reject: [ :c | c = $- ]) groupedBy:
			                   #yourself) collect: #size) associations sort: [
			                 :a
			                 :b |
			                 a value = b value
				                 ifTrue: [ a key <= b key ]
				                 ifFalse: [ a value > b value ] ]) collect: #key)
			               first: 5) ].
	^ namesAndIdsWithChecksums select: [ :e |
		  | name checksum |
		  name := e first.
		  checksum := e third.
		  (checksumFn value: name) = checksum ]
]
