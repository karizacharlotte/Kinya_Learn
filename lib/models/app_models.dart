class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profileImageUrl;
  final String? currentLessonId;
  final List<String> completedLessons;
  final Map<String, dynamic> progress;
  final int xpPoints;
  final int currentStreak;
  final int maxStreak;
  final DateTime lastActive;
  final DateTime createdAt;
  final Map<String, dynamic> settings;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profileImageUrl,
    this.currentLessonId,
    this.completedLessons = const [],
    this.progress = const {},
    this.xpPoints = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    required this.lastActive,
    required this.createdAt,
    this.settings = const {},
  });

  factory UserModel.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserModel(
      uid: uid,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      profileImageUrl: data['profileImageUrl'],
      currentLessonId: data['currentLessonId'],
      completedLessons: List<String>.from(data['completedLessons'] ?? []),
      progress: data['progress'] ?? {},
      xpPoints: data['xpPoints'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      maxStreak: data['maxStreak'] ?? 0,
      lastActive: data['lastActive']?.toDate() ?? DateTime.now(),
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      settings: data['settings'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'currentLessonId': currentLessonId,
      'completedLessons': completedLessons,
      'progress': progress,
      'xpPoints': xpPoints,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'lastActive': lastActive,
      'createdAt': createdAt,
      'settings': settings,
    };
  }
}

class LessonModel {
  final String id;
  final String title;
  final String description;
  final String level; // Beginner, Intermediate, Advanced
  final int order;
  final String? imageUrl;
  final String category; // greetings, vocabulary, grammar, etc.
  final int estimatedDuration; // in minutes
  final List<String> objectives; // learning objectives
  final bool isActive;

  LessonModel({
    required this.id,
    required this.title,
    required this.description,
    required this.level,
    required this.order,
    this.imageUrl,
    required this.category,
    this.estimatedDuration = 15,
    this.objectives = const [],
    this.isActive = true,
  });

  factory LessonModel.fromFirestore(Map<String, dynamic> data, String id) {
    return LessonModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      level: data['level'] ?? 'Beginner',
      order: data['order'] ?? 0,
      imageUrl: data['imageUrl'],
      category: data['category'] ?? 'general',
      estimatedDuration: data['estimatedDuration'] ?? 15,
      objectives: List<String>.from(data['objectives'] ?? []),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'level': level,
      'order': order,
      'imageUrl': imageUrl,
      'category': category,
      'estimatedDuration': estimatedDuration,
      'objectives': objectives,
      'isActive': isActive,
    };
  }
}

class SectionModel {
  final String id;
  final String lessonId;
  final String title;
  final String type; // text, vocabulary, dialogue, quiz, audio_practice
  final dynamic content; // varies by type
  final int order;
  final bool isRequired;

  SectionModel({
    required this.id,
    required this.lessonId,
    required this.title,
    required this.type,
    required this.content,
    required this.order,
    this.isRequired = true,
  });

  factory SectionModel.fromFirestore(Map<String, dynamic> data, String id) {
    return SectionModel(
      id: id,
      lessonId: data['lessonId'] ?? '',
      title: data['title'] ?? '',
      type: data['type'] ?? 'text',
      content: data['content'],
      order: data['order'] ?? 0,
      isRequired: data['isRequired'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'lessonId': lessonId,
      'title': title,
      'type': type,
      'content': content,
      'order': order,
      'isRequired': isRequired,
    };
  }
}

class VocabularyItem {
  final String kinyarwandaWord;
  final String englishTranslation;
  final String? audioUrl;
  final String? pronunciation; // phonetic guide
  final String? category;
  final int difficulty; // 1-5

  VocabularyItem({
    required this.kinyarwandaWord,
    required this.englishTranslation,
    this.audioUrl,
    this.pronunciation,
    this.category,
    this.difficulty = 1,
  });

  factory VocabularyItem.fromMap(Map<String, dynamic> data) {
    return VocabularyItem(
      kinyarwandaWord: data['kinyarwandaWord'] ?? '',
      englishTranslation: data['englishTranslation'] ?? '',
      audioUrl: data['audioUrl'],
      pronunciation: data['pronunciation'],
      category: data['category'],
      difficulty: data['difficulty'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'kinyarwandaWord': kinyarwandaWord,
      'englishTranslation': englishTranslation,
      'audioUrl': audioUrl,
      'pronunciation': pronunciation,
      'category': category,
      'difficulty': difficulty,
    };
  }
}

class DialogueItem {
  final String speaker;
  final String kinyarwandaLine;
  final String englishTranslation;
  final String? audioUrl;
  final String? context; // situational context

  DialogueItem({
    required this.speaker,
    required this.kinyarwandaLine,
    required this.englishTranslation,
    this.audioUrl,
    this.context,
  });

