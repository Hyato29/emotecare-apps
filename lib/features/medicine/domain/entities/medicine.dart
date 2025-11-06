// lib/features/medicine/domain/entities/medicine.dart
import 'package:equatable/equatable.dart';

class Medicine extends Equatable {
  final int id;
  final String name;
  final String type;
  final String manufacturer;
  final String description;
  final String? imageUrl;

  const Medicine({
    required this.id,
    required this.name,
    required this.type,
    required this.manufacturer,
    required this.description,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [id, name, type, manufacturer, description, imageUrl];
}