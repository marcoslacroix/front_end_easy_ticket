
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

String formatDate(String dateStr) {
  DateTime date = DateTime.parse(dateStr);
  return DateFormat('dd/MM/yyyy').format(date);
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    // Remove any non-digit characters from the input
    final String cleanedText = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    final StringBuffer formattedDate = StringBuffer();

    // Handle day (1st and 2nd characters)
    if (cleanedText.length >= 1) {
      formattedDate.write(cleanedText[0]);
      if (cleanedText.length > 1) {
        final int day = int.parse(cleanedText.substring(0, 2));
        if (day > 31) {
          return oldValue;
        }
        formattedDate.write(cleanedText[1]);
        // Add separator (/) after day if there are more characters
        if (cleanedText.length > 2) {
          formattedDate.write('/');
        }
      }
    }

    // Handle month (3rd and 4th characters)
    if (cleanedText.length >= 3) {
      formattedDate.write(cleanedText[2]);
      if (cleanedText.length > 3) {
        final int month = int.parse(cleanedText.substring(2, 4));
        if (month > 12) {
          return oldValue;
        }
        formattedDate.write(cleanedText[3]);
        // Add separator (/) after month if there are more characters
        if (cleanedText.length > 4) {
          formattedDate.write('/');
        }
      }
    }

    // Handle year (5th to 8th characters)
    if (cleanedText.length > 4) {
      formattedDate.write(cleanedText.substring(4, min(8, cleanedText.length)));
    }

    return TextEditingValue(
      text: formattedDate.toString(),
      selection: TextSelection.collapsed(offset: formattedDate.length),
    );
  }
}
