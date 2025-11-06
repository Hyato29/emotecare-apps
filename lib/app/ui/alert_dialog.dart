import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

/// Fungsi helper untuk menampilkan dialog kustom Anda
Future<void> showModernDialog({
  required BuildContext context,
  required String title,
  required String content,
  required IconData icon,
  required String confirmText,
  Color confirmColor = Colors.red, // Default warna merah untuk aksi destruktif
  String cancelText = 'Batal',
  VoidCallback? onConfirm,
}) {
  return showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return ModernAlertDialog(
        title: title,
        content: content,
        icon: icon,
        confirmText: confirmText,
        confirmColor: confirmColor,
        cancelText: cancelText,
        onConfirm: onConfirm,
      );
    },
  );
}

/// Widget UI Dialog yang Reusable
class ModernAlertDialog extends StatelessWidget {
  final String title;
  final String content;
  final IconData icon;
  final String confirmText;
  final Color confirmColor;
  final String cancelText;
  final VoidCallback? onConfirm;

  const ModernAlertDialog({
    super.key,
    required this.title,
    required this.content,
    required this.icon,
    required this.confirmText,
    required this.confirmColor,
    required this.cancelText,
    this.onConfirm,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
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
              color: confirmColor, // Gunakan warna konfirmasi
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

            // 4. Tombol Aksi
            Row(
              children: [
                // Tombol Batal
                Expanded(
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.grey[800],
                      side: BorderSide(color: Colors.grey[300]!),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(cancelText),
                    onPressed: () {
                      Navigator.of(context).pop(); // Tutup dialog
                    },
                  ),
                ),
                const SizedBox(width: 12),

                // Tombol Konfirmasi
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: confirmColor, // Gunakan warna konfirmasi
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(confirmText),
                    onPressed: () {
                      // Tutup dialog
                      Navigator.of(context).pop();
                      // Jalankan aksi konfirmasi jika ada
                      if (onConfirm != null) {
                        onConfirm!();
                      }
                    },
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}