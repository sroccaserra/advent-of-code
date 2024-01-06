"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestAoC,
	#superclass : #PackageManifest,
	#category : #'AoC-Manifest'
}

{ #category : #'code-critics' }
ManifestAoC class >> ruleClassNotReferencedRuleV1FalsePositive [
	^ #(#(#(#RGClassDefinition #(#AoC2018Day16)) #'2023-05-11T22:33:34.326214+02:00') #(#(#RGClassDefinition #(#AoC2018Day15)) #'2023-05-11T22:33:34.327115+02:00') #(#(#RGClassDefinition #(#AoCCellMarker)) #'2023-05-11T22:33:34.326659+02:00') )
]

{ #category : #'code-critics' }
ManifestAoC class >> ruleImplementedNotSentRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#'AoCGraphics class' #nibbleRowsToForm: #true)) #'2023-05-11T22:34:40.486506+02:00') #(#(#RGMethodDefinition #(#'AoCGraphics class' #bitRowsToForm: #true)) #'2023-05-11T22:34:40.486584+02:00') #(#(#RGMethodDefinition #(#'AoCCellMarker class' #atPoint: #true)) #'2023-05-11T22:34:40.486656+02:00') )
]

{ #category : #'code-critics' }
ManifestAoC class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#AoC2018Day15 #unwindPathFromNode:withParents: #false)) #'2023-05-11T22:34:40.491266+02:00') #(#(#RGMethodDefinition #(#AoC2018Day16 #parseFourNumbers: #false)) #'2023-05-11T22:34:40.491286+02:00') #(#(#RGMethodDefinition #(#AoC2018Day16 #parseInstructionLine: #false)) #'2023-05-11T22:34:40.491293+02:00') #(#(#RGMethodDefinition #(#AoCBase #loadLines: #false)) #'2023-05-11T22:34:40.491248+02:00') )
]
