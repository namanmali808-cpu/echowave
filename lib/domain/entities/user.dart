import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String phone;
  final String avatarUrl;
  final bool isPremium;
  final DateTime? premiumUntil;
  final DateTime createdAt;
  final String language;
  final bool darkMode;
  final bool notificationsEnabled;
  final String streamingQuality;

  const User({
    required this.id,
    required this.name,
    required this.email,
    this.phone = '',
    this.avatarUrl = '',
    this.isPremium = false,
    this.premiumUntil,
    required this.createdAt,
    this.language = 'en',
    this.darkMode = false,
    this.notificationsEnabled = true,
    this.streamingQuality = 'high',
  });

  User copyWith({
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
    return User(
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

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        avatarUrl,
        isPremium,
        premiumUntil,
        createdAt,
        language,
        darkMode,
        notificationsEnabled,
        streamingQuality,
      ];
}
