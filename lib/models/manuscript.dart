import 'package:cloud_firestore/cloud_firestore.dart';

class Manuscript {
  final String id;
  final String ownerId;
  final String title;
  final String? summary;
  final String status;
  final int chapterCount;
  final double avgRating;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String content;
  final bool isPublic;

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
    this.content = '',
    this.isPublic = false,
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
      'content': content,
      'isPublic': isPublic,
    };
  }

  factory Manuscript.fromMap(String id, Map<String, dynamic> map) {
    DateTime _parseDate(dynamic value, {DateTime? fallback}) {
      if (value == null) return fallback ?? DateTime.now();
      if (value is String) {
        try {
          return DateTime.parse(value);
        } catch (_) {
          return fallback ?? DateTime.now();
        }
      }
      if (value is Timestamp) return value.toDate();
      return fallback ?? DateTime.now();
    }

    final createdAt = _parseDate(map['createdAt']);
    final updatedAt = _parseDate(map['updatedAt'], fallback: createdAt);

    final chapterCount = (map['chapterCount'] as num?)?.toInt() ?? 0;
    final avgRating = (map['avgRating'] as num?)?.toDouble() ?? 0.0;

    return Manuscript(
      id: id,
      ownerId: map['ownerId'] as String? ?? '',
      title: map['title'] as String? ?? 'Sans titre',
      summary: map['summary'] as String?,
      status: map['status'] as String? ?? ManuscriptStatus.writing,
      chapterCount: chapterCount,
      avgRating: avgRating,
      createdAt: createdAt,
      updatedAt: updatedAt,
      content: map['content'] as String? ?? '',
      isPublic: map['isPublic'] as bool? ?? false, // 👈 vieux docs = false
    );
  }
}

class ManuscriptStatus {
  static const writing = 'writing';
  static const editing = 'editing';
  static const reviewing = 'reviewing';
  static const selected = 'selected';
  static const published = 'published';
}
