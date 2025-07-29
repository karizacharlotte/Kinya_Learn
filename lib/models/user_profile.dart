class UserProfile {
  final String uid;
  final String displayName;
  final String email;
  final String? photoURL;
  final DateTime createdAt;
  final DateTime lastLoginAt;
  final UserStats stats;
  final UserSettings settings;
  final Map<String, dynamic> preferences;

  UserProfile({
    required this.uid,
    required this.displayName,
    required this.email,
    this.photoURL,
    required this.createdAt,
    required this.lastLoginAt,
    required this.stats,
    required this.settings,
    this.preferences = const {},
  });

  factory UserProfile.fromFirestore(Map<String, dynamic> data, String uid) {
    return UserProfile(
      uid: uid,
      displayName: data['displayName'] ?? '',
      email: data['email'] ?? '',
      photoURL: data['photoURL'],
      createdAt: data['createdAt']?.toDate() ?? DateTime.now(),
      lastLoginAt: data['lastLoginAt']?.toDate() ?? DateTime.now(),
      stats: UserStats.fromMap(data['stats'] ?? {}),
      settings: UserSettings.fromMap(data['settings'] ?? {}),
      preferences: data['preferences'] ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'displayName': displayName,
      'email': email,
      'photoURL': photoURL,
      'createdAt': createdAt,
      'lastLoginAt': lastLoginAt,
      'stats': stats.toMap(),
      'settings': settings.toMap(),
      'preferences': preferences,
    };
  }

  UserProfile copyWith({
    String? displayName,
    String? email,
    String? photoURL,
    DateTime? lastLoginAt,
    UserStats? stats,
    UserSettings? settings,
    Map<String, dynamic>? preferences,
  }) {
    return UserProfile(
      uid: uid,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      photoURL: photoURL ?? this.photoURL,
      createdAt: createdAt,
      lastLoginAt: lastLoginAt ?? this.lastLoginAt,
      stats: stats ?? this.stats,
      settings: settings ?? this.settings,
      preferences: preferences ?? this.preferences,
    );
  }
}

class UserStats {
  final int totalXP;
  final int lessonsCompleted;
  final int currentStreak;
  final int maxStreak;
  final int achievementsUnlocked;
  final double avgSessionTime;
  final DateTime lastSessionDate;

  UserStats({
    this.totalXP = 0,
    this.lessonsCompleted = 0,
    this.currentStreak = 0,
    this.maxStreak = 0,
    this.achievementsUnlocked = 0,
    this.avgSessionTime = 0.0,
    required this.lastSessionDate,
  });

  factory UserStats.fromMap(Map<String, dynamic> data) {
    return UserStats(
      totalXP: data['totalXP'] ?? 0,
      lessonsCompleted: data['lessonsCompleted'] ?? 0,
      currentStreak: data['currentStreak'] ?? 0,
      maxStreak: data['maxStreak'] ?? 0,
      achievementsUnlocked: data['achievementsUnlocked'] ?? 0,
      avgSessionTime: (data['avgSessionTime'] ?? 0.0).toDouble(),
      lastSessionDate: data['lastSessionDate']?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'totalXP': totalXP,
      'lessonsCompleted': lessonsCompleted,
      'currentStreak': currentStreak,
      'maxStreak': maxStreak,
      'achievementsUnlocked': achievementsUnlocked,
      'avgSessionTime': avgSessionTime,
      'lastSessionDate': lastSessionDate,
    };
  }

  UserStats copyWith({
    int? totalXP,
    int? lessonsCompleted,
    int? currentStreak,
    int? maxStreak,
    int? achievementsUnlocked,
    double? avgSessionTime,
    DateTime? lastSessionDate,
  }) {
    return UserStats(
      totalXP: totalXP ?? this.totalXP,
      lessonsCompleted: lessonsCompleted ?? this.lessonsCompleted,
      currentStreak: currentStreak ?? this.currentStreak,
      maxStreak: maxStreak ?? this.maxStreak,
      achievementsUnlocked: achievementsUnlocked ?? this.achievementsUnlocked,
      avgSessionTime: avgSessionTime ?? this.avgSessionTime,
      lastSessionDate: lastSessionDate ?? this.lastSessionDate,
    );
  }
}

class UserSettings {
  final bool notifications;
  final bool soundEnabled;
  final int dailyGoal; // in minutes
  final String preferredLanguage;
  final bool darkMode;
  final double speechRate;

  UserSettings({
    this.notifications = true,
    this.soundEnabled = true,
    this.dailyGoal = 30,
    this.preferredLanguage = 'en',
    this.darkMode = false,
    this.speechRate = 1.0,
  });

  factory UserSettings.fromMap(Map<String, dynamic> data) {
    return UserSettings(
      notifications: data['notifications'] ?? true,
      soundEnabled: data['soundEnabled'] ?? true,
      dailyGoal: data['dailyGoal'] ?? 30,
      preferredLanguage: data['preferredLanguage'] ?? 'en',
      darkMode: data['darkMode'] ?? false,
      speechRate: (data['speechRate'] ?? 1.0).toDouble(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'notifications': notifications,
      'soundEnabled': soundEnabled,
      'dailyGoal': dailyGoal,
      'preferredLanguage': preferredLanguage,
      'darkMode': darkMode,
      'speechRate': speechRate,
    };
  }

  UserSettings copyWith({
    bool? notifications,
    bool? soundEnabled,
    int? dailyGoal,
    String? preferredLanguage,
    bool? darkMode,
    double? speechRate,
  }) {
    return UserSettings(
      notifications: notifications ?? this.notifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      dailyGoal: dailyGoal ?? this.dailyGoal,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      darkMode: darkMode ?? this.darkMode,
      speechRate: speechRate ?? this.speechRate,
    );
  }
}
