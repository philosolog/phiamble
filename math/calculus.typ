// Differentials and calculus helpers.
#import "symbols.typ": op

// --- Differentials & Calculus ---

/// Upright differential: `dd()`, `dd(x)`, or `dd(x, 2)`.
#let dd(..args) = {
	let a = args.pos()
	if a.len() == 0 {
		$dif$
	} else if a.len() == 1 {
		$dif #a.at(0)$
	} else {
		// dd(x, n) -> d^n x
		$dif^(#a.at(1)) #a.at(0)$
	}
}

/// Upright partial differential: `pd()`, `pd(x)`, or `pd(x, 2)`.
#let pd(..args) = {
	let a = args.pos()
	if a.len() == 0 {
		$partial$
	} else if a.len() == 1 {
		$partial #a.at(0)$
	} else {
		// pd(x, n) -> partial^n x
		$partial^(#a.at(1)) #a.at(0)$
	}
}

// Vector calculus operators

/// Gradient symbol.
#let grad = $nabla$
/// Divergence operator.
#let divg = $nabla dot.op$
/// Curl operator.
#let curl = $nabla times$
/// Laplacian operator.
#let laplacian = $nabla^2$
/// Alias for `laplacian`.
#let lap = laplacian

// Derivative operator:
// dv(x) -> d/dx
// dv(y, x) -> dy/dx
// dv(y, x, 4) -> d^4 y / dx^4
// dv(y, x, n: 4) -> d^4 y / dx^4
// dv(x, n: 2) -> d^2 / dx^2

/// Derivative fraction helper: `dv(x)`, `dv(y, x)`, `dv(y, x, n: 2)`.
#let dv(..args, n: none) = {
	let a = args.pos()
	let d = $dif$
	let has_positional_order = a.len() == 3
	let has_named_order = n != none
	if has_positional_order and has_named_order {
		panic(
			"dv: pass derivative order either as 3rd positional arg or as n:, not both",
		)
	}
	let order = if has_named_order {
		n
	} else if has_positional_order {
		a.at(2)
	} else {
		1
	}

	if a.len() == 1 {
		let x = a.at(0)
		if order == 1 { $frac(#d, #d #x)$ } else { $frac(#d^#order, #d #x^#order)$ }
	} else if a.len() == 2 or a.len() == 3 {
		let y = a.at(0)
		let x = a.at(1)
		if order == 1 { $frac(#d #y, #d #x)$ } else {
			$frac(#d^#order #y, #d #x^#order)$
		}
	} else {
		panic("dv expects 1, 2, or 3 positional arguments")
	}
}

/// Partial derivative fraction helper: `pdv(x)`, `pdv(y, x)`, `pdv(y, x, n: 2)`.
#let pdv(..args, n: none) = {
	let a = args.pos()
	let d = $partial$
	let has_positional_order = a.len() == 3
	let has_named_order = n != none
	if has_positional_order and has_named_order {
		panic(
			"pdv: pass derivative order either as 3rd positional arg or as n:, not both",
		)
	}
	let order = if has_named_order {
		n
	} else if has_positional_order {
		a.at(2)
	} else {
		1
	}

	if a.len() == 1 {
		let x = a.at(0)
		if order == 1 { $frac(#d, #d #x)$ } else { $frac(#d^#order, #d #x^#order)$ }
	} else if a.len() == 2 or a.len() == 3 {
		let y = a.at(0)
		let x = a.at(1)
		if order == 1 { $frac(#d #y, #d #x)$ } else {
			$frac(#d^#order #y, #d #x^#order)$
		}
	} else {
		panic("pdv expects 1, 2, or 3 positional arguments")
	}
}

/// Cancel to value: `cancelsto($x - x$, 0)` draws a diagonal arrow and tip label.
#let cancelsto(
	body,
	to,
	angle_adjust: 0deg,
	arrow_size: none,
	min_arrow_size: 20pt,
	arrow_extra: 6pt,
	tip_extra: 2pt,
	label_gap: 2pt,
	label_lift: 1pt,
	top_pad: 0.15em,
	to_scale: 75%,
) = context {
	let m = measure(body)
	let w = m.width.to-absolute().pt()
	let h = m.height.to-absolute().pt()
	let label = scale(to_scale, reflow: true, $#to$)
	let angle = -calc.atan2(w, h) + angle_adjust
	let span = if arrow_size == none {
		calc.max(calc.sqrt(w * w + h * h) * 1pt + arrow_extra, min_arrow_size)
	} else {
		arrow_size
	}
	let vx = calc.cos(angle)
	let vy = calc.sin(angle)
	let arrow = rotate(angle, math.stretch(sym.arrow.r, size: span))
	let label_m = measure(label)
	let tip_x = span * vx / 2 + tip_extra * vx
	let tip_y = span * vy / 2 + tip_extra * vy

	box(inset: (top: label_m.height + top_pad))[
		#set place(center + horizon)
		#body
		#place(dx: 0pt, dy: 0pt, arrow)
		#place(
			dx: tip_x + label_gap * vx - label_lift * vy,
			dy: tip_y + label_gap * vy + label_lift * vx,
			label,
		)
	]
}

/// Compatibility alias for `cancelsto`.
#let cancelto = cancelsto
