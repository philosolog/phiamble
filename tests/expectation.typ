// Run from the package root: typst compile --root . tests/expectation.typ
#let native-exponential = $exp(x)$
#import "../lib.typ": *

#assert.eq(Exp, E)
#let x = $X$
#let y = $Y$
#assert.eq(Exp(x), $EE #x$)
#let grouped = $(X + Y)$
#assert.eq(Exp(grouped), $EE #grouped$)
#assert.eq(Exp(x, given: y), $EE lr([#x mid(|) #y])$)
#assert.eq($exp(x)$, native-exponential)
#let rate = $lambda$
#assert.eq(Exponential(rate), $op("Exp") lr((#rate))$)

$Exp(X)$
$Exp((X + Y))$
$Exp(X, given: Y)$
$exp(x)$
$X tilde Exponential(lambda)$
