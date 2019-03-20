# Mixtape Data Batch Processor

There are two modes. The most basic mode takes 3 input files:

`process-batch input.json changes.json output.json`

The second mode validates an input/output file against a schema:

`process-batch file.json`

## Dependencies

### Packages
Ruby 2.5.3
RubyGems

### Gems
bundler
dry-schema

## Scaling up

The simplest way this could be scaled to handle larger input files is by using a streaming JSON parser and a real relational database. The streaming parser would ease the memory burden of having to read the entire input and changes file as a JSON blob. The database would ease the burden of having to keep the entire mixtape data in memory during processing.

Going further, the database could be moved to an external box or a service like Amazon RDS. Instead of batching changes, they could be published to an event stream/queue like Amazon Kinesis, or SQS and consumed by any number of different event processors (eg. one each for playlists, songs, users).
