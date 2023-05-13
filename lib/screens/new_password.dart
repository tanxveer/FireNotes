import 'package:flutter/material.dart';

//ignore: must_be_immutable
class NewPasswordPage extends StatefulWidget {
  NewPasswordPage(
      {Key? key,
      required this.companyController,
      required this.usernameController,
      required this.passwordController,
      required this.generatePass,
      required this.saveNew})
      : super(key: key);

  final VoidCallback generatePass;
  final VoidCallback saveNew;
  final TextEditingController companyController;
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  late bool hiddenPassword;

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
          "Add a Password.",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: widget.saveNew,
            icon: const Icon(
              Icons.check_circle_outline,
              color: Color(0xff66ffc2),
            ),
          ),
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
                  hintStyle: const TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Color(0xff66ffc2)),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  hintText: 'WEBSITE',
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
                  hintText: 'EMAIL/USERNAME',
                  hintStyle: const TextStyle(color: Colors.white38),
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
                  hintStyle: const TextStyle(color: Colors.white38),
                  enabledBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xff66ffc2)),
                      borderRadius: BorderRadius.circular(12)),
                  hintText: 'PASSWORD',
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Padding(
                padding:
                    const EdgeInsets.only(top: 24.0, left: 12.0, right: 12.0),
                child: OutlinedButton(
                  onPressed: widget.generatePass,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: const Color(0xff66ffc2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Generate a Password.',
                    style: TextStyle(color: Color(0xff66ffc2)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
