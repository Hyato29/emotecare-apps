// lib/features/medicine/presentation/pages/add_medicine_page.dart

import 'package:cached_network_image/cached_network_image.dart';
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/app/ui/form_widget.dart';
import 'package:emotcare_apps/app/ui/info_dialog.dart';
import 'package:emotcare_apps/app/ui/labelform_widget.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:go_router/go_router.dart';

class AddMedicinePage extends StatefulWidget {
  final Medicine medicine;
  const AddMedicinePage({super.key, required this.medicine});

  @override
  State<AddMedicinePage> createState() => _AddMedicinePageState();
}

class _AddMedicinePageState extends State<AddMedicinePage> {
  // Controller untuk form-form
  final _dosisController = TextEditingController();
  final _periodeController = TextEditingController();
  final _frekuensiController = TextEditingController();
  final _intruksiController = TextEditingController();

  @override
  void dispose() {
    _dosisController.dispose();
    _periodeController.dispose();
    _frekuensiController.dispose();
    _intruksiController.dispose();
    super.dispose();
  }

  void _submit() {
    // Panggil cubit untuk menambahkan resep
    context.read<PrescriptionCubit>().submitPrescription(
      medicineId: widget.medicine.id,
      dosage: _dosisController.text,
      duration: _periodeController
          .text, // Ganti ini jika Anda punya controller "Durasi"
      frequency: _frekuensiController.text,
      instructions: _intruksiController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarWidget(context),
      body: BlocListener<PrescriptionCubit, PrescriptionState>(
        listener: (context, state) {
          if (state is PrescriptionSuccess) {
            // Tampilkan dialog sukses
            showSuccessDialog(
              context: context,
              content: 'Pengingat berhasil ditambahkan.',
              onPressed: () {
                Navigator.of(context).pop(); // 1. Tutup dialog

                // --- PERBAIKAN DI SINI ---
                // Alur sebelumnya: [Home, Med, Search, Add]
                context
                    .pop(); // 2. Tutup AddMedicinePage. Stack: [Home, Med, Search]
                context
                    .pop(); // 3. Tutup MedicineSearchPage. Stack: [Home, Med]

                // 4. Buka PrescriptionPage di atas MedicinePage
                context.pushNamed('prescription');
                // Stack akhir: [Home, Med, Prescription]
                // -------------------------
              },
            );
          } else if (state is PrescriptionFailure) {
            // Tampilkan dialog error
            showErrorDialog(context: context, content: state.message);
          }
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailObatCard(widget.medicine),
                      const SizedBox(height: 32),

                      LabelformWidget(label: "Dosis"),
                      const SizedBox(height: 8),
                      FormWidget(
                        label: "Pilih Dosis",
                        controller: _dosisController,
                        options: const [
                          '1 tablet',
                          '2 tablet',
                          '1 sendok makan',
                        ],
                      ),
                      const SizedBox(height: 16),

                      LabelformWidget(label: "Periode Minum Obat"),
                      const SizedBox(height: 8),
                      FormWidget(
                        label: "Pilih Periode",
                        controller: _periodeController,
                        options: const ['7 hari', '14 hari', '30 hari'],
                      ),
                      const SizedBox(height: 16),

                      LabelformWidget(label: "Berapa Kali Sehari"),
                      const SizedBox(height: 8),
                      FormWidget(
                        label: "Pilih Frekuensi",
                        controller: _frekuensiController,
                        options: const ['1x sehari', '2x sehari', '3x sehari'],
                      ),
                      const SizedBox(height: 16),

                      LabelformWidget(label: "Intruksi Minum Obat"),
                      const SizedBox(height: 8),
                      FormWidget(
                        label: "Pilih Intruksi",
                        controller: _intruksiController,
                        options: const [
                          'Minum setelah makan',
                          'Minum sebelum makan',
                          'Minum saat makan',
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // --- PERBARUI TOMBOL SUBMIT ---
              BlocBuilder<PrescriptionCubit, PrescriptionState>(
                builder: (context, state) {
                  final bool isLoading = (state is PrescriptionLoading);

                  return SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                      ),
                      onPressed: isLoading
                          ? null
                          : _submit, // Panggil fungsi submit
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              'Tambah Pengingat',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget untuk menampilkan detail obat (Bagian atas)
  Widget _buildDetailObatCard(Medicine medicine) {
    String baseUrl = "${dotenv.env['BASE_URL']}/storage/";
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: Colors.grey[200]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gambar Placeholder
          Container(
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: medicine.imageUrl != null
                  ? CachedNetworkImage(
                      imageUrl: '$baseUrl${medicine.imageUrl}',
                      fit: BoxFit.cover,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                  : const Icon(
                      Icons.image_not_supported_outlined,
                      size: 50,
                      color: Colors.grey,
                    ),
            ),
          ),
          const SizedBox(width: 16),
          // Teks Detail
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  medicine.name,
                  style: TextStyle(fontSize: 16, fontWeight: bold),
                ),
                const SizedBox(height: 4),
                Text(
                  medicine.manufacturer,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: semiBold,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  medicine.description,
                  style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
