// Measure theory helpers.
#import "symbols.typ": op, limop

// --- Notation & Constants ---

/// Default measure symbol.
#let mu = $mu$
/// Secondary measure symbol.
#let nu = $nu$
/// Lambda/Lebesgue-style measure symbol.
#let lam = $lambda$

/// Default sigma-algebra (cal(F)).
#let sigalg = $cal(F)$
/// Borel sigma-algebra (cal(B)).
#let borel = $cal(B)$
/// Lebesgue sigma-algebra (cal(L)).
#let lebesgue = $cal(L)$

// --- Operators ---

/// Measurable-space/operator text.
#let Meas = op("Meas")
/// Essential supremum operator with limits.
#let esssup = limop("ess sup")
/// Essential infimum operator with limits.
#let essinf = limop("ess inf")
/// Measurable operator text.
#let measurable = op("measurable")

// --- Abbreviations ---

/// Almost everywhere marker.
#let ae = $"a.e."$
/// Almost surely marker.
#let almost-surely = $"a.s."$

// --- Measures & Integration ---

/// Upright differential "d".
#let dd = math.upright("d")

/// Standard integral with differential: `mint(f, measure: mu)` -> \int f d\mu.
/// Supports `over` for domain: `mint(f, measure: mu, over: Omega)`.
#let mint(body, measure: none, over: none) = {
	let i = if over == none { $integral$ } else { $integral_(#over)$ }
	if measure == none {
		$#i #body$
	} else {
		$#i #body \, dd #measure$
	}
}

/// Radon-Nikodym derivative: `rn(nu, mu)` -> dnu / dmu.
#let rn(nu, mu) = $frac(dd #nu, dd #mu)$

/// Pushforward measure: `push(mu, f)` -> f_* mu.
#let push(measure, mapping) = $#mapping _* #measure$

/// Restriction: `restr(mu, A)` -> mu|_A.
#let restr(measure, body) = $#measure |_#body$

// --- Relations ---

/// Absolute continuity (nu << mu).
#let abscont = $<<$
/// Singularity (nu perp mu).
#let perp = math.perp
/// Equivalence of measures (nu approx mu).
#let equivmeas = $approx$

// --- Function Spaces ---

/// L^p space notation: `Lp(2)`, `Lp(inf)`, or `Lp(2, over: Omega)`.
/// Use `prime: true` for the conjugate exponent p'.
#let Lp(p, over: none, measure: none, prime: false) = {
	let exp = if prime { $#p'$ } else { $#p$ }
	let base = $L^#exp$
	if over == none { base }
	else if measure == none { $#base (#over)$ }
	else { $#base (#over, #measure)$ }
}

/// L^p norm: `normp(f, 2)`.
#let normp(body, p: 2) = $lr(||#body||)_#p$

// --- Convergence ---

/// Convergence in measure marker.
#let to_m = $arrow.r^(m)$
/// Convergence almost everywhere marker.
#let to_ae = $arrow.r^("a.e.")$

// --- Space Definitions ---

/// Measurable space triple: `meas-space(Omega)` -> (Omega, F, mu).
#let meas-space(space, sigma: sigalg, measure: mu) = $(#space, #sigma, #measure)$
