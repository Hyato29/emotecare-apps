import 'package:emotcare_apps/app/ui/appbar_widget.dart';
import 'package:emotcare_apps/app/ui/history_report_item_widget.dart';
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/app/ui/profile_card_widget.dart';
import 'package:emotcare_apps/app/ui/labelform_widget.dart';
import 'package:emotcare_apps/app/ui/form_widget.dart';

import 'package:emotcare_apps/app/ui/date_form_widget.dart';
import 'package:emotcare_apps/features/report_complaint/presentation/cubit/report_complaint_cubit.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReportComplaintPage extends StatefulWidget {
  const ReportComplaintPage({super.key});

  @override
  State<ReportComplaintPage> createState() => _ReportComplaintPageState();
}

class _ReportComplaintPageState extends State<ReportComplaintPage> {
  final _symptomController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _dateController = TextEditingController();

  @override
  void dispose() {
    _symptomController.dispose();
    _frequencyController.dispose();
    _dateController.dispose();
    super.dispose();
  }

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

  // --- PERBAIKAN 1: GANTI FUNGSI INI ---
  // (Menggunakan showModalBottomSheet + DraggableScrollableSheet)
  void _showHistoryBottomSheet(BuildContext context) {
    context.read<ReportComplaintCubit>().fetchHistory();

    showModalBottomSheet(
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
            // Beri controller ke builder
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
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: bold,
                          color: primaryColor),
                    ),
                  ),
                  Expanded(
                    // Beri controller ke list
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
  // ------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(context),
      body: BlocListener<ReportComplaintCubit, ReportComplaintState>(
        listener: (context, state) {
          if (state is ReportComplaintSubmitSuccess) {
            _showSuccessDialog(context);

            _symptomController.clear();
            _frequencyController.clear();
            _dateController.clear();
          } else if (state is ReportComplaintSubmitFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.error)));
          }
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ProfileCardWidget(
                color: purpleColor,
              ),
              const SizedBox(height: 16),
              Text(
                'Apa keluhan terhadap perkembangan kondisi anda?',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: purpleColor),
              ),
              const SizedBox(height: 16),
              Center(
                  child: Image.asset('assets/images/report_complaint.jpg',
                      height: 120)),
              const SizedBox(height: 16),
              LabelformWidget(
                label: 'Bentuk Keluhan',
                color: purpleColor,
              ),
              const SizedBox(height: 8),
              FormWidget(
                label: 'Pilih keluhan yang anda rasakan',
                color: purpleColor,
                controller: _symptomController,
                options: const [
                  'Mual',
                  'Pusing',
                  'Kebas',
                  'Urin Berwarna Merah',
                  'Lainnya',
                ],
              ),
              const SizedBox(height: 8),
              LabelformWidget(
                label: 'Frekuensi Gejala/Tingkat Keparahan',
                color: purpleColor,
              ),
              const SizedBox(height: 8),
              FormWidget(
                label: 'Pilih Frekuensi',
                color: purpleColor,
                controller: _frequencyController,
                options: const ['Ringan', 'Sedang', 'Parah', 'Sangat Parah'],
              ),
              const SizedBox(height: 8),
              LabelformWidget(
                label: 'Tanggal Kejadian',
                color: purpleColor,
              ),
              const SizedBox(height: 8),
              DateFormWidget(
                  label: 'hh/bb/tttt',
                  color: purpleColor,
                  controller: _dateController),
              const SizedBox(height: 24),
              _buildReportButton(context),
              const SizedBox(height: 16),
              _buildHistoryButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportButton(BuildContext context) {
    return BlocBuilder<ReportComplaintCubit, ReportComplaintState>(
      builder: (context, state) {
        bool isLoading = (state is ReportComplaintSubmitLoading);
        return SizedBox(
          width: double.infinity,
          height: 60,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () {
                    context.read<ReportComplaintCubit>().submitReport(
                          symptom: _symptomController.text,
                          frequency: _frequencyController.text,
                          date: _dateController.text,
                        );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: purpleColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: isLoading
                ? const CircularProgressIndicator(color: Colors.white)
                : Text(
                    'LAPORKAN',
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

  Widget _buildHistoryButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        _showHistoryBottomSheet(context);
      },
      style: TextButton.styleFrom(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.keyboard_arrow_up, color: purpleColor),
          const SizedBox(width: 8),
          Text(
            'Lihat Riwayat Laporan',
            style: TextStyle(color: purpleColor, fontWeight: bold),
          ),
        ],
      ),
    );
  }

  // --- PERBAIKAN 2: Terima ScrollController dan hapus SizedBox ---
  Widget _buildHistoryListForBottomSheet(ScrollController scrollController) {
    // Hapus SizedBox(height: ...) yang membungkus BlocBuilder
    return BlocBuilder<ReportComplaintCubit, ReportComplaintState>(
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
            controller: scrollController, // <-- Terapkan controller di sini
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
  // -----------------------------------------------------------
}