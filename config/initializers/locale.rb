# Permitted locales available for the application
I18n.load_path += Dir[Rails.root.join('config', 'locales', '**', '*.{rb,yml}')]
I18n.available_locales = [:en, :de]

# Set default locale to something other than :en
if Rails.env.development?
  I18n.default_locale = :en
else
  I18n.default_locale = :de
end
