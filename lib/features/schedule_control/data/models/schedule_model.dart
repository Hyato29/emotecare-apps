// lib/features/schedule_control/data/models/schedule_model.dart
import 'package:emotcare_apps/features/schedule_control/domain/entities/schedule.dart';
import 'package:intl/intl.dart'; // <-- Import intl untuk format

class ScheduleModel extends Schedule {
  const ScheduleModel({
    required super.id,
    required super.scheduleDate,
    required super.scheduleTime,
    required super.location,
    required super.status,
  });

  factory ScheduleModel.fromJson(Map<String, dynamic> json) {
    // Default values
    String date = 'Tanggal tidak diketahui';
    String time = '00:00 WIB';
    
    // Coba parsing tanggal dari API
    try {
      if (json['scheduled_at'] != null) {
        final dateTime = DateTime.parse(json['scheduled_at']);
        // Format ke "Senin, 6 Oktober 2025" (Contoh)
        date = DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(dateTime); 
        // Format ke "10:10 WIB" (Contoh)
        time = DateFormat('HH:mm', 'id_ID').format(dateTime) + ' WIB'; 
      }
    } catch (e) {
      // Biarkan nilai default jika parsing gagal
    }

    return ScheduleModel(
      id: json['id'] ?? 0,
      scheduleDate: date, // <-- Gunakan tanggal yang sudah diformat
      scheduleTime: time, // <-- Gunakan waktu yang sudah diformat
      // API Anda tidak mengirim 'location', jadi kita beri default
      location: json['location'] ?? 'Klinik Emotcare', 
      status: json['status'] ?? 'scheduled',
    );
  }
}