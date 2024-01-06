"
AoCGraphics initialize.
"
Class {
	#name : #AoCGraphics,
	#superclass : #Object,
	#classInstVars : [
		'pico8Palette',
		'c64Palette'
	],
	#category : #'AoC-Base'
}

{ #category : #displaying }
AoCGraphics class >> bitRowsToForm: bitRows [

	| w h form y |
	h := bitRows size.
	w := 8. "hardcoded, meh"
	form := Form extent: w @ h depth: 1.
	bitRows doWithIndex: [ :line :n | 
		y := n - 1.
		0 to: 7 do: [ :x | 
			form pixelValueAt: x @ y put: (line bitAt: 8 - x) ] ].
	^ form
]

{ #category : #'class initialization' }
AoCGraphics class >> initialize [

	c64Palette := {
		              (0 -> '000000').
		              (1 -> 'FFFFFF').
		              (2 -> '880000').
		              (3 -> 'AAFFEE').
		              (4 -> 'CC44CC').
		              (5 -> '00CC55').
		              (6 -> '0000AA').
		              (7 -> 'EEEE77').
		              (8 -> 'DD8855').
		              (9 -> '664400').
		              (10 -> 'FF7777').
		              (11 -> '333333').
		              (12 -> '777777').
		              (13 -> 'AAFF66').
		              (14 -> '0088FF').
		              (15 -> 'BBBBBB') } asDictionary collect: [ :str |
		              Color fromHexString: str ].

	pico8Palette := {
		                (0 -> '000000').
		                (1 -> '1D2B53').
		                (2 -> '7E2553').
		                (3 -> '008751').
		                (4 -> 'AB5236').
		                (5 -> '5F574F').
		                (6 -> 'C2C3C7').
		                (7 -> 'FFF1E8').
		                (8 -> 'FF004D').
		                (9 -> 'FFA300').
		                (10 -> 'FFEC27').
		                (11 -> '00E436').
		                (12 -> '29ADFF').
		                (13 -> '83769C').
		                (14 -> 'FF77A8').
		                (15 -> 'FFCCAA') } asDictionary collect: [ :str |
		                Color fromHexString: str ]
]

{ #category : #displaying }
AoCGraphics class >> markerForm [

	| w h form y bitRows color transparentColor |
	h := 8.
	w := 8.
	color := Color yellow.
	transparentColor := Color
		                    r: 0
		                    g: 0
		                    b: 0
		                    alpha: 0.
	bitRows := #( 2r11100111 2r10000001 2r10000001 2r00000000 2r00000000
	              2r10000001 2r10000001 2r11100111 ).
	form := Form extent: w @ h depth: 32.
	bitRows doWithIndex: [ :line :n | 
		y := n - 1.
		0 to: w - 1 do: [ :x | 
			(line bitAt: w - x) = 1
				ifTrue: [ form colorAt: x @ y put: color ]
				ifFalse: [ form colorAt: x @ y put: transparentColor ] ] ].
	^ form
]

{ #category : #displaying }
AoCGraphics class >> nibbleRowsToForm: nibbleRows [

	| formW formH form y xOffset nibbleSize colorNumber |
	formH := nibbleRows size.
	formW := 8.
	nibbleSize := 4.
	form := Form extent: formW @ formH depth: 32.
	nibbleRows doWithIndex: [ :line :n | 
		y := n - 1.
		0 to: 7 do: [ :x | 
			xOffset := (7 - x) * nibbleSize.
			colorNumber := line >> xOffset & 16rF.
			form colorAt: x @ y put: (c64Palette at: colorNumber) ] ].
	^ form
]

{ #category : #displaying }
AoCGraphics class >> pico8StringToForm: pico8String [

	"example of pico8String:
	'[gfx]0808999999999aaaaaa49a4444429422222299999999aaaa49aa444429a422222942[/gfx]'
	"

	| dimensionData colorData w h form c yOffset colorNumber |

	dimensionData := (pico8String allButFirst: 5) first: 4.
	w := Integer readFrom: (dimensionData first: 2) base: 16.
	h := Integer readFrom: (dimensionData last: 2) base: 16.

	colorData := (pico8String allButFirst: 9) allButLast: 6.
	form := Form extent: w @ h depth: 32.
	0 to: (h - 1) do: [ :y |
		yOffset := y*w .
		0 to: (w -1) do: [ :x |
			c := colorData at: (yOffset + x + 1).
			colorNumber := Integer readFrom: (c asString) base: 16.
			form colorAt: x @ y put: (pico8Palette at: colorNumber) ] ].
	^ form
]
