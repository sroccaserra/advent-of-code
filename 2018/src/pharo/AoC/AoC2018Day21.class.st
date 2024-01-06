"
no comment
"
Class {
	#name : #AoC2018Day21,
	#superclass : #AoC2018DayWithVM,
	#category : #'AoC-2018'
}

{ #category : #running }
AoC2018Day21 >> run: filename [

	| result |
	self initializeFromInput: filename.
	result := {
		          self solvePartOne.
		          self solvePartTwo }.
	Clipboard clipboardText: result asString.
	^ result
]

{ #category : #running }
AoC2018Day21 >> solvePartOne [

	state := AoCState fromNumbers: #( 7967233 0 0 0 0 0 ).
	[ instructionCount < 100000 and: [ self isHalted not ] ] whileTrue: [
		self step ].
	"self debug"
	^ 7967233

	"
	7967233: value of register 3 when line 28 is reached. Observable by adding the following condition:
	`and: [ (self pc) ~= 28 ]`
"

	"
0   # 123 -> @3                 ~
1   # @3 & 456 -> @3            ~
2   # (@3 == 72) ? 1 : 0 -> @3  ~ if @3 == 72:
3   # @3 + @2 -> @2             ~   goto START
4   # 0 -> @2                   ~ else: goto 1

                                START:
5   # 0 -> @3                   # @3 = 0

                                A:
6   # @3 | 65536 -> @1          . @1 = @3 | 65536
7   # 10373714 -> @3            # @3 = 10373714

                                B:
8   # @1 & 255 -> @5            . @5 = @1 & 255 (@1 mod 2^8)
9   # @3 + @5 -> @3             # @3 += @5
10  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)
11  # @3 * 65899 -> @3          # @3 *= 65899
12  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)
13  # (256 > @1) ? 1 : 0 -> @5  # if @1 < 256:
14  # @5 + @2 -> @2             #   goto 16 (=> goto D)
15  # @2 + 1 -> @2              # else: goto 17 (continue)
16  # 27 -> @2                  # goto D
17  # 0 -> @5                   # @5 = 0

                                C:
18  # @5 + 1 -> @4              . @4 = @5 + 1
19  # @4 * 256 -> @4            # @4 *= 256
20  # (@4 > @1) ? 1 : 0 -> @4   # if @4 > @1:
21  # @4 + @2 -> @2             #   goto 23 => goto 26: set @1 to @5 and goto B
22  # @2 + 1 -> @2              # else: goto 24 => increment @5 and goto C
23  # 25 -> @2                  . goto 26
24  # @5 + 1 -> @5              . @5 += 1
25  # 17 -> @2                  # goto C:
26  # @5 -> @1                  . @1 = @5
27  # 7 -> @2                   # goto B

                                D:
28  # (@3 == @0) ? 1 : 0 -> @5  . if @3 == @0:
29  # @5 + @2 -> @2             #   HALT
30  # 5 -> @2                   # else: goto A
"
]

{ #category : #running }
AoC2018Day21 >> solvePartTwo [

	| values previous |
	state := AoCState fromNumbers: #( 0 0 0 0 0 0 ).
	instructionCount := 0.
	values := Set new.
	previous := 0.
	[ instructionCount < 2500000000 ] whileTrue: [
		self step.
		"instructionCount % 1000000 = 0 ifTrue: [
			ZnClient new
				url: 'http://localhost:8080/' , instructionCount asString;
				get ]."
		"(#( 6 8 13 18 20 28 ) includes: self pc) ifTrue: [ self halt ]."
		self pc = 28 ifTrue: [
			| n |
			n := state at: 3.
			(values includes: n) ifTrue: [ ^ previous ].
			values add: n.
			previous := n ] ].
	^ {
		  'Not found.'.
		  instructionCount.
		  values size }
]

{ #category : #running }
AoC2018Day21 >> values [

	| result reg_0 reg_1 reg_3 reg_5 max reg_4 |
	result := OrderedCollection new.
	max := 2 ** 24 - 1.
	reg_0 := 0.

	"START"
	reg_3 := 0.

	"A"
	reg_1 := reg_3 | 65536.
	reg_3 := 10373714.

	"B"
	reg_5 := reg_1 % 256.
	reg_3 := reg_3 + reg_5.
	reg_3 := reg_3 % (2 ** 24).
	reg_3 := reg_3 * 65899.
	reg_3 := reg_3 % (2 ** 24).
	reg_1 < 256 ifTrue: [
		reg_3 = reg_0
			ifTrue: [ ^ reg_3 ]
			ifFalse: [ "goto A" ] ].
	reg_5 := 0.

	"C"
	reg_4 := reg_5 + 1.
	reg_4 := reg_4 * 256.
	"if reg_4 > reg_1:"
	"	reg_1 := reg_5"
	"	goto B"
	"else:"
	"	reg_5 := reg_5 + 1"
	"	goto C"

	result addAll: {
			(#_1 -> reg_1).
			reg_3.
			reg_4.
			reg_5 }.
	^ result

	"
                                START:
5   # 0 -> @3                   # @3 = 0

                                A:
6   # @3 | 65536 -> @1          . @1 = @3 | 65536
7   # 10373714 -> @3            # @3 = 10373714

                                B:
8   # @1 & 255 -> @5            . @5 = @1 & 255 (@1 mod 2^8)
9   # @3 + @5 -> @3             # @3 += @5
10  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)
11  # @3 * 65899 -> @3          # @3 *= 65899
12  # @3 & 16777215 -> @3       # @3 &= 2^24-1 (mod 2^24)
13  # (256 > @1) ? 1 : 0 -> @5  # if @1 < 256:
14  # @5 + @2 -> @2             #   (goto 16) => goto D
15  # @2 + 1 -> @2              # else: (goto 17) => continue
16  # 27 -> @2                  # (goto D)
17  # 0 -> @5                   # @5 = 0

                                C:
18  # @5 + 1 -> @4              . @4 = @5 + 1
19  # @4 * 256 -> @4            # @4 *= 256
20  # (@4 > @1) ? 1 : 0 -> @4   # if @4 > @1:
21  # @4 + @2 -> @2             #   goto 23 => goto 26: set @1 to @5 and goto B
22  # @2 + 1 -> @2              # else: goto 24 => increment @5 and goto C
23  # 25 -> @2                  . goto 26
24  # @5 + 1 -> @5              . @5 += 1
25  # 17 -> @2                  # goto C:
26  # @5 -> @1                  . @1 = @5
27  # 7 -> @2                   # goto B

                                D:
28  # (@3 == @0) ? 1 : 0 -> @5  . if @3 == @0:
29  # @5 + @2 -> @2             #   HALT
30  # 5 -> @2                   # else: goto A
"
]
