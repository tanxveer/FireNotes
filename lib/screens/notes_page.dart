import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../style/app_style.dart';
import '../widgets/note_card.dart';
import 'note_creator.dart';
import 'note_editor.dart';

//ignore: must_be_immutable
class NotesPage extends StatefulWidget {
  const NotesPage({Key? key}) : super(key: key);

  final String cryptKey = 'b^z)5*qQ';

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  //controller
  final TextEditingController _titleController = TextEditingController();

  final TextEditingController _contentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    CollectionReference _refNotes = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notes');
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: const Text(
          'Notes.',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
        actions: [
          IconButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
            },
            icon: const Icon(
              Icons.logout_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NoteCreatorScreen(
                refNotes: _refNotes,
                titleController: _titleController,
                contentController: _contentController,
                cryptKey: widget.cryptKey,
              ),
            ),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.black,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _refNotes.snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (snapshot.data?.docs.length == 0) {
                    return Center(
                      child: Text(
                        'There\'s no note',
                        style: GoogleFonts.nunito(color: Colors.white),
                      ),
                    );
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data!.docs.length);
                    return GridView(
                      physics: const AlwaysScrollableScrollPhysics(
                        parent: BouncingScrollPhysics(),
                      ),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      children: snapshot.data!.docs
                          .map(
                            (note) => noteCard(() {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoteEditorScreen(
                                    note,
                                    refNotes: _refNotes,
                                    titleController: _titleController,
                                    contentController: _contentController,
                                    cryptKey: widget.cryptKey,
                                  ),
                                ),
                              );
                            }, note, widget.cryptKey),
                          )
                          .toList(),
                    );
                  } else {
                    return Text(
                      'There\'s no note',
                      style: GoogleFonts.nunito(color: Colors.white),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
