// Numbered theorem-like environments (Theorem, Lemma, Definition, etc.).
#import "../core/state.typ": (
axiom_counter, corollary_counter, definition_counter, example_counter,
fact_counter, lemma_counter, proposition_counter, remark_counter,
theorem_counter,
)
#import "base.typ": create_numbered_environment

#let env(
	kind,
	title,
	counter_obj,
	fill_key,
	variant: "box",
) = create_numbered_environment(
	kind,
	title,
	kind,
	counter_obj,
	fill_key: fill_key,
	variant: variant,
)

/// Numbered theorem block. 
///
/// Supports `name:`, `num:`, `continuing:`, `continued:`, `ref:`, and `of:`.
#let theorem = env("theorem", "Theorem", theorem_counter, "theorem_fill")

/// Numbered definition block.
#let definition = env(
	"definition",
	"Definition",
	definition_counter,
	"definition_fill",
	variant: "accent-left",
)

/// Numbered lemma block.
#let lemma = env("lemma", "Lemma", lemma_counter, "theorem_fill")

/// Numbered axiom block.
#let axiom = env(
	"axiom",
	"Axiom",
	axiom_counter,
	"definition_fill",
	variant: "accent-left",
)

/// Numbered corollary block.
#let corollary = env(
	"corollary",
	"Corollary",
	corollary_counter,
	"theorem_fill",
)

/// Numbered proposition block.
#let proposition = env(
	"proposition",
	"Proposition",
	proposition_counter,
	"theorem_fill",
)

/// Numbered fact block.
#let fact = env("fact", "Fact", fact_counter, "theorem_fill")

/// Numbered example block.
#let example = env("example", "Example", example_counter, "example_fill")

/// Numbered remark block.
#let remark = env(
	"remark",
	"Remark",
	remark_counter,
	"remark_fill",
	variant: "accent-left",
)
