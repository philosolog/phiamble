// Assignment/problem/solution blocks.
#import "../core/state.typ": (
exercise_counter, local_equation_scope, problem_counter, theme_state,
)
#import "../core/colors.typ": get_colors
#import "base.typ": (
block_ref, environment_box, resolve_block_ref, store_block_ref,
with_local_equations,
)

/// Numbered problem block with local equation numbering.
#let problem(
	body,
	name: none,
	num: none,
	breakable: true,
	continuation: "single",
	continued: false,
	continuing: false,
	ref: none,
	of: none,
) = {
	if not continued and num == none { problem_counter.step() }
	figure(
		context {
			let prior_ref = resolve_block_ref("problem", of: of, continued: continued)
			if continued and prior_ref == none {
				panic(
					"problem_continue requires a prior problem marked `continuing: true` or explicit `of:` reference",
				)
			}

			let colors = get_colors(theme_state.get())
			let display_num = if continued {
				prior_ref.at("number")
			} else if num != none {
				num
			} else {
				problem_counter.display()
			}
			let scope_id = if continued {
				prior_ref.at("scope")
			} else if num != none {
				if type(num) == str { num } else { str(num) }
			} else {
				str(problem_counter.get().first())
			}
			let display_name = if name != none { name } else if continued {
				prior_ref.at("name", default: none)
			} else { none }
			let active_ref = if continued {
				prior_ref
			} else if ref != none {
				block_ref(
					"problem",
					name: if ref.at("name", default: none) != none {
						ref.at("name")
					} else {
						display_name
					},
					number: display_num,
					scope: scope_id,
					key: if ref.at("key", default: none) != none { ref.at("key") } else {
						"problem-ref-" + scope_id
					},
				)
			} else if continuing {
				block_ref(
					"problem",
					name: display_name,
					number: display_num,
					scope: scope_id,
					key: "problem-ref-" + scope_id,
				)
			} else {
				none
			}
			local_equation_scope.update(scope_id)

			[
				#if active_ref != none {
					store_block_ref(active_ref)
				}
				#environment_box(
					title: "Problem",
					name: display_name,
					number: display_num,
					color: colors.problem,
					fill: colors.example_fill,
					header_mode: "stack",
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
		kind: "problem",
		supplement: "Problem",
		numbering: if num != none { _ => num } else { "1" },
	)
}

/// Solution block. By default appends a filled QED square.
#let solution(
	body,
	name: none,
	breakable: true,
	proven: true,
	qed: true,
	continuation: "single",
	continued: false,
	continuing: false,
	ref: none,
	of: none,
) = context {
	let colors = get_colors(theme_state.get())
	let prior_ref = resolve_block_ref("solution", of: of, continued: continued)
	if continued and prior_ref == none {
		panic(
			"solution_continue requires a prior solution marked `continuing: true` or explicit `of:` reference",
		)
	}
	let scope = if continued { prior_ref.at("scope") } else {
		local_equation_scope.get()
	}
	let display_name = if name != none { name } else if continued {
		prior_ref.at("name", default: none)
	} else { none }
	let fresh_ref_key = if not continued and ref == none and continuing {
		"solution-ref-" + str(counter("solution-ref-serial").get().first() + 1)
	} else {
		none
	}
	if fresh_ref_key != none { counter("solution-ref-serial").step() }

	let active_ref = if continued {
		prior_ref
	} else if ref != none {
		block_ref(
			"solution",
			name: if ref.at("name", default: none) != none { ref.at("name") } else {
				display_name
			},
			scope: scope,
			key: ref.at("key", default: none),
		)
	} else if continuing {
		block_ref("solution", name: display_name, scope: scope, key: fresh_ref_key)
	} else {
		none
	}
	let show_qed = qed and not continuing
	let content = if show_qed {
		let qed_symbol = if proven { $square.filled$ } else { $square.stroked$ }
		[
			#body
			#block(width: 100%, above: 0.35em)[#align(right)[#qed_symbol]]
		]
	} else {
		body
	}

	[
		#if active_ref != none {
			store_block_ref(active_ref)
		}
		#environment_box(
			title: "Solution",
			name: display_name,
			color: colors.solution,
			fill: colors.solution_fill,
			variant: "accent-left",
			header_mode: "stack",
			continuation: continuation,
			continued: continued,
			continuing: continuing,
			breakable: breakable,
			with_local_equations(
				content,
				scope: scope,
				continued: continued,
				ref_key: if active_ref != none { active_ref.at("key") } else { none },
			),
		)
	]
}

/// Numbered exercise block. Supports automatic, manual `num:`, and section-based numbering.
#let exercise(
	body,
	name: none,
	num: none,
	section: none,
	breakable: true,
	continuation: "single",
	continued: false,
	continuing: false,
	ref: none,
	of: none,
) = {
	if not continued and num == none { exercise_counter.step() }
	context {
		let colors = get_colors(theme_state.get())
		let prior_ref = resolve_block_ref(
			"exercise",
			of: of,
			continued: continued,
		)
		if continued and prior_ref == none {
			panic(
				"exercise_continue requires a prior exercise marked `continuing: true` or explicit `of:` reference",
			)
		}

		if continued {
			let scope_id = prior_ref.at("scope")
			let display_num = prior_ref.at("number")
			let display_name = if name != none { name } else {
				prior_ref.at("name", default: none)
			}
			let active_ref = prior_ref
			local_equation_scope.update(scope_id)

			[
				#store_block_ref(active_ref)
				#environment_box(
					title: "Exercise",
					name: display_name,
					number: display_num,
					color: colors.exercise,
					fill: colors.exercise_fill,
					header_mode: "stack",
					continuation: continuation,
					continued: true,
					continuing: continuing,
					breakable: breakable,
					with_local_equations(
						body,
						scope: scope_id,
						continued: true,
						ref_key: active_ref.at("key"),
					),
				)
			]
		} else {
			if section != none {
				// Section-based numbering using per-section counter (content-based)
				let sec_counter = counter("exercise_sec_" + str(section))
				let serial = str(sec_counter.get().first())
				let scope_id = str(section) + "." + serial
				let display_num = [#scope_id]
				let active_ref = if ref != none {
					block_ref(
						"exercise",
						name: if ref.at("name", default: none) != none {
							ref.at("name")
						} else { name },
						number: display_num,
						scope: scope_id,
						key: if ref.at("key", default: none) != none {
							ref.at("key")
						} else { "exercise-ref-" + scope_id },
					)
				} else if continuing {
					block_ref(
						"exercise",
						name: name,
						number: display_num,
						scope: scope_id,
						key: "exercise-ref-" + scope_id,
					)
				} else {
					none
				}
				local_equation_scope.update(scope_id)

				[
					#if section != none {
						counter("exercise_sec_" + str(section)).step()
					}
					#if active_ref != none {
						store_block_ref(active_ref)
					}
					#environment_box(
						title: "Exercise",
						name: name,
						number: display_num,
						color: colors.exercise,
						fill: colors.exercise_fill,
						header_mode: "stack",
						continuation: continuation,
						continuing: continuing,
						breakable: breakable,
						with_local_equations(
							body,
							scope: scope_id,
							ref_key: if active_ref != none { active_ref.at("key") } else {
								none
							},
						),
					)
				]
			} else {
				// String-based numbering (manual or auto)
				let display_num = if num != none {
					if type(num) == str { num } else { str(num) }
				} else {
					exercise_counter.display("1")
				}
				let active_ref = if ref != none {
					block_ref(
						"exercise",
						name: if ref.at("name", default: none) != none {
							ref.at("name")
						} else { name },
						number: display_num,
						scope: display_num,
						key: if ref.at("key", default: none) != none {
							ref.at("key")
						} else { "exercise-ref-" + display_num },
					)
				} else if continuing {
					block_ref(
						"exercise",
						name: name,
						number: display_num,
						scope: display_num,
						key: "exercise-ref-" + display_num,
					)
				} else {
					none
				}
				local_equation_scope.update(display_num)

				[
					#if active_ref != none {
						store_block_ref(active_ref)
					}
					#environment_box(
						title: "Exercise",
						name: name,
						number: display_num,
						color: colors.exercise,
						fill: colors.exercise_fill,
						header_mode: "stack",
						continuation: continuation,
						continuing: continuing,
						breakable: breakable,
						with_local_equations(
							body,
							scope: display_num,
							ref_key: if active_ref != none { active_ref.at("key") } else {
								none
							},
						),
					)
				]
			}
		}
	}
}
