// lib/features/medicine/data/models/medicine_model.dart
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';

class MedicineModel extends Medicine {
  const MedicineModel({
    required super.id,
    required super.name,
    required super.type,
    required super.manufacturer,
    required super.description,
    super.imageUrl,
  });

  factory MedicineModel.fromJson(Map<String, dynamic> json) {
    return MedicineModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      type: json['type'] ?? 'Generik',
      manufacturer: json['manufacturer'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['image_url'],
    );
  }
}