// lib/features/prescription/domain/entities/prescription.dart
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:equatable/equatable.dart';

class Prescription extends Equatable {
  final int id;
  final int userId;
  final int medicineId;
  final String dosage;
  final String duration;
  final String frequency;
  final String instructions;
  final Medicine medicine; // Kita sertakan detail obat

  const Prescription({
    required this.id,
    required this.userId,
    required this.medicineId,
    required this.dosage,
    required this.duration,
    required this.frequency,
    required this.instructions,
    required this.medicine,
  });

  @override
  List<Object?> get props => [id, userId, medicineId, dosage, duration, frequency];
}