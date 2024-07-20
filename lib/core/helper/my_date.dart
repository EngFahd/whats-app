import 'package:flutter/material.dart';

class MyDate {
  static String getFormattedTime(
      {required String dateTime, required BuildContext context}) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(dateTime));
    return TimeOfDay.fromDateTime(date).format(context);
  }
}
