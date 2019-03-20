# frozen_string_literal: true

# Mixtape Data Access Object
# Interface supports basic database operations
# Could easily be backed with a real database
class MixtapeDao
  TABLE_NAMES = %w(songs users playlists).freeze

  def initialize
    @tables =
      Hash.new do |h, k|
        h[k] = {}
      end
  end

  def self.populate(data)
    new.tap do |dao|
      TABLE_NAMES.each do |key|
        dao.insert(key, data[key])
      end
    end
  end

  def find(type, id)
    @tables[type].fetch(id)
  end

  def insert(type, records)
    records.each do |record|
      id = record.fetch('id', sequence_next_id(type))
      ensure_not_exists(type, id)
      @tables[type][id] = record.merge('id' => id)
    end
  end

  def update(type, records)
    records.each do |record|
      id = record.fetch('id')
      ensure_exists(type, id)
      @tables[type][id].merge(record)
    end
  end

  def delete(type, ids)
    ids.each do |id|
      ensure_exists(type, id)
      @tables[type].delete(id)
    end
  end

  def to_h
    @tables.transform_values do |value|
      value.values
    end
  end

  private

  def sequence_next_id(type)
    (@tables[type].size + 1).to_s
  end

  def ensure_exists(type, id)
    raise(ArgumentError, "#{type} with id #{id} does not exist") unless @tables[type].key?(id)
  end

  def ensure_not_exists(type, id)
    raise(ArgumentError, "#{type} with id #{id} already exists") if @tables[type].key?(id)
  end
end
