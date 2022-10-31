import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

import '../../flutter_json_schema_form.dart';
import '../models/models.dart';

part 'form_event.dart';

part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ChangeFormCallback? onChangeCallback;

  FormBloc({
    Map<String, dynamic>? formData,
    this.onChangeCallback,
  }) : super(FormInitial(formData ?? {})) {
    on<ChangeFormEvent>(_onChangeFormEvent);
    on<SubmitFormEvent>(_onSubmitFormEvent);
  }

  void _onChangeFormEvent(ChangeFormEvent event, Emitter<FormState> emit) {
    final value = event.value;
    final path = event.path;
    print(path.stringPath);
    final formData = _updateFormDataByPath(state.formData, value, path);
    emit(FormModified(formData));
    if (onChangeCallback != null) {
      onChangeCallback!(formData);
    }
  }

  Map<String, dynamic> _updateFormDataByPath(
    Map<String, dynamic> formData,
    dynamic value,
    Path path,
  ) {
    Map<String, dynamic> data = {...formData};
    final pathItems = path.path;
    dynamic dataPointer = data;
    for (final field in pathItems) {
      if (field.fieldType == FieldType.object || field.fieldType == FieldType.array) {
        final emptyValue = field.fieldType == FieldType.object ? {} : [];
        if (dataPointer is Map) {
          dataPointer.putIfAbsent(field.id, () => emptyValue);
        }
        if (dataPointer is List) {
          dataPointer.add(emptyValue);
        }
      } else {
        if (dataPointer is Map) {
          dataPointer.update(field.id, (prevValue) => value, ifAbsent: () => value);
        }
        if (dataPointer is List) {
          final index = int.parse(field.id);
          try {
            dataPointer[index] = value;
          } on RangeError {
            for (var i = dataPointer.length; i < index; i++) {
              dataPointer.add(null);
            }
            dataPointer.add(value);
          }
        }
      }
      if (dataPointer is Map) {
        dataPointer = dataPointer[field.id];
      }
    }
    return data;
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {}
}
