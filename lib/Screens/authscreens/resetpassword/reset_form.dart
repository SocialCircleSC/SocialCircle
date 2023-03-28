import 'package:community/themes/theme.dart';
import 'package:flutter/material.dart';

class ResetForm extends StatelessWidget {
  const ResetForm({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: const InputDecoration(
        hintText: "Email",
        hintStyle: TextStyle(color: TextFieldColor),
        focusedBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: PrimaryColor)),
      ),
    );
  }
}
