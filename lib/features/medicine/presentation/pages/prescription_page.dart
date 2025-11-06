// lib/features/medicine/presentation/pages/medicine_page.dart
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/prescription.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_list_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
// import 'package:intl/intl.dart';

class PrescriptionPage extends StatefulWidget {
  const PrescriptionPage({super.key});

  @override
  State<PrescriptionPage> createState() => _PrescriptionPageState();
}

class _PrescriptionPageState extends State<PrescriptionPage> {
  @override
  void initState() {
    super.initState();
    // Panggil data saat halaman pertama kali dimuat
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PrescriptionListCubit>().fetchPrescriptions();
    });
  }

  // Helper untuk format tanggal (Anda bisa perbaiki ini)
  // String _formatDate(String isoDate) {
  //   try {
  //     final date = DateTime.parse(isoDate);
  //     return DateFormat('EEEE, d MMMM yyyy', 'id_ID').format(date);
  //   } catch (e) {
  //     return isoDate; // Fallback
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Daftar Pengingat",
          style: TextStyle(color: Colors.black, fontWeight: bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          // Tambahkan fitur refresh
          context.read<PrescriptionListCubit>().fetchPrescriptions();
        },
        child: BlocBuilder<PrescriptionListCubit, PrescriptionListState>(
          builder: (context, state) {
            if (state is PrescriptionListLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is PrescriptionListError) {
              return Center(child: Text(state.message));
            }
            if (state is PrescriptionListLoaded) {
              if (state.prescriptions.isEmpty) {
                return const Center(child: Text("Belum ada pengingat ditambahkan."));
              }
              // Jika data ada, tampilkan ListView
              return ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                itemCount: state.prescriptions.length,
                itemBuilder: (context, index) {
                  final prescription = state.prescriptions[index];
                  return _buildReminderItem(prescription);
                },
              );
            }
            return const SizedBox.shrink(); // State Initial
          },
        ),
      ),
      // Tombol "Tambah Pengingat"
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        width: double.infinity,
        height: 60,
        margin: const EdgeInsets.symmetric(horizontal: 28),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
          onPressed: () {
            context.goNamed('medicine');
          },
          child: Text(
            'Kembali',
            style: TextStyle(
              fontSize: 18,
              fontWeight: bold,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  // Widget untuk satu item pengingat
  Widget _buildReminderItem(Prescription prescription) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 5,
            offset: const Offset(0, 3),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(Icons.calendar_today_outlined, color: Colors.grey[600]),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // Data tanggal tidak ada di API, jadi kita gunakan "Frequency"
                  // atau "Duration" sebagai judul
                  prescription.frequency,
                  style: TextStyle(fontWeight: bold, fontSize: 16),
                ),
                const SizedBox(height: 4),
                Text(
                  prescription.medicine.name,
                  style: TextStyle(color: Colors.grey[700], fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Text(
            // Data waktu tidak ada, kita tampilkan dosis
            prescription.dosage,
            style: TextStyle(
              color: primaryColor,
              fontWeight: bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}