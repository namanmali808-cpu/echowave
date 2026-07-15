import 'package:echowave/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.name,
    required super.email,
    super.phone,
    super.avatarUrl,
    super.isPremium,
    super.premiumUntil,
    required super.createdAt,
    super.language,
    super.darkMode,
    super.notificationsEnabled,
    super.streamingQuality,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      avatarUrl: json['avatar_url'] as String? ?? json['avatarUrl'] as String? ?? '',
      isPremium: json['is_premium'] as bool? ?? json['isPremium'] as bool? ?? false,
      premiumUntil: json['premium_until'] != null
          ? DateTime.parse(json['premium_until'] as String)
          : json['premiumUntil'] != null
              ? DateTime.parse(json['premiumUntil'] as String)
              : null,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : json['createdAt'] != null
              ? DateTime.parse(json['createdAt'] as String)
              : DateTime.now(),
      language: json['language'] as String? ?? 'en',
      darkMode: json['dark_mode'] as bool? ?? json['darkMode'] as bool? ?? false,
      notificationsEnabled: json['notifications_enabled'] as bool? ??
          json['notificationsEnabled'] as bool? ??
          true,
      streamingQuality: json['streaming_quality'] as String? ??
          json['streamingQuality'] as String? ??
          'high',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'is_premium': isPremium,
      'premium_until': premiumUntil?.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
      'language': language,
      'dark_mode': darkMode,
      'notifications_enabled': notificationsEnabled,
      'streaming_quality': streamingQuality,
    };
  }

  User toEntity() {
    return User(
      id: id,
      name: name,
      email: email,
      phone: phone,
      avatarUrl: avatarUrl,
      isPremium: isPremium,
      premiumUntil: premiumUntil,
      createdAt: createdAt,
      language: language,
      darkMode: darkMode,
      notificationsEnabled: notificationsEnabled,
      streamingQuality: streamingQuality,
    );
  }

  factory UserModel.fromEntity(User user) {
    return UserModel(
      id: user.id,
      name: user.name,
      email: user.email,
      phone: user.phone,
      avatarUrl: user.avatarUrl,
      isPremium: user.isPremium,
      premiumUntil: user.premiumUntil,
      createdAt: user.createdAt,
      language: user.language,
      darkMode: user.darkMode,
      notificationsEnabled: user.notificationsEnabled,
      streamingQuality: user.streamingQuality,
    );
  }

  @override
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? avatarUrl,
    bool? isPremium,
    DateTime? premiumUntil,
    DateTime? createdAt,
    String? language,
    bool? darkMode,
    bool? notificationsEnabled,
    String? streamingQuality,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      isPremium: isPremium ?? this.isPremium,
      premiumUntil: premiumUntil ?? this.premiumUntil,
      createdAt: createdAt ?? this.createdAt,
      language: language ?? this.language,
      darkMode: darkMode ?? this.darkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      streamingQuality: streamingQuality ?? this.streamingQuality,
    );
  }
}
