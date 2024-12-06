import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Style yang adaptif dengan tema
TextStyle styleKu1(BuildContext context) {
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Warna teks untuk mode gelap
        : const Color.fromARGB(255, 10, 52, 87),
  );
}

TextStyle styleKu2(BuildContext context) {
  return TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Warna teks untuk mode gelap
        : const Color.fromARGB(255, 10, 52, 87),
  );
}

TextStyle styleKu3(BuildContext context) {
  return TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Warna teks untuk mode gelap
        : const Color.fromARGB(255, 10, 52, 87),
  );
}

TextStyle styleKu4(BuildContext context) {
  return TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.bold,
    color: Theme.of(context).brightness == Brightness.dark
        ? Colors.white // Warna teks untuk mode gelap
        : const Color.fromARGB(255, 10, 52, 87),
  );
}

String capitalizeFirst(String text) {
  return toBeginningOfSentenceCase(text) ?? text;
}
