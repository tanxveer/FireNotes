import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:encryptor/encryptor.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../style/app_style.dart';

//ignore: must_be_immutable
class NoteEditorScreen extends StatefulWidget {
  NoteEditorScreen(this.doc,
      {Key? key,
      required this.refNotes,
      required this.titleController,
      required this.contentController,
      required this.cryptKey})
      : super(key: key);
  QueryDocumentSnapshot doc;
  final CollectionReference refNotes;
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String? cryptKey;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  String userID = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    widget.titleController.text =
        Encryptor.decrypt(widget.cryptKey!, widget.doc['note_title']);
    widget.contentController.text =
        Encryptor.decrypt(widget.cryptKey!, widget.doc['note_content']);
    super.initState();
  }

  @override
  void dispose() {
    widget.titleController.clear();
    widget.contentController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int colorId = widget.doc['color_id'];
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[colorId],
      appBar: AppBar(
        elevation: 0.0,
        scrolledUnderElevation: 0.0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
            widget.refNotes.doc(widget.doc.id).update(
              {
                'note_title': Encryptor.encrypt(
                    widget.cryptKey!, widget.titleController.text),
                'note_content': Encryptor.encrypt(
                    widget.cryptKey!, widget.contentController.text),
              },
            );
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: AppStyle.cardsColor[colorId],
        actions: [
          IconButton(
            onPressed: () {
              widget.refNotes.doc(widget.doc.id).delete();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
