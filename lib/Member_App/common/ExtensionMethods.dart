import 'package:flutter/material.dart';

extension ExtendedText on Widget {
  alignAtStart() {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: this,
    );
  }

  alignAtEnd() {
    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: this,
    );
  }
}

extension StringParsing on String {
  String checkForNull() {
    if (this != "null" && this != null) {
      return this;
    } else
      return "";
  }
}
