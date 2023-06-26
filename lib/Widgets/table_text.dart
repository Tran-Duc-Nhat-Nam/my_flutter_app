import 'package:flutter/material.dart';

class TableText extends StatelessWidget {
  final String text;

  const TableText({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        overflow: TextOverflow.ellipsis,
        text.toString().trim(),
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
