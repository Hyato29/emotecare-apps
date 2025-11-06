import 'package:emotcare_apps/app/ui/bottom_sheet_widget.dart';
import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

// WIDGET UTAMA ANDA (ADD MEDICINE FORM)
class FormWidget extends StatefulWidget {
  final String label;
  final Color? color;
  final List<String> options;
  final TextEditingController controller;

  const FormWidget({
    super.key,
    required this.label,
    this.color,
    required this.controller,
    required this.options,
  });

  @override
  State<FormWidget> createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  // Fungsi _showOptionPicker sekarang memanggil UI kustom Anda
  void _showOptionPicker(BuildContext context) async {
    final String? selectedValue = await showMyBottomSheet<String>(
      context: context,
      // 1. Sediakan widget untuk judul (title)
      title: Text(
        widget.label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: bold,
          color: widget.color ?? primaryColor,
        ),
      ),
      // 2. Sediakan widget untuk konten (child), yaitu daftar pilihan
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8), // Beri sedikit padding
        itemCount: widget.options.length,
        itemBuilder: (context, index) {
          final value = widget.options[index];
          return ListTile(
            title: Text(
              value,
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: semiBold),
            ),
            onTap: () {
              // Aksi tetap sama: tutup modal dan kirim nilai
              Navigator.of(context).pop(value);
            },
          );
        },
      ),
    );

    // Logika untuk memperbarui controller tetap sama
    if (selectedValue != null) {
      setState(() {
        widget.controller.text = selectedValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Tidak ada perubahan pada build method, sudah benar
    return TextFormField(
      controller: widget.controller,
      readOnly: true,
      style: TextStyle(color: widget.color ?? primaryColor, fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: TextStyle(color: greyColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.color ?? primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: widget.color ?? primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        suffixIcon: Icon(Icons.keyboard_arrow_down, color: widget.color ?? primaryColor),
      ),
      onTap: () {
        _showOptionPicker(context);
      },
    );
  }
}
