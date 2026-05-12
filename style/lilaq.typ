// Lilaq diagram styling and theme integration.
#import "@preview/lilaq:0.5.0" as lq
#import "@preview/tiptoe:0.4.0"
#import "../core/state.typ": theme_state
#import "../core/colors.typ": get_colors, is_dark_theme


/// Computes Lilaq-specific color tokens based on the current theme.

#let get_lilaq_colors(dark) = {
	let colors = get_colors(dark)
	let is_dark = is_dark_theme(dark)
	
	// For light themes, mixing with black creates muddy grays.
	// Pure white (colors.bg) acts as a clean, premium 'card' against 
	// both white pages and tinted theorem backgrounds.
	// For dark themes, we slightly elevate the background towards white.
	let legend_bg = if is_dark {
		colors.bg_alt.mix((white, 6%))
	} else {
		colors.bg
	}

	(
		label_fill: colors.text,
		// Solidify axis stroke for better contrast against dark backgrounds
		axis_stroke: 0.7pt + colors.text_muted.transparentize(if is_dark { 10% } else { 30% }),
		legend_fill: legend_bg,
		legend_stroke: 0.8pt + colors.text_muted.transparentize(if is_dark { 30% } else { 60% }),
	)
}

/// Applies the default diagram theme to a Lilaq diagram.
#let phiamble_diagram_theme = it => context {
	let lq_colors = get_lilaq_colors(theme_state.get())
	let filter(value, distance) = value != 0 and distance >= 5pt
	let axis-args = (position: 0, filter: filter)

	// Base diagram styling
	show: lq.set-tick(stroke: lq_colors.axis_stroke, inset: 1.5pt, outset: 1.5pt, pad: 0.4em)
	show: lq.set-spine(stroke: lq_colors.axis_stroke, tip: tiptoe.stealth)
	show: lq.set-grid(stroke: none)
	
	// Configure the diagram and its legend explicitly
	// This overrides Lilaq's default white.transparentize(20%) legend fill
	show: lq.set-legend(
		fill: lq_colors.legend_fill,
		stroke: lq_colors.legend_stroke,
		radius: 4pt,
		inset: 0.5em,
	)
	show: lq.set-diagram(
		xaxis: axis-args,
		yaxis: axis-args,
		legend: (
			fill: lq_colors.legend_fill,
			stroke: lq_colors.legend_stroke,
			radius: 4pt,
			inset: 0.5em,
		)
	)
	
	show: lq.set-label(pad: 1.25em)


	it
}
