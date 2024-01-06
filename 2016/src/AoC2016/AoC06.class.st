"
nc
"
Class {
	#name : #AoC06,
	#superclass : #AoCBase,
	#category : #AoC2016
}

{ #category : #running }
AoC06 >> run: filename [

	| lines w stats |
	lines := self loadLines: filename.
	w := lines first size.
	stats := OrderedCollection new.
	w timesRepeat: [ stats add: Dictionary new ].
	lines do: [ :line |
		line withIndexDo: [ :c :i |
			| d n |
			d := stats at: i.
			n := d at: c ifAbsent: 0.
			d at: c put: n + 1 ] ].
	^ {
		  (self solvePartOne: stats).
		  (self solvePartTwo: stats) }
]

{ #category : #running }
AoC06 >> solvePartOne: stats [

	^ '' join: (stats collect: [ :d |
			   ((d associations asSortedCollection: [ :a :b |
				     a value > b value ]) collect: #key) first ])
]

{ #category : #running }
AoC06 >> solvePartTwo: stats [

	^ '' join: (stats collect: [ :d |
			   ((d associations asSortedCollection: [ :a :b |
				     a value < b value ]) collect: #key) first ])
]
