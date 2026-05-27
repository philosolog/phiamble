// Page setup and document-level styling.
#import "../core/state.typ": (
	continued_block_refs, main_math_font, main_text_font, render_mode_state,
	reset_counters, theme_state,
)
#import "../core/state.typ": problem_counter
#import "../core/colors.typ": get_colors, resolve_theme
#import "lilaq.typ": phiamble_diagram_theme

// Import itemize for native enum referencing
#import "@preview/itemize:0.2.0" as itemize

/// Configures the visual styling of the document (colors, fonts, math styles, etc.)
/// without applying page layout properties like margins or headers.
/// Useful for snippets or embedding content in other documents.
///
/// - theme (string): Overrides the default theme ("github-light", "github-dark", or "gruvbox").
/// - body (content): The content to style.
#let setup_theme(
	theme: auto,
	body,
) = {
	let active_theme = resolve_theme(theme: theme)
	theme_state.update(active_theme)
	let colors = get_colors(active_theme)
	set page(fill: colors.bg)

	set text(
		font: main_text_font,
		size: 11pt,
		fill: colors.text,
		hyphenate: false,
	)

	// Paragraphs
	set par(justify: false, leading: 0.65em)

	// Headings
	set heading(numbering: "1.1")
	show heading: it => {
		set text(fill: colors.text, weight: "semibold")
		block(above: 1.5em, below: 0.7em, it)
	}

	show heading.where(level: 1): it => {
		set text(size: 15pt, weight: "semibold", fill: colors.text)
		block(above: 1.8em, below: 0.85em)[#it.body]
	}

	show heading.where(level: 2): it => {
		set text(size: 12pt, weight: "semibold", fill: colors.text)
		block(above: 1.3em, below: 0.5em)[#it.body]
	}

	// Math styling
	set math.equation(numbering: "(1)")
	show math.equation: set text(font: main_math_font, fill: colors.text)

	// Links — Blue underlined
	show link: it => {
		set text(fill: colors.text)
		underline(it)
	}

	// Apply itemize rule to enable native list references
	show: itemize.config.ref.with(supplement: none)
	show: itemize.default-enum-list


	// Figures (Environments) — Left aligned
	show figure: set align(left)

	// Apply diagram theme for Lilaq diagrams
	show: phiamble_diagram_theme

	// Code blocks
	show raw.where(block: true): it => {
		block(
			fill: colors.bg_alt,
			stroke: 1pt + colors.text_muted.transparentize(70%),
			inset: 12pt,
			radius: 4pt,
			width: 100%,
			it,
		)
	}

	show raw.where(block: false): it => {
		box(
			fill: colors.bg_alt,
			inset: (x: 3pt, y: 0pt),
			outset: (y: 3pt),
			radius: 2pt,
			it,
		)
	}

	// Strong/emphasis
	show strong: set text(fill: colors.text, weight: "bold")

	body
}

/// Configures the document-level styling, page layout, and preamble state.
///
/// - title (content): The document title.
/// - subtitle (content): A secondary title or description.
/// - author (content): The author(s) of the document.
/// - date (content): The document date.
/// - course (content): The course name/ID for the header.
/// - theme (string): Overrides the default theme ("github-light", "github-dark", or "gruvbox").
/// - render_mode (string): Either "paged" (default) or "html" (skips headers/footers).
/// - running_header (bool): Whether paged output includes the running header.
/// - show_title_block (bool): Whether to render the default title/metadata block.
/// - show_first_page_footer (bool): Whether the page number appears on the first page.
/// - start (int): The starting number for headings and counters.
/// - prob_start (int): The starting number for the problem counter (defaults to `start`).
#let setup_page(
	title: none,
	subtitle: none,
	author: none,
	date: none,
	course: none,
	term: none,
	due: none,
	instructor: none,
	institution: none,
	theme: auto,
	render_mode: "paged",
	running_header: true,
	show_title_block: true,
	show_first_page_footer: true,
	start: 1,
	prob_start: auto,
	body,
) = {
	// Initialize state and reset all counters
	let active_theme = resolve_theme(theme: theme)
	let first = if start < 1 { 1 } else { start }
	let requested_prob_start = if prob_start == auto { first } else { prob_start }
	let active_prob_start = if requested_prob_start < 1 { 1 } else {
		requested_prob_start
	}
	render_mode_state.update(render_mode)
	reset_counters(start: first)
	problem_counter.update(active_prob_start - 1)
	continued_block_refs.update((:))

	let colors = get_colors(active_theme)
	let doc-meta = (:)
	if type(title) == str {
		doc-meta.insert("title", title)
	}
	if type(author) == str or type(author) == array {
		doc-meta.insert("author", author)
	}

	set document(..doc-meta) if doc-meta.len() > 0


	let page_background = context {
		box(fill: colors.bg, width: 100% + 2in, height: 100% + 2in)[
			#move(dx: -1in, dy: -1in)[]
		]
	}

	let page_args = if render_mode == "html" {
		(
			paper: "us-letter",
			margin: (x: 1in, y: 1in),
			fill: colors.bg,
			background: page_background,
		)
	} else {
		(
			paper: "us-letter",
			margin: (x: 1in, y: 1in),
			fill: colors.bg,
			background: page_background,
			header: if running_header {
				context {
					let show_running_header = counter(page).get().first() > 1
					let header_text_fill = if show_running_header {
						colors.text_muted
					} else {
						colors.text_muted.transparentize(100%)
					}
					let header_rule = if show_running_header {
						0.5pt + colors.text_muted.transparentize(50%)
					} else {
						0.5pt + colors.text_muted.transparentize(100%)
					}

					set text(fill: header_text_fill, size: 9pt)
					grid(
						columns: (1fr, 1fr),
						align: (left, right),
						smallcaps(if course != none { course } else { "" }),
						smallcaps(if title != none { title } else { "" }),
					)
					v(-8pt)
					line(length: 100%, stroke: header_rule)
				}
			} else {
				none
			},
			footer: context {
				let footer_fill = if show_first_page_footer or counter(page).get().first() > 1 {
					colors.text_muted
				} else {
					colors.text_muted.transparentize(100%)
				}
				set text(fill: footer_fill, size: 9pt)
				align(center)[#counter(page).display()]
			},
		)
	}

	set page(..page_args)

	show: setup_theme.with(theme: active_theme)

	// ─── TITLE BLOCK — Official centered header ───
	if show_title_block and title != none {
		align(left)[
			#block(
				inset: (top: 6pt, bottom: 20pt),
				below: 22pt,
				width: 100%,
			)[
				#if course != none {
					text(
						size: 10pt,
						fill: colors.text_muted,
						tracking: 0.08em,
					)[#smallcaps(course)]
					v(6pt)
				}
				#text(size: 19pt, weight: "semibold", fill: colors.text)[#title]
				#if subtitle != none {
					v(5pt)
					text(size: 11pt, fill: colors.text_muted, style: "italic")[#subtitle]
				}
				#let meta_cells = ()
				#if author != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Author])
					meta_cells.push(text(size: 10pt, fill: colors.text_muted)[#author])
				}
				#if instructor != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Instructor])
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
					)[#instructor])
				}
				#if institution != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Institution])
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
					)[#institution])
				}
				#if term != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Term])
					meta_cells.push(text(size: 10pt, fill: colors.text_muted)[#term])
				}
				#if due != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Due])
					meta_cells.push(text(size: 10pt, fill: colors.text_muted)[#due])
				}
				#if date != none {
					meta_cells.push(text(
						size: 10pt,
						fill: colors.text_muted,
						weight: "bold",
					)[Date])
					meta_cells.push(text(size: 10pt, fill: colors.text_muted)[#date])
				}
				#if meta_cells.len() > 0 {
					v(10pt)
					grid(
						columns: (72pt, 1fr),
						column-gutter: 10pt,
						row-gutter: 4pt,
						..meta_cells,
					)
				}
				#v(10pt)
				#line(
					length: 100%,
					stroke: 0.7pt + colors.text_muted.transparentize(60%),
				)
			]
		]
	}

	if render_mode == "html" {
		box(fill: colors.bg, width: 100%)[
			// Ensure the visible HTML preview gets the theme background even if the
			// viewer canvas is otherwise white. The inner block preserves normal
			// content flow while the box provides the background color.
			body
		]
	} else {
		body
	}
}
