// lib/features/prescription/data/models/prescription_model.dart
import 'package:emotcare_apps/features/medicine/data/models/medicine_model.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';

class PrescriptionModel extends Prescription {
  const PrescriptionModel({
    required super.id,
    required super.userId,
    required super.medicineId,
    required super.dosage,
    required super.duration,
    required super.frequency,
    required super.instructions,
    required super.medicine,
  });

  factory PrescriptionModel.fromJson(Map<String, dynamic> json) {
    return PrescriptionModel(
      id: json['id'] ?? 0,
      userId: json['user_id'] ?? 0,
      medicineId: json['medicine_id'] ?? 0,
      dosage: json['dosage'] ?? '',
      duration: json['duration'] ?? '',
      frequency: json['frequency'] ?? '',
      instructions: json['instructions'] ?? '',
      medicine: MedicineModel.fromJson(json['medicine']),
    );
  }
}