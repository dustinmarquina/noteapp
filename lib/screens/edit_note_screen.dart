import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/note_provider.dart';

class EditNoteScreen extends StatefulWidget {
  final String? noteId;
  const EditNoteScreen({super.key, this.noteId});

  @override
  State<EditNoteScreen> createState() => _EditNoteScreenState();
}

class _EditNoteScreenState extends State<EditNoteScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _contentController;
  bool _initialized = false;

  @override
  void initState() {
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized && widget.noteId != null) {
      final provider = Provider.of<NoteProvider>(context, listen: false);
      final note = provider.getById(widget.noteId!);
      if (note != null) {
        _titleController.text = note.title;
        _contentController.text = note.content;
      }
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    final provider = Provider.of<NoteProvider>(context, listen: false);

    if (widget.noteId == null) {
      // create
      if (title.isEmpty && content.isEmpty) {
        // nothing to save
        Navigator.of(context).pop();
        return;
      }
      provider.addNote(title, content);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Note added')));
    } else {
      provider.updateNote(widget.noteId!, title, content);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Note updated')));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.noteId != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit Note' : 'New Note'),
        actions: [
          IconButton(
            icon: const Icon(Icons.save),
            onPressed: _save,
            tooltip: 'Save',
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: TextField(
                controller: _contentController,
                decoration: const InputDecoration(
                  labelText: 'Content',
                  border: OutlineInputBorder(),
                ),
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: _save,
                  child: const Text('Save'),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
