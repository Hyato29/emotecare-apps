// lib/app/routes/routes.dart

import 'package:emotcare_apps/app/ui/splash_page.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/auth/presentation/pages/login_page.dart';
import 'package:emotcare_apps/features/auth/presentation/pages/register_page.dart';
import 'package:emotcare_apps/features/comming_soon.dart';
import 'package:emotcare_apps/features/video_education/presentation/pages/video_education_page.dart';
import 'package:emotcare_apps/features/fingerprint/presentation/pages/fingerprint_page.dart';
import 'package:emotcare_apps/features/home/presentation/pages/health_center_home_page.dart';
import 'package:emotcare_apps/features/home/presentation/pages/patient_home_page.dart';
import 'package:emotcare_apps/features/medicine/domain/entities/medicine.dart';
import 'package:emotcare_apps/features/medicine/presentation/pages/add_medicine_page.dart';
import 'package:emotcare_apps/features/medicine/presentation/pages/medicine_page.dart';
import 'package:emotcare_apps/features/medicine/presentation/pages/medicine_search_page.dart';
import 'package:emotcare_apps/features/medicine/presentation/pages/prescription_page.dart';
import 'package:emotcare_apps/features/report_complaint/presentation/pages/report_complaint_page.dart';
import 'package:emotcare_apps/features/report_side_effect/presentation/pages/report_side_effect_page.dart';
import 'package:emotcare_apps/features/schedule_control/presentation/pages/schedule_control_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  final AuthCubit authCubit;
  late final GoRouter router;

  AppRouter({required this.authCubit}) {
    router = GoRouter(
      initialLocation: '/',
      refreshListenable: GoRouterRefreshStream(authCubit.stream),

      redirect: (BuildContext context, GoRouterState state) {
        final authState = authCubit.state;

        final onSplash = state.matchedLocation == '/';
        final onAuthRoute =
            state.matchedLocation == '/auth' ||
            state.matchedLocation == '/login' ||
            state.matchedLocation == '/register';

        // --- PERBAIKAN DI SINI ---
        if (authState is AuthInitial || authState is AuthLoading) {
          // Ganti baris ini:
          // return onSplash ? null : '/';

          // Menjadi ini:
          return null;
          // Alasan: Biarkan pengguna TETAP di halaman saat ini
          // (misal: LoginPage atau FingerprintPage)
          // dan biarkan BlocBuilder di halaman itu yang menampilkan loading.
        }
        // -------------------------

        if (authState is Unauthenticated) {
          return onAuthRoute ? null : '/auth';
        }

        if (authState is Authenticated) {
          if (onSplash || onAuthRoute) {
            final role = authState.user.role?.toLowerCase().trim();

            if (role == 'patient') {
              return '/home-patient';
            } else if (role == 'healt_center' || role == 'admin') {
              return '/home-health-center';
            } else {
              return '/home-patient';
            }
          }
        }

        return null; // Biarkan
      },

      // Daftar rute Anda (tidak berubah)
      routes: <RouteBase>[
        GoRoute(
          path: '/',
          name: 'splash',
          builder: (BuildContext context, GoRouterState state) {
            return const SplashPage();
          },
        ),
        GoRoute(
          path: '/auth',
          name: 'loginFinger',
          builder: (BuildContext context, GoRouterState state) {
            return const FingerPrintPage();
          },
        ),
        GoRoute(
          path: '/login',
          name: 'login',
          builder: (BuildContext context, GoRouterState state) {
            return const LoginPage();
          },
        ),
        GoRoute(
          path: '/register',
          name: 'register',
          builder: (BuildContext context, GoRouterState state) {
            return const RegisterPage();
          },
        ),
        GoRoute(
          path: '/home-patient',
          name: 'home_patient',
          builder: (context, state) => PatientHomePage(),
        ),
        GoRoute(
          path: '/home-health-center',
          name: 'home_health_center',
          builder: (context, state) => const HealthCenterHomePage(),
        ),
        GoRoute(
          path: '/medicine',
          name: 'medicine',
          builder: (BuildContext context, GoRouterState state) {
            return MedicinePage();
          },
        ),
        GoRoute(
          path: '/add_medicine',
          name: 'add_medicine',
          builder: (BuildContext context, GoRouterState state) {
            // Ambil objek Medicine yang dikirim dari halaman search
            final Medicine medicine = state.extra as Medicine;
            return AddMedicinePage(medicine: medicine);
          },
        ),
        GoRoute(
          path: '/medicine_search',
          name: 'medicine_search',
          builder: (BuildContext context, GoRouterState state) {
            return MedicineSearchPage();
          },
        ),
        GoRoute(
          path: '/prescription',
          name: 'prescription',
          builder: (BuildContext context, GoRouterState state) {
            // Pastikan ini menunjuk ke halaman daftar pengingat
            return const PrescriptionPage();
          },
        ),
        GoRoute(
          path: '/education',
          name: 'education',
          builder: (BuildContext context, GoRouterState state) {
            return VideoEducationPage();
          },
        ),

        GoRoute(
          path: '/schedule_control',
          name: 'schedule_control',
          builder: (BuildContext context, GoRouterState state) {
            return ScheduleControlPage();
          },
        ),
        GoRoute(
          path: '/report_side_effect',
          name: 'report_side_effect',
          builder: (BuildContext context, GoRouterState state) {
            return ReportSideEffectPage();
          },
        ),
        GoRoute(
          path: '/report_complaint',
          name: 'report_complaint',
          builder: (BuildContext context, GoRouterState state) {
            return ReportComplaintPage();
          },
        ),
        GoRoute(
          path: '/comming_soon',
          name: 'comming_soon',
          builder: (BuildContext context, GoRouterState state) {
            return CommingSoon();
          },
        ),
      ],
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    notifyListeners();
    stream.asBroadcastStream().listen((_) => notifyListeners());
  }
}
