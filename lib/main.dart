import 'package:flutter/material.dart';
import 'package:note_isar/Models/note_db.dart';
import 'package:provider/provider.dart';

import 'Pages/home_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NoteDb.initialized();
  runApp(ChangeNotifierProvider(
      create: (context) => NoteDb(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Note',
      theme: ThemeData.dark(
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}
