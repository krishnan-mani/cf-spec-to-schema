#!/usr/bin/env ruby

require 'optparse'
require 'json'
require 'fileutils'

require_relative 'lib/spec_to_schema'

options = {}

OptionParser.new do |opts|
  opts.banner = "Usage: generate_schema.rb [options]"

  opts.on('-r', '--resource-specification relative-path/to/resource-specification.json', '(REQUIRED) relative path to CloudFormation resource specification') do |resource_spec_relative_path|
    options[:resource_spec_relative_path] = resource_spec_relative_path
  end

  opts.on('-h', '--help', 'Display help') do
    puts opts
    exit
  end

end.parse!

raise OptionParser::MissingArgument, "-r relative-path/to/resource-specification.json" if options[:resource_spec_relative_path].nil?

base_path = File.dirname(__FILE__)
resource_specification_path = File.join(base_path, options[:resource_spec_relative_path])
raise "Missing resource specification at #{resource_specification_path}" unless FileTest.exist? resource_specification_path

resource_specification = JSON.parse(File.read(resource_specification_path))
spec_to_schema = SpecToSchema.new(resource_specification)
schema = spec_to_schema.get_schema

FileUtils.makedirs(File.join(base_path, 'out'))
output_schema_path = File.join(base_path, 'out', 'resource.json')
File.open(output_schema_path, 'w') { |file| file.write(schema) }