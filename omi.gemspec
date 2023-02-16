require_relative "lib/omi/version"

version = Omi::VERSION

Gem::Specification.new do |spec|
  spec.name = "omi"
  spec.version = version
  spec.authors = ["Tony Burns"]
  spec.email = ["tony@tonyburns.net"]

  spec.summary = ""
  spec.description = ""
  spec.homepage = "https://omi.tbhb.io"
  spec.license = "MIT"

  spec.required_ruby_version = ">= 3.0.5"
  spec.required_rubygems_version = ">= 3.2.33"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/tbhb/omi/issues",
    "changelog_uri" => "https://github.com/tbhb/omi/blob/v#{version}/CHANGELOG.md",
    "documentation_uri" => "https://omi.tbhb.io/api/v#{version}",
    "homepage_uri" => spec.homepage,
    "mailing_list_uri" => "https://github.com/tbhb/omi/discussions",
    "source_code_uri" => "https://github.com/tbhb/omi/tree/v#{version}",
    "rubygems_mfa_required" => "true"
  }

  spec.files = Dir["lib/**/.rb", "LICENSE.md", "README.md"]
  spec.bindir = "exe"
  spec.executables = ["omi"]
  spec.require_paths = ["lib"]

  spec.add_dependency "zeitwerk"
end
