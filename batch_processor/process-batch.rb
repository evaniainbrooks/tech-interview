require 'json'
require 'benchmark'

require_relative './app/dao'
require_relative './app/api'
require_relative './app/batch_processor'
require_relative './app/schema'

# Extract command line arguments
# use something like optparse as this becomes more complex
def extract_arguments!
  return ARGV[0], nil, nil if ARGV.length == 1

  raise(ArgumentError, "Usage: mixtape-bu SOURCE [CHANGES] [DEST]") unless ARGV.length == 3

  ARGV.take(3)
end

# Utilities for reading/writing JSON files
def parse_json_file(filename, symbolize_names: false)
  f = File.open(filename, 'r')
  JSON.parse(f.read, symbolize_names: symbolize_names).tap do
    f.close
  end
end

def write_json_file(filename, data)
  File.write(filename, JSON.pretty_generate(data))
end

# Globals
dao = nil
api = nil
batch_processor = nil
source, changes, destination = extract_arguments!

if !changes
  # Validation mode
  result = MixtapeDataSchema.call(parse_json_file(source, symbolize_names: true))
  unless result.success?
    puts "Failed to validate #{source}"
    puts result.errors.inspect
    exit 1
  end

  puts "Success! #{source} is a valid Mixtape data file"
  exit 0
end

# Begin populate operation
Benchmark.realtime do
  dao = MixtapeDao.populate(parse_json_file(source))
end.tap do |elapsed|
  puts "Populated database in #{elapsed.round(5)} seconds"
end

# Begin changes operation
Benchmark.realtime do
  api = MixtapeApi.new(dao)
  update_operations = parse_json_file(changes)

  batch_processor = BatchProcessor.new(api)
  batch_processor.process_batch(update_operations) do |operation, error|
    if error
      print 'F'
    else
      print '.'
    end
  end
end.tap do |elapsed|
  puts ""
  puts "Processed #{batch_processor.processed} operations with #{batch_processor.errors} errors in #{elapsed.round(5)} seconds"
end

# Begin output operation
Benchmark.realtime do
  write_json_file(destination, dao.to_h)
end.tap do |elapsed|
  puts "Generated output in #{elapsed.round(5)} seconds"
end

puts "Finished"
exit 0
