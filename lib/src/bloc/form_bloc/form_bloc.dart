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
  final WebhookTriggerCallback? onWebhookTriggerCallback;
  final DownloadFileCallback? onDownloadFileCallback;
  final Reference? storage;
  final bool disabled;
  final GlobalKey<FormBuilderState> formKey;
  final ValidationWarningCallback? onValidationCallback;
  final List<Field> fields;
  final Map<String, dynamic>? correctFormData;
  final bool showCorrectFields;
  final bool alternativeTheme;
  final bool showAlternativeCorrectFields;

  FormBloc({
    Map<String, dynamic>? formData,
    required this.formKey,
    required this.fields,
    this.storage,
    this.disabled = false,
    this.onChangeCallback,
    this.onSubmitCallback,
    this.onValidationCallback,
    this.onWebhookTriggerCallback,
    this.onDownloadFileCallback,
    this.correctFormData,
    this.showCorrectFields = false,
    this.alternativeTheme = false,
    this.showAlternativeCorrectFields = false,
  }) : super(FormInitial(formData ?? {}, disabled: disabled)) {
    on<ChangeFormEvent>(_onChangeFormEvent);
    on<SubmitFormEvent>(_onSubmitFormEvent);
    on<DownloadFileEvent>(_onDownloadFileEvent);
  }

  Future<void> _onDownloadFileEvent(DownloadFileEvent event, Emitter<FormState> emit) async {
    final url = await event.file.getDownloadURL();
    final name = event.file.name;
    final metaData = await event.file.getMetadata();
    final bytes = metaData.size;
    if (onDownloadFileCallback != null) {
      onDownloadFileCallback!(url, name, bytes);
    }
  }

  void _onChangeFormEvent(ChangeFormEvent event, Emitter<FormState> emit) {
    if (state is FormSubmitted || disabled) {
      return;
    }

    final value = event.value;
    final path = event.path;
    final delete = event.delete || value == null;
    final isDependency = event.isDependency;

    Map<String, dynamic> formData;
    formData = Map<String, dynamic>.from(
      updateDeeply(path.path, state.formData, (prevValue) => value, delete),
    );

    // for (final field in fields) {
    //   if (!field.shouldRenderDependency(formData)) {
    //     if (field is ValueField) {
    //       formData = Map<String, dynamic>.from(
    //         updateDeeply(field.path.path, formData, (prevValue) => null, true),
    //       );
    //     }
    //
    //     formKey.currentState?.removeInternalFieldValue(field.id);
    //   }
    // }

    if (isDependency) {
      emit(const FormModified({}));
    }

    emit(FormModified(formData));
    if (onChangeCallback != null) {
      onChangeCallback!(formData, path.toString());
    }
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {
    if (disabled) {
      return;
    }

    if (formKey.currentState!.validate()) {
      if (onSubmitCallback != null) {
        Map<String, dynamic> formData = {...state.formData};

        for (final field in fields) {
          if (!field.shouldRenderDependency(formData)) {
            if (field is ValueField) {
              formData = Map<String, dynamic>.from(
                updateDeeply(field.path.path, formData, (prevValue) => null, true),
              );
            }

            formKey.currentState?.removeInternalFieldValue(field.id);
          }
        }

        onSubmitCallback!(formData);
      }
      emit(FormSubmitted(state.formData));
    } else {
      print('SUBMIT ERROR ${formKey.currentState?.value}');
      if (onValidationCallback != null) {
        onValidationCallback!(formKey.currentState?.value.toString());
      }
    }
  }
}
