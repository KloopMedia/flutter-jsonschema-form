import 'package:flutter/material.dart';
import 'package:url_launcher/link.dart';

final defaultFieldDecoration = InputDecoration(
  isDense: true,
  filled: true,
  fillColor: Colors.white,
  border: OutlineInputBorder(
    borderSide: const BorderSide(width: 1, color: Color(0xFFA9ACAC)),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.blueAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Color(0xFF8E9192)),
    borderRadius: BorderRadius.circular(15),
  ),
  disabledBorder: OutlineInputBorder(
    borderSide: const BorderSide(width: 1.0, color: Color(0xFFA9ACAC)),
    borderRadius: BorderRadius.circular(15),
  ),
  errorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
  focusedErrorBorder: OutlineInputBorder(
    borderSide: const BorderSide(
      color: Colors.redAccent,
      width: 1.0,
    ),
    borderRadius: BorderRadius.circular(15),
  ),
);

const _correctColorBorder = Color.fromRGBO(116, 191, 59, 1);
final _correctOutlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(width: 1, color: _correctColorBorder),
  borderRadius: BorderRadius.circular(15),
);

final correctFormDataDecoration = defaultFieldDecoration.copyWith(
  border: _correctOutlineInputBorder,
  enabledBorder: _correctOutlineInputBorder,
  focusedBorder: _correctOutlineInputBorder,
  disabledBorder: _correctOutlineInputBorder,
);

const _errorColorBorder = Color.fromRGBO(255, 137, 125, 1);
final _errorOutlineInputBorder = OutlineInputBorder(
  borderSide: const BorderSide(width: 1, color: _errorColorBorder),
  borderRadius: BorderRadius.circular(15),
);

final wrongFormDataDecoration = defaultFieldDecoration.copyWith(
  border: _errorOutlineInputBorder,
  enabledBorder: _errorOutlineInputBorder,
  focusedBorder: _errorOutlineInputBorder,
  disabledBorder: _errorOutlineInputBorder,
);

const _correctContainerColor = Color.fromRGBO(116, 191, 59, 0.15);
const correctContainerDecoration = BoxDecoration(
  color: _correctContainerColor,
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

const _errorContainerColor = Color.fromRGBO(255, 137, 125, 0.15);
const wrongContainerDecoration = BoxDecoration(
  color: _errorContainerColor,
  borderRadius: BorderRadius.all(Radius.circular(15)),
);

InputDecoration showCorrectFieldDecoration(bool? isCorrect) {
  if (isCorrect == null) {
    return defaultFieldDecoration;
  }

  if (isCorrect) {
    return correctFormDataDecoration;
  } else {
    return wrongFormDataDecoration;
  }
}

BoxDecoration? showCorrectContainerDecoration(bool? isCorrect) {
  if (isCorrect == null) {
    return null;
  }

  if (isCorrect) {
    return correctContainerDecoration;
  } else {
    return wrongContainerDecoration;
  }
}

final urlRegExp = RegExp(
  r"(http(s)?:\/\/)?(www.)?[a-zA-Z0-9]{2,256}\.[a-zA-Z0-9]{2,256}(\.[a-zA-Z0-9]{2,256})?([-a-zA-Z0-9@:%_\+~#?&//=.]*)([-a-zA-Z0-9@:%_\+~#?&//=]+)",
  caseSensitive: false,
  dotAll: true,
);

List<String> getUrls(String? value) {
  if (value != null && value.isNotEmpty) {
    try {
      final regExp = urlRegExp;
      final matches = regExp.allMatches(value);
      return matches.map((match) => value.substring(match.start, match.end)).toSet().toList();
    } on Exception {
      return [];
    }
  }
  return [];
}

Uri formatUri(String url) {
  String formattedLink = url;

  if (!url.substring(0, 5).contains('http')) {
    formattedLink = 'http://$url';
  }

  return Uri.parse(formattedLink);
}

Widget getLinks(String? value) {
  final urls = getUrls(value);

  if (urls.isNotEmpty) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: urls
            .map(
              (link) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Link(
                  uri: formatUri(link),
                  builder: (BuildContext context, FollowLink? followLink) => InkWell(
                    onTap: followLink,
                    child: Text(
                      link,
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  return SizedBox.shrink();
}
