import 'package:flutter_json_schema_form/src/helpers/form_parser.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Refactor form', () {

    final schema = {
      "title": "Person",
      "type": "object",
      "properties": {
        "Do you have any pets?": {
          "type": "string",
          "enum": ["No", "Yes: One", "Yes: More than one"],
          "default": "No"
        },
      },
      "required": ["Do you have any pets?"],
      "dependencies": {
        "Do you have any pets?": {
          "oneOf": [
            {
              "properties": {
                "Do you have any pets?": {
                  "enum": ["No"]
                }
              }
            },
            {
              "properties": {
                "Do you have any pets?": {
                  "enum": ["Yes: One"]
                },
                "How old is your pet?": {"type": "number"}
              },
              "required": ["How old is your pet?"]
            },
            {
              "properties": {
                "Do you have any pets?": {
                  "enum": ["Yes: More than one"]
                },
                "Do you want to get rid of any?": {"type": "boolean"}
              },
              "required": ["Do you want to get rid of any?"]
            }
          ]
        }
      }
    };

    final responses = {
      "back_to_observer": "no",
      // "3a": "no"
    };

    final big = {
      "type": "object",
      "properties": {
        "back_to_observer": {
          "enum": ["yes", "no"],
          "title": "Should the form be sent back to the observer?",
          "type": "string",
          "enumNames": ["yes", "no"]
        }
      },
      "dependencies": {
        "back_to_observer": {
          "oneOf": [
            {
              "properties": {
                "back_to_observer": {
                  "enum": ["yes"]
                },
                "note": {"title": "Note to observer", "type": "string"}
              },
              "required": ["note"]
            },
            {
              "properties": {
                "back_to_observer": {
                  "enum": ["no"]
                },
                "3a": {
                  "enum": ["yes", "no", "not_applicable"],
                  "title":
                  "3a. Was the number of voters in the general voting lists announced and entered into a protocol?",
                  "type": "string",
                  "enumNames": ["yes", "no", "not applicable"]
                },
              },
              "dependencies": {
                "3a": {
                  "oneOf": [
                    {
                      "properties": {
                        "3a": {
                          "enum": ["no"]
                        },
                        "3a_why": {"title": "Please write an explanation why.", "type": "string"}
                      },
                      "required": []
                    },
                    {
                      "properties": {
                        "3a": {
                          "enum": ["yes", "not_applicable"]
                        }
                      },
                      "required": []
                    }
                  ]
                },
              }
            }
          ]
        }
      },
      "required": ["back_to_observer"],
      "title": "Opening Procedures Verification"
    };

    final parser = SchemaParser( schema: {}, formData: responses);

    final fields = parser.parse(id: '#', schema: big);

    void drawTree(List<Field> fields) {
      fields.forEach((element) {
        print("ID: ${element.id}");
        print("PATH: ${element.path.toString()}");
        print("DEPENDENCY PATH ${element.dependencyParentPath}");
        print("DEPENDENCY CONDITION ${element.dependencyConditions}");
        print('\n');
        if (element is Section) {
          drawTree(element.fields);
        }
      });
    }

    drawTree(fields);

    final parsedFields = parser.serialize(fields);

    print(parsedFields);
  });
}
