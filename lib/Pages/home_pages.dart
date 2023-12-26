import 'package:flutter/material.dart';
import 'package:note_isar/Models/note_db.dart';
import 'package:note_isar/Models/note_models.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController controller = TextEditingController();

  void createNote() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          content: TextField(
            controller: controller,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                if (controller.text.isNotEmpty) {
                  context.read<NoteDb>().addNote(textFromUser: controller.text);
                  Navigator.pop(context);
                  controller.clear();
                } else {
                  context.read<NoteDb>().addNote(textFromUser: 'Empty Note');
                  Navigator.pop(context);
                  controller.clear();
                }
              },
              child: const Text('AddNote'),
            ),
          ],
        );
      },
    );
  }

  void readNotes() {
    context.read<NoteDb>().fetchAllNote();
    controller.clear();
  }

  void updateNote({required Notes notes}) {
    controller.text = notes.text;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Update Note'),
          content: TextField(
            controller: controller,
          ),
          actions: [
            MaterialButton(
              onPressed: () {
                context.read<NoteDb>().uppdateNote(
                      id: notes.id,
                      newText: controller.text,
                    );
                controller.clear();
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void deleteNote({required int id}) {
    context.read<NoteDb>().deleteNote(id: id);
  }

  @override
  void initState() {
    readNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteDB = context.watch<NoteDb>();
    List<Notes> currentNotes = noteDB.currentNote;
    return Scaffold(
      appBar: AppBar(
        elevation: 5,
        title: const Text('Note Isar'),
      ),
      body: currentNotes.isNotEmpty
          ? ListView.builder(
              itemCount: currentNotes.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  leading: CircleAvatar(
                    child: Text(currentNotes[index].id.toString()),
                  ),
                  title: Text(currentNotes[index].text),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // edit
                      IconButton(
                        onPressed: () => updateNote(notes: currentNotes[index]),
                        icon: const Icon(Icons.edit),
                      ),
                      // delete
                      IconButton(
                        onPressed: () => deleteNote(id: currentNotes[index].id),
                        icon: const Icon(Icons.delete),
                      ),
                    ],
                  ),
                );
              },
            )
          : const Center(
              child: Text('No Note Add it yet try add some note..!'),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
