

import 'package:flutter/material.dart';

Future<DateTime?> pickDate(BuildContext context, ThemeMode theme,
    {required DateTime firstDate, required DateTime lastDate}) async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: firstDate,
    lastDate: lastDate,
    builder: (BuildContext context, Widget? child) {
      bool isDark = theme == ThemeMode.dark;
      return Theme(
        data: ThemeData.dark().copyWith(
          primaryColor: isDark ? Colors.white : Colors.black,
          // accentColor: Colors.white,
          colorScheme: ColorScheme.dark(
            primary: isDark ? Colors.white : Colors.black,
            onPrimary: isDark ? Colors.black : Colors.white,
            surface: isDark ? Colors.black : Colors.white,
            onSurface: isDark ? Colors.white : Colors.black,
          ),
          textTheme: TextTheme(
            bodyLarge: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
          dialogTheme: DialogThemeData(backgroundColor: isDark ? Colors.black : Colors.white),
          buttonTheme: const ButtonThemeData(textTheme: ButtonTextTheme.primary),
        ),
        child: Builder(
          builder: (BuildContext context) {
            return child == null ? Container() : Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                child,
                // Hide the "OK" button and the "CANCEL" button
                Container(
                  height: 0,
                ),
              ],
            );
          },
        ),
      );
    },
  );
  return picked;
}

Future<DateTimeRange?> pickDateRange(BuildContext context, ThemeMode theme,
    {required DateTime firstDate, required DateTime lastDate}) async {
  final bool isDark = theme == ThemeMode.dark;

  final DateTimeRange? picked = await showDateRangePicker(
    context: context,
    firstDate: firstDate,
    lastDate: lastDate,
    // initialDateRange: DateTimeRange(
    //   start: DateTime.now(),
    //   end: DateTime.now().add(const Duration(days: 7)),
    // ),
    builder: (BuildContext context, Widget? child) {
      return Theme(
        data: ThemeData(
          brightness: isDark ? Brightness.dark : Brightness.light,
          colorScheme: ColorScheme(
            brightness: isDark ? Brightness.dark : Brightness.light,
            primary: isDark ? Colors.white : Colors.black,
            onPrimary: isDark ? Colors.black : Colors.white,
            secondary: Colors.grey,
            onSecondary: isDark ? Colors.black : Colors.white,
            error: Colors.red,
            onError: Colors.white,
            background: isDark ? Colors.black : Colors.white,
            onBackground: isDark ? Colors.white : Colors.black,
            surface: isDark ? Colors.grey[900]! : Colors.white,
            onSurface: isDark ? Colors.white : Colors.black,
          ),
        ),
        child: child ?? const SizedBox(),
      );
    },
  );

  return picked;
}