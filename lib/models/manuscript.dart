class ManuscriptStatus {
  static const writing = 'writing'; // Écriture
  static const editing = 'editing'; // Édition
  static const reviewing = 'reviewing'; // Bêta-lecture
  static const selected = 'selected'; // Sélectionné par la maison
  static const published = 'published'; // Publié
}

class Manuscript {
  final String id;
  final String ownerId; // uid de l'autrice
  final String title;
  final String? summary;
  final String status; // voir ManuscriptStatus
  final int chapterCount;
  final double avgRating; // moyenne des notes bêta
  final DateTime createdAt;
  final DateTime updatedAt;

  Manuscript({
    required this.id,
    required this.ownerId,
    required this.title,
    this.summary,
    required this.status,
    required this.chapterCount,
    required this.avgRating,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'ownerId': ownerId,
      'title': title,
      'summary': summary,
      'status': status,
      'chapterCount': chapterCount,
      'avgRating': avgRating,
      'createdAt': createdAt.toUtc().toIso8601String(),
      'updatedAt': updatedAt.toUtc().toIso8601String(),
    };
  }

  factory Manuscript.fromMap(String id, Map<String, dynamic> map) {
    return Manuscript(
      id: id,
      ownerId: map['ownerId'] as String,
      title: map['title'] as String,
      summary: map['summary'] as String?,
      status: map['status'] as String? ?? ManuscriptStatus.writing,
      chapterCount: (map['chapterCount'] ?? 0) as int,
      avgRating: (map['avgRating'] ?? 0.0).toDouble(),
      createdAt: DateTime.parse(map['createdAt'] as String),
      updatedAt: DateTime.parse(map['updatedAt'] as String),
    );
  }
}
