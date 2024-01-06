asciiToPriority ← 58∘|20∘+
splitInTwo ← ↓{2(2÷⍨≢⍵)⍴⍵}
chunkByThree ← {(3÷⍨≢⍵)3⍴⍵}

priorities ← asciiToPriority∘⎕UCS¨ ⊃⎕NGET'src/03.in'1
⎕← +/⊃¨∩/ ↑splitInTwo¨ priorities
⎕← +/⊃¨∩/ chunkByThree priorities
