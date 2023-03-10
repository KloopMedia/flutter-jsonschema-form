import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../bloc/bloc.dart' as bloc;
import '../../models/models.dart';

class ReaderWidget extends StatefulWidget {
  final ReaderFieldModel model;
  final dynamic value;

  const ReaderWidget({Key? key, required this.value, required this.model})
      : super(key: key);

  @override
  State<ReaderWidget> createState() => _ReaderWidgetState();
}

class _ReaderWidgetState extends State<ReaderWidget> {
  late final id = widget.model.id;
  late final path = widget.model.path;
  late bloc.FormBloc _bloc;

  String _clickedWord = '';

  String get clickedWord => _clickedWord;

  String _translation = '';

  String get translation => _translation;

  final List<String> _words = [];

  List<String> get words => _words;

  List<List<Map<String, dynamic>>> _value = [];

  List<List<Map<String, dynamic>>> get value => _value;

  List<Map<String, dynamic>> _formData = [];

  List<Map<String, dynamic>> get formData => _formData;

  int _index = 0;

  int get index => _index;

  int _counter = 0;

  int get counter => _counter;

  final List<String> _clickedWords = [];

  List<String> get clickedWords => _clickedWords;

  final List<String> _translations = [];

  List<String> get translations => _translations;

  final List<TextSpan> _wordsAsTextSpan = [];

  List<TextSpan> get wordsAsTextSpan => _wordsAsTextSpan;

  @override
  void initState() {
    _bloc = context.read<bloc.FormBloc>();
    _value = widget.value;
    getText();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _bloc = context.read<bloc.FormBloc>();
    super.didChangeDependencies();
  }

  void onChange(value) {
    if (value is String) {
      var val = value.isNotEmpty ? value : null;
      _bloc.add(bloc.ChangeFormEvent(id, val, path));
    } else {
      _bloc.add(bloc.ChangeFormEvent(id, value, path));
    }
  }

  void getText() {
    _formData = value[counter];
    /// получаем в виде списка данные одного предложения

    /// получаем список всех слов текста (words)
    words.clear();
    for (var map in formData) {
      _words.add(map['word']);
    }

    /// все слова из списка words оборачиваем виджетом TextSpan
    wordsAsTextSpan.clear();
    for (int index = 0; index < words.length; index++) {
      _wordsAsTextSpan.add(TextSpan(text: words[index] + ' '));
    }
  }

  setOnTapChanges(String word) {
    _clickedWord = word;
    getTranslation();
    increaseCount();
    getClickedWordsWithTranslation();
  }

  void hideClickedWord() {
    setState(() => _clickedWord = '');
  }

  void getTranslation() {
    var wordWithoutSpace = clickedWord.substring(0, clickedWord.length - 1);

    /// убираем лишний пробел в конце слова
    _index = words.indexOf(wordWithoutSpace);

    /// находим под каким индексом находится нажатое слово в списке всех слов
    _translation = formData[index]['translation'];

    /// получаем перевод нажатого слова
  }

  void increaseCount() {
    Map<String, dynamic> clickedWordProperties;
    List<List<Map<String, dynamic>>> updatedValueToFormData = [];
    List<List<Map<String, dynamic>>> updatedValueFromFormData = [];
    List<Map<String, dynamic>> arrayOfTextProperties = [];

    /// из formData получаем данные текста с измененными значениями свойств
    updatedValueFromFormData = widget.value;
    updatedValueToFormData = List.from(updatedValueFromFormData);
    arrayOfTextProperties = List.from(updatedValueFromFormData[counter]);

    /// по индексу получаем свойства нажатого слова
    clickedWordProperties = {...arrayOfTextProperties[index]};

    /// при каждом нажатии на слово, свойство count этого слова увеличивается на один
    clickedWordProperties['count'] = clickedWordProperties['count'] + 1;

    /// если слово нажато один раз, то свойство active становится true
    if (clickedWordProperties['count'] == 1) {
      clickedWordProperties['active'] = true;
    }

    /// заменяем в схеме изменившиеся свойства
    arrayOfTextProperties.removeAt(index);
    arrayOfTextProperties.insert(index, clickedWordProperties);
    updatedValueToFormData.removeAt(counter);
    updatedValueToFormData.insert(counter, arrayOfTextProperties);
    onChange(updatedValueToFormData);
  }

  /// добавляем нажатые слова по очереди в список для отображения в UI
  void getClickedWordsWithTranslation() {
    if (!clickedWords.contains(clickedWord) &&
        !translations.contains(translation)) {
      _clickedWords.add(getModifiedWord(clickedWord));
      _translations.add(translation);
    }
  }

  /// убираем лишние знаки в начале и конце слова для отображения в UI
  String getModifiedWord(String word) {
    String modifiedWord;
    if (word.endsWith('" ') ||
        word.endsWith('? ') ||
        word.endsWith('! ') ||
        word.endsWith('- ')) {
      modifiedWord = word.substring(0, word.length - 2);
      return modifiedWord;
    } else if (word.startsWith('"')) {
      modifiedWord = word.substring(1, word.length);
      return modifiedWord;
    } else {
      modifiedWord = word.substring(0, word.length - 1);
      return modifiedWord;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 1.0),
                borderRadius: const BorderRadius.all(Radius.circular(20))),
            padding: const EdgeInsets.all(16.0),
            child: ExtractedTextSpan(
                wordsAsTextSpan: wordsAsTextSpan,
                clickedWord: clickedWord,
                onPressed: (word) => setOnTapChanges(word))),
        Container(
          padding: const EdgeInsets.all(16.0),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            (counter == 0)
                ? const SizedBox.shrink()
                : Container(
                    decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: IconButton(
                        icon: const Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _counter--;
                            getText();
                          });
                        })),
            (counter == value.length - 1)
                ? const SizedBox.shrink()
                : Container(
                    decoration: const BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                    child: IconButton(
                        icon: const Icon(
                          Icons.arrow_forward,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(() {
                            _counter++;
                          });
                          getText();
                        })),
          ]),
        ),
        (clickedWord.isEmpty)
            ? const SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(8.0),
                child: ListTile(
                  title: Text(
                    "${getModifiedWord(clickedWord)}: $translation",
                    style: const TextStyle(fontSize: 20.0),
                  ),
                  trailing: IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => hideClickedWord()),
                ),
              ),
        const SizedBox(height: 8.0),
        (clickedWords.isEmpty)
            ? const SizedBox.shrink()
            : Container(
                decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey, width: 1.0),
                    borderRadius: const BorderRadius.all(Radius.circular(20))),
                padding: const EdgeInsets.all(8.0),
                child: ListView.builder(
                    shrinkWrap: true,
                    padding: const EdgeInsets.all(8),
                    itemCount: clickedWords.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Text(
                          "${clickedWords[index]}: ${translations[index]}",
                          style: const TextStyle(fontSize: 20));
                    }),
              )
      ],
    );
  }
}

class ExtractedTextSpan extends StatelessWidget {
  const ExtractedTextSpan(
      {Key? key,
      required this.wordsAsTextSpan,
      required this.clickedWord,
      required this.onPressed})
      : super(key: key);

  final List<TextSpan> wordsAsTextSpan;
  final String? clickedWord;
  final Function(String) onPressed;

  @override
  Widget build(BuildContext context) {
    return RichText(
        text: TextSpan(
            children: wordsAsTextSpan
                .map((word) => TextSpan(
                    text: word.text,
                    style: TextStyle(
                      fontSize: 20.0,
                      color: (clickedWord == word.text)
                          ? Colors.greenAccent
                          : Colors.black,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        onPressed(word.text!);
                      }))
                .toList()));
  }
}
