import 'package:json_annotation/json_annotation.dart';

part 'character.g.dart';

@JsonSerializable()
class Character {
  final String id;
  final String name;
  final String description;
  final String imagePath;
  final int requiredStars;
  final bool isUnlocked;
  final CharacterType type;

  const Character({
    required this.id,
    required this.name,
    required this.description,
    required this.imagePath,
    required this.requiredStars,
    this.isUnlocked = false,
    required this.type,
  });

  factory Character.fromJson(Map<String, dynamic> json) => _$CharacterFromJson(json);
  Map<String, dynamic> toJson() => _$CharacterToJson(this);

  Character copyWith({
    String? id,
    String? name,
    String? description,
    String? imagePath,
    int? requiredStars,
    bool? isUnlocked,
    CharacterType? type,
  }) {
    return Character(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      requiredStars: requiredStars ?? this.requiredStars,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      type: type ?? this.type,
    );
  }
}

enum CharacterType {
  @JsonValue('star')
  star,
  @JsonValue('planet')
  planet,
  @JsonValue('comet')
  comet,
  @JsonValue('asteroid')
  asteroid,
  @JsonValue('moon')
  moon,
}
