import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class DeleteButton extends StatelessWidget {
  const DeleteButton({
    super.key,
    required this.getIdControl,
    required this.getRef,
  });

  final Function() getIdControl;
  final Function() getRef;

  @override
  Widget build(BuildContext context) {
    var messenger = ScaffoldMessenger.of(context);

    return ElevatedButton(
        onPressed: () {
          if (getIdControl().text.isNotEmpty) {
            showAlertDialog(context);
          } else {
            messenger.showSnackBar(
                const SnackBar(content: Text("Vui lòng điền đủ thông tin")));
          }
        },
        child: Text(
          "Delete",
          style: TextStyle(color: Theme.of(context).colorScheme.background),
        ));
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: const Text("Không"),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: const Text("Ok"),
      onPressed: () {
        Navigator.of(context).pop();
        DatabaseReference newEmpolyeeRef = getRef().child(getIdControl().text);
        newEmpolyeeRef.remove();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: const Text("Xác nhận xóa"),
      content: const Text("Bạn có muốn xóa thông tin nhân viên này không?"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
