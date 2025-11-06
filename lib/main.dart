// lib/main.dart

import 'package:emotcare_apps/app/routes/routes.dart';
import 'package:emotcare_apps/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:emotcare_apps/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:emotcare_apps/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_token.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/get_user_profile.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/login_user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/register_user.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/remove_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/remove_token.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/save_credentials.dart';
import 'package:emotcare_apps/features/auth/domain/usecases/save_token.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth/auth_cubit.dart';
import 'package:emotcare_apps/features/medicine/data/datasources/medicine_remote_data_source.dart';
import 'package:emotcare_apps/features/medicine/data/datasources/prescription_remote_data_source.dart';
import 'package:emotcare_apps/features/medicine/data/repositories/medicine_repository_impl.dart';
import 'package:emotcare_apps/features/medicine/data/repositories/prescription_repository_impl.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/add_prescription.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/get_medicines.dart';
import 'package:emotcare_apps/features/medicine/domain/usecases/get_prescriptions.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/medicine/medicine_cubit.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_cubit.dart';
import 'package:emotcare_apps/features/medicine/presentation/cubit/prescription/prescription_list_cubit.dart';
import 'package:emotcare_apps/features/report_complaint/presentation/cubit/report_complaint_cubit.dart';
import 'package:emotcare_apps/features/report_side_effect/presentation/cubit/report_side_effect_cubit.dart';
import 'package:emotcare_apps/features/video_education/data/datasources/education_remote_data_source.dart';
import 'package:emotcare_apps/features/video_education/data/repositories/education_repository_impl.dart';
import 'package:emotcare_apps/features/video_education/domain/usecases/get_video_educations.dart';
import 'package:emotcare_apps/features/video_education/presentation/cubit/video_education_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// --- IMPORT USE CASE BARU ---
import 'package:emotcare_apps/features/video_education/domain/usecases/mark_video_as_watched.dart';
// ----------------------------

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await dotenv.load(fileName: ".env");

  // --- 1. Buat SEMUA Dependensi Inti di sini ---
  final httpClient = http.Client();
  final secureStorage = const FlutterSecureStorage();

  // DataSources
  final authLocalDataSource = AuthLocalDataSourceImpl(storage: secureStorage);
  final authRemoteDataSource = AuthRemoteDataSourceImpl(client: httpClient);
  final medicineRemoteDataSource = MedicineRemoteDataSourceImpl(
    client: httpClient,
  );
  final prescriptionRemoteDataSource = PrescriptionRemoteDataSourceImpl(
    client: httpClient,
  );

  // Repositories
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );
  final medicineRepository = MedicineRepositoryImpl(
    remoteDataSource: medicineRemoteDataSource,
  );
  final prescriptionRepository = PrescriptionRepositoryImpl(
    remoteDataSource: prescriptionRemoteDataSource,
  );

  final educationRemoteDataSource = EducationRemoteDataSourceImpl(
    client: httpClient,
  );
  final educationRepository = EducationRepositoryImpl(
    remoteDataSource: educationRemoteDataSource,
  );
  final getVideoEducations = GetVideoEducations(educationRepository);

  // --- 2. Buat SEMUA Usecase di sini ---
  // ... (use case auth tidak berubah) ...
  final registerUser = RegisterUser(authRepository);
  final loginUser = LoginUser(authRepository);
  final getUserProfile = GetUserProfile(authRepository);
  final getToken = GetToken(authRepository);
  final saveToken = SaveToken(authRepository);
  final removeToken = RemoveToken(authRepository);
  final getCredentials = GetCredentials(authRepository);
  final saveCredentials = SaveCredentials(authRepository);
  final removeCredentials = RemoveCredentials(authRepository);
  // Medicine
  final getMedicines = GetMedicines(medicineRepository);
  // Prescription
  final addPrescription = AddPrescription(prescriptionRepository);
  final getPrescriptions = GetPrescriptions(prescriptionRepository);

  // --- TAMBAHKAN USE CASE BARU ---
  final markVideoAsWatched = MarkVideoAsWatched(educationRepository);
  // -----------------------------

  // --- 3. Buat AuthCubit (Satu-satunya) ---
  final authCubit = AuthCubit(
    registerUser: registerUser,
    loginUser: loginUser,
    getUserProfile: getUserProfile,
    getToken: getToken,
    saveToken: saveToken,
    removeToken: removeToken,
    getCredentials: getCredentials,
    saveCredentials: saveCredentials,
    removeCredentials: removeCredentials,
  );

  // Panggil checkAuthStatus di sini
  await authCubit.checkAuthStatus();

  // --- 4. Buat Router dan berikan AuthCubit ---
  final appRouter = AppRouter(authCubit: authCubit);

  runApp(
    MainApp(
      authCubit: authCubit,
      router: appRouter.router,
      // Kirim usecase yang dibutuhkan oleh Cubit lain
      getMedicinesUsecase: getMedicines,
      addPrescriptionUsecase: addPrescription,
      getPrescriptionsUsecase: getPrescriptions,
      getVideoEducationsUsecase: getVideoEducations,
      // --- KIRIM USE CASE BARU ---
      markVideoAsWatchedUsecase: markVideoAsWatched,
      // --------------------------
    ),
  );
}

