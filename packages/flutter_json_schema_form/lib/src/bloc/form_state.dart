part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  final Map<String, dynamic> formData;

  const FormState(this.formData);
}

class FormInitial extends FormState {
  const FormInitial(super.formData);

  @override
  List<Object> get props => [];
}

class FormModified extends FormState {
  const FormModified(super.formData);

  FormState copyWidth(Map<String, dynamic>? formData) {
    return FormModified(formData ?? this.formData);
  }

  @override
  List<Object> get props => [];
}

class FormSubmitted extends FormState {
  const FormSubmitted(super.formData);

  @override
  List<Object> get props => [];
}

class FormDisabled extends FormState {
  const FormDisabled(super.formData);

  @override
  List<Object> get props => [];
}

class FormReadOnly extends FormState {
  const FormReadOnly(super.formData);

  @override
  List<Object> get props => [];
}
