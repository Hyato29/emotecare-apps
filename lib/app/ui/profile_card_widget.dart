import 'package:emotcare_apps/app/themes/colors.dart';
import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCardWidget extends StatelessWidget {
  final Color? color;
  const ProfileCardWidget({this.color, super.key});

  @override
  Widget build(BuildContext context) {
    String getGreeting() {
      final int currentHour = DateTime.now().hour;

      if (currentHour >= 3 && currentHour < 11) {
        return "Selamat Pagi"; // Jam 03:00 - 10:59
      } else if (currentHour >= 11 && currentHour < 15) {
        return "Selamat Siang"; // Jam 11:00 - 14:59
      } else if (currentHour >= 15 && currentHour < 18) {
        return "Selamat Sore"; // Jam 15:00 - 17:59
      } else {
        return "Selamat Malam"; // Jam 18:00 - 02:59
      }
    }

    String toTitleCase(String text) {
      if (text.isEmpty) {
        return '';
      }

      // Pisahkan nama berdasarkan spasi, ubah tiap kata, lalu gabungkan lagi
      return text
          .split(' ')
          .map((word) {
            if (word.isEmpty) return '';
            // Ubah huruf pertama jadi kapital, sisanya jadi lowercase
            return word[0].toUpperCase() + word.substring(1).toLowerCase();
          })
          .join(' ');
    }

    return BlocBuilder<AuthCubit, AuthState>(
      builder: (context, state) {
        String greeting = getGreeting();
        String userName = "Pengguna";

        if (state is Authenticated) {
          userName = toTitleCase(state.user.name);
        } else if (state is AuthLoading) {
          userName = "Memuat...";
        }
        return Container(
          width: double.infinity,
          height: 120,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color ?? primaryColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image(
                  image: AssetImage('assets/images/logo.jpg'),
                  width: 100,
                  height: 100,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white),
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      greeting,
                      style: TextStyle(
                        color: color ?? primaryColor,
                        fontSize: 14,
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: bold,
                    ),
                  ),
                  Text(
                    DateFormat(
                      'EEEE, d MMMM yyyy',
                      'id_ID',
                    ).format(DateTime.now()),
                    style: TextStyle(
                      color: greyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
