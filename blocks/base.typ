// Core block and environment machinery for the phiamble package.
#import "../core/state.typ": continued_block_refs, main_text_font, theme_state
#import "../core/colors.typ": get_colors, is_dark_theme

// --- Component Constructors ---

#let normalize_block_name(name) = {
	if name == none {
		none
	} else if (
	type(name) == str and name.starts-with("(") and name.ends-with(")")
	) {
		[#name]
	} else {
		[(#name)]
	}
}

#let block_gap = 14pt
#let linked_block_gap = 10pt

/// Renders a callout-style header with a title and optional name.
#let callout_header(title, color, muted, name: none) = context {
	let note = normalize_block_name(name)
	text(weight: "bold", fill: color, font: main_text_font)[#title]
	if note != none {
		h(0.3em)
		set text(
			weight: "regular",
			style: "italic",
			fill: muted,
			font: main_text_font,
		)
		show math.equation: set text(fill: muted)
		note
	}
	text(weight: "bold", fill: color, font: main_text_font)[.]
}

/// Packs block metadata into a consistent reference object.
#let pack_block_ref(kind, key, name: none, number: none, scope: none) = (
	kind: kind,
	key: key,
	name: name,
	number: number,
	scope: scope,
)

/// Build a continuation reference for theorem/problem/callout blocks.
#let block_ref(
	kind,
	name: none,
	number: none,
	scope: none,
	key: none,
) = pack_block_ref(
	kind,
	if key != none {
		key
	} else if type(name) == str and name != "" {
		kind + "-ref-" + name.replace(" ", "-")
	} else {
		none
	},
	name: name,
	number: number,
	scope: scope,
)

/// Stores a block reference in the document state for later continuation.
#let store_block_ref(ref) = continued_block_refs.update(refs => {
	refs.insert(ref.at("kind"), ref)
	refs
})

/// Retrieves the most recent block reference of a specific kind.
#let latest_block_ref(kind) = continued_block_refs.get().at(kind, default: none)

/// Resolves a reference object for a block, optionally supporting continuations.
#let resolve_block_ref(kind, of: none, continued: false) = {
	if of != none {
		of
	} else if continued {
		latest_block_ref(kind)
	} else {
		none
	}
}

/// Configures a local equation scope for a block, optionally continuing numbering.
#let with_local_equations(
	body,
	scope: none,
	continued: false,
	ref_key: none,
) = context {
	if ref_key != none {
		let eq_state = state("block-eq-" + ref_key, 0)
		let offset = if continued {
			eq_state.get()
		} else {
			0
		}
		// Track equations incrementally instead of reading the laid-out counter back
		// at the end of the block, which can trigger pagination convergence retries.
		if not continued {
			eq_state.update(_ => 0)
		}
		counter(math.equation).update(0)
		set math.equation(numbering: if scope != none {
			n => "(" + scope + "." + str(offset + n) + ")"
		} else {
			"(1)"
		})
		show math.equation: it => {
			eq_state.update(n => n + 1)
			it
		}
		body
	} else {
		let equation_numbering = if scope != none {
			n => "(" + scope + "." + str(n) + ")"
		} else {
			"(1)"
		}
		if not continued {
			counter(math.equation).update(0)
		}
		set math.equation(numbering: equation_numbering)
		body
	}
}

/// Resolves the continuation state (start, middle, end, or single) for a block.
#let resolve_continuation(
	continuation: "single",
	continued: false,
	continuing: false,
) = {
	if continuation != "single" {
		continuation
	} else if continued and continuing {
		"middle"
	} else if continued {
		"end"
	} else if continuing {
		"start"
	} else {
		"single"
	}
}

