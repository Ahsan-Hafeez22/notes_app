class Note {
  final int? id;
  final String title;
  final String content;
  final String color; // Store as "#FFFFFF" format
  final String dateTime;

  Note({
    this.id,
    required this.title,
    required this.content,
    required this.color,
    required this.dateTime,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color, // Store as "#FFFFFF"
      'dateTime': dateTime,
    };
  }

  factory Note.fromMap(Map<String, dynamic> map) {
    return Note(
      id: map['id'] as int?,
      title: map['title'] as String,
      content: map['content'] as String,
      color: map['color'] ?? '#FFFFFF', // Default to white
      dateTime: map['dateTime'] as String,
    );
  }
}
