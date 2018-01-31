# require third party libraries
require 'pry'
require 'jobcoin_client'
require 'bigdecimal'

# require files
require 'helpers/data_helper.rb'
# get rid of the '.' and '..' directories first.
Dir.entries('lib').select {|f| !File.directory? f}
.tap { require 'distributor.rb' }
.each { |path| require path }

ENV['RACK_ENV'] = 'test'

RSpec.configure do |config|
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.warnings = true

  config.order = :random
end
