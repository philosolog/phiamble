// Proofs and callout blocks.
#import "../core/state.typ": theme_state
#import "../core/colors.typ": get_colors
#import "base.typ": (
block_ref, environment_box, resolve_block_ref, store_block_ref,
with_local_equations,
)

// Shared constructor for unnumbered callouts.
#let make_callout_environment(kind, title, color_key, fill_key) = (
	body,
	name: none,
	breakable: true,
	continuation: "single",
	continued: false,
	continuing: false,
	ref: none,
	of: none,
) => context {
	let colors = get_colors(theme_state.get())
	let prior_ref = resolve_block_ref(kind, of: of, continued: continued)
	if continued and prior_ref == none {
		panic(
			kind
			+ "_continue requires a prior "
			+ kind
			+ " marked `continuing: true` or explicit `of:` reference",
		)
	}
	let fresh_ref_key = if not continued and ref == none and continuing {
		kind + "-ref-" + str(counter(kind + "-ref-serial").get().first() + 1)
	} else {
		none
	}

	let display_name = if name != none {
		name
	} else if prior_ref != none {
		prior_ref.at("name", default: none)
	} else {
		none
	}
	let active_ref = if continued {
		prior_ref
	} else if ref != none {
		block_ref(
			kind,
			name: if ref.at("name", default: none) != none { ref.at("name") } else {
				display_name
			},
			key: ref.at("key", default: none),
		)
	} else if continuing {
		block_ref(kind, name: display_name, key: fresh_ref_key)
	} else {
		none
	}

	[
		#if fresh_ref_key != none { counter(kind + "-ref-serial").step() }
		#if active_ref != none {
			store_block_ref(active_ref)
		}
		#environment_box(
			title: title,
			name: display_name,
			color: colors.at(color_key),
			fill: colors.at(fill_key),
			variant: "accent-left",
			header_mode: "stack",
			continuation: continuation,
			continued: continued,
			continuing: continuing,
			breakable: breakable,
			with_local_equations(
				body,
				continued: continued,
				ref_key: if active_ref != none { active_ref.at("key") } else { none },
			),
		)
	]
}

/// Warning callout block. Supports continuation/ref options.
#let warning = make_callout_environment(
	"warning",
	"Warning",
	"warning",
	"warning_fill",
)

/// Build an explicit proof reference for continued proofs.
#let proof_ref(name: none, key: none) = {
	if key == none and type(name) != str {
		panic("proof_ref requires `key:` unless `name:` is a plain string")
	}
	block_ref("proof", name: name, key: key)
}

/// Proof block with optional QED mark. Use `continuing: true` and `proof_continue` for split proofs.
#let proof(
	body,
	name: none,
	ref: none,
	of: none,
	breakable: true,
	proven: true,
	qed: true,
	continuation: "single",
	continued: false,
	continuing: false,
) = context {
	let colors = get_colors(theme_state.get())
	let prior_ref = resolve_block_ref("proof", of: of, continued: continued)
	if continued and prior_ref == none {
		panic(
			"proof_continue requires a prior proof marked `continuing: true` or explicit `of:` reference",
		)
	}
	let fresh_ref_key = if not continued and ref == none and continuing {
		"proof-ref-" + str(counter("proof-ref-serial").get().first() + 1)
	} else {
		none
	}

	let active_ref = if continued {
		prior_ref
	} else if ref != none {
		block_ref(
			"proof",
			name: if ref.at("name", default: none) != none { ref.at("name") } else {
				name
			},
			key: ref.at("key", default: none),
		)
	} else if continuing {
		block_ref("proof", name: name, key: fresh_ref_key)
	} else {
		none
	}
	let proof_name = if name != none {
		name
	} else if (
	active_ref != none and active_ref.at("name", default: none) != none
	) {
		active_ref.at("name")
	} else if prior_ref != none and prior_ref.at("name", default: none) != none {
		prior_ref.at("name")
	} else {
		none
	}
	let show_qed = qed and not continuing
	let content = if show_qed {
		let qed_symbol = if proven { $square.filled$ } else { $square.stroked$ }
		body + h(1fr) + qed_symbol
	} else {
		body
	}

	[
		#if fresh_ref_key != none { counter("proof-ref-serial").step() }
		#if active_ref != none {
			store_block_ref(active_ref)
		}
		#environment_box(
			title: "Proof",
			name: proof_name,
			number: none,
			color: colors.proof,
			fill: colors.proof_fill,
			variant: "accent-left",
			continuation: continuation,
			continued: continued,
			continuing: continuing,
			breakable: breakable,
			with_local_equations(
				content,
				continued: continued,
				ref_key: if active_ref != none { active_ref.at("key") } else { none },
			),
		)
	]
}

// --- Callouts ---

/// Note callout block.
#let note = make_callout_environment("note", "Note", "note", "note_fill")
/// Recall callout block.
#let recall = make_callout_environment("recall", "Recall", "recall", "recall_fill")
/// `TODO` callout block.
#let todo = make_callout_environment("todo", "TODO", "todo", "todo_fill")
