import 'package:flutter_json_schema_form/src/helpers/helpers.dart';
import 'package:flutter_json_schema_form/src/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Testing getting data from formData by field path', () {
    final formData = {'firstName2': 'test', 'firstName': 'atai'};
    final path = PathModel([PathItem("firstName", FieldType.string)]);
    final value = getFormDataByPath(formData, path);
    expect(value, equals('atai'));
  });

  test('Testing getting data from nested object', () {
    final formData = {
      'firstName2': 'test',
      'firstName': 'atai',
      'test-section': {'test1': 'section'},
      'fixedItemsList': [null, 'array']
    };
    final path = PathModel(
        [PathItem('test-section', FieldType.object), PathItem('test1', FieldType.string)]);
    final value2 = getFormDataByPath(formData, path);
    expect(value2, equals('section'));
  });
}
