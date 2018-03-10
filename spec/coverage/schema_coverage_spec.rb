require 'json'
require 'pathname'

require_relative '../../lib/spec_to_schema'

def get_resource_type_from_ref(refmap)
  Pathname.new(refmap.values.first.gsub('#', '')).basename.to_s
end

RSpec.describe "generated schema for resources" do

  context "coverage" do

    it "includes all resource types present in the specification" do

      resource_specification_filename = 'CloudFormationResourceSpecification.json'
      base_path = File.dirname(__FILE__)
      resource_specification_path = File.join(base_path, resource_specification_filename)
      resource_specification = JSON.parse(File.read(resource_specification_path))
      resource_types_from_spec = resource_specification['ResourceTypes'].keys.sort

      spec_to_schema = SpecToSchema.new(resource_specification)
      schema = JSON.parse(spec_to_schema.get_schema)

      resource_types_refs = schema['oneOf'].collect { |refmap| get_resource_type_from_ref(refmap) }.sort
      expect(resource_types_refs).to eql resource_types_from_spec

      resource_types_from_schema = schema['definitions']['resource_types'].keys.sort
      expect(resource_types_from_schema).to eql resource_types_from_spec

    end

  end

end