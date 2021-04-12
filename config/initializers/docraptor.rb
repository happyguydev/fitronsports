require "docraptor"

DocRaptor.configure do |config|
  config.username = ENV['DOCRAPTOR_USERNAME']
  config.debugging = true
end

