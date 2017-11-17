# Make it more obvious that a PR is a work in progress and shouldn't be merged yet
warn("PR is classed as Work in Progress") if github.pr_title.include? "[WIP]"

# Warn when there is a big PR
warn("Big PR") if git.lines_of_code > 500

swiftlint.config_file = '.swiftlint.yml'
swiftlint.lint_files inline_mode: true
slather.configure("Usabilla.xcodeproj", "Usabilla", options: {
  workspace: 'Usabilla.xcworkspace',
  source_directory: ".",
  decimals: 2,
  build_directory: "derivedData",
  ci_service: :jenkins
})
slather.show_coverage
message "[Coverage report](#{ENV['BUILD_URL']}Coverage_Report/)"