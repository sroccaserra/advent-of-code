"
no comment
"
Class {
	#name : #AoCInstruction,
	#superclass : #Object,
	#instVars : [
		'a',
		'b',
		'c',
		'implementation',
		'mnemonic',
		'numericalOpcode'
	],
	#category : #'AoC-2018'
}

{ #category : #accessing }
AoCInstruction class >> descriptions [

	^ {
		  (#addr
		   ->
		   '(add register) stores into register C the result of adding register A and register B.').
		  (#addi
		   ->
		   '(add immediate) stores into register C the result of adding register A and value B.').
		  (#mulr
		   -> '(multiply register) stores into register C the result of').
		  (#muli
		   ->
		   '(multiply immediate) stores into register C the result of multiplying register A and value B.').
		  (#banr
		   ->
		   '(bitwise AND register) stores into register C the result of the bitwise AND of register A and register B.').
		  (#bani
		   ->
		   '(bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B.').
		  (#borr
		   ->
		   '(bitwise OR register) stores into register C the result of the bitwise OR of register A and register B.').
		  (#bori
		   ->
		   '(bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B.').
		  (#setr
		   ->
		   '(set register) copies the contents of register A into register C. (Input B is ignored.)').
		  (#seti
		   ->
		   '(set immediate) stores value A into register C. (Input B is ignored.)').
		  (#gtir
		   ->
		   '(greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0.').
		  (#gtri
		   ->
		   '(greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0.').
		  (#gtrr
		   ->
		   '(greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0.').
		  (#eqir
		   ->
		   '(equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0.').
		  (#eqri
		   ->
		   '(equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0.').
		  (#eqrr
		   ->
		   '(equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0.') }
		  asDictionary
]

{ #category : #'instance creation' }
AoCInstruction class >> fromFourNumbers: fourNumbers [

	^ self new
		  numericalOpcode: fourNumbers first;
		  a: fourNumbers second;
		  b: fourNumbers third;
		  c: fourNumbers fourth;
		  yourself
]

{ #category : #accessing }
AoCInstruction class >> implementations [

	^ {
		  (#addr -> [ :inst :state |
		   state
			   at: inst c put: (state at: inst a) + (state at: inst b);
			   yourself ]).
		  "(add register) stores into register C the result of adding register A and register B."
		  (#addi -> [ :inst :state |
		   state
			   at: inst c put: (state at: inst a) + inst b;
			   yourself ]).
		  "(add immediate) stores into register C the result of adding register A and value B."
		  (#mulr -> [ :inst :state |
		   state
			   at: inst c put: (state at: inst a) * (state at: inst b);
			   yourself ]).
		  "(multiply register) stores into register C the result of"
		  (#muli -> [ :inst :state |
		   state
			   at: inst c put: (state at: inst a) * inst b;
			   yourself ]).
		  "(multiply immediate) stores into register C the result of multiplying register A and value B."
		  (#banr -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) bitAnd: (state at: inst b));
			   yourself ]).
		  "(bitwise AND register) stores into register C the result of the bitwise AND of register A and register B."
		  (#bani -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) bitAnd: inst b);
			   yourself ]).
		  "(bitwise AND immediate) stores into register C the result of the bitwise AND of register A and value B."
		  (#borr -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) bitOr: (state at: inst b));
			   yourself ]).
		  "(bitwise OR register) stores into register C the result of the bitwise OR of register A and register B."
		  (#bori -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) bitOr: inst b);
			   yourself ]).
		  "(bitwise OR immediate) stores into register C the result of the bitwise OR of register A and value B."
		  (#setr -> [ :inst :state |
		   state
			   at: inst c put: (state at: inst a);
			   yourself ]).
		  "(set register) copies the contents of register A into register C. (Input B is ignored.)"
		  (#seti -> [ :inst :state |
		   state
			   at: inst c put: inst a;
			   yourself ]).
		  "(set immediate) stores value A into register C. (Input B is ignored.)"
		  (#gtir -> [ :inst :state |
		   state
			   at: inst c put: {
					   (inst a bytesCompare: (state at: inst b)).
					   0 } max;
			   yourself ]).
		  "(greater-than immediate/register) sets register C to 1 if value A is greater than register B. Otherwise, register C is set to 0."
		  (#gtri -> [ :inst :state |
		   state
			   at: inst c put: {
					   ((state at: inst a) bytesCompare: inst b).
					   0 } max;
			   yourself ]).
		  "(greater-than register/immediate) sets register C to 1 if register A is greater than value B. Otherwise, register C is set to 0."
		  (#gtrr -> [ :inst :state |
		   state
			   at: inst c put: {
					   ((state at: inst a) bytesCompare: (state at: inst b)).
					   0 } max;
			   yourself ]).
		  "(greater-than register/register) sets register C to 1 if register A is greater than register B. Otherwise, register C is set to 0."
		  (#eqir -> [ :inst :state |
		   state
			   at: inst c put: (inst a = (state at: inst b)
					    ifTrue: [ 1 ]
					    ifFalse: [ 0 ]);
			   yourself ]).
		  "(equal immediate/register) sets register C to 1 if value A is equal to register B. Otherwise, register C is set to 0."
		  (#eqri -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) = inst b
					    ifTrue: [ 1 ]
					    ifFalse: [ 0 ]);
			   yourself ]).
		  "(equal register/immediate) sets register C to 1 if register A is equal to value B. Otherwise, register C is set to 0."
		  (#eqrr -> [ :inst :state |
		   state
			   at: inst c put: ((state at: inst a) = (state at: inst b)
					    ifTrue: [ 1 ]
					    ifFalse: [ 0 ]);
			   yourself ])
		  "(equal register/register) sets register C to 1 if register A is equal to register B. Otherwise, register C is set to 0." }
		  asDictionary
]

