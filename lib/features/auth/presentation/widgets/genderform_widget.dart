import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';

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

Future<T?> showMyBottomSheet<T>({
  required BuildContext context,
  Widget? title,
  required Widget child,
  bool isClosable = true,
  bool useCustomLayout = false,
}) {
  return showModalBottomSheet<T>(
    context: context,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(178),
    isDismissible: false,
    isScrollControlled: true,
    enableDrag: false,
    useSafeArea: true,
    builder: (BuildContext context) {
      if (useCustomLayout) return child;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (isClosable) ...[
            _close(context),
            const SizedBox(height: 16),
          ],
          Flexible(
            child: BfiBottomSheetLayout(
              title: title,
              isClosable: false,
              child: child,
            ),
          ),
        ],
      );
    },
  );
}

Widget _close(BuildContext context) {
  return Row(
    children: [
      const Spacer(),
      Material(
        key: const Key('close_button'),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: () {
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.close, color: Colors.black),
          ),
        ),
      ),
      const SizedBox(width: 20),
    ],
  );
}

class BfiBottomSheetLayout extends StatelessWidget {
  const BfiBottomSheetLayout({
    super.key,
    this.title,
    this.isClosable = true,
    required this.child,
  });

  final Widget? title;
  final Widget child;
  final bool isClosable;

  @override
  Widget build(BuildContext context) {
    return Column(
      key: const Key('bottom_sheet'),
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isClosable) ...[
          _close(context),
          const SizedBox(height: 16),
        ],
        Flexible(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(16),
              ),
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (title != null) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ),
                      child: DefaultTextStyle(
                        style: const TextStyle(fontSize: 16, color: Colors.black),
                        child: title!,
                      ),
                    ),
                    const Divider(height: 1),
                  ],
                  Flexible(child: child),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}