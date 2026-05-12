// Probability helpers.
#import "symbols.typ": op, ub, dist

// --- Probability ---
/// Probability with optional conditioning.
/// Multiple positional events are rendered as intersections:
/// `Pr(A, B; given: C)` renders `P(A inter B | C)`.
#let Pr(..events, given: none) = {
	let raw = events.pos()
	let events = if raw.len() == 1 and type(raw.at(0)) == array {
		raw.at(0)
	} else { raw }
	let event = none
	for item in events {
		event = if event == none { item } else { $#event, space #item$ }
	}
	if given == none {
		$PP lr((#event))$
	} else {
		$PP lr((#event mid(|) #given))$
	}
}
/// Expectation with optional conditioning: `E($X$)` or `E($X$, given: $cal(F)$)`.
#let E(random-var, given: none) = if given == none {
	$EE lr([#random-var])$
} else {
	$EE lr([#random-var mid(|) #given])$
}
/// Indicator of an event/set: `ind($A$)`.
#let ind(event) = $upright(bold(1))_(#event)$
/// Variance operator.
#let Var = op("Var")
/// Covariance operator.
#let Cov = op("Cov")
/// Correlation operator.
#let Corr = op("Corr")
/// Law/distribution operator.
#let law = op("Law")
/// Independence and identical-distribution marker for math mode.
#let iid = $attach(tilde, t: "iid")$
/// Convergence in probability arrow.
#let to_p = $arrow.r^(P)$
/// Convergence in distribution arrow.
#let to_d = $arrow.r^(d)$
/// Almost-sure convergence arrow.
#let to_as = $arrow.r^("a.s.")$
/// L^p convergence arrow: `to_lp(2)`.
#let to_lp(p) = $arrow.r^(L^#p)$
