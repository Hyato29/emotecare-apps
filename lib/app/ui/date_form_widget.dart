import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

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
        style: TextStyle(fontSize: 18, fontWeight: bold, color: widget.color ?? primaryColor),
      ),

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
        suffixIcon: Icon(Icons.calendar_month, color: widget.color ?? primaryColor),
      ),
      onTap: () {
        _showDatePicker(context);
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
          if (isClosable) ...[_close(context), const SizedBox(height: 16)],
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
        if (isClosable) ...[_close(context), const SizedBox(height: 16)],
        Flexible(
          child: Material(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
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
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        child: title!,
                      ),
                    ),
                    const Divider(height: 1),
                  ],

                  Flexible(child: SingleChildScrollView(child: child)),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
