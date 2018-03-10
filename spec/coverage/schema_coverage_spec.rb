require 'json'
require 'pathname'

require_relative '../../lib/spec_to_schema'

def get_resource_type_from_ref(refmap)
  Pathname.new(refmap.values.first.gsub('#', '')).basename.to_s
end

def get_resource_type_refs_from_schema(schema)
  schema['oneOf'].collect { |refmap| get_resource_type_from_ref(refmap) }.sort
end

def get_resource_types_from_schema(schema)
  schema['definitions']['resource_types'].keys.sort
end

def get_resource_specification(resource_specification_filename)
  base_path = File.dirname(__FILE__)
  resource_specification_path = File.join(base_path, resource_specification_filename)
  JSON.parse(File.read(resource_specification_path))
end

RSpec.describe "generated schema for resources" do

  context "coverage" do

    it "includes all resource types present in the specification" do

      resource_specification_filename = 'CloudFormationResourceSpecification.json'
      resource_specification = get_resource_specification(resource_specification_filename)
      resource_types_from_spec = resource_specification['ResourceTypes'].keys.sort

      spec_to_schema = SpecToSchema.new(resource_specification)
      schema = JSON.parse(spec_to_schema.get_schema)

      resource_types_refs = get_resource_type_refs_from_schema(schema)
      expect(resource_types_refs).to eql resource_types_from_spec

      resource_types_from_schema = get_resource_types_from_schema(schema)
      expect(resource_types_from_schema).to eql resource_types_from_spec

    end

  end

end