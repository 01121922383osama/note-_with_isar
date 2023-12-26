import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_isar/Models/note_models.dart';
import 'package:path_provider/path_provider.dart';

class NoteDb extends ChangeNotifier {
  static late Isar isar;
  // init
  static Future<void> initialized() async {
    final dir = await getApplicationCacheDirectory();
    isar = await Isar.open([NotesSchema], directory: dir.path);
  }

  // list
  final List<Notes> currentNote = [];
  // add note to db
  Future<void> addNote({required String textFromUser}) async {
    final newNote = Notes()..text = textFromUser;
    await isar.writeTxn(() => isar.notes.put(newNote));
    fetchAllNote();
  }

  // read
  Future<void> fetchAllNote() async {
    List<Notes> fetchNote = await isar.notes.where().findAll();
    currentNote.clear();
    currentNote.addAll(fetchNote);
    notifyListeners();
  }

  // create
  Future<void> uppdateNote({required int id, required String newText}) async {
    final existNote = await isar.notes.get(id);
    if (existNote != null) {
      existNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existNote));
      await fetchAllNote();
    }
  }

  Future<void> deleteNote({required int id}) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchAllNote();
  }
}
