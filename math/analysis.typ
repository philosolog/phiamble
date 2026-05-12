// Analysis operators.
#import "symbols.typ": op, limop, dist

// --- Analysis ---

/// Limit with explicit lower/upper attachments: `inlim($n -> oo$)`.
#let inlim(under, over: none) = math.attach(
	math.limits(math.op("lim")),
	b: under,
	t: over,
)
/// Argument maximum operator with limits.
#let argmax = limop("arg max")
/// Argument minimum operator with limits.
#let argmin = limop("arg min")
/// Supremum operator with limits.
#let sup = limop("sup")
/// Infimum operator with limits.
#let inf = limop("inf")
/// Limit superior operator with limits.
#let limsup = limop("lim sup")
/// Limit inferior operator with limits.
#let liminf = limop("lim inf")
/// Trace operator.
#let tr = op("tr")
/// Support operator.
#let supp = op("supp")
#let sgn = op("sgn")
#let Res = op("Res")
#let Re = op("Re")
#let Im = op("Im")
#let osc = op("osc")
#let diam = op("diam")
#let Lip = op("Lip")
#let BV = op("BV")

// --- Analysis Prefixes ---
#let dom = op("dom")
#let cod = op("cod")
#let ker = op("ker")
#let rng = op("range")
#let cl = op("cl")
#let interior = op("int")
#let bd = op("bd")
#let ext = op("ext")
#let conv = op("conv")
#let aff = op("aff")
#let epi = op("epi")
#let hyp = op("hyp")
#let conv_hull = op("conv hull")

// --- Common Set Operations ---
/// Closure with overline: `clos($A$)`.
#let clos(body) = $overline(#body)$
/// Interior with operator notation: `intr($A$)`.
#let intr(body) = $#interior lr((#body))$
/// Boundary notation: `bdy($A$)`.
#let bdy(body) = $partial #body$
/// Open ball notation: `ball($x$, $r$)`.
#let ball(center, radius) = $B_(#radius) lr((#center))$
