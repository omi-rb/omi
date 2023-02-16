require "simplecov"
require "simplecov-cobertura"
SimpleCov.start "rails" do
  enable_coverage :branch

  formatter SimpleCov::Formatter::MultiFormatter.new([
    SimpleCov::Formatter::CoberturaFormatter,
    SimpleCov::Formatter::HTMLFormatter
  ])
end

require "omi"

RSpec.configure do |config|
  config.disable_monkey_patching!

  config.example_status_persistence_file_path = ".rspec_status"
  config.order = :random
  config.profile_examples = 10 if ENV["RSPEC_PROFILE_EXAMPLES"]
  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_doubled_constant_names = true
    mocks.verify_partial_doubles = true
  end
end
