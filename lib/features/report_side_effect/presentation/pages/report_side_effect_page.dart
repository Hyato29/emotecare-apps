// lib/features/report_side_effect/presentation/pages/report_side_effect_page.dart
// (Pastikan semua import ini sesuai dengan path di proyek Anda)
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/date_form_widget.dart'; // Untuk input tanggal
import 'package:emotcare_apps/app/ui/form_widget.dart'; // Untuk dropdown
import 'package:emotcare_apps/app/ui/history_report_item_widget.dart'; // Untuk bottom sheet
import 'package:emotcare_apps/features/report_side_effect/presentation/cubit/report_side_effect_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart'; // Untuk context.pop()

class ReportSideEffectPage extends StatefulWidget {
  const ReportSideEffectPage({super.key});

  @override
  State<ReportSideEffectPage> createState() => _ReportSideEffectPageState();
}

class _ReportSideEffectPageState extends State<ReportSideEffectPage> {
  // --- KEMBALIKAN CONTROLLER ---
  final _symptomController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _dateController = TextEditingController();
  // -----------------------------

  @override
  void dispose() {
    // --- KEMBALIKAN DISPOSE ---
    _symptomController.dispose();
    _frequencyController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  // --- FUNGSI DIALOG SUKSES (dikembalikan) ---
  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext dialogContext) {
        return GestureDetector(
          onTap: () => Navigator.of(dialogContext).pop(),
          child: Dialog(
            backgroundColor: Colors.transparent,
            insetPadding: const EdgeInsets.all(24),
            child: Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 70, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Laporan Berhasil Terkirim',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: bold,
                          color: primaryColor,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Tekan dimana saja untuk keluar',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: -50,
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.white,
                      size: 70,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // --- FUNGSI BOTTOM SHEET RIWAYAT (dikembalikan) ---
  void _showHistoryBottomSheet(BuildContext context) {
    context.read<ReportSideEffectCubit>().fetchHistory();

    showModalBottomSheet( // Ganti showMyBottomSheet dengan showModalBottomSheet
      context: context,
      isScrollControlled: true, // Agar bisa ambil tinggi penuh
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.6, // Tinggi awal 60%
          minChildSize: 0.3,
          maxChildSize: 0.9,
          expand: false,
          builder: (_, scrollController) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'Riwayat Laporan',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 18, fontWeight: bold, color: primaryColor),
                    ),
                  ),
                  Expanded(
                    child: _buildHistoryListForBottomSheet(scrollController),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // --- Widget Riwayat untuk Bottom Sheet (dikembalikan) ---
  Widget _buildHistoryListForBottomSheet(ScrollController scrollController) {
    return BlocBuilder<ReportSideEffectCubit, ReportSideEffectState>(
      builder: (context, state) {
        if (state is HistoryLoading) {
          return Center(
            child: CircularProgressIndicator(color: primaryColor),
          );
        }
        if (state is HistoryError) {
          return Center(
            child: Text(
              state.error,
              style: const TextStyle(color: Colors.black),
            ),
          );
        }
        if (state is HistoryLoaded) {
          if (state.historyList.isEmpty) {
            return const Center(
              child: Text(
                "Belum ada riwayat laporan.",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }
          return ListView.builder(
            controller: scrollController, // Penting untuk DraggableScrollableSheet
            itemCount: state.historyList.length,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            itemBuilder: (context, index) {
              final item = state.historyList[index];
              return Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: HistoryReportItemWidget(
                  date: item.date,
                  symptom: item.symptom,
                ),
              );
            },
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100], // Sesuaikan warna latar belakang
      // --- APPBAR SESUAI GAMBAR ---
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.grey.shade700),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          "Gejala Efek Samping",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600, // Semi-bold
            fontSize: 18,
          ),
        ),
      ),
      // --- BODY DENGAN FORM ---
      body: BlocListener<ReportSideEffectCubit, ReportSideEffectState>(
        listener: (context, state) {
          if (state is ReportSubmitSuccess) {
            _showSuccessDialog(context);
            _symptomController.clear();
            _frequencyController.clear();
            _dateController.clear();
          } else if (state is ReportSubmitFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20), // Sesuaikan padding
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian "Tuliskan Gejala Anda" dan "Riwayat"
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tuliskan Gejala Anda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: bold,
                      color: Colors.black87,
                    ),
                  ),
                  InkWell(
                    onTap: () => _showHistoryBottomSheet(context),
                    child: Row(
                      children: [
                        Text(
                          'Riwayat',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: bold,
                            color: primaryColor,
                          ),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: primaryColor,
                          size: 16,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // --- FORM INPUTS ---
              Text(
                'Gejala Efek Samping',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: semiBold, // Gunakan semibold jika ada
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              FormWidget(
                label: 'Pilih gejala efek samping',
                controller: _symptomController,
                options: const [
                  'Mual', 'Pusing', 'Lelah', 'Ruam Kulit', 'Diare', 'Sembelit',
                  'Kebas', 'Urin Berwarna Merah', 'Lainnya',
                ],
              ),
              const SizedBox(height: 16),

              Text(
                'Frekuensi Gejala',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: semiBold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              FormWidget(
                label: 'Frekuensi Gejala',
                controller: _frequencyController,
                options: const ['Ringan', 'Sedang', 'Parah', 'Sangat Parah'],
              ),
              const SizedBox(height: 16),

              Text(
                'Tanggal Kejadian',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: semiBold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 8),
              DateFormWidget(label: 'Tanggal Kejadian', controller: _dateController),
              const SizedBox(height: 32),

              // --- TOMBOL SIMPAN ---
              _buildSaveButton(context),
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Tombol Simpan (diganti dari _buildReportButton) ---
  Widget _buildSaveButton(BuildContext context) {
    return BlocBuilder<ReportSideEffectCubit, ReportSideEffectState>(
      builder: (context, state) {
        bool isLoading = (state is ReportSubmitLoading);
        return SizedBox(
          width: double.infinity,
          height: 55, // Sesuaikan tinggi tombol
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<ReportSideEffectCubit>().submitReport(
                          symptom: _symptomController.text,
                          frequency: _frequencyController.text,
                          date: _dateController.text,
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF4C8CD6), // Warna biru sesuai gambar
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15), // Radius lebih besar
              ),
              elevation: 0, // Hapus shadow
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'Simpan',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: bold,
                    ),
                  ),
          ),
        );
      },
    );
  }
}