/// Low-level styled block renderer used by theorem, callout, and assignment environments.
#let environment_box(
	title: none,
	name: none,
	number: none,
	color: auto,
	fill: auto,
	variant: "box",
	header_mode: "auto",
	body_style: "roman",
	continuation: "single",
	continued: false,
	continuing: false,
	breakable: true,
	body,
) = context {
	let active_theme = theme_state.get()
	let is_dark = is_dark_theme(active_theme)
	let colors = get_colors(active_theme)
	let active_color = if color == auto { colors.theorem } else { color }
	let active_fill = if fill == auto {
		active_color.transparentize(if is_dark { 88% } else { 95% })
	} else {
		fill
	}
	let note = normalize_block_name(name)
	let header_uses_grid = number != none and variant != "plain"
	let stacked = if header_mode == "stack" {
		true
	} else if header_mode == "inline" {
		false
	} else {
		header_uses_grid or variant == "accent-left" or note != none
	}
	let link_state = resolve_continuation(
		continuation: continuation,
		continued: continued,
		continuing: continuing,
	)
	let dotted_top = link_state == "middle" or link_state == "end"
	let dotted_bottom = link_state == "middle" or link_state == "start"
	let top_radius = if link_state == "middle" or link_state == "end" {
		0pt
	} else { 6pt }
	let bottom_radius = if link_state == "middle" or link_state == "start" {
		0pt
	} else { 6pt }
	let accent_radius = (
		top-left: top_radius,
		top-right: top_radius,
		bottom-right: bottom_radius,
		bottom-left: bottom_radius,
	)
	let connector_paint = if variant == "box" {
		active_color
	} else if active_fill != none {
		if is_dark {
			active_fill.lighten(18%)
		} else {
			active_fill.darken(18%)
		}
	} else {
		colors.bg
	}
	let connector_stroke = (
		paint: connector_paint,
		thickness: 1pt,
		dash: "loosely-dotted",
		cap: "round",
	)
	let solid_stroke = 1pt + active_color

	let header_label = {
		set text(weight: "semibold", font: main_text_font)
		text(fill: active_color)[#title]
		if number != none { text(fill: active_color)[ #number] }
		if note != none {
			h(0.3em)
			set text(
				weight: "regular",
				style: "italic",
				fill: colors.text_muted,
				font: main_text_font,
			)
			show math.equation: set text(fill: colors.text_muted)
			note
		}
		if continued {
			h(0.3em)
			set text(
				weight: "regular",
				style: "italic",
				fill: colors.text_muted,
				font: main_text_font,
			)
			[(continued)]
		}
		text(fill: active_color)[.]
	}

	let header = if header_uses_grid {
		grid(
			columns: (1fr, auto),
			column-gutter: 10pt,
			align: (left, right),
			header_label, text(
				weight: "semibold",
				font: main_text_font,
				fill: active_color,
			)[#number],
		)
	} else {
		header_label
	}

	let rendered_body = if body_style == "italic" {
		text(style: "italic")[#body]
	} else {
		body
	}

	if variant == "plain" {
		block(
			width: 100%,
			above: if link_state == "single" or link_state == "start" {
				block_gap
			} else { linked_block_gap },
			below: if link_state == "single" or link_state == "end" {
				block_gap
			} else { linked_block_gap },
			breakable: breakable,
		)[
			#if dotted_top {
				line(length: 100%, stroke: connector_stroke)
				v(0.35em)
			}
			#if stacked {
				block(below: 0.35em, header)
				rendered_body
			} else {
				header
				h(0.4em)
				rendered_body
			}
			#if dotted_bottom {
				v(0.45em)
				line(length: 100%, stroke: connector_stroke)
			}
		]
	} else if variant == "accent-left" {
		block(
			width: 100%,
			inset: (left: 14pt, right: 8pt, top: 6pt, bottom: 6pt),
			radius: 0pt,
			fill: active_fill,
			stroke: (left: (paint: active_color, thickness: 4pt)),
			above: if link_state == "single" or link_state == "start" {
				block_gap
			} else { linked_block_gap },
			below: if link_state == "single" or link_state == "end" {
				block_gap
			} else { linked_block_gap },
			breakable: breakable,
		)[
			#if dotted_top {
				line(length: 100%, stroke: connector_stroke)
				v(0.45em)
			}
			#block(below: 0.45em, header)
			#rendered_body
			#if dotted_bottom {
				v(0.45em)
				line(length: 100%, stroke: connector_stroke)
			}
		]
	} else {
		block(
			width: 100%,
			inset: (left: 14pt, right: 14pt, top: 10pt, bottom: 10pt),
			radius: accent_radius,
			fill: active_fill,
			stroke: (
				left: solid_stroke,
				right: solid_stroke,
				top: if dotted_top { none } else { solid_stroke },
				bottom: if dotted_bottom { none } else { solid_stroke },
			),
			above: if link_state == "single" or link_state == "start" {
				block_gap
			} else { linked_block_gap },
			below: if link_state == "single" or link_state == "end" {
				block_gap
			} else { linked_block_gap },
			breakable: breakable,
		)[
			#if dotted_top {
				box(width: 100% + 28pt, height: 0pt)[
					#move(dx: -14pt, dy: -10pt)[
						#line(length: 100%, stroke: connector_stroke)
					]
				]
			}
			#if stacked {
				block(below: 0.5em, header)
				rendered_body
			} else {
				header
				h(0.4em)
				rendered_body
			}
			#if dotted_bottom {
				box(width: 100% + 28pt, height: 0pt)[
					#move(dx: -14pt, dy: 10pt)[
						#line(length: 100%, stroke: connector_stroke)
					]
				]
			}
		]
	}
}

// --- Specific Environments ---

// Factory function to create standard environments
/// Factory for numbered theorem-like environments.
#let create_numbered_environment(
	kind,
	supplement,
	color_key,
	counter_obj,
	fill_key: none,
	variant: "box",
	header_mode: "auto",
	equation_scope: none,
	body_style: "roman",
) = {
	return (
		body,
		name: none,
		num: none,
		breakable: true,
		continuation: "single",
		continued: false,
		continuing: false,
		ref: none,
		of: none,
	) => {
		if not continued and num == none { counter_obj.step() }
		figure(
			context {
				let prior_ref = resolve_block_ref(kind, of: of, continued: continued)
				if continued and prior_ref == none {
					panic(
						kind
						+ "_continue requires a prior continued block or explicit `of:` reference",
					)
				}

				let active_theme = theme_state.get()
				let is_dark = is_dark_theme(active_theme)
				let colors = get_colors(active_theme)
				let display_number = if continued {
					prior_ref.at("number")
				} else if num != none {
					num
				} else {
					counter_obj.display()
				}
				let scope_id = if continued {
					prior_ref.at("scope")
				} else if equation_scope != none {
					equation_scope
				} else if num != none {
					if type(num) == str { num } else { str(num) }
				} else {
					str(counter_obj.get().first())
				}
				let display_name = if name != none {
					name
				} else if continued {
					prior_ref.at("name", default: none)
				} else {
					none
				}
				let active_ref = if continued {
					prior_ref
				} else if ref != none {
					block_ref(
						kind,
						name: if ref.at("name", default: none) != none {
							ref.at("name")
						} else { display_name },
						number: display_number,
						scope: scope_id,
						key: if ref.at("key", default: none) != none {
							ref.at("key")
						} else {
							kind + "-ref-" + scope_id
						},
					)
				} else if continuing {
					block_ref(
						kind,
						name: display_name,
						number: display_number,
						scope: scope_id,
						key: kind + "-ref-" + scope_id,
					)
				} else {
					none
				}
				[
					#if active_ref != none {
						store_block_ref(active_ref)
					}
					#environment_box(
						title: supplement,
						name: display_name,
						number: display_number,
						color: colors.at(color_key),
						fill: if fill_key != none { colors.at(fill_key) } else { auto },
						variant: variant,
						header_mode: header_mode,
						body_style: body_style,
						continuation: continuation,
						continued: continued,
						continuing: continuing,
						breakable: breakable,
						with_local_equations(
							body,
							scope: scope_id,
							continued: continued,
							ref_key: if active_ref != none { active_ref.at("key") } else {
								none
							},
						),
					)
				]
			},
			kind: kind,
			supplement: supplement,
			numbering: if num != none { _ => num } else { "1" },
		)
	}
}

/// Create a `*_continue` helper for an existing block environment.
#let make_continue_environment(env) = (
	body,
	..args,
) => env(
	body,
	continued: true,
	..args,
)
