// lib/app/widgets/info_dialog.dart
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

/// Menampilkan dialog SUKSES yang modern.
Future<void> showSuccessDialog({
  required BuildContext context,
  required String content,
  String title = 'Berhasil',
  String buttonText = 'OK',
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return InfoDialog(
        title: title,
        content: content,
        icon: Icons.check_circle_outline_rounded,
        iconColor: Colors.green,
        buttonText: buttonText,
        onPressed: onPressed ?? () {
          Navigator.of(dialogContext).pop(); // Tutup dialog
        },
      );
    },
  );
}

/// Menampilkan dialog ERROR yang modern.
Future<void> showErrorDialog({
  required BuildContext context,
  required String content,
  String title = 'Gagal',
  String buttonText = 'Tutup',
  VoidCallback? onPressed,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return InfoDialog(
        title: title,
        content: content,
        icon: Icons.cancel,
        iconColor: Colors.red,
        buttonText: buttonText,
        onPressed: onPressed ?? () {
          Navigator.of(dialogContext).pop(); // Tutup dialog
        },
      );
    },
  );
}

/// Widget UI Dialog yang Reusable
class InfoDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final Color iconColor;
  final String buttonText;
  final VoidCallback onPressed;

  const InfoDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.iconColor,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min, // Agar dialog pas dengan konten
          children: [
            // 1. Ikon
            Icon(
              icon,
              color: iconColor,
              size: 50,
            ),
            const SizedBox(height: 16),

            // 2. Judul
            Text(
              title,
              style: TextStyle(
                fontSize: 20,
                fontWeight: bold, // Menggunakan style dari theme Anda
              ),
            ),
            const SizedBox(height: 8),

            // 3. Konten
            Text(
              content,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(height: 24),

            // 4. Tombol Aksi (Satu Tombol)
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: iconColor, // Warna tombol = warna ikon
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                onPressed: onPressed,
                child: Text(buttonText), // Panggil aksi
              ),
            ),
          ],
        ),
      ),
    );
  }
}