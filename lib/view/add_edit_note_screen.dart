import 'package:flutter/material.dart';
import 'package:sqlite_notes_app/db/db_helper.dart';
import 'package:sqlite_notes_app/model/notes_model.dart';
import 'package:sqlite_notes_app/view/home_screen.dart';

class AddEditNoteScreen extends StatefulWidget {
  final Note? note;
  const AddEditNoteScreen({super.key, this.note});

  @override
  State<AddEditNoteScreen> createState() => _AddEditNoteScreenState();
}

class _AddEditNoteScreenState extends State<AddEditNoteScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  final DatabaseHelper _databaseHelper = DatabaseHelper();
  Color _selectedColor = Colors.blue;

  final List<Color> _noteColors = [
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFFC62828),
    Color(0xFF6D4C41),
    Color(0xFF6A1B9A),
    Color(0xFF00695C),
    Color(0xFFE65100),
    Color(0xFF1A237E),
    Color(0xFF000000),
    Color(0xFF212121),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note!.title;
      _contentController.text = widget.note!.content;
      _selectedColor = Color(int.parse(widget.note!.color));
    }
  }

  Future<void> _saveNote() async {
    if (!_formKey.currentState!.validate()) return;

    final note = Note(
      id: widget.note?.id,
      title: _titleController.text.trim(),
      content: _contentController.text.trim(),
      color: _selectedColor.value.toString(),
      dateTime: DateTime.now().toString(),
    );

    if (widget.note == null) {
      await _databaseHelper.insertNote(note);
    } else {
      await _databaseHelper.updateNote(note);
    }
    if (mounted) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(widget.note == null ? "Add Note" : "Edit Note"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    hintText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Title is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                TextFormField(
                  controller: _contentController,
                  decoration: InputDecoration(
                    hintText: 'Content',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  maxLines: 10,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Content is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _noteColors.map((e) {
                      return GestureDetector(
                        onTap: () => setState(() {
                          _selectedColor = e;
                        }),
                        child: Container(
                          height: 40,
                          width: 40,
                          margin: EdgeInsets.only(right: 8),
                          decoration: BoxDecoration(
                            color: e,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: _selectedColor == e
                                  ? Colors.black45
                                  : Colors.transparent,
                              width: 4,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                SizedBox(height: 20),
                InkWell(
                  onTap: () {
                    _saveNote();
                  },
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Color(0xFF50C878),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        'Save Note',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
