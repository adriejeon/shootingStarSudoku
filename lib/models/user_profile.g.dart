// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
      unlockedCharacters: (json['unlockedCharacters'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      completedPuzzles:
          (json['completedPuzzles'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      bestTimes: (json['bestTimes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
    );

Map<String, dynamic> _$UserProfileToJson(UserProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'avatar': instance.avatar,
      'totalStars': instance.totalStars,
      'unlockedCharacters': instance.unlockedCharacters,
      'completedPuzzles': instance.completedPuzzles,
      'bestTimes': instance.bestTimes,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastPlayedAt': instance.lastPlayedAt.toIso8601String(),
    };
