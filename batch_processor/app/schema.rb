# frozen_string_literal: true

require 'dry-schema'

MixtapeDataSchema = Dry::Schema.JSON do
  required(:songs).each do
    schema do
      required(:id).filled(:string)
      required(:artist).filled(:string)
      required(:title).filled(:string)
    end
  end

  required(:playlists).each do
    schema do
      required(:id).filled(:string)
      required(:user_id).filled(:string)
      required(:song_ids).value(:array, :filled?)
    end
  end

  required(:users).each do
    schema do
      required(:id).filled(:string)
      required(:name).filled(:string)
    end
  end
end
