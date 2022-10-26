import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'form_event.dart';
part 'form_state.dart';

class FormBloc extends Bloc<FormEvent, FormState> {
  FormBloc([Map<String, dynamic>? formData]) : super(FormInitial(formData ?? {})) {
    on<ChangeFormEvent>(_onChangeFormEvent);
    on<SubmitFormEvent>(_onSubmitFormEvent);
  }

  void _onChangeFormEvent(ChangeFormEvent event, Emitter<FormState> emit) {
    final id = event.id;
    final value = event.value;
    final prevState = state.formData;
    final Map<String, dynamic> newState = {...prevState, id: value};
    emit(FormModified(newState));
  }

  void _onSubmitFormEvent(SubmitFormEvent event, Emitter<FormState> emit) {}
}
