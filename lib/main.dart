import 'package:flutter/material.dart';

void main() {
  runApp(const LeexNotesApp());
}

class LeexNotesApp extends StatelessWidget {
  const LeexNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LEEX Notes',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.amber,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: const NotesScreen(),
    );
  }
}

class Note {
  String id;
  String title;
  String content;
  DateTime date;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.date,
  });
}

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<Note> _notes = [];

  void _addOrEditNote({Note? note}) {
    final titleController = TextEditingController(text: note?.title ?? '');
    final contentController = TextEditingController(text: note?.content ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                note == null ? 'Nueva Nota' : 'Editar Nota',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  labelText: 'Título',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: contentController,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: 'Contenido',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.amber,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                icon: const Icon(Icons.save),
                label: const Text('Guardar'),
                onPressed: () {
                  final title = titleController.text.trim();
                  final content = contentController.text.trim();

                  if (title.isEmpty && content.isEmpty) return;

                  setState(() {
                    if (note == null) {
                      _notes.add(
                        Note(
                          id: DateTime.now().toString(),
                          title: title.isEmpty ? 'Sin título' : title,
                          content: content,
                          date: DateTime.now(),
                        ),
                      );
                    } else {
                      note.title = title.isEmpty ? 'Sin título' : title;
                      note.content = content;
                      note.date = DateTime.now();
                    }
                  });

                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _deleteNote(String id) {
    setState(() {
      _notes.removeWhere((note) => note.id == id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'LEEX Notes',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.amber.shade700,
        foregroundColor: Colors.black,
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.note_alt_outlined, size: 80, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    'No tienes notas guardadas',
                    style: TextStyle(color: Colors.grey, fontSize: 16),
                  ),
                ],
              ),
            )
          : ListView.builder(
              itemCount: _notes.length,
              padding: const EdgeInsets.all(12),
              itemBuilder: (context, index) {
                final note = _notes[index];
                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      note.content,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _deleteNote(note.id),
                    ),
                    onTap: () => _addOrEditNote(note: note),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.amber,
        foregroundColor: Colors.black,
        onPressed: () => _addOrEditNote(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
