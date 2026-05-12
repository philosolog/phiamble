#import "@preview/fletcher:0.5.8" as fletcher_mod: *
#let node = fletcher_mod.node
#let edge = fletcher_mod.edge
#import "../core/state.typ": theme_state
#import "../core/colors.typ": get_colors

#let diagram(..args) = context {
	let colors = get_colors(theme_state.get())
	let named = args.named()
	let theme-stroke = 0.8pt + colors.text

	// Merge theme color into strokes if they are just thicknesses
	for key in ("node-stroke", "edge-stroke") {
		if key in named {
			let val = named.at(key)
			if type(val) == length {
				named.insert(key, val + colors.text)
			}
		} else {
			named.insert(key, theme-stroke)
		}
	}

	fletcher_mod.diagram(..args.pos(), ..named)
}
