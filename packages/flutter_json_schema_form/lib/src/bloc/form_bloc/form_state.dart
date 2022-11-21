part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  final Map<String, dynamic> formData;

  const FormState(this.formData);

  @override
  List<Object> get props => [formData];
}

class FormInitial extends FormState {
  const FormInitial(super.formData);
}

class FormModified extends FormState {
  const FormModified(super.formData);
}

class FormSubmitted extends FormState {
  const FormSubmitted(super.formData);
}

class FormDisabled extends FormState {
  const FormDisabled(super.formData);
}

class FormReadOnly extends FormState {
  const FormReadOnly(super.formData);
}
