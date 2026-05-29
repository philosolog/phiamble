// Theme palettes and color resolution logic.

// --- Colors ---

// GitHub Light
#let light_colors = (
	bg: rgb("#ffffff"),
	bg_alt: rgb("#f6f8fa"),
	text: rgb("#1f2328"),
	text_muted: rgb("#59636e"),
	accent: rgb("#0969da"),
	accent_dark: rgb("#0550ae"),
	theorem: rgb("#0969da"),
	theorem_fill: rgb("#ddf4ff"),
	definition: rgb("#1a7f37"),
	definition_fill: rgb("#dafbe1"),
	axiom: rgb("#1a7f37"),
	lemma: rgb("#0969da"),
	corollary: rgb("#0969da"),
	proposition: rgb("#0969da"),
	fact: rgb("#0969da"),
	example: rgb("#1a7f37"),
	example_fill: rgb("#dafbe1"),
	note: rgb("#0969da"),
	note_fill: rgb("#ddf4ff"),
	recall: rgb("#8250df"),
	recall_fill: rgb("#fbefff"),
	remark: rgb("#8250df"),
	remark_fill: rgb("#fbefff"),
	warning: rgb("#9a6700"),
	warning_fill: rgb("#fff8c5"),
	todo: rgb("#9a6700"),
	todo_fill: rgb("#fff8c5"),
	proof: rgb("#0969da"),
	proof_fill: rgb("#ddf4ff"),
	problem: rgb("#1a7f37"),
	solution: rgb("#1a7f37"),
	solution_fill: rgb("#dafbe1"),
	exercise: rgb("#9a6700"),
	exercise_fill: rgb("#fff8c5"),
)

// GitHub Dark
#let dark_colors = (
	bg: rgb("#0d1117"),
	bg_alt: rgb("#151b23"),
	text: rgb("#f0f6fc"),
	text_muted: rgb("#9198a1"),
	accent: rgb("#4493f8"),
	accent_dark: rgb("#388bfd"),
	theorem: rgb("#4493f8"),
	theorem_fill: rgb("#388bfd1a"),
	definition: rgb("#3fb950"),
	definition_fill: rgb("#2ea04326"),
	axiom: rgb("#3fb950"),
	lemma: rgb("#4493f8"),
	corollary: rgb("#4493f8"),
	proposition: rgb("#4493f8"),
	fact: rgb("#4493f8"),
	example: rgb("#3fb950"),
	example_fill: rgb("#2ea04326"),
	note: rgb("#4493f8"),
	note_fill: rgb("#388bfd1a"),
	recall: rgb("#ab7df8"),
	recall_fill: rgb("#ab7df826"),
	remark: rgb("#ab7df8"),
	remark_fill: rgb("#ab7df826"),
	warning: rgb("#d29922"),
	warning_fill: rgb("#bb800926"),
	todo: rgb("#d29922"),
	todo_fill: rgb("#bb800926"),
	proof: rgb("#4493f8"),
	proof_fill: rgb("#388bfd1a"),
	problem: rgb("#3fb950"),
	solution: rgb("#3fb950"),
	solution_fill: rgb("#2ea04326"),
	exercise: rgb("#d29922"),
	exercise_fill: rgb("#bb800926"),
)

// Gruvbox Dark
#let gruvbox_dark_colors = (
	bg: rgb("#282828"),
	bg_alt: rgb("#1d2021"),
	text: rgb("#ebdbb2"),
	text_muted: rgb("#bdae93"),
	accent: rgb("#83a598"),
	accent_dark: rgb("#8ec07c"),
	theorem: rgb("#83a598"),
	theorem_fill: rgb("#223238"),
	definition: rgb("#8ec07c"),
	definition_fill: rgb("#26351f"),
	axiom: rgb("#8ec07c"),
	lemma: rgb("#83a598"),
	corollary: rgb("#83a598"),
	proposition: rgb("#83a598"),
	fact: rgb("#83a598"),
	example: rgb("#b8bb26"),
	example_fill: rgb("#343416"),
	note: rgb("#fabd2f"),
	note_fill: rgb("#3e3216"),
	recall: rgb("#d3869b"),
	recall_fill: rgb("#3b2630"),
	remark: rgb("#d3869b"),
	remark_fill: rgb("#3b2630"),
	warning: rgb("#fb4934"),
	warning_fill: rgb("#3d1f1b"),
	todo: rgb("#fe8019"),
	todo_fill: rgb("#3b2716"),
	proof: rgb("#8ec07c"),
	proof_fill: rgb("#26351f"),
	problem: rgb("#b8bb26"),
	solution: rgb("#8ec07c"),
	solution_fill: rgb("#26351f"),
	exercise: rgb("#d65d0e"),
	exercise_fill: rgb("#352414"),
)

#let resolve_theme(theme: "github-light") = if theme in (auto, none) { "github-light" } else { theme }

#let theme_presets = (
	"light": (palette: light_colors, is_dark: false),
	"dark": (palette: dark_colors, is_dark: true),
	"gruvbox-dark": (palette: gruvbox_dark_colors, is_dark: true),
)

#let get_preset(theme) = theme_presets.at(
	if theme == true { "dark" }
	else if theme in (false, none, auto) { "light" }
	else {
		(
			"gruvbox": "gruvbox-dark",
			"github-light": "light",
			"github-dark": "dark",
		).at(theme, default: theme)
	},
	default: theme_presets.light,
)


#let is_dark_theme(theme) = get_preset(theme).is_dark
#let get_colors(theme) = get_preset(theme).palette

