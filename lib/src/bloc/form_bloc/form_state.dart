part of 'form_bloc.dart';

abstract class FormState extends Equatable {
  final Map<String, dynamic> formData;
  final bool disabled;
  final bool readOnly;
  final List<String>? addFileText;

  const FormState(this.formData, {this.disabled = false, this.readOnly = false, this.addFileText});

  @override
  List<Object> get props => [formData, disabled, readOnly];
}

class FormInitial extends FormState {
  const FormInitial(super.formData, {super.disabled, super.addFileText});
}

class FormModified extends FormState {
  const FormModified(super.formData);
}

class FormSubmitted extends FormState {
  const FormSubmitted(super.formData, {super.disabled});
}

class FormDisabled extends FormState {
  const FormDisabled(super.formData);
}

class FormReadOnly extends FormState {
  const FormReadOnly(super.formData);
}