class MainApp extends StatelessWidget {
  final AuthCubit authCubit;
  final GoRouter router;
  // Terima Usecase untuk Cubit lain
  final GetMedicines getMedicinesUsecase;
  final AddPrescription addPrescriptionUsecase;
  final GetPrescriptions getPrescriptionsUsecase;
  final GetVideoEducations getVideoEducationsUsecase;
  // --- TERIMA USE CASE BARU ---
  final MarkVideoAsWatched markVideoAsWatchedUsecase;
  // ----------------------------

  const MainApp({
    super.key,
    required this.authCubit,
    required this.router,
    required this.getMedicinesUsecase,
    required this.addPrescriptionUsecase, // <-- Terima ini
    required this.getPrescriptionsUsecase,
    required this.getVideoEducationsUsecase,
    required this.markVideoAsWatchedUsecase, // <-- Terima ini
  });

  @override
  Widget build(BuildContext context) {
    // --- HAPUS SEMUA Usecase yang dibuat di sini ---
    // (Mereka sudah dibuat di main() dan diteruskan)

    return MultiBlocProvider(
      providers: [
        // Sediakan instance AuthCubit yang sudah dibuat
        BlocProvider<AuthCubit>.value(value: authCubit),

        // --- HAPUS RegisterCubit, LoginCubit, dan FingerprintCubit ---

        // Sisa Cubit Anda
        BlocProvider<MedicineCubit>(
          create: (context) => MedicineCubit(
            getMedicines: getMedicinesUsecase,
            authCubit: authCubit, // Kirim AuthCubit ke sini
          ),
        ),

        // --- PERBAIKI PrescriptionCubit ---
        BlocProvider<PrescriptionCubit>(
          create: (context) => PrescriptionCubit(
            addPrescription: addPrescriptionUsecase, // <-- Suntikkan di sini
            authCubit: authCubit, // Berikan AuthCubit
          ),
        ),

        BlocProvider<PrescriptionListCubit>(
          create: (context) => PrescriptionListCubit(
            getPrescriptions: getPrescriptionsUsecase,
            authCubit: authCubit,
          ),
        ),

        // --- PERBAIKI VideoEducationCubit ---
        BlocProvider<VideoEducationCubit>(
          create: (context) => VideoEducationCubit(
            getVideoEducations: getVideoEducationsUsecase,
            markVideoAsWatched: markVideoAsWatchedUsecase, // <-- Suntikkan
            authCubit: authCubit,
          ),
          lazy: false,
        ),
        // ------------------------------------

        // Sisa Cubit Anda (asumsi belum butuh dependensi)
        BlocProvider<ReportSideEffectCubit>(
          create: (BuildContext context) => ReportSideEffectCubit(),
        ),
        BlocProvider<ReportComplaintCubit>(
          create: (BuildContext context) => ReportComplaintCubit(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          scaffoldBackgroundColor: Colors.white,
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
          ),
          textTheme: GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
        ),
        // debugShowCheckedModeBanner: false,

        // Gunakan router dari constructor
        routerConfig: router,
      ),
    );
  }
}
