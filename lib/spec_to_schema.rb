require_relative 'models'

class SpecToSchema

  def initialize(resource_spec_json)
    @schema = CloudFormationJSONSchema.from_resource_specification(resource_spec_json)
  end

  def get_schema
    @schema.to_json
  end

end
