import 'package:flutter/material.dart';

class DataTableHeader extends StatelessWidget {
  const DataTableHeader({
    super.key,
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.white),
            borderRadius: const BorderRadius.all(Radius.circular(25))),
        margin: const EdgeInsets.all(16),
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4,
            bottom: 4,
            left: 12,
            right: 12,
          ),
          child: Text(
            textAlign: TextAlign.center,
            text,
            textScaleFactor: 1.25,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.lightBlue[300],
            ),
          ),
        ));
  }
}
