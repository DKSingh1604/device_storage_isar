// ignore_for_file: prefer_const_constructors

import 'package:device_storage_isar/models/notes.dart';
import 'package:device_storage_isar/models/notes_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  //text controller
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    //fetch notes
    readNotes();
  }

  //create a note
  void createNote(VoidCallback onNoteAdded) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: "Enter your note",
          ),
        ),
        actions: [
          //CANCEL
          TextButton(
            onPressed: () {
              //pop the dialog
              Navigator.of(context).pop();
            },
            child: Text("Cancel"),
          ),
          //SAVE
          TextButton(
            onPressed: () {
              context.read<NotesDatabase>().addNote(textController.text);

              setState(() {
                textController.clear();
              });

              onNoteAdded();

              //pop the dialog
              Navigator.of(context).pop();
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  //read a note
  void readNotes() {
    context.read<NotesDatabase>().fetchNotes();
  }

  //update a note
  void updateNotes(Notes note) {
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Update Note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          //cancel button
          MaterialButton(
            child: Text("Cancel"),
            onPressed: () => Navigator.of(context).pop(),
          ),

          //update button
          MaterialButton(
            child: Text("Update"),
            onPressed: () {
              //update note in db
              context
                  .read<NotesDatabase>()
                  .updateNote(note.id, textController.text);

              textController.clear();

              //close dialog
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  //delete a note
  void deleteNotes(int id) {
    context.read<NotesDatabase>().deleteNotes(id);
  }

  @override
  Widget build(BuildContext context) {
    //notes database
    final notesDatabase = context.watch<NotesDatabase>();

    //current notes
    List<Notes> currentNotes = notesDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        title: Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          createNote(() {
            setState(() {}); // Rebuild the ListView to show the new note
          });
        },
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          //get individual note
          final note = currentNotes[index];

          //list tile UI
          return ListTile(
            title: Text(note.text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                //edit button
                IconButton(
                    onPressed: () => updateNotes(note), icon: Icon(Icons.edit)),

                //delete button
                IconButton(
                    onPressed: () => deleteNotes(note.id),
                    icon: Icon(Icons.delete)),
              ],
            ),
          );
        },
      ),
    );
  }
}
