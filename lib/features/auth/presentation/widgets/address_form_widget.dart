import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:flutter/material.dart';

class AddressFormWidget extends StatelessWidget {
  final TextEditingController controller;
  final void Function()? onTap;
  final bool isLocationLoading;

  const AddressFormWidget({
    required this.controller,
    required this.onTap,
    required this.isLocationLoading,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: "Tekan untuk mengambil alamat GPS",
        hintStyle: TextStyle(color: greyColor),
        suffixIcon: isLocationLoading
            ? Container(
                padding: const EdgeInsets.all(16.0),
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: primaryColor,
                ),
              )
            : Icon(Icons.gps_fixed, color: primaryColor),
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
      ),
    );
  }
}
