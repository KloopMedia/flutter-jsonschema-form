import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';

class ImageField<T> extends StatelessWidget {
  final String name;
  final InputDecoration decoration;
  final String? Function(dynamic value)? validator;
  final dynamic initialValue;
  final List<String> images;
  final String? text;
  final List<FormBuilderFieldOption<T>>? options;
  final ValueChanged<T?> onChanged;
  final bool enabled;

  const ImageField({
    Key? key,
    required this.name,
    required this.decoration,
    required this.initialValue,
    this.validator,
    required this.images,
    this.text,
    this.options,
    required this.onChanged,
    this.enabled = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FormBuilderField(
      name: name,
      validator: validator,
      initialValue: initialValue,
      builder: (field) {
        return InputDecorator(
          decoration: decoration.copyWith(errorText: field.errorText),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ImageRow(images: images),
              if (text != null && text!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: Text(
                    key: const Key('image_text'),
                    text!,
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              if (options != null && options!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 15.0),
                  child: ButtonRow<T>(options: options!, onChanged: onChanged),
                ),
            ],
          ),
        );
      },
    );
  }
}

class ImageDetailScreen extends StatelessWidget {
  final String tag;
  final String url;

  const ImageDetailScreen({super.key, required this.tag, required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.primary,
        ),
      ),
      body: Center(
        child: Hero(
          tag: tag,
          child: CachedNetworkImage(
            imageUrl: url,
            fit: BoxFit.contain,
            placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
            errorWidget: (context, url, error) => const Icon(Icons.error),
          ),
        ),
      ),
    );
  }
}

class ImageRow extends StatelessWidget {
  final List<String> images;

  const ImageRow({super.key, required this.images});

  List<Widget> renderImageList() {
    final widgetList = <Widget>[];
    for (int i = 0; i < images.length; i++) {
      const double spacing = 8;
      widgetList.add(
        DecoratedImage(
          images[i],
          tag: 'image_widget_tag_$i',
          margin: EdgeInsets.only(
            left: i == 0 ? 0 : spacing,
            right: i == images.length - 1 ? 0 : spacing,
          ),
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: renderImageList());
  }
}

class ButtonRow<T> extends StatefulWidget {
  final dynamic value;
  final List<FormBuilderFieldOption<T>> options;
  final ValueChanged<T?> onChanged;

  const ButtonRow({super.key, required this.options, this.value, required this.onChanged});

  @override
  State<ButtonRow<T>> createState() => _ButtonRowState<T>();
}

class _ButtonRowState<T> extends State<ButtonRow<T>> {
  late dynamic _value = widget.value;

  List<Widget> renderButtonList() {
    final widgetList = <Widget>[];
    for (int i = 0; i < widget.options.length; i++) {
      final item = widget.options[i];
      const double spacing = 5;

      widgetList.add(DecoratedChip(
        label: item.child ?? Text(item.value.toString()),
        selected: _value == item.value,
        onTap: () {
          widget.onChanged(item.value);
          setState(() {
            _value = item.value;
          });
        },
        margin: EdgeInsets.only(
          left: i == 0 ? 0 : spacing,
          right: i == widget.options.length - 1 ? 0 : spacing,
        ),
      ));
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Row(children: renderButtonList());
  }
}

class DecoratedChip extends StatelessWidget {
  final bool selected;
  final void Function() onTap;
  final Widget label;
  final EdgeInsetsGeometry? margin;

  const DecoratedChip({
    super.key,
    required this.selected,
    required this.onTap,
    required this.label,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    final decoratedLabel = label is Text
        ? Text(
            (label as Text).data ?? "",
            style: TextStyle(
              color: selected ? Colors.white : const Color(0xFF5C5F5F),
              fontSize: 16,
            ),
          )
        : null;

    return Container(
      height: 39,
      constraints: const BoxConstraints(minWidth: 67),
      margin: margin,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          decoration: ShapeDecoration(
            color: selected ? const Color(0xFF94A4FB) : const Color(0xFFEFF1F1),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Center(child: decoratedLabel ?? label),
        ),
      ),
    );
  }
}

class DecoratedImage extends StatelessWidget {
  final String url;
  final String tag;
  final EdgeInsetsGeometry? margin;

  const DecoratedImage(this.url, {super.key, this.margin, required this.tag});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 72,
      height: 72,
      margin: margin,
      child: Hero(
        tag: tag,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) {
                return ImageDetailScreen(tag: tag, url: url);
              }));
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: CachedNetworkImage(
                imageUrl: url,
                fit: BoxFit.fill,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
