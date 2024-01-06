"
no comment
"
Class {
	#name : #AoC2018Day24,
	#superclass : #AoCBase,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day24 >> parseArmyConfigurations: twoCollectionsOfSpecLines [

	^ twoCollectionsOfSpecLines collect: [ :spec |
		  spec collect: [ :line | self parseLine: line ] ]
]

{ #category : #running }
AoC2018Day24 >> parseAttackOn: aLine [

	| matcher |
	matcher := '([\d]+) ([\w]+) damage' asRegex.
	matcher search: aLine.
	^ {
		  (matcher subexpression: 2) asNumber.
		  (matcher subexpression: 3) }
]

{ #category : #running }
AoC2018Day24 >> parseHitPointsOn: aLine [

	| matcher |
	matcher := '([\d]+) hit points' asRegex.
	matcher search: aLine.
	^ (matcher subexpression: 2) asNumber
]

{ #category : #running }
AoC2018Day24 >> parseInitiativeOn: aLine [

	| matcher |
	matcher := 'initiative ([\d]+)' asRegex.
	matcher search: aLine.
	^ (matcher subexpression: 2) asNumber
]

{ #category : #running }
AoC2018Day24 >> parseLine: aLine [

	| weaknesses immunities attack hitPoints initiative nbUnits |
	nbUnits := aLine asNumber.
	hitPoints := self parseHitPointsOn: aLine.
	attack := self parseAttackOn: aLine.
	initiative := self parseInitiativeOn: aLine.
	weaknesses := self parseXTo: 'weak' on: aLine.
	immunities := self parseXTo: 'immune' on: aLine.

	^ AoCDay24Group new
		  nbUnits: nbUnits;
		  unitHitPoints: hitPoints;
		  attackDamage: attack first;
		  attackType: attack second;
		  initiative: initiative;
		  weaknesses: weaknesses;
		  immunities: immunities;
		  yourself
]

{ #category : #running }
AoC2018Day24 >> parseXTo: prefix on: aLine [

	| matcher match |
	matcher := (prefix , ' to ([^;)]+)') asRegex.
	matcher search: aLine.
	match := matcher subexpression: 2.
	match ifNotNil: [ ^ match substrings: ', ' ] ifNil: [ ^ #(  ) ]
]

{ #category : #running }
AoC2018Day24 >> run: filename [

	| lines parts armyConfigurations |
	lines := self loadLines: filename.
	parts := lines splitOn: #( '' ).
	armyConfigurations := parts collect: [ :each |
		         each allButFirst asOrderedCollection ].
	^ {
		  (self solvePartOne: (self parseArmyConfigurations: armyConfigurations)).
		  (self solvePartTwo: armyConfigurations) }
]

{ #category : #running }
AoC2018Day24 >> selectAllTargetsFor: immuneSystemArmy opposing: infectionArmy [

	| infectionTargets result allGroupsSorted immuneSystemTargets |
	allGroupsSorted := OrderedCollection new
		                   addAll: immuneSystemArmy;
		                   addAll: infectionArmy;
		                   sort;
		                   yourself.

	immuneSystemTargets := immuneSystemArmy asSet.
	infectionTargets := infectionArmy asSet.
	result := OrderedCollection new.

	allGroupsSorted sorted do: [ :attacker |
		| targets |
		targets := (immuneSystemArmy includes: attacker)
			           ifTrue: [ infectionTargets ]
			           ifFalse: [ immuneSystemTargets ].
		targets ifNotEmpty: [
			| association target |
			target := (self sortedTargets: targets for: attacker) first.
			(attacker damagesTo: target) > 0 ifTrue: [
				association := attacker -> target.
				targets remove: association value.
				result add: association ] ] ].

	^ result sorted: [ :a :b | a key initiative > b key initiative ]
]

{ #category : #running }
AoC2018Day24 >> solvePartOne: armies [

	| targetSelection immuneSystemArmy infectionArmy isDraw stillStanding |
	immuneSystemArmy := armies first.
	infectionArmy := armies second.
	isDraw := false.

	[ isDraw not and: [ armies allSatisfy: #notEmpty ] ] whileTrue: [
		| nbUnitsLost |
		targetSelection := self
			                   selectAllTargetsFor: immuneSystemArmy
			                   opposing: infectionArmy.
		nbUnitsLost := 0.
		targetSelection do: [ :e1 |
			| attacker defender |
			attacker := e1 key.
			defender := e1 value.
			nbUnitsLost := nbUnitsLost + (attacker attack: defender).

			immuneSystemArmy removeAllSuchThat: #isDefeated.
			infectionArmy removeAllSuchThat: #isDefeated.
			stillStanding := armies select: #notEmpty.
			stillStanding size = 1 ifTrue: [
				^ stillStanding first
					  inject: 0
					  into: [ :acc :each | acc + each nbUnits ] ] ].

		isDraw := nbUnitsLost = 0 ].

	^ -1
]

{ #category : #running }
AoC2018Day24 >> solvePartTwo: specs [

	| isGood result low high |
	low := 0.
	high := 10000.
	result := 0.
	isGood := [ :armies |
	          armies first notEmpty and: [ armies second isEmpty ] ].

	[ high - low > 1 ] whileTrue: [
		| mid armies nbUnitsLeft |
		mid := low + high // 2.
		armies := self parseArmyConfigurations: specs.
		armies first do: [ :each | each boost: mid ].
		nbUnitsLeft := self solvePartOne: armies.
		(isGood value: armies)
			ifTrue: [
				high := mid.
				result := nbUnitsLeft ]
			ifFalse: [ low := mid ] ].
	^ result
]

{ #category : #running }
AoC2018Day24 >> sortedTargets: anArmy for: anAttacker [

	^ anArmy sorted: [ :a :b |
		  | damagesToA damagesToB |
		  damagesToA := anAttacker damagesTo: a.
		  damagesToB := anAttacker damagesTo: b.
		  damagesToA = damagesToB
			  ifTrue: [
				  | effectivePowerA effectivePowerB |
				  effectivePowerA := a effectivePower.
				  effectivePowerB := b effectivePower.
				  effectivePowerA = effectivePowerB
					  ifTrue: [ a initiative > b initiative ]
					  ifFalse: [ effectivePowerA > effectivePowerB ] ]
			  ifFalse: [ damagesToA > damagesToB ] ]
]
