// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'puzzle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Puzzle _$PuzzleFromJson(Map<String, dynamic> json) => Puzzle(
      id: (json['id'] as num).toInt(),
      difficulty: (json['difficulty'] as num).toInt(),
      grid: (json['grid'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      solution: (json['solution'] as List<dynamic>)
          .map((e) =>
              (e as List<dynamic>).map((e) => (e as num).toInt()).toList())
          .toList(),
      hint: json['hint'] as String?,
    );

Map<String, dynamic> _$PuzzleToJson(Puzzle instance) => <String, dynamic>{
      'id': instance.id,
      'difficulty': instance.difficulty,
      'grid': instance.grid,
      'solution': instance.solution,
      'hint': instance.hint,
    };
