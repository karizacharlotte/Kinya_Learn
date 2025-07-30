import 'package:cloud_firestore/cloud_firestore.dart';

class LearningNote {
  final String id;
  final String userId;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime? deadline;
  final Priority priority;
  final NoteCategory category;
  final bool isCompleted;
  final Map<String, dynamic> metadata;

  LearningNote({
    required this.id,
    required this.userId,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
    this.deadline,
    this.priority = Priority.medium,
    this.category = NoteCategory.general,
    this.isCompleted = false,
    this.metadata = const {},
  });

  factory LearningNote.fromFirestore(Map<String, dynamic> data, String id) {
    return LearningNote(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      content: data['content'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      deadline: (data['deadline'] as Timestamp?)?.toDate(),
      priority: Priority.values.firstWhere(
        (e) => e.toString().split('.').last == (data['priority'] ?? 'medium'),
        orElse: () => Priority.medium,
      ),
      category: NoteCategory.values.firstWhere(
        (e) => e.toString().split('.').last == (data['category'] ?? 'general'),
        orElse: () => NoteCategory.general,
      ),
      isCompleted: data['isCompleted'] ?? false,
      metadata: data['metadata'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'deadline': deadline != null ? Timestamp.fromDate(deadline!) : null,
      'priority': priority.toString().split('.').last,
      'category': category.toString().split('.').last,
      'isCompleted': isCompleted,
      'metadata': metadata,
    };
  }

  LearningNote copyWith({
    String? title,
    String? content,
    DateTime? updatedAt,
    DateTime? deadline,
    Priority? priority,
    NoteCategory? category,
    bool? isCompleted,
    Map<String, dynamic>? metadata,
  }) {
    return LearningNote(
      id: id,
      userId: userId,
      title: title ?? this.title,
      content: content ?? this.content,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      deadline: deadline ?? this.deadline,
      priority: priority ?? this.priority,
      category: category ?? this.category,
      isCompleted: isCompleted ?? this.isCompleted,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isOverdue {
    if (deadline == null || isCompleted) return false;
    return DateTime.now().isAfter(deadline!);
  }

  bool get isDueSoon {
    if (deadline == null || isCompleted) return false;
    final now = DateTime.now();
    final tomorrow = now.add(const Duration(days: 1));
    return deadline!.isBefore(tomorrow) && deadline!.isAfter(now);
  }

  int get daysUntilDeadline {
    if (deadline == null) return -1;
    return deadline!.difference(DateTime.now()).inDays;
  }
}

enum Priority {
  low,
  medium,
  high,
  urgent,
}

enum NoteCategory {
  general,
  vocabulary,
  grammar,
  pronunciation,
  culture,
  goals,
  review,
}

class LearningGoal {
  final String id;
  final String userId;
  final String title;
  final String description;
  final DateTime createdAt;
  final DateTime updatedAt;
  final DateTime targetDate;
  final GoalType type;
  final int targetValue;
  final int currentProgress;
  final bool isCompleted;
  final Map<String, dynamic> milestones;

  LearningGoal({
    required this.id,
    required this.userId,
    required this.title,
    required this.description,
    required this.createdAt,
    required this.updatedAt,
    required this.targetDate,
    required this.type,
    required this.targetValue,
    this.currentProgress = 0,
    this.isCompleted = false,
    this.milestones = const {},
  });

  factory LearningGoal.fromFirestore(Map<String, dynamic> data, String id) {
    return LearningGoal(
      id: id,
      userId: data['userId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      targetDate: (data['targetDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      type: GoalType.values.firstWhere(
        (e) => e.toString().split('.').last == (data['type'] ?? 'lessons'),
        orElse: () => GoalType.lessons,
      ),
      targetValue: data['targetValue'] ?? 0,
      currentProgress: data['currentProgress'] ?? 0,
      isCompleted: data['isCompleted'] ?? false,
      milestones: data['milestones'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'title': title,
      'description': description,
      'createdAt': Timestamp.fromDate(createdAt),
      'updatedAt': Timestamp.fromDate(updatedAt),
      'targetDate': Timestamp.fromDate(targetDate),
      'type': type.toString().split('.').last,
      'targetValue': targetValue,
      'currentProgress': currentProgress,
      'isCompleted': isCompleted,
      'milestones': milestones,
    };
  }

  LearningGoal copyWith({
    String? title,
    String? description,
    DateTime? updatedAt,
    DateTime? targetDate,
    GoalType? type,
    int? targetValue,
    int? currentProgress,
    bool? isCompleted,
    Map<String, dynamic>? milestones,
  }) {
    return LearningGoal(
      id: id,
      userId: userId,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt,
      updatedAt: updatedAt ?? DateTime.now(),
      targetDate: targetDate ?? this.targetDate,
      type: type ?? this.type,
      targetValue: targetValue ?? this.targetValue,
      currentProgress: currentProgress ?? this.currentProgress,
      isCompleted: isCompleted ?? this.isCompleted,
      milestones: milestones ?? this.milestones,
    );
  }

  double get progressPercentage {
    if (targetValue == 0) return 0.0;
    return (currentProgress / targetValue * 100).clamp(0.0, 100.0);
  }

  bool get isOverdue {
    if (isCompleted) return false;
    return DateTime.now().isAfter(targetDate);
  }

  int get daysRemaining {
    return targetDate.difference(DateTime.now()).inDays;
  }
}

enum GoalType {
  lessons,
  xp,
  streak,
  vocabulary,
  accuracy,
  time,
}
