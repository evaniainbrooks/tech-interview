require 'rest-client'

Pprailstest::RecipePuppyClient = RestClient::Resource.new(Pprailstest::Application.config.recipe_puppy_endpoint)
