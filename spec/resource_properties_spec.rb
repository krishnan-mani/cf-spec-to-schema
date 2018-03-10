require_relative '../lib/models'

require 'json'


RSpec.describe PropertyType do


  context "parsing resource specification" do

    # for PropertyType "AWS::SNS::Topic.Subscription"
    resource_specification_json = JSON.parse <<SPEC
{
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html",
      "Properties": {
        "Endpoint": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html#cfn-sns-topic-subscription-endpoint",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Immutable"
        },
        "Protocol": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html#cfn-sns-topic-subscription-protocol",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Immutable"
        }
      }
    }
SPEC

    schema_json = JSON.parse <<SCHEMA
{
        "title": "Amazon SNS Subscription Property Type",
        "descriptionURL": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-sns-subscription.html",
        "type": "object",
        "properties": {
          "Endpoint": {
            "$ref": "basic_types.json#/definitions/string"
          },
          "Protocol": {
            "$ref": "basic_types.json#/definitions/string"
          }
        },
        "required": [
          "Endpoint",
          "Protocol"
        ],
        "additionalProperties": false
      }
SCHEMA

    property_type = PropertyType.from_resource_specification("AWS::SNS::Topic.Subscription", resource_specification_json)

    it '.from_resource_specification' do
      expect(property_type.title).to eql 'AWS::SNS::Topic.Subscription'
    end

    it '#to_json' do
      out = property_type.to_json
      expect(out["properties"].keys).to include 'Endpoint'
      expect(out["required"]).to match_array %w[ Endpoint Protocol ]
    end

  end

  context "output schema" do

    it 'classifies properties that are primitives' do
      resource_specification_json = JSON.parse <<SPEC
    {
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html",
      "Properties": {
        "Namespace": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-namespace",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        },
        "OptionName": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-optionname",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        },
        "Value": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-value",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        }
      }
    }
SPEC
      property_type = PropertyType.from_resource_specification('AWS::ElasticBeanstalk::ConfigurationTemplate.ConfigurationOptionSetting', resource_specification_json)
      expect(property_type.get_property("Namespace").primitive_type).to eql 'String'
      expect(property_type.get_property("OptionName").primitive_type).to eql 'String'
    end

    it 'outputs primitive types with a reference to the primitive type definition' do
      resource_specification_json = JSON.parse <<SPEC
    {
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html",
      "Properties": {
        "Namespace": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-namespace",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        },
        "OptionName": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-optionname",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        },
        "Value": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-properties-beanstalk-option-settings.html#cfn-beanstalk-optionsettings-value",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Mutable"
        }
      }
    }
SPEC
      property_type = PropertyType.from_resource_specification('AWS::ElasticBeanstalk::ConfigurationTemplate.ConfigurationOptionSetting', resource_specification_json)
      out = property_type.to_json
      expect(out["properties"]["Namespace"]["$ref"]).to eql "basic_types.json#/definitions/string"
    end

  end

end


RSpec.describe ResourceType do

  context 'parsing resource specification' do

    # for Type "AWS::EC2::Subnet"
    resource_specification_json = JSON.parse <<SPEC
      {
      "Attributes": {
        "AvailabilityZone": {
          "PrimitiveType": "String"
        }
      },
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html",
      "Properties": {
        "AvailabilityZone": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html#cfn-ec2-subnet-availabilityzone",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Immutable"
        },
        "CidrBlock": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html#cfn-ec2-subnet-cidrblock",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Immutable"
        },
        "MapPublicIpOnLaunch": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html#cfn-ec2-subnet-mappubliciponlaunch",
          "PrimitiveType": "Boolean",
          "Required": false,
          "UpdateType": "Mutable"
        },
        "Tags": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html#cfn-ec2-subnet-tags",
          "DuplicatesAllowed": true,
          "ItemType": "Tag",
          "Required": false,
          "Type": "List",
          "UpdateType": "Mutable"
        },
        "VpcId": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-ec2-subnet.html#cfn-awsec2subnet-prop-vpcid",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Immutable"
        }
      }
    }
SPEC
    resource_type = ResourceType.from_resource_specification("AWS::EC2::Subnet", resource_specification_json)

    it '.from_resource_specification' do
      out = resource_type.to_json
      expect(out["properties"]["Properties"]["properties"].keys).to match_array %w[ AvailabilityZone CidrBlock MapPublicIpOnLaunch Tags VpcId ]
    end

    it 'prints required properties' do
      out = resource_type.to_json
      expect(out["properties"]["Properties"]["required"]).to match_array %w[ CidrBlock VpcId ]
    end

  end

end

RSpec.describe ResourceProperties do

  context 'parsing JSON' do

    # for Type "AWS::ApiGateway::Account"

    it '.from_json_schema' do
      JSON_SCHEMA = JSON.parse <<SCHEMA
{
  "type": "object",
  "additionalProperties": false,
  "properties": {
                      "CloudWatchRoleArn": {
                          "$ref": "basic_types.json#/definitions/string"
                      }
                  }
}
SCHEMA

      resource_properties = ResourceProperties.from_json_schema(JSON_SCHEMA)
      out = resource_properties.to_json
      expect(out["additionalProperties"]).to be_falsey
      expect(out["required"]).to match_array []
      expect(out["properties"].keys[0]).to eql "CloudWatchRoleArn"
    end

    it '.from_resource_specification' do
      resource_specification_json = JSON.parse <<SPEC
{
        "CloudWatchRoleArn": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-apigateway-account.html#cfn-apigateway-account-cloudwatchrolearn",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Mutable"
        }
      }
SPEC

      resource_properties = ResourceProperties.from_resource_specification(resource_specification_json)
      out = resource_properties.to_json
      expect(out["properties"].keys[0]).to eql "CloudWatchRoleArn"
    end

  end

end