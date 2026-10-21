// Common mathematical symbols, logic operators, and delimiters.

// --- Common Symbols ---
#import "@preview/metalogo:1.2.0": LaTeX as LaTeX_Logo

#show math.op.where(text: "lim"): it => math.limits(it)
#let op(name, limits: false) = math.op(name, limits: limits)
#let limop(name) = op(name, limits: true)
#let eqn = math.equation


/// Short epsilon alias.
#let eps = sym.epsilon
/// Alternate phi glyph.
#let vphi = sym.phi.alt
/// Alternate epsilon glyph.
#let veps = sym.epsilon.alt
/// Upright bold letter for matrices/vectors, e.g. `ub(P)`.
#let ub(letter) = math.upright(math.bold(letter))
/// Distance operator.
#let dist = op("dist")

/// LaTeX logo helper.
#let LaTeX = text(size: 1.18em, LaTeX_Logo)
/// Typst logo helper.
#let typst = {
	set text(
		size: 1.08em,
		weight: "bold",
		fill: rgb("#239dad"),
	)
	{
		text("t")
		text("y")
		h(0.035em)
		text("p")
		h(-0.025em)
		text("s")
		h(-0.015em)
		text("t")
	}
}

// --- Relation Annotations ---

/// Renders a compact annotation above a mathematical relation or arrow.
///
/// - base (content): The relation or arrow symbol.
/// - top (content): The annotation text or symbol to place above.
/// - stretchy (bool): If true, stretches the base to match the width of the annotation.
/// - lift (length): Vertical offset for the annotation.
#let betteraccent(base, top: [?], stretchy: false, lift: 0.12em) = context {
	if stretchy {
		let w = measure(top).width
		$attach(limits(stretch(#base, size: #w)), t: #move(dy: -lift, top))$
	} else {
		$attach(limits(#base), t: #move(dy: -lift, top))$
	}
}

// --- Logic & Set Theory ---
/// Mapping
#let to = sym.arrow.r

/// "Such that" text with spacing.
#let st = $"s.t."$
/// "With respect to" text with spacing.
#let wrt = $"w.r.t."$

/// Implications
#let iff = sym.arrow.l.r.double.long
#let implies = sym.arrow.r.double.long
#let impliedby = sym.arrow.l.double.long

// --- Calligraphic Letters ---
// Explicit names avoid shadowing built-ins such as bb, dd, and oo.
#let calA = $cal(A)$
#let calB = $cal(B)$
#let calC = $cal(C)$
#let calD = $cal(D)$
#let calE = $cal(E)$
#let calF = $cal(F)$
#let calG = $cal(G)$
#let calH = $cal(H)$
#let calI = $cal(I)$
#let calJ = $cal(J)$
#let calK = $cal(K)$
#let calL = $cal(L)$
#let calM = $cal(M)$
#let calN = $cal(N)$
#let calO = $cal(O)$
#let calP = $cal(P)$
#let calQ = $cal(Q)$
#let calR = $cal(R)$
#let calS = $cal(S)$
#let calT = $cal(T)$
#let calU = $cal(U)$
#let calV = $cal(V)$
#let calW = $cal(W)$
#let calX = $cal(X)$
#let calY = $cal(Y)$
#let calZ = $cal(Z)$

// --- Braces & Delimiters (auto-scaling) ---

// Set builder notation: Set(x ; condition)
/// Set or set-builder notation: `Set($x in RR$, $x > 0$)`.
#let Set(..args) = {
	let a = args.pos()
	if a.len() == 1 {
		$lr({#a.at(0)})$
	} else {
		$lr({#a.at(0) mid(|) #a.at(1)})$
	}
}

/// Inner product notation.
#let iprod(a, b) = $lr(chevron.l #a, #b chevron.r)$
/// Evaluation bar helper.
#let evaluated(expr) = $lr(#expr |)$

// --- Blackboard Bold Sets ---
/// Indicator / characteristic function symbol.
#let II = $bb(1)$
