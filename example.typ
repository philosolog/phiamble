#import "lib.typ": *

#show: setup_page.with(
	title: "phiamble Preamble Showcase",
	subtitle: "A comprehensive guide to using the library components",
	course: "MATH-X",
	term: "Spring 2026",
	theme: "dark", // Try "github-dark" or "gruvbox"
)


= Introduction
Welcome to the *phiamble* showcase. This document demonstrates the various blocks, mathematical helpers, and utility functions available in the preamble package.

= Blocks & Environments

== Theorems and Proofs
The preamble provides a set of standard theorem-like blocks.

#theorem(name: "Fundamental Theorem of Typst")[
	If a document is written in Typst, it compiles faster than LaTeX.
]

#proof[
	We observe the compilation times of various documents...
	$ 1 + 1 = 2 $
]

#lemma[
	A simple lemma following the theorem.
]

#definition(name: "Beautiful Document")[
	A document is *beautiful* if it uses the phiamble package.
]

#remark[
	This is a remark with a left accent variant.
]

== Assignments and Exercises
For homework and assignments, we have specialized blocks.

#problem(name: "Matrix Multiplication")[
	Compute the product of the following matrices:
	$ A = imat(2) quad B = dmat(1, 2) $
]

#solution[
	The product is simply:
	$ A B = imat(2) dmat(1, 2) = dmat(1, 2) $
]

#exercise(section: 1)[
	This is an exercise using section-based numbering (1.1).
]

== Continuations
Blocks can be continued across page breaks or logically separated.

#problem(name: "Long Problem", continuing: true)[
	Part 1 of a long problem...
]

#pagebreak()

#problem(continued: true)[
	Part 2 of the same problem (Problem 2 continued).
]

= Mathematics

== Calculus & Differentials
Use `dd`, `pd`, `dv`, and `pdv` for consistent styling.

$ f(x) = x^2 => dv(f, x) = 2x $
$ pdv(f, x, y) = pdv(f, y, x) $
$ dd(x, 2) + 2 dd(x) + x = 0 $

Gradient, Divergence, and Curl:
$ grad f, divg F, curl F, laplacian f $

Cancel to value:
$ x + cancelsto(y - y, 0) = x $

== Linear Algebra
Construct matrices easily.

$ dmat(1, 2, 3) $
$ imat(3, fill: 0) $
$ zmat(2, m: 3) $

Piecewise cases with aligned conditions:
$ f(x) = pcases(
	x^2, x > 0,
	-x, x <= 0,
	terminal-period: #true
) $

== Logic & Sets
$ Set(x in RR, x > 0) $
$ iprod(u, v) = 0 => u perp v $
$ II_(A)(x) = pcases(1, x in A, 0, x in.not A) $

= Utilities

== Columns and Enums
Split enums into columns (flows horizontally):
#tasks(columns: 2)[
	+ First item
	+ Second item
	+ Third item
	+ Fourth item
]

== Referenceable Enums
#enum(numbering: "(i)",
  [First roman numeral item <roman1>],
  [Second roman numeral item <roman2>],
)

As seen in @roman1, we can reference specific items.

== Logo Helpers
Made with #LaTeX and #typst.
