# frozen_string_literal: true

RSpec.configure do |config|
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  # Run specs in random order to surface order dependencies.
  config.order = :random
  Kernel.srand config.seed
end
