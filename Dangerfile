# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

swiftlint.lint_files
swiftlint.lint_files inline_mode: true

slather.configure("UsabillaFeedbackForm.xcodeproj", "UsabillaFeedbackForm", options: {
  workspace: 'UsabillaFeedbackForm.xcworkspace',
  source_directory: ".",
  decimals: 2
})
slather.show_coverage
