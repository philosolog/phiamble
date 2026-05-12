# phiamble, my (Typst) preamble

## Usage

### 1. Import the Library
Import the main entry point `lib.typ` at the top of your document:

```typst
#import "preamble/lib.typ": *
```

### 2. Configure the Page
Wrap your document in the `setup_page` show rule to apply styles and initialize metadata.

```typst
#show: setup_page.with(
  title: "Homework 1",
  course: "MATH 101",
  author: "Your Name",
  theme: "github-light", // "github-light", "github-dark", or "gruvbox"
)
```

## Quick Start Example

```typst
#import "preamble/lib.typ": *

#show: setup_page.with(
  title: "Analysis of phiamble",
  course: "CS Y",
)

= Introduction
#theorem(name: "Correctness")[
  If you use this preamble, your math will look beautiful.
]

#proof[
  The proof is left as an exercise to the reader.
]

#problem(num: 1)[
  Compute $dv(f, x)$ where $f(x) = Set(y in RR, y > x)$.
]

#solution[
  $ f'(x) = ... $
]
```

---

## Core Configuration: `setup_page`

The `setup_page` function handles document-level styling, page layout, and state initialization.

| Parameter | Type | Description |
| :--- | :--- | :--- |
| `title` | `str/content` | Main document title (sets PDF metadata and centered header). |
| `subtitle` | `str/content` | Optional text below the title. |
| `author` | `str/content` | Document author(s). |
| `course` | `str/content` | Course ID/Name (e.g., "MATH-130C") for header. |
| `theme` | `str/auto` | `"github-light"`, `"github-dark"`, or `"gruvbox"`. |
| `render_mode`| `"paged"/"html"`| Use `"html"` to hide headers/footers for web-style scrolling. |
| `start` | `int` | Starting number for headings and counters (default: 1). |
| `instructor` | `str/content` | Instructor name for the title block. |
| `due` | `str/content` | Due date displayed in the title block. |
| `term` | `str/content` | Academic term (e.g., "Spring 2026"). |

---

## Blocks & Environments

All environments support `name:`, `num:`, `breakable:`, and continuation logic.

### Theorems & Logic
- **Theorems**: `theorem`, `lemma`, `proposition`, `corollary`, `fact`, `axiom`.
- **Definitions**: `definition` (Left-accented).
- **Remarks**: `remark`, `example` (Muted/Light accents).
- **Proofs**: `proof` (Ends with a filled QED square).

### Assignments & Exercises
- `problem`: Numbered problem block with local equation numbering `(1.1)`.
- `solution`: Solution block, ends with a QED square.
- `exercise`: Supports section-based numbering `exercise(section: 1)` -> **Exercise 1.1**.

### Continuations
Any block can be continued across page breaks by passing `continuing: true` to the first block and using the same command with `continued: true` for the next.
- Helper commands like `problem_continue` are also available.

---

## Mathematical Shorthands

### General Symbols (`math/symbols.typ`)
- `Set(a, b)`: Renders $\{a \mid b\}$. `Set(a)` renders $\{a\}$.
- `iprod(u, v)`: Inner product $\langle u, v \rangle$.
- `evaluated(expr)`: Evaluation bar notation $expr \rvert$.
- `ub(x)`: Upright bold symbol for matrices/vectors.
- `betteraccent(base, top: [...])`: Compact annotation above a relation.
- `st`: "s.t." with proper math spacing.
- `eps`, `vphi`, `veps`: Aliases for $\epsilon, \phi_{\text{alt}}, \epsilon_{\text{alt}}$.

### Calculus (`math/calculus.typ`)
- `dd(x)`, `dd(x, n)`: Upright differentials $d x, d^n x$.
- `pd(x)`, `pd(x, n)`: Partial differentials $\partial x, \partial^n x$.
- `dv(y, x, n: 2)`, `pdv(...)`: Total/Partial derivative fractions.
- `grad`, `divg`, `curl`, `laplacian`: Vector calculus operators ($\nabla, \nabla \cdot, \nabla \times, \nabla^2$).
- `cancelsto(expr, value)`: Diagonal arrow canceling an expression to a value.

### Linear Algebra (`math/linear-algebra.typ`)
- **Operators**: `rank`, `nullity`, `span`, `spec`, `tr`, `det`, `End`, `Hom`, `Aut`, `GL`, `SL`.
- **Matrix Constructors**: 
  - `dmat(1, 2, 3)`: Diagonal matrix.
  - `imat(3)`: Identity matrix.
  - `zmat(2, 3)`: Zero matrix.
- `pcases(...)`: Aligned piecewise cases with automated punctuation support.
- `TT`: Transpose symbol ($\top$).

### Probability (`math/probability.typ`)
- `Pr(A, B; given: C)`: Intersection probability with conditioning $P(A, B \mid C)$.
- `E(X; given: F)`: Expectation $E[X \mid F]$.
- `ind(A)`: Indicator function $\mathbb{1}_A$.
- `Var`, `Cov`, `Corr`, `law`, `iid`: Standard probability operators.
- `to_p`, `to_d`, `to_as`, `to_lp(p)`: Convergence arrows.

### Analysis & Measure Theory (`math/analysis.typ`, `math/measure-theory.typ`)
- `inlim(n -> oo)`: Limit with automated limits placement.
- `sup`, `inf`, `limsup`, `liminf`, `argmax`, `argmin`: Operators with limits.
- `clos(A)`, `intr(A)`, `bdy(A)`, `ball(x, r)`: Topological set operations.
- `mint(f, measure: mu, over: Omega)`: Integration with upright differential $d\mu$.
- `rn(nu, mu)`: Radon-Nikodym derivative $d\nu/d\mu$.
- `Lp(p, over: Omega)`: $L^p$ space notation.
- `to_m`, `to_ae`: Convergence in measure and almost everywhere.

---

## Utilities

### Referencing List Items
The preamble uses the `itemize` package to allow referencing enumeration items natively. Simply place a standard Typst `<label>` after your item.

```typst
#set enum(numbering: "1.a)")

+ The first part of the problem. <part-a>
+ The second part.

As shown in @part-a, the claim holds.
```

- `eref(label)`: Alias for `ref(label(...))`, useful for programmatically generating references.

### Document Helpers
- `#tasks(columns: 2)[...]`: Create horizontal multi-column lists using the `taskize` package.
- `boxed(eq)`: Highlight an equation with a theme-aware border.
- `divider`: Insert a subtle horizontal separator.
- `wip(body, visible: false)`: Placeholder for draft content, hidden unless explicitly enabled.
- `LaTeX`, `typst`: Logo helpers for the respective systems.

---

## Technical Details

- **Namespacing**: Most modules are available as namespaces (e.g., `math.grad` or `blocks.theorem`).
- **State Management**: Uses Typst `state` and `counter` to ensure accurate numbering across complex block layouts.
- **Theme Engine**: Powered by a custom theme system in `core/colors.typ`, ensuring accessibility and visual consistency across Light, Dark, and Gruvbox modes.
