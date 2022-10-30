import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

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
    final id = event.id;
    final value = event.value;
    final path = event.path;
    print(path.stringPath);
    final prevState = state.formData;
    final Map<String, dynamic> newState = {...prevState, id: value};
    emit(FormModified(newState));
    if (onChangeCallback != null) {
      onChangeCallback!(newState);
    }
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {}
}
