part of 'form_bloc.dart';

abstract class FormEvent extends Equatable {
  const FormEvent();
}

class ChangeFormEvent extends FormEvent {
  final String id;
  final dynamic value;
  final PathModel path;
  final bool delete;

  const ChangeFormEvent(this.id, this.value, this.path, [this.delete = false]);

  @override
  List<Object?> get props => [id, value];
}

class SubmitFormEvent extends FormEvent {
  @override
  List<Object?> get props => [];
}

class DisableFormEvent extends FormEvent {
  @override
  List<Object?> get props => [];
}

class ReadOnlyFormEvent extends FormEvent {
  @override
  List<Object?> get props => [];
}