{ #category : #accessing }
AoCInstruction class >> named: aString [

	| impl mnemonic |
	mnemonic := aString asSymbol.
	impl := self implementations at: mnemonic.
	^ self new
		  mnemonic: mnemonic;
		  implementation: impl;
		  yourself
]

{ #category : #accessing }
AoCInstruction class >> shortDescs [

	^ {
		  (#addr -> '@a + @b -> @c').
		  (#addi -> '@a + b -> @c').
		  (#mulr -> '@a * @b -> @c').
		  (#muli -> '@a * b -> @c').

		  (#banr -> '@a & @b -> @c').
		  (#bani -> '@a & b -> @c').
		  (#borr -> '@a | @b -> @c').
		  (#bori -> '@a | b -> @c').

		  (#setr -> '@a -> @c').
		  (#seti -> 'a -> @c').

		  (#gtir -> '(a > @b) ? 1 : 0 -> @c').
		  (#gtri -> '(@a > b) ? 1 : 0 -> @c').
		  (#gtrr -> '(@a > @b) ? 1 : 0 -> @c').

		  (#eqir -> '(a == @b) ? 1 : 0 -> @c').
		  (#eqri -> '(@a == b) ? 1 : 0 -> @c').
		  (#eqrr -> '(@a == @b) ? 1 : 0 -> @c') } asDictionary
]

{ #category : #accessing }
AoCInstruction class >> shortDescsFormat [

	^ {
		  (#addr -> '@{1} + @{2} -> @{3}').
		  (#addi -> '@{1} + {2} -> @{3}').
		  (#mulr -> '@{1} * @{2} -> @{3}').
		  (#muli -> '@{1} * {2} -> @{3}').

		  (#banr -> '@{1} & @{2} -> @{3}').
		  (#bani -> '@{1} & {2} -> @{3}').
		  (#borr -> '@{1} | @{2} -> @{3}').
		  (#bori -> '@{1} | {2} -> @{3}').

		  (#setr -> '@{1} -> @{3}').
		  (#seti -> '{1} -> @{3}').

		  (#gtir -> '({1} > @{2}) ? 1 : 0 -> @{3}').
		  (#gtri -> '(@{1} > {2}) ? 1 : 0 -> @{3}').
		  (#gtrr -> '(@{1} > @{2}) ? 1 : 0 -> @{3}').

		  (#eqir -> '({1} == @{2}) ? 1 : 0 -> @{3}').
		  (#eqri -> '(@{1} == {2}) ? 1 : 0 -> @{3}').
		  (#eqrr -> '(@{1} == @{2}) ? 1 : 0 -> @{3}') } asDictionary
]

{ #category : #accessing }
AoCInstruction >> a [

	^ a
]

{ #category : #accessing }
AoCInstruction >> a: aNumber [

	a := aNumber
]

{ #category : #accessing }
AoCInstruction >> b [

	^ b
]

{ #category : #accessing }
AoCInstruction >> b: aNumber [

	b := aNumber
]

{ #category : #accessing }
AoCInstruction >> c [

	^ c
]

{ #category : #accessing }
AoCInstruction >> c: aNumber [

	c := aNumber
]

{ #category : #execution }
AoCInstruction >> executeOn: aState [

	implementation value: self value: aState.
	^ aState
]

{ #category : #accessing }
AoCInstruction >> implementation: aBloc [

	implementation := aBloc
]

{ #category : #accessing }
AoCInstruction >> mnemonic: aSymbol [

	mnemonic := aSymbol
]

{ #category : #accessing }
AoCInstruction >> numericalOpcode [

	^ numericalOpcode
]

{ #category : #accessing }
AoCInstruction >> numericalOpcode: aNumber [

	numericalOpcode := aNumber
]

{ #category : #printing }
AoCInstruction >> printOn: aStream [

	| strings |
	strings := { mnemonic asString } asOrderedCollection.
	strings addAll: ({
			 a.
			 b.
			 c } collect: [ :each | each asString padLeftTo: 3 ]).
	strings add: ' #'.
	strings add: ((self class shortDescsFormat at: mnemonic) format: {
				 a.
				 b.
				 c }).
	(Character space join: strings) printOn: aStream
]
