require 'json'


class CloudFormationJSONSchema

  attr_reader :title, :description

  SCHEMA_SKELETON_JSON = JSON.parse <<SCHEMA
{
    "$schema": "http://json-schema.org/draft-04/schema#",
    "title": "Resources",
    "description": "CloudFormation template resource"
}
SCHEMA

  def initialize(spec)
    @title = "Resources"
    @description = "CloudFormation template resource"
    @resource_specification = spec.dup
    parse_resource_spec
  end

  def self.from_resource_specification(spec)
    CloudFormationJSONSchema.new(spec)
  end

  def parse_resource_spec
    resource_types_spec = @resource_specification["ResourceTypes"]
    @resource_types = resource_types_spec.keys.collect do |resource_type|
      ResourceType.from_resource_specification(resource_type, resource_types_spec[resource_type])
    end

    property_types_spec = @resource_specification["PropertyTypes"]
    @property_types = property_types_spec.keys.collect do |property_type|
      PropertyType.from_resource_specification(property_type, property_types_spec[property_type])
    end
  end

  def to_json
    schema = SCHEMA_SKELETON_JSON.dup
    schema["oneOf"] = get_resource_listings
    schema["definitions"] = {}
    schema["definitions"]["resource_types"] = get_resource_definitions
    schema["definitions"]["property_types"] = get_property_definitions
    schema.to_json
  end

  def get_resource_listings
    @resource_specification["ResourceTypes"].keys.collect do |resource_type|
      {"$ref" => "#/definitions/resource_types/#{resource_type}"}
    end
  end

  def get_property_definitions
    (Hash[@property_types.collect { |property_type| [property_type.type, property_type.to_json] }])
  end

  def get_resource_definitions
    (Hash[@resource_types.collect { |resource_type| [resource_type.type, resource_type.to_json] }])
  end

end


class ResourceType
  attr_reader :type, :attributes, :properties

  def initialize(type, attributes, properties)
    @type = type
    @attributes = attributes
    @properties = properties
  end

  def self.from_resource_specification(type, spec)
    properties_spec = spec["Properties"]
    properties = properties_spec.keys.collect do |key|
      SimpleProperty.from_resource_specification(key, properties_spec[key])
    end

    ResourceType.new(type, spec["Attributes"], properties)
  end

  def properties_to_json
    (Hash[properties.collect { |property| [property.name, property.to_json] }]).to_json
  end

  def required_properties
    ((properties.select(&:required?)).collect(&:name)).to_json
  end

  def to_json
    JSON.parse <<JSON_STRING
    {
      "type": "object",
      "properties": {
          "Properties": {
            "properties": #{properties_to_json},
            "required": #{required_properties}
          }
      }
    }
JSON_STRING
  end

end

class PropertyType

  attr_reader :type, :title, :properties, :required, :additionalProperties

  def initialize(type, properties, additionalProperties = false)
    set_type_and_title(type)
    set_properties(properties)
    @additionalProperties = additionalProperties
  end

  def set_properties(properties)
    @properties = properties
    @required = @properties.select(&:required?).collect(&:name)
  end

  def set_type_and_title(type)
    @type = type
    @title = type
  end

  def self.from_resource_specification(type, spec)
    properties_spec = spec["Properties"]
    properties = properties_spec.keys.collect do |key|
      SimpleProperty.from_resource_specification(key, properties_spec[key])
    end
    PropertyType.new(type, properties)
  end

  def to_json
    JSON.parse <<JSON_STRING
    {
        "title": "#{title}",
        "type": "object",
        "properties": #{properties_to_json},
        "required": #{required_to_json},
        "additionalProperties": #{additionalProperties}
      }
JSON_STRING
  end

  def properties_to_json
    (Hash[properties.collect { |property| [property.name, property.to_json] }]).to_json
  end

  def required_to_json
    required.empty? ? "[]" : required.to_json
  end

  def get_property(name)
    properties.find { |x| x.name.eql?(name) }
  end

end


class ResourceProperties
  attr_reader :type, :additionalProperties, :properties, :required

  def initialize(properties, additionalProperties = false, required = [])
    @type = "object"
    @properties = properties
    @additionalProperties = additionalProperties
    @required = required
  end

  def self.from_resource_specification(spec)
    _properties = []
    spec.keys.each do |key|
      _properties << SimpleProperty.from_resource_specification(key, spec[key])
    end
    ResourceProperties.new(_properties)
  end

  def self.from_json_schema(json)
    ResourceProperties.new(json["properties"], json["additionalProperties"], json["required"] || [])
  end

  def properties_to_json
    properties.is_a?(Array) ? properties_ary_to_json(properties) : properties.to_json
  end

  def properties_ary_to_json(props)
    (Hash[props.collect { |property| [property.name, property.to_json] }]).to_json
  end

  def required_to_json
    required.empty? ? "[]" : "#{required}"
  end

  def to_json
    JSON.parse <<JSON_STRING
{
      "type": "object",
      "properties": #{properties_to_json},
      "additionalProperties": #{additionalProperties},
      "required": #{required_to_json}
}
JSON_STRING
  end

end


class SimpleProperty
  attr_reader :name, :primitive_type, :required

  def initialize(name, primitive_type, required = false)
    @name = name
    @primitive_type = primitive_type
    @required = required
  end

  def self.from_resource_specification(name, spec)
    SimpleProperty.new(name, spec["PrimitiveType"], spec["Required"])
  end

  def required?
    required
  end

  def primitive_type_schema_ref
    "basic_types.json#/definitions/#{primitive_type}".downcase
  end

  def to_json
    JSON.parse <<JSON_STRING
{
  "$ref": "#{primitive_type_schema_ref}"
}
JSON_STRING
  end

end
