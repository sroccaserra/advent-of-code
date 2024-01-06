sums ← +/¨(≢¨⊆⊢),⎕CSV('src/01.in')⍬4
⎕← ⌈/sums
⎕← {+/3↑⍵[⍒⍵]}sums
