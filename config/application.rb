require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module MemoApp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    default_tags = %w(
      del dd h3 address big sub tt a ul h4 cite dfn h5 small kbd code
      b ins img h6 sup pre strong blockquote acronym dt br p div samp
      li ol var em h1 i abbr h2 span hr
    )
    default_attributes = %w(
      name href cite class title src xml:lang height datetime alt abbr width
    )
    config.action_view.sanitized_allowed_tags = default_tags + %w(table thead tbody tr th td mark q iframe)
    config.action_view.sanitized_allowed_attributes = default_attributes +%w(style frameborder allow allowfullscreen)

  end
end

