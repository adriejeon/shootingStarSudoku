// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'character.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      imagePath: json['imagePath'] as String,
      requiredStars: (json['requiredStars'] as num).toInt(),
      isUnlocked: json['isUnlocked'] as bool? ?? false,
      type: $enumDecode(_$CharacterTypeEnumMap, json['type']),
    );

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'imagePath': instance.imagePath,
      'requiredStars': instance.requiredStars,
      'isUnlocked': instance.isUnlocked,
      'type': _$CharacterTypeEnumMap[instance.type]!,
    };

const _$CharacterTypeEnumMap = {
  CharacterType.star: 'star',
  CharacterType.planet: 'planet',
  CharacterType.comet: 'comet',
  CharacterType.asteroid: 'asteroid',
  CharacterType.moon: 'moon',
};