  factory DialogueItem.fromMap(Map<String, dynamic> data) {
    return DialogueItem(
      speaker: data['speaker'] ?? '',
      kinyarwandaLine: data['kinyarwandaLine'] ?? '',
      englishTranslation: data['englishTranslation'] ?? '',
      audioUrl: data['audioUrl'],
      context: data['context'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'speaker': speaker,
      'kinyarwandaLine': kinyarwandaLine,
      'englishTranslation': englishTranslation,
      'audioUrl': audioUrl,
      'context': context,
    };
  }
}

class QuizModel {
  final String id;
  final String title;
  final String lessonId;
  final List<QuizQuestion> questions;
  final int passingScore; // percentage
  final int timeLimit; // in minutes, 0 for no limit

  QuizModel({
    required this.id,
    required this.title,
    required this.lessonId,
    required this.questions,
    this.passingScore = 70,
    this.timeLimit = 0,
  });

  factory QuizModel.fromFirestore(Map<String, dynamic> data, String id) {
    return QuizModel(
      id: id,
      title: data['title'] ?? '',
      lessonId: data['lessonId'] ?? '',
      questions: (data['questions'] as List<dynamic>?)
          ?.map((q) => QuizQuestion.fromMap(q))
          .toList() ?? [],
      passingScore: data['passingScore'] ?? 70,
      timeLimit: data['timeLimit'] ?? 0,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'lessonId': lessonId,
      'questions': questions.map((q) => q.toMap()).toList(),
      'passingScore': passingScore,
      'timeLimit': timeLimit,
    };
  }
}

class QuizQuestion {
  final String questionText;
  final String type; // multiple_choice, fill_in_the_blank, matching, true_false
  final List<String> options;
  final dynamic correctAnswer; // String or List<String>
  final String? audioUrl;
  final String? imageUrl;
  final String? explanation;

  QuizQuestion({
    required this.questionText,
    required this.type,
    this.options = const [],
    required this.correctAnswer,
    this.audioUrl,
    this.imageUrl,
    this.explanation,
  });

  factory QuizQuestion.fromMap(Map<String, dynamic> data) {
    return QuizQuestion(
      questionText: data['questionText'] ?? '',
      type: data['type'] ?? 'multiple_choice',
      options: List<String>.from(data['options'] ?? []),
      correctAnswer: data['correctAnswer'],
      audioUrl: data['audioUrl'],
      imageUrl: data['imageUrl'],
      explanation: data['explanation'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'questionText': questionText,
      'type': type,
      'options': options,
      'correctAnswer': correctAnswer,
      'audioUrl': audioUrl,
      'imageUrl': imageUrl,
      'explanation': explanation,
    };
  }
}

class ProgressModel {
  final String userId;
  final String lessonId;
  final String sectionId;
  final double completionPercentage;
  final int score;
  final int timeSpent; // in seconds
  final DateTime startedAt;
  final DateTime? completedAt;
  final Map<String, dynamic> answers;

  ProgressModel({
    required this.userId,
    required this.lessonId,
    required this.sectionId,
    required this.completionPercentage,
    this.score = 0,
    this.timeSpent = 0,
    required this.startedAt,
    this.completedAt,
    this.answers = const {},
  });

  factory ProgressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return ProgressModel(
      userId: data['userId'] ?? '',
      lessonId: data['lessonId'] ?? '',
      sectionId: data['sectionId'] ?? '',
      completionPercentage: data['completionPercentage']?.toDouble() ?? 0.0,
      score: data['score'] ?? 0,
      timeSpent: data['timeSpent'] ?? 0,
      startedAt: data['startedAt']?.toDate() ?? DateTime.now(),
      completedAt: data['completedAt']?.toDate(),
      answers: data['answers'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'sectionId': sectionId,
      'completionPercentage': completionPercentage,
      'score': score,
      'timeSpent': timeSpent,
      'startedAt': startedAt,
      'completedAt': completedAt,
      'answers': answers,
    };
  }
}

class CategoryModel {
  final String id;
  final String name;
  final String nameKinyarwanda;
  final String description;
  final String icon;
  final String color;
  final int order;
  final int lessonsCount;
  final bool isActive;

  CategoryModel({
    required this.id,
    required this.name,
    required this.nameKinyarwanda,
    required this.description,
    required this.icon,
    required this.color,
    required this.order,
    this.lessonsCount = 0,
    this.isActive = true,
  });

  factory CategoryModel.fromFirestore(Map<String, dynamic> data, String id) {
    return CategoryModel(
      id: id,
      name: data['name'] ?? '',
      nameKinyarwanda: data['nameKinyarwanda'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      color: data['color'] ?? '',
      order: data['order'] ?? 0,
      lessonsCount: data['lessonsCount'] ?? 0,
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'nameKinyarwanda': nameKinyarwanda,
      'description': description,
      'icon': icon,
      'color': color,
      'order': order,
      'lessonsCount': lessonsCount,
      'isActive': isActive,
    };
  }
}

class UserProgressModel {
  final String userId;
  final int totalLessonsCompleted;
  final int totalPoints;
  final int currentStreak;
  final int longestStreak;
  final DateTime lastActivityDate;
  final Map<String, dynamic> levelProgress;
  final Map<String, dynamic> categoryProgress;

