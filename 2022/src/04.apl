m ← ↑{2⊃'-,'⎕VFI⍵}¨⊃⎕NGET'src/04.in'1
a1 a2 b1 b2 ← ↓⍉m
⎕← +/0≥(a1-b1)×a2-b2
⎕← +/0≥(a1-b2)×a2-b1
