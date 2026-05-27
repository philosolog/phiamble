// Layout and mathematical typesetting utilities.
#import "../core/state.typ": theme_state
#import "../core/colors.typ": get_colors
#import "../blocks/base.typ": environment_box

// --- Equation Utilities ---

/// Renders a zero-width box for annotations, ensuring spaces are non-breaking.
#let brace_label(s) = box(width: 0pt)[
	#if type(s) == str {
		text(s.replace(" ", "\u{A0}"))
	} else {
		s
	}
]

/// Renders an underbrace with a non-wrapping, zero-width annotation label.
#let underbrace(eq, label) = math.underbrace(eq, brace_label(label))

/// Inline math box with theme-aware stroke.
#let boxed(eq) = context {
	let colors = get_colors(theme_state.get())
	box(
		fill: none,
		stroke: 0.5pt + colors.text,
		inset: (x: 2pt, top: 2pt, bottom: 4pt),
		outset: (y: 2pt),
		radius: 0pt,
		baseline: 4pt,
		eq,
	)
}

// --- Layout Utilities ---

/// Placeholder block for hidden draft content. Use `visible: true` to render body.
#let wip(body, visible: false) = context {
	if visible {
		body
	} else {
		let colors = get_colors(theme_state.get())

		environment_box(
			title: "Missing content here",
			color: colors.todo,
			fill: colors.todo_fill,
			variant: "accent-left",
			header_mode: "stack",
			[
				_Content here is intentionally hidden for compilation purposes._
			],
		)
	}
}


/// Renders a theme-aware horizontal divider line.
#let divider = context {
	let colors = get_colors(theme_state.get())
	v(8pt)
	line(length: 100%, stroke: 0.5pt + colors.text_muted.transparentize(50%))
	v(8pt)
}

/// Runs `body` with a theme-aware stroke for table rules.
#let with_table_rule_stroke(body) = context {
	let colors = get_colors(theme_state.get())
	body(0.5pt + colors.text_muted.transparentize(35%))
}

/// Reference an enum item by label string.
/// Enables native @-label support by aliasing to standard ref.
#let eref(name) = ref(label(name))
