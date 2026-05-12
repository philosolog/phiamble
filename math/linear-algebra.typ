// Linear algebra helpers and matrix constructors.
#import "symbols.typ": op

// --- Linear Algebra ---
/// Rank operator.
#let rank = op("rank")
/// Nullity operator.
#let nullity = op("nullity")
/// Span operator.
#let span = op("span")
/// Endomorphism operator.
#let End = op("End")
/// Homomorphism operator.
#let Hom = op("Hom")
/// Automorphism operator.
#let Aut = op("Aut")
/// General linear group operator.
#let GL = op("GL")
/// Special linear group operator.
#let SL = op("SL")
/// Diagonal operator text. Use `diag(...)` for diagonal matrix constructor.
#let diag_op = op("diag")
/// Spectrum operator.
#let spec = op("spec")
/// Adjugate/adjoint operator, depending on course convention.
#let adj = op("adj")
/// Projection operator.
#let proj = op("proj")
/// Null-space operator.
#let Null = op("Null")
/// Range operator.
#let Range = op("Range")

/// Transpose symbol.
#let TT = $top$
/// Parenthesized ordered basis/vector list: `basis($v_1$, ..., $v_n$)`.
#let basis(..vectors) = $lr((#vectors.pos().join(", ")))$

// --- Matrix Constructors ---

/// Diagonal matrix constructor: `dmat(1, 2, 3)` or `dmat(a, b, delim: "[", fill: $0$)`.
#let dmat(..entries) = {
	let vals = entries.pos()
	let fill = entries.named().at("fill", default: none)
	let delim = entries.named().at("delim", default: "(")
	let fill_sym = if fill != none { fill } else { $dot.c$ }
	let n = vals.len()
	let rows = ()
	for i in range(n) {
		let row = ()
		for j in range(n) {
			if i == j {
				row.push(vals.at(i))
			} else {
				row.push(fill_sym)
			}
		}
		rows.push(row)
	}
	math.mat(delim: delim, ..rows)
}

/// Alias for `dmat`.
#let diag = dmat

/// Identity matrix constructor: `imat(3)`.
#let imat(n, delim: "(", fill: none) = {
	let n = if type(n) == int { n } else { int(repr(n).replace("[", "").replace("]", "").replace("$", "")) }
	let rows = ()
	for i in range(n) {
		let row = ()
		for j in range(n) {
			if i == j {
				row.push($1$)
			} else if fill != none {
				row.push(fill)
			} else {
				row.push($dot.c$)
			}
		}
		rows.push(row)
	}
	math.mat(delim: delim, ..rows)
}

/// Zero matrix constructor: `zmat(2)` or `zmat(2, m: 3)`.
#let zmat(n, m: none, delim: "(") = {
	let n = if type(n) == int { n } else { int(repr(n).replace("[", "").replace("]", "").replace("$", "")) }
	let cols = if m == none { n } else {
		if type(m) == int { m } else { int(repr(m).replace("[", "").replace("]", "").replace("$", "")) }
	}
	let rows = ()
	for i in range(n) {
		let row = ()
		for j in range(cols) {
			row.push($0$)
		}
		rows.push(row)
	}
	math.mat(delim: delim, ..rows)
}

// Piecewise cases with an aligned condition column:
// pcases(value_1, condition_1, value_2, condition_2)
// Set terminal-period: true to end the final condition line with a period.
// Customize with word, bare-conditions, row-punctuation, terminal-punctuation,
// delim, align, and column-gap.
/// Piecewise cases with aligned condition column.
#let pcases(
	..entries,
	word: "if",
	bare-conditions: ("else", "otherwise"),
	row-punctuation: ",",
	terminal-punctuation: none,
	terminal-period: false,
	delim: ("{", none),
	align: left,
	column-gap: 1em,
) = {
	let items = entries.pos()
	if calc.rem(items.len(), 2) != 0 {
		panic("pcases expects value/condition pairs")
	}

	if terminal-period and terminal-punctuation == none {
		terminal-punctuation = "."
	}

	let rows = ()
	for i in range(0, items.len(), step: 2) {
		let is-last = i == items.len() - 2
		let value = items.at(i)
		let value-cell = $#value$

		let condition = items.at(i + 1)
		let bare-condition = type(condition) == str and condition in bare-conditions
		let show-word = word != none and not bare-condition
		let condition-text = if show-word { $#word #condition$ } else {
			$#condition$
		}
		let punctuation = if is-last {
			terminal-punctuation
		} else {
			row-punctuation
		}
		let condition-cell = if punctuation == none {
			$#condition-text$
		} else {
			$#condition-text#punctuation$
		}
		rows.push((value-cell, condition-cell))
	}

	math.mat(delim: delim, align: align, column-gap: column-gap, ..rows)
}
