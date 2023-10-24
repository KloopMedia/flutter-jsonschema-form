import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

import 'bloc/form_bloc/form_bloc.dart' as bloc;
import 'helpers/form_parser.dart';
import 'helpers/helpers.dart';

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
    // serializedField = serializeFields(fields, widget.formData ?? {});
    super.initState();
  }

  @override
  void didChangeDependencies() {
    serializedField = serializeFields(fields, widget.formData ?? {});
    super.didChangeDependencies();
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
                      if (field is DynamicArray) {
                        return ElevatedButton(
                          onPressed: () {
                            final arrayPath = field.path.add(index.toString(), field.field.type);
                            final arrayField =
                                field.field.copyWith(id: index.toString(), path: arrayPath);
                            setState(() {
                              serializedField.insert(index, arrayField);
                            });
                          },
                          child: Text('+'),
                        );
                      }
                      return field.build();
                    },
                    childCount: serializedField.length,
                  ),
                ),
                SliverToBoxAdapter(
                  child: ElevatedButton(
                    onPressed: () {},
                    child: Text('Submit'),
                  ),
                )
              ],
            ),
          );
        },
      ),
      // child: Form(
      //   formKey: _formKey,
      //   fields: fields,
      //   disabled: widget.disabled,
      //   submitButtonText: widget.submitButtonText,
      //   pageStorageKey: widget.pageStorageKey,
      //   allowOpenPrevious: widget.allowOpenPrevious,
      //   onOpenPreviousTask: widget.onOpenPreviousTask,
      //   openPreviousButtonText: widget.openPreviousButtonText,
      // ),
    );
  }
}

class Form extends StatelessWidget {
  final GlobalKey<FormBuilderState> formKey;
  final PageStorageKey? pageStorageKey;
  final List fields;
  final bool disabled;
  final Text? submitButtonText;
  final VoidCallback? onOpenPreviousTask;
  final Text? openPreviousButtonText;
  final bool allowOpenPrevious;

  const Form({
    Key? key,
    required this.formKey,
    required this.fields,
    required this.disabled,
    this.submitButtonText,
    this.pageStorageKey,
    this.onOpenPreviousTask,
    this.openPreviousButtonText,
    required this.allowOpenPrevious,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      key: pageStorageKey,
      child: Column(
        children: [
          FormBuilder(
            key: formKey,
            clearValueOnUnregister: true,
            child: FormConstructor(fields: fields),
          ),
          Row(
            children: [
              if (allowOpenPrevious)
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
                      onPressed: onOpenPreviousTask,
                      child: openPreviousButtonText ?? const Text('Go back'),
                    ),
                  ),
                ),
              if (allowOpenPrevious && !disabled) const SizedBox(width: 10),
              if (!disabled)
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
                      child: submitButtonText ?? const Text('Submit'),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
