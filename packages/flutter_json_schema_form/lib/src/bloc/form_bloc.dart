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
    final delete = event.delete;
    print(path.stringPath);
    Map<String, dynamic> formData;
    if (delete || value == null) {
      formData = Map<String, dynamic>.from(
        updateDeeply(path.path, state.formData, (prevValue) => value, true),
      );
    } else {
      formData = Map<String, dynamic>.from(
        updateDeeply(path.path, state.formData, (prevValue) => value, false),
      );
    }
    emit(FormModified(formData));
    if (onChangeCallback != null) {
      onChangeCallback!(formData);
    }
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {}
}
