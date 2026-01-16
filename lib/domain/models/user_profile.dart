class UserProfile {
  final String userId;
  final String? name;
  final String? theme;
  final String? accent;
  final double? fontScale;
  final String? notificationTime;
  final String? avatarUrl;

  UserProfile({
    required this.userId,
    this.name,
    this.theme,
    this.accent,
    this.fontScale,
    this.notificationTime,
    this.avatarUrl,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      name: json['name'] as String?,
      theme: json['theme'] as String?,
      accent: json['accent'] as String?,
      fontScale: (json['font_scale'] != null)
          ? (json['font_scale'] as num).toDouble()
          : null,
      notificationTime: json['notification_time'] as String?,
      avatarUrl: json['avatar_url'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'theme': theme,
      'accent': accent,
      'font_scale': fontScale,
      'notification_time': notificationTime,
      'avatar_url': avatarUrl,
    };
  }
}
