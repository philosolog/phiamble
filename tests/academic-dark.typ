// Run from the repository root: typst compile --root . preamble/tests/academic-dark.typ
#import "../lib.typ": *

#assert(is_academic_theme("academic"))
#assert(is_academic_theme("academic-dark"))
#assert(not is_academic_theme("github-dark"))
#assert(is_dark_theme("academic-dark"))
#assert(not is_dark_theme("academic"))
#for (key, value) in get_colors("academic").pairs() {
  assert.eq(get_colors("academic-dark").at(key), if value == white { black } else { white })
}

#show: setup_page.with(theme: "academic-dark", title: "Academic dark", course: "Putnam")

#problem[Find $x$ such that $x + 1 = 2$.]
#solution[We have $x = 1$.]
#solution[

]
#solution[
  A solution with a trailing blank paragraph.

]
#theorem[The academic layout retains its theorem styling.]
