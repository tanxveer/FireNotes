import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

// ignore: must_be_immutable
class NoteCreatorScreen extends StatefulWidget {
  const NoteCreatorScreen(
      {Key? key,
      required this.cryptKey,
      required this.refNotes,
      required this.titleController,
      required this.contentController})
      : super(key: key);

  final CollectionReference refNotes;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String? cryptKey;

  @override
  State<NoteCreatorScreen> createState() => _NoteCreatorScreenState();
}

class _NoteCreatorScreenState extends State<NoteCreatorScreen> {
  int color_id = Random().nextInt(AppStyle.cardsColor.length);

  //dispose
  @override
  void dispose() {
    widget.titleController.clear();
    widget.contentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        centerTitle: true,
        title: const Text(
          'Add a new note',
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: SingleChildScrollView(
        physics: AlwaysScrollableScrollPhysics(
          parent: BouncingScrollPhysics(),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: widget.titleController,
                decoration: const InputDecoration(
                    isDense: true, border: InputBorder.none, hintText: 'Title'),
                style: AppStyle.mainTitle,
              ),
              SizedBox(
                height: size.height * 0.80,
                child: Column(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: widget.contentController,
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            hintText: 'Note content'),
                        style: AppStyle.mainContent,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        onPressed: () async {
          widget.refNotes.add({
            'note_title': Encryptor.encrypt(
                widget.cryptKey!, widget.titleController.text),
            'note_content': Encryptor.encrypt(
                widget.cryptKey!, widget.contentController.text),
            'color_id': color_id,
          }).then((value) {
            print(value.id);
            Navigator.pop(context);
          });
        },
        child: const Icon(
          Icons.done,
          color: Colors.orange,
        ),
      ),
    );
  }
}
