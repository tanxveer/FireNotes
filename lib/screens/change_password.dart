import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

//ignore: must_be_immutable
class ChangePasswordPage extends StatefulWidget {
  ChangePasswordPage(
    this.doc, {
    Key? key,
    required this.refNotes,
    required this.companyController,
    required this.usernameController,
    required this.passwordController,
    required this.onSave,
    required this.deleteTapped,
    required this.generatePassword,
    required this.cryptKey,
  }) : super(key: key);

  QueryDocumentSnapshot doc;
  final String cryptKey;
  final CollectionReference refNotes;
  final VoidCallback onSave;
  final VoidCallback deleteTapped;
  final VoidCallback generatePassword;
  final TextEditingController companyController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  late bool hiddenPassword;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    super.initState();
    hiddenPassword = true;
  }

  @override
  void dispose() {
    widget.companyController.clear();
    widget.usernameController.clear();
    widget.passwordController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(
            Icons.cancel_outlined,
            color: Colors.white,
          ),
        ),
        title: const Text(
          "Change credentials.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: widget.onSave,
              icon: const Icon(
                Icons.check_circle_outline,
                color: Color(0xff66ffc2),
              ))
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
        ),
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
              child: TextField(
                controller: widget.companyController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff66ffc2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText:
                      Encryptor.decrypt(widget.cryptKey, widget.doc['website']),
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
              child: TextField(
                controller: widget.usernameController,
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff66ffc2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: Encryptor.decrypt(
                      widget.cryptKey, widget.doc['username']),
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
              child: TextField(
                controller: widget.passwordController,
                obscureText: hiddenPassword,
                decoration: InputDecoration(
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      hiddenPassword = !hiddenPassword;
                    }),
                    icon: hiddenPassword
                        ? const Icon(Icons.visibility_off_outlined)
                        : const Icon(Icons.visibility_outlined),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff66ffc2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'Password',
                  hintStyle: const TextStyle(color: Colors.white38),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
              child: ButtonBar(
                alignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: widget.deleteTapped,
                    style: ElevatedButton.styleFrom(
                      fixedSize: const Size(171, 30),
                      backgroundColor: const Color(0xff66ffc2),
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Delete Password.'),
                  ),
                  OutlinedButton(
                    onPressed: widget.generatePassword,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xff66ffc2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Generate a Password.',
                      style: TextStyle(color: Color(0xff66ffc2)),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
