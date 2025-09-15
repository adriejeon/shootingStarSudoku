// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserProfileAdapter extends TypeAdapter<UserProfile> {
  @override
  final int typeId = 0;

  @override
  UserProfile read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserProfile(
      id: fields[0] as String,
      name: fields[1] as String,
      avatar: fields[2] as String,
      totalStars: fields[3] as int,
      completedPuzzles: (fields[4] as Map).cast<String, int>(),
      bestTimes: (fields[5] as Map).cast<String, int>(),
      completedLevels: (fields[8] as Map).cast<String, bool>(),
      visitedStages: (fields[9] as Map).cast<String, bool>(),
      createdAt: fields[6] as DateTime,
      lastPlayedAt: fields[7] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserProfile obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.avatar)
      ..writeByte(3)
      ..write(obj.totalStars)
      ..writeByte(4)
      ..write(obj.completedPuzzles)
      ..writeByte(5)
      ..write(obj.bestTimes)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.lastPlayedAt)
      ..writeByte(8)
      ..write(obj.completedLevels)
      ..writeByte(9)
      ..write(obj.visitedStages);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserProfile _$UserProfileFromJson(Map<String, dynamic> json) => UserProfile(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String,
      totalStars: (json['totalStars'] as num?)?.toInt() ?? 0,
      completedPuzzles:
          (json['completedPuzzles'] as Map<String, dynamic>?)?.map(
                (k, e) => MapEntry(k, (e as num).toInt()),
              ) ??
              const {},
      bestTimes: (json['bestTimes'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, (e as num).toInt()),
          ) ??
          const {},
      completedLevels: (json['completedLevels'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
          ) ??
          const {},
      visitedStages: (json['visitedStages'] as Map<String, dynamic>?)?.map(
            (k, e) => MapEntry(k, e as bool),
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
      'completedPuzzles': instance.completedPuzzles,
      'bestTimes': instance.bestTimes,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastPlayedAt': instance.lastPlayedAt.toIso8601String(),
      'completedLevels': instance.completedLevels,
      'visitedStages': instance.visitedStages,
    };
