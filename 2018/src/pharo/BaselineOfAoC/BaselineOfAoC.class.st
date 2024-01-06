"
No comment.
"
Class {
	#name : #BaselineOfAoC,
	#superclass : #BaselineOf,
	#category : #BaselineOfAoC
}

{ #category : #baselines }
BaselineOfAoC >> baseline: spec [

	<baseline>
	spec for: #common do: [ "Packages"
		spec
			package: 'AoC' with: [ spec requires: #( 'Geometry' ) ];
			package: 'AoC-Base' with: [ spec requires: #( 'AoC' ) ];
			package: 'AoC-2018' with: [ spec requires: #( 'AoC' 'AoC-Base' ) ] ]
]
