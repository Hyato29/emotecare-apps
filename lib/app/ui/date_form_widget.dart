import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// --- TAMBAHKAN IMPORT INI ---
import 'package:emotcare_apps/app/ui/bottom_sheet_widget.dart';
// ---------------------------

class DateFormWidget extends StatefulWidget {
  final String label;
  final Color? color;
  final TextEditingController controller;

  const DateFormWidget({
    super.key,
    required this.label,
    this.color,
    required this.controller,
  });

  @override
  State<DateFormWidget> createState() => _DateFormWidgetState();
}

class _DateFormWidgetState extends State<DateFormWidget> {
  void _showDatePicker(BuildContext context) {
    DateTime selectedDate = DateTime.now();

    try {
      selectedDate = DateFormat('dd-MM-yyyy').parse(widget.controller.text);
    } catch (e) {
      selectedDate = DateTime.now();
    }

    showMyBottomSheet(
      context: context,
      title: Text(
        "Pilih Tanggal",
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: 18,
            fontWeight: bold,
            color: widget.color ?? primaryColor),
      ),
      // --- PERBAIKAN DI SINI ---
      // Bungkus child dengan SingleChildScrollView agar kalender bisa di-scroll
      child: SingleChildScrollView(
        child: StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CalendarDatePicker(
                  initialDate: selectedDate,
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2101),
                  onDateChanged: (DateTime newDate) {
                    setModalState(() {
                      selectedDate = newDate;
                    });
                  },
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: widget.color ?? primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      onPressed: () {
                        setState(() {
                          widget.controller.text = DateFormat(
                            'dd-MM-yyyy',
                          ).format(selectedDate);
                        });
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Selesai',
                        style: TextStyle(color: Colors.white, fontWeight: bold),
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
      // ---------------------------
    );
  }

  @override
  Widget build(BuildContext context) {
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
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        suffixIcon:
            Icon(Icons.calendar_month, color: widget.color ?? primaryColor),
      ),
      onTap: () {
        _showDatePicker(context);
      },
    );
  }
}