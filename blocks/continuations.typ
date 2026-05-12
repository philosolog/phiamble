// Continuation aliases for block environments.
#import "base.typ": make_continue_environment
#import "theorem.typ": (
	axiom, corollary, definition, example, fact, lemma, proposition, remark,
	theorem,
)
#import "callouts.typ": note, proof, todo, warning
#import "assignment.typ": exercise, problem, solution

#let theorem_continue = make_continue_environment(theorem)
#let definition_continue = make_continue_environment(definition)
#let lemma_continue = make_continue_environment(lemma)
#let axiom_continue = make_continue_environment(axiom)
#let corollary_continue = make_continue_environment(corollary)
#let proposition_continue = make_continue_environment(proposition)
#let fact_continue = make_continue_environment(fact)
#let example_continue = make_continue_environment(example)
#let remark_continue = make_continue_environment(remark)
#let warning_continue = make_continue_environment(warning)
#let proof_continue = make_continue_environment(proof)
#let problem_continue = make_continue_environment(problem)
#let solution_continue = make_continue_environment(solution)
#let exercise_continue = make_continue_environment(exercise)
#let note_continue = make_continue_environment(note)
#let todo_continue = make_continue_environment(todo)