  UserProgressModel({
    required this.userId,
    this.totalLessonsCompleted = 0,
    this.totalPoints = 0,
    this.currentStreak = 0,
    this.longestStreak = 0,
    required this.lastActivityDate,
    this.levelProgress = const {},
    this.categoryProgress = const {},
  });

  factory UserProgressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserProgressModel(
      userId: data['userId'] ?? '',
      totalLessonsCompleted: data['totalLessonsCompleted'] ?? 0,
      totalPoints: data['totalPoints'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      longestStreak: data['longestStreak'] ?? 0,
      lastActivityDate: data['lastActivityDate']?.toDate() ?? DateTime.now(),
      levelProgress: data['levelProgress'] ?? {},
      categoryProgress: data['categoryProgress'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'totalLessonsCompleted': totalLessonsCompleted,
      'totalPoints': totalPoints,
      'currentStreak': currentStreak,
      'longestStreak': longestStreak,
      'lastActivityDate': lastActivityDate,
      'levelProgress': levelProgress,
      'categoryProgress': categoryProgress,
    };
  }
}

enum LessonProgressStatus {
  notStarted,
  inProgress,
  completed,
}

class LessonProgressModel {
  final String userId;
  final String lessonId;
  final LessonProgressStatus status;
  final int progress;
  final int pointsEarned;
  final int attemptsCount;
  final DateTime? firstCompletedAt;
  final DateTime lastAccessedAt;
  final List<Map<String, dynamic>> exerciseResults;

  LessonProgressModel({
    required this.userId,
    required this.lessonId,
    required this.status,
    required this.progress,
    this.pointsEarned = 0,
    this.attemptsCount = 0,
    this.firstCompletedAt,
    required this.lastAccessedAt,
    this.exerciseResults = const [],
  });

  factory LessonProgressModel.fromFirestore(Map<String, dynamic> data, String id) {
    return LessonProgressModel(
      userId: data['userId'] ?? '',
      lessonId: data['lessonId'] ?? '',
      status: LessonProgressStatus.values.firstWhere(
        (e) => e.toString().split('.').last == data['status'],
        orElse: () => LessonProgressStatus.notStarted,
      ),
      progress: data['progress'] ?? 0,
      pointsEarned: data['pointsEarned'] ?? 0,
      attemptsCount: data['attemptsCount'] ?? 0,
      firstCompletedAt: data['firstCompletedAt']?.toDate(),
      lastAccessedAt: data['lastAccessedAt']?.toDate() ?? DateTime.now(),
      exerciseResults: List<Map<String, dynamic>>.from(data['exerciseResults'] ?? []),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'lessonId': lessonId,
      'status': status.toString().split('.').last,
      'progress': progress,
      'pointsEarned': pointsEarned,
      'attemptsCount': attemptsCount,
      'firstCompletedAt': firstCompletedAt,
      'lastAccessedAt': lastAccessedAt,
      'exerciseResults': exerciseResults,
    };
  }
}

class AchievementModel {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String type;
  final Map<String, dynamic> condition;
  final int points;
  final bool isActive;
  final String rarity;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.type,
    required this.condition,
    this.points = 0,
    this.isActive = true,
    this.rarity = 'common',
  });

  factory AchievementModel.fromFirestore(Map<String, dynamic> data, String id) {
    return AchievementModel(
      id: id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      icon: data['icon'] ?? '',
      type: data['type'] ?? '',
      condition: data['condition'] ?? {},
      points: data['points'] ?? 0,
      isActive: data['isActive'] ?? true,
      rarity: data['rarity'] ?? 'common',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'icon': icon,
      'type': type,
      'condition': condition,
      'points': points,
      'isActive': isActive,
      'rarity': rarity,
    };
  }
}

class UserAchievementModel {
  final String userId;
  final String achievementId;
  final DateTime unlockedAt;
  final int progress;

  UserAchievementModel({
    required this.userId,
    required this.achievementId,
    required this.unlockedAt,
    this.progress = 100,
  });

  factory UserAchievementModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserAchievementModel(
      userId: data['userId'] ?? '',
      achievementId: data['achievementId'] ?? '',
      unlockedAt: data['unlockedAt']?.toDate() ?? DateTime.now(),
      progress: data['progress'] ?? 100,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'userId': userId,
      'achievementId': achievementId,
      'unlockedAt': unlockedAt,
      'progress': progress,
    };
  }
}

class DailyChallengeModel {
  final String date;
  final Map<String, dynamic> challenge;
  final List<String> participants;
  final bool isActive;

  DailyChallengeModel({
    required this.date,
    required this.challenge,
    this.participants = const [],
    this.isActive = true,
  });

  factory DailyChallengeModel.fromFirestore(Map<String, dynamic> data, String id) {
    return DailyChallengeModel(
      date: data['date'] ?? '',
      challenge: data['challenge'] ?? {},
      participants: List<String>.from(data['participants'] ?? []),
      isActive: data['isActive'] ?? true,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'date': date,
      'challenge': challenge,
      'participants': participants,
      'isActive': isActive,
    };
  }
}
