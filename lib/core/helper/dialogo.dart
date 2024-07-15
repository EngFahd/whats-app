import 'package:flutter/material.dart';

class Dialogo {
  static void showSnackBar(BuildContext context, String massaage) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        
        duration: const Duration(milliseconds: 500),
        content: Text(massaage),
        backgroundColor: Colors.blue,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  showProgresBar(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => const Center(
        child: CircularProgressIndicator(),
      ),
    );
  }
}
