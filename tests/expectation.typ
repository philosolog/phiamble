// Run from the package root: typst compile --root . tests/expectation.typ
#let native-exponential = $exp(x)$
#import "../lib.typ": *

#assert.eq(Exp, E)
#let x = $X$
#let y = $Y$
#assert.eq(Exp(x), $EE lr([#x])$)
#assert.eq(Exp(x, given: y), $EE lr([#x mid(|) #y])$)
#assert.eq($exp(x)$, native-exponential)

$Exp(X)$
$Exp(X, given: Y)$
$exp(x)$
