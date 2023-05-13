import 'dart:core';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:word_generator/word_generator.dart';

//ignore: must_be_immutable
class DialogBox extends StatefulWidget {
  DialogBox({Key? key, required this.controller, required this.onCancel})
      : super(key: key);

  late TextEditingController controller;
  final Function() onCancel;

  @override
  State<DialogBox> createState() => _DialogBoxState();
}

class _DialogBoxState extends State<DialogBox> {
  @override
  void initState() {
    super.initState();
    generatePassword();
  }

  late String generatedPassword;
  late List<String> passList;
  bool memorizable = false;

  //generate New Password
  void generatePassword() {
    if (memorizable) {
      final passwordGenerator = WordGenerator();
      setState(() {
        passList = passwordGenerator.randomVerbs(2);
        generatedPassword = passList.join(' ');
      });
    } else {
      final passwordGenerator = PasswordGenerator();
      setState(() {
        generatedPassword = passwordGenerator.generatePassword(10);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      content: SizedBox(
        width: 700,
        height: 210,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            TextField(
              controller: widget.controller,
              decoration: InputDecoration(
                hintText: generatedPassword,
                hintStyle: const TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.white),
                  borderRadius: BorderRadius.circular(12),
                ),
                focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff66ffc2)),
                    borderRadius: BorderRadius.circular(12)),
              ),
              style: const TextStyle(color: Colors.white),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Memorizable ?',
                  style: TextStyle(color: Colors.white),
                ),
                Switch.adaptive(
                  activeTrackColor: const Color(0xff66ffc2),
                  activeColor: CupertinoColors.systemGrey,
                  value: memorizable,
                  onChanged: (value) => setState(() {
                    memorizable = !memorizable;
                    generatePassword();
                  }),
                ),
              ],
            ),
            Row(
              children: [
                OutlinedButton(
                  onPressed: () => generatePassword(),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff66ffc2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Generate a Password.',
                    style: TextStyle(
                      color: Color(0xff66ffc2),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 30),
                    backgroundColor: const Color(0xff66ffc2),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: widget.onCancel,
                  child: const Text('Cancel'),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: () {
                    widget.controller.text = generatedPassword;
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(80, 30),
                    backgroundColor: const Color(0xff66ffc2),
                    foregroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Use it'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
