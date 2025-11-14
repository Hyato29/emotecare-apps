import 'package:emotcare_apps/app/themes/fontweight.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfileCardWidget extends StatelessWidget {
  const ProfileCardWidget({super.key});

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
      return text
          .split(' ')
          .map((word) {
            if (word.isEmpty) return '';
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
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipOval(
                  child: Image(
                    image: AssetImage('assets/images/logo.png'),
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                  ),
                ),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      greeting,
                      style: TextStyle(
                        color: Colors.black54,
                        fontSize: 18,
                        fontWeight: semiBold,
                      ),
                    ),
                    Text(
                      userName,
                      style: TextStyle(fontSize: 16, color: Colors.black87),
                    ),
                  ],
                ),
              ],
            ),
            Image(
              image: AssetImage('assets/images/logo.png'),
              width: 100,
              height: 100,
              fit: BoxFit.contain,
            ),
          ],
        );
      },
    );
  }
}
