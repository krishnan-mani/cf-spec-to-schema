require 'json'

require_relative '../../lib/spec_to_schema'

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
      resource_types_from_schema = schema['definitions']['resource_types'].keys.sort
      expect(resource_types_from_schema).to eql resource_types_from_spec

    end

  end

end