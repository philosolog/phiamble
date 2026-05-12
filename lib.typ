// phiamble Package Entry Point
// This module consolidates all components and provides a comprehensive default preamble.

// --- External Dependencies ---
#import "@preview/mannot:0.3.1": markrect
#import "@preview/algorithmic:1.0.7"
#import "@preview/fletcher:0.5.8" as fletcher
#import "@preview/suiji:0.5.1" as suiji
#import "@preview/pavemat:0.2.0": pavemat
#import "@preview/zero:0.6.0" as zero
#import "@preview/zebraw:0.6.1" as zebraw
#import "@preview/taskize:0.2.5": tasks

// --- Core & Style ---
#import "core/state.typ": *
#import "core/colors.typ": *
#import "style/lilaq.typ": *
#import "style/page.typ": *

// --- Blocks ---
#import "blocks/base.typ": *
#import "blocks/theorem.typ": *
#import "blocks/callouts.typ": *
#import "blocks/assignment.typ": *
#import "blocks/continuations.typ": *

// --- Mathematics ---
#import "math/symbols.typ": *
#import "math/calculus.typ": *
#import "math/linear-algebra.typ": *
#import "math/analysis.typ": *
#import "math/probability.typ": *
#import "math/measure-theory.typ": *
#import "utils/mod.typ": *

// --- Re-exports as Namespaces ---
#import "blocks/mod.typ" as blocks
#import "core/mod.typ" as core
#import "style/mod.typ" as style
#import "math/mod.typ" as math
#import "utils/mod.typ" as utils

/// Legacy support object for the 'full' preamble preset.
/// Includes nested namespaces for blocks, core, style, math, and utils.
#let full = (
	blocks: blocks,
	core: core,
	style: style,
	math: math,
	utils: utils,
)
