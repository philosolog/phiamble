// Centralized state management and document-wide counters.
/// Current resolved theme key. Written by `setup_page`.
#let theme_state = state("theme", "light")
/// Current rendering mode key. Written by `setup_page`.
#let render_mode_state = state("render_mode", "paged")

/// The primary typeface for body text and headers.
#let main_text_font = "New Computer Modern"
/// The primary typeface for mathematical content.
#let main_math_font = "New Computer Modern Math"

// --- Counters (Programmatic) ---
#let counter_names = (
	"theorem",
	"definition",
	"axiom",
	"lemma",
	"corollary",
	"proposition",
	"fact",
	"example",
	"remark",
	"problem",
	"exercise",
)

#let counters = {
	let result = (:)
	for name in counter_names {
		result.insert(name, counter(name))
	}
	result
}

// Named accessors for convenience

#let theorem_counter = counters.at("theorem")
#let definition_counter = counters.at("definition")
#let axiom_counter = counters.at("axiom")
#let lemma_counter = counters.at("lemma")
#let corollary_counter = counters.at("corollary")
#let proposition_counter = counters.at("proposition")
#let fact_counter = counters.at("fact")
#let example_counter = counters.at("example")
#let remark_counter = counters.at("remark")
#let problem_counter = counters.at("problem")
#let exercise_counter = counters.at("exercise")
#let exercise_current_section = state("exercise_current_section", none)
#let local_equation_scope = state("local_equation_scope", none)
#let continued_block_refs = state("continued_block_refs", (:))

// --- Counter Reset ---

/// Reset theorem/problem/exercise counters for a fresh document render.
#let reset_counters(start: 1) = {
	let first = if start < 1 { 1 } else { start }
	for name in counter_names {
		counters.at(name).update(first - 1)
	}
	counter(heading).update(first - 1)
	// Reset serial reference counters
	for kind in ("solution", "proof", "note", "recall", "todo", "warning", "exercise") {
		counter(kind + "-ref-serial").update(0)
	}
}
