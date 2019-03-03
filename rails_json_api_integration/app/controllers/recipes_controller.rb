require 'recipe_puppy_dao'

class RecipesController < ApplicationController
  MAX_RECIPIES = 20

  def index
    @query = params.fetch(:query, '')
    @recipes = Pprailstest::RecipePuppyDAO.search(@query, MAX_RECIPIES) || [] unless @query.blank?

    respond_to do |format|
      format.html
    end
  end
end
