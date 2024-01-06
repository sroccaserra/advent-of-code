Exprs ← {"^zero""^one""^two""^three""^four""^five""^six""^seven""^eight""^nine"}
Parts ← ♭⊠(□↘)⊙¤⇡⧻.
LiterateDigits ← /+×⇡10⊞(⧻regex∩°□)Exprs Parts
Digits ← ×<10.-@0
FilterAndSum ← +×10⊃⊢(⊢⇌)▽>0.

SolveOne ← /+≡(FilterAndSum Digits °□)
SolveTwo ← /+≡(FilterAndSum +⊃Digits LiterateDigits °□)

⊃SolveTwo SolveOne ⊜□≠@\n. &fras"01"

---
Digits "ab1c3de2"
⍤⊙≍,[0 0 1 0 3 0 0 2]

Parts "abcd"
⍤⊙≍,{"abcd" "bcd" "cd" "d"}

# "oneightwobob"
# [108000200000]
LiterateDigits "oneightwobob"
⍤⊙≍,[1 0 8 0 0 0 2 0 0 0 0 0]

SolveOne {"1abc2"
          "pqr3stu8vwx"
          "a1b2c3d4e5f"
          "treb7uchet"}
⍤⊙=,142

SolveTwo {"two1nine"
          "eightwothree"
          "abcone2threexyz"
          "xtwone3four"
          "4nineeightseven2"
          "zoneight234"
          "7pqrstsixteen"}
⍤⊙=,281

# ⬚@.\(⊂:)⇌"abcd"
---
