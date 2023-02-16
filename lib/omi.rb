require "zeitwerk"

module Omi
  require_relative "omi/version"
  require_relative "omi/constants"
  require_relative "omi/errors"

  def self.autoloader
    @autoloader ||= Zeitwerk::Loader.for_gem.tap do |loader|
      loader.ignore(
        "#{__dir__}/omi/cli/constants",
        "#{__dir__}/omi/cli/errors",
        "#{__dir__}/omi/constants",
        "#{__dir__}/omi/errors"
      )

      loader.inflector.inflect(
        "cli" => "CLI"
      )

      loader.do_not_eager_load(
        "#{__dir__}/omi/cli",
        "#{__dir__}/omi/cli.rb"
      )
    end
  end

  autoloader.setup
end
