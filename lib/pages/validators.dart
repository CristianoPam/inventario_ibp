import 'package:flutter/material.dart';

class Validators {
  Validators._();

  static FormFieldValidator compare(
      TextEditingController? valuePass, String message) {
    return (value) {
      final valueCompare = valuePass?.text ?? '';
      if (value == null || (value != null && value != valueCompare)) {
        return message;
      }
      return null;
    };
  }

}
