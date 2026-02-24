class StudyMaterial{
  final String id;
  final String title;       // e.g., "Machine Learning Basics"
  final String subject;     // e.g., "Computer Science"
  final DateTime createdAt; // When the file was uploaded/created
  final String type;        // e.g., "pdf", "quiz", "flashcard"
  StudyMaterial({
    required this.id,
    required this.title,
    required this.subject,
    required this.createdAt,
    required this.type,
  });
}