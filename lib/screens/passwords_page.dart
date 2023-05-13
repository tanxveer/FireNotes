import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firenote/screens/change_password.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:local_auth/local_auth.dart';

import '../widgets/dialog_box.dart';
import '../widgets/list_icon.dart';
import 'new_password.dart';

// ignore: must_be_immutable
class PasswordsPage extends StatefulWidget {
  const PasswordsPage({Key? key}) : super(key: key);

  @override
  State<PasswordsPage> createState() => _PasswordsPageState();
}

class _PasswordsPageState extends State<PasswordsPage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  late final LocalAuthentication auth;
  late bool _isAuthenticated = false;
  late String passBackUp;

  //controller
  final TextEditingController _companyController = TextEditingController();

  final TextEditingController _usernameController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final String key = 'b^z#5*qQ';

  @override
  initState() {
    auth = LocalAuthentication();
    super.initState();
  }

  //save New Credentials
  void saveNew() {
    CollectionReference _refPasswords = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('passwords');
    setState(
      () {
        _companyController.text.trim() == '' ||
                _usernameController.text.trim() == '' ||
                _passwordController.text.trim() == ''
            ? ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Fill all required fields.'),
                ),
              )
            : {
                _refPasswords.add({
                  'website':
                      Encryptor.encrypt(key, _companyController.text.trim()),
                  'username':
                      Encryptor.encrypt(key, _usernameController.text.trim()),
                  'password':
                      Encryptor.encrypt(key, _passwordController.text.trim()),
                }).then((value) {
                  Navigator.pop(context);
                })
              };
      },
    );
  }

  //copy Password to clipboard
  void copyPassword(QueryDocumentSnapshot doc) async {
    await _authenticate();
    if (_isAuthenticated) {
      await Clipboard.setData(
        ClipboardData(
          text: Encryptor.decrypt(key, doc['password']),
        ),
      ).then((value) => {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                duration: Duration(milliseconds: 2500),
                dismissDirection: DismissDirection.horizontal,
                content: Text('Password was copied to clipboard !'),
              ),
            ),
          });
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
  }

  //create New Password
  void createNewPassword() {
    passBackUp = _passwordController.text;
    _passwordController.clear();
    showDialog(
        context: context,
        builder: (context) {
          return DialogBox(
            controller: _passwordController,
            onCancel: () {
              _passwordController.text = passBackUp;
              Navigator.of(context).pop();
            },
          );
        });
  }

  //delete Existing Credentials
  void deleteCredential(QueryDocumentSnapshot doc) async {
    CollectionReference _refPasswords = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('passwords');
    await _authenticate();
    if (_isAuthenticated) {
      setState(() {
        _refPasswords.doc(doc.id).delete();
      });
      if (!mounted) return;
      Navigator.of(context).pop();
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
  }

  //change Existing Credentials
  void changeExistingCredential(QueryDocumentSnapshot doc) async {
    CollectionReference _refPasswords = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('passwords');
    await _authenticate();
    if (_isAuthenticated) {
      setState(() {
        if (_companyController.text.trim().isNotEmpty) {
          _refPasswords.doc(doc.id).update({
            'website': Encryptor.encrypt(key, _companyController.text.trim()),
          });
        }
        if (_usernameController.text.trim().isNotEmpty) {
          _refPasswords.doc(doc.id).update({
            'username': Encryptor.encrypt(key, _usernameController.text.trim()),
          });
        }
        if (_passwordController.text.trim().isNotEmpty) {
          _refPasswords.doc(doc.id).update({
            'password': Encryptor.encrypt(key, _passwordController.text.trim()),
          });
        }
      });
      //clear textFields
      _companyController.clear();
      _usernameController.clear();
      _passwordController.clear();
      //pop the page
      if (!mounted) return;
      Navigator.of(context).pop();
      _isAuthenticated = false;
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(milliseconds: 2500),
          dismissDirection: DismissDirection.horizontal,
          content: Text('Please authenticate yourself first !'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance.collection('users').doc(uid).get().then((doc) {
      final key = doc['key'];
      print(key);
    });
    CollectionReference _refPasswords = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('passwords');
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Passwords.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => NewPasswordPage(
                saveNew: () => saveNew(),
                companyController: _companyController,
                usernameController: _usernameController,
                passwordController: _passwordController,
                generatePass: () {
                  createNewPassword();
                },
              ),
            ),
          );
        },
        backgroundColor: const Color(0xff66ffc2),
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _refPasswords.snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (snapshot.data!.docs.length == 0) {
                  return Center(
                    child: Text(
                      'There\'s no saved Password',
                      style: GoogleFonts.nunito(color: Colors.white),
                    ),
                  );
                }
                if (snapshot.hasData) {
                  return ListView(
                    physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics()),
                    children: snapshot.data!.docs
                        .map(
                          (doc) => IdTile(
                            () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChangePasswordPage(
                                    doc,
                                    refNotes: _refPasswords,
                                    companyController: _companyController,
                                    usernameController: _usernameController,
                                    passwordController: _passwordController,
                                    onSave: () => changeExistingCredential(doc),
                                    deleteTapped: () => deleteCredential(doc),
                                    generatePassword: createNewPassword,
                                    cryptKey: key,
                                  ),
                                ),
                              );
                            },
                            doc,
                          ),
                        )
                        .toList(),
                  );
                }
                return Text(
                  'There\'s no saved Password',
                  style: GoogleFonts.nunito(color: Colors.white),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget IdTile(Function()? onTap, QueryDocumentSnapshot doc) {
    return ListTile(
      selectedTileColor: Colors.transparent,
      onTap: onTap,
      textColor: Colors.white,
      leading: ListIcon(
        companyName: Encryptor.decrypt(key, doc['website']),
      ),
      trailing: IconButton(
        onPressed: () => copyPassword(doc),
        icon: const Icon(
          Icons.copy,
          color: Colors.white,
        ),
      ),
      title: Text(
        Encryptor.decrypt(key, doc['website']),
      ),
      subtitle: Text(
        Encryptor.decrypt(key, doc['username']),
      ),
    );
  }

  Future<void> _authenticate() async {
    try {
      bool authenticated = await auth.authenticate(
          localizedReason: 'Authenticate yourself first !',
          options: const AuthenticationOptions(
            stickyAuth: true,
            biometricOnly: true,
          ));
      setState(() {
        _isAuthenticated = authenticated;
      });
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }
}
