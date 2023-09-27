abstract class Schema {
  final Map<String, dynamic> formSchema;
  final Map<String, dynamic> uiSchema;
  final Map<String, dynamic>? formData;

  Schema({required this.formSchema, required this.uiSchema, this.formData});
}

class ImageSchema extends Schema {
  ImageSchema()
      : super(
          formSchema: {
            "title": "A registration form",
            "description": "A simple form example.",
            "type": "object",
            "required": [],
            "properties": {
              "firstName": {"type": "string", "title": "First name", "default": "Chuck"},
              "lastName": {"type": "string", "title": "Last name"},
              "image_widget_test": {"type": "integer", "title": "Test", "enum": ['1', '2', '3']}
            }
          },
          uiSchema: {
            "image_widget_test": {
              "ui:widget": "image",
              "ui:options": {
                "images": [
                  "https://picsum.photos/200",
                  "https://picsum.photos/200",
                  "https://picsum.photos/200"
                ]
              }
            }
          },
        );
}
