import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
import 'helpers/helpers.dart';
import 'models/models.dart';

typedef ChangeFormCallback = Function(Map<String, dynamic> formData, String path);
typedef SubmitFormCallback = Function(Map<String, dynamic> formData);
typedef ValidationWarningCallback = void Function(String? error);
typedef WebhookTriggerCallback = void Function();
typedef DownloadFileCallback = Future<String?> Function(String url, String? filename, int? bytes);

class FlutterJsonSchemaForm extends StatefulWidget {
  final Map<String, dynamic> schema;
  final Map<String, dynamic>? uiSchema;
  final Map<String, dynamic>? formData;
  final ChangeFormCallback? onChange;
  final SubmitFormCallback? onSubmit;
  final ValidationWarningCallback? onValidationFailed;
  final WebhookTriggerCallback? onWebhookTrigger;
  final DownloadFileCallback? onDownloadFile;
  final VoidCallback? onOpenPreviousTask;
  final Reference? storage;
  final bool disabled;
  final bool allowOpenPrevious;
  final Text? submitButtonText;
  final List<String>? addFileText;
  final Text? openPreviousButtonText;
  final PageStorageKey? pageStorageKey;

  const FlutterJsonSchemaForm({
    Key? key,
    required this.schema,
    this.uiSchema,
    this.formData,
    this.onChange,
    this.onSubmit,
    this.onValidationFailed,
    this.onWebhookTrigger,
    this.storage,
    this.disabled = false,
    this.submitButtonText,
    this.addFileText,
    this.pageStorageKey,
    this.onDownloadFile,
    this.onOpenPreviousTask,
    this.openPreviousButtonText,
    this.allowOpenPrevious = false,
  }) : super(key: key);

  @override
  State<FlutterJsonSchemaForm> createState() => _FlutterJsonSchemaFormState();
}

class _FlutterJsonSchemaFormState extends State<FlutterJsonSchemaForm> {
  final _formKey = GlobalKey<FormBuilderState>();
  late final List<Field> fields;
  late final List<Field> serializedField;

  @override
  void initState() {
    fields = parseSchema(schema: widget.schema, uiSchema: widget.uiSchema);
    serializedField = serializeFields(fields, widget.formData ?? {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => bloc.FormBloc(
        formKey: _formKey,
        formData: widget.formData,
        storage: widget.storage,
        disabled: widget.disabled,
        onChangeCallback: widget.onChange,
        onSubmitCallback: widget.onSubmit,
        onValidationCallback: widget.onValidationFailed,
        onWebhookTriggerCallback: widget.onWebhookTrigger,
        onDownloadFileCallback: widget.onDownloadFile,
        addFileText: widget.addFileText,
      ),
      child: BlocBuilder<bloc.FormBloc, bloc.FormState>(
        builder: (context, state) {
          return FormBuilder(
            key: _formKey,
            child: CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final field = serializedField[index];
                      return field.build();
                    },
                    childCount: serializedField.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: Row(
                    children: [
                      if (widget.allowOpenPrevious)
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(
                                  width: 1,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ),
                              onPressed: widget.onOpenPreviousTask,
                              child: widget.openPreviousButtonText ?? const Text('Go back'),
                            ),
                          ),
                        ),
                      if (widget.allowOpenPrevious && !widget.disabled) const SizedBox(width: 10),
                      if (!widget.disabled)
                        Expanded(
                          child: SizedBox(
                            height: 52,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                backgroundColor: Theme.of(context).colorScheme.primary,
                              ),
                              onPressed: () {
                                context.read<bloc.FormBloc>().add(bloc.SubmitFormEvent());
                              },
                              child: widget.submitButtonText ?? const Text('Submit'),
                            ),
                          ),
                        ),
                    ],
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
