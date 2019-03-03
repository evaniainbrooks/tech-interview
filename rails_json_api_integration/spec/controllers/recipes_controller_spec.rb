require 'rails_helper'
require 'recipe_puppy_dao'

RSpec.describe RecipesController, type: :controller do

  describe "GET #index" do
    context 'with no query' do
      before do
        Pprailstest::RecipePuppyDAO.should_not_receive(:search)
      end
      it "returns http success" do
        get :index
        expect(response).to have_http_status(:success)
      end
    end
    context 'with query' do
      before do
        Pprailstest::RecipePuppyDAO.should_receive(:search).and_return(double)
      end
      it 'returns https success' do
        get :index, query: 'omlette'
        expect(response).to have_http_status(:success)
      end
    end
  end
end
