Current organisation of the schema
===

- ```schema.json```: "top-level" schema that references ```resource.json``` and ```basic_types.json```

Mapping from the resource specification to the JSON schema
===

Resources
====

- Any single resource ```Type``` occurs as an entry in ```ResourceTypes```
 
```json

{ "ResourceTypes:     
    { "AWS::ElasticBeanstalk::ConfigurationTemplate": {
      "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html",
      "Properties": {
        "ApplicationName": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-applicationname",
          "PrimitiveType": "String",
          "Required": true,
          "UpdateType": "Immutable"
        },
        "Description": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-description",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Mutable"
        },
        "EnvironmentId": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-environmentid",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Immutable"
        },
        "OptionSettings": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-optionsettings",
          "DuplicatesAllowed": true,
          "ItemType": "ConfigurationOptionSetting",
          "Required": false,
          "Type": "List",
          "UpdateType": "Mutable"
        },
        "PlatformArn": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-platformarn",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Immutable"
        },
        "SolutionStackName": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-solutionstackname",
          "PrimitiveType": "String",
          "Required": false,
          "UpdateType": "Immutable"
        },
        "SourceConfiguration": {
          "Documentation": "http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/aws-resource-elasticbeanstalk-configurationtemplate.html#cfn-elasticbeanstalk-configurationtemplate-sourceconfiguration",
          "Required": false,
          "Type": "SourceConfiguration",
          "UpdateType": "Immutable"
        }
      }
    }
  }
}
 
```

- This corresponds to an entry in ```resource.json``` in the ```oneOf``` list that references a ```definitions``` in ```resource_types``` 

```json

"oneOf": [
    { "$ref": "#/definitions/resource_types/AWS::ElasticBeanstalk::ConfigurationTemplate" }
]

```

- The entry is a reference to the same key in ```resource_types``` under ```definitions```

```json

{"definitions": {
    "resource_types: {
            "AWS::ElasticBeanstalk::ConfigurationTemplate": {
                "type": "object",
                "properties": {
                    "Properties": {
                        "type": "object",
                        "additionalProperties": false,
                        "properties": {
                            "ApplicationName": {
                                "$ref": "basic_types.json#/definitions/string"
                            },
                            "Description": {
                                "$ref": "basic_types.json#/definitions/string"
                            },
                            "EnvironmentId": {
                                "$ref": "basic_types.json#/definitions/string"
                            },
                            "OptionSettings": {
                                "oneOf": [
                                    {
                                        "type": "array",
                                        "items": {
                                            "$ref": "#/definitions/property_types/aws-properties-beanstalk-option-settings"
                                        }
                                    },
                                    {
                                        "$ref": "basic_types.json#/definitions/function"
                                    }
                                ]
                            },
                            "SolutionStackName": {
                                "$ref": "basic_types.json#/definitions/string"
                            },
                            "SourceConfiguration": {
                                "$ref": "#/definitions/property_types/aws-properties-beanstalk-configurationtemplate-sourceconfiguration"
                            }
                        },
                        "required": [
                            "ApplicationName"
                        ]
                    },
                    "Type": {
                        "type": "string",
                        "enum": [
                            "AWS::ElasticBeanstalk::ConfigurationTemplate"
                        ]
                    },
                    "DependsOn": {
                        "$ref": "#/definitions/attributes/DependsOn"
                    },
                    "Metadata": {
                        "type": "object"
                    },
                    "DeletionPolicy": {
                        "$ref": "#/definitions/attributes/DeletionPolicy"
                    },
                    "Condition": {
                        "type": "string"
                    }
                },
                "required": [
                    "Type",
                    "Properties"
                ],
                "additionalProperties": false
            }
       }
   }
}
            
```

