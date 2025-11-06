import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

// --- TAMBAHKAN IMPORT INI ---
import 'package:emotcare_apps/app/ui/bottom_sheet_widget.dart';
// ---------------------------

// WIDGET UTAMA (GENDER FORM)
class GenderformWidget extends StatefulWidget {
  final String label;
  final TextEditingController controller;
  const GenderformWidget({
    required this.label,
    required this.controller,
    super.key,
  });

  @override
  State<GenderformWidget> createState() => _GenderformWidgetState();
}

class _GenderformWidgetState extends State<GenderformWidget> {
  // Daftar pilihan tetap di sini karena spesifik untuk gender
  final List<String> genderOptions = ['Laki-laki', 'Perempuan'];

  // Fungsi untuk menampilkan bottom sheet
  void _showGenderPicker(BuildContext context) async {
    // Menunggu hasil pilihan dari bottom sheet kustom
    final String? selectedValue = await showMyBottomSheet<String>(
      context: context,
      // 1. Sediakan widget untuk judul (title)
      title: Text(
        'Pilih Jenis Kelamin',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18,
          fontWeight: bold,
          color: primaryColor,
        ),
      ),
      // 2. Sediakan widget untuk konten (child)
      child: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: genderOptions.length,
        itemBuilder: (context, index) {
          final value = genderOptions[index];
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
      style: TextStyle(color: primaryColor, fontSize: 16),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: widget.label,
        hintStyle: TextStyle(color: greyColor),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(color: primaryColor),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        suffixIcon: Icon(Icons.keyboard_arrow_down, color: primaryColor),
      ),
      onTap: () {
        _showGenderPicker(context);
      },
    );
  }
}