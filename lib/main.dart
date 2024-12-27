import 'package:device_storage_isar/models/notes_database.dart';
import 'package:device_storage_isar/pages/notes_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  //intialize note in isar database
  WidgetsFlutterBinding.ensureInitialized();
  await NotesDatabase.initialize();

  runApp(
    ChangeNotifierProvider(
      create: (context) => NotesDatabase(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: NotesPage(),
    );
  }
}
