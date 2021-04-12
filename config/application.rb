require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'active_storage/engine'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_mailbox/engine'
require 'action_text/engine'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'
require 'rails/test_unit/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module FitronSport
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0

    # Set Global Application Name
    config.application_name = I18n.t 'site_name'

    # Use Resque for job scheduling
    config.active_job.queue_adapter = :sidekiq

    # Disable generation of helpers
    config.generators.helpers = false

    # Disable generation of assets (we'll use webpacker)
    config.generators.assets = false

    # Allow exporting to pdf only on public routes. Disabled for now
    # config.middleware.use PDFKit::Middleware, { :print_media_type => true }, :only => %r[^/public]

    # Include custom paths in eager/auto loading
    %w[lib app/validators app/components app/inputs app/forms].each do |path|
      config.eager_load_paths << Rails.root.join(path)
      config.autoload_paths << Rails.root.join(path)
    end
  end
end
