require 'support/helpers/session_helpers'
require 'support/helpers/ajax_helpers'
RSpec.configure do |config|
  config.include Features::SessionHelpers, type: :feature
  config.include Features::AjaxHelpers, type: :feature
end
