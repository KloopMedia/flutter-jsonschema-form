import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:flutter_json_schema_form/src/helpers/helpers.dart';

import '../../../flutter_json_schema_form.dart';
import '../../models/models.dart';

part 'form_event.dart';

part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  final ChangeFormCallback? onChangeCallback;
  final SubmitFormCallback? onSubmitCallback;
  final Reference? storage;
  final GlobalKey<FormBuilderState> formKey;

  FormBloc({
    Map<String, dynamic>? formData,
    required this.formKey,
    this.storage,
    this.onChangeCallback,
    this.onSubmitCallback,
  }) : super(FormInitial(formData ?? {})) {
    on<ChangeFormEvent>(_onChangeFormEvent);
    on<SubmitFormEvent>(_onSubmitFormEvent);
  }

  void _onChangeFormEvent(ChangeFormEvent event, Emitter<FormState> emit) {
    if (state is FormSubmitted) {
      return;
    }

    final value = event.value;
    final path = event.path;
    final delete = event.delete;

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
      onChangeCallback!(formData, path.toString());
    }
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {
    if (formKey.currentState!.validate()) {
      if (onSubmitCallback != null) {
        onSubmitCallback!(state.formData);
      }
      emit(FormSubmitted(state.formData, disabled: true));
    } else {
      print('SUBMIT ERROR ${formKey.currentState?.value}');
    }
  }
}
