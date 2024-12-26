import 'package:device_storage_isar/models/notes.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

class NotesDatabase {
  static late Isar isar;
  //INITIALIZE DATABASE

  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open(
      [NotesSchema],
      directory: dir.path,
    );
  }

  //list of notes
  final List<Notes> currentNotes = [];

  //CREATE - a note and save to db
  Future<void> addNote(String textFromUser) async {
    //create a new note object
    final newNote = Notes()..text = textFromUser;

    //save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    //re-read from db
  }

  //READ - notes from db
  Future<void> fetchNotes() async {
    List<Notes> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);
  }

  //UPDATE - notes from db
  Future<void> updateNote(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  //DELETE - a noted from db
  Future<void> deleteNotes(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
