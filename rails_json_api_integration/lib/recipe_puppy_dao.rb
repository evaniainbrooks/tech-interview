module Pprailstest
  module RecipePuppyDAO
    RECIPE_RESULT_FIELDS = [:title, :href, :ingredients, :thumbnail].freeze

    class SearchResult < Struct.new(*RECIPE_RESULT_FIELDS)
    end

    def self.search query, limit
      begin
        results = []
        p = 1
        loop do
          recipe_puppy_params = { q: query, p: p }
          response = Pprailstest::RecipePuppyClient.get params: recipe_puppy_params
          Rails.logger.debug(response.inspect)

          break if response.code != 200
          break if response.body.blank?

          page_results = JSON.parse(response.body)['results']

          results.concat(page_results)
          p = p + 1
          
          break if results.count >= limit || page_results.count == 0 || p > 10
        end

        results.map do |result|
          SearchResult.new(*result.values)
        end
      rescue StandardError => e
        Rails.logger.error e
        
        return nil
      end
    end
  end
end
