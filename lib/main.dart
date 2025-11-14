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
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/home/data/datasources/banner_remote_data_source.dart';
import 'package:emotcare_apps/features/home/data/repositories/banner_repository_impl.dart';
import 'package:emotcare_apps/features/home/domain/usecases/get_banner.dart';
import 'package:emotcare_apps/features/home/presentation/cubit/home_cubit.dart';
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
import 'package:emotcare_apps/features/schedule_control/data/datasources/schedule_remote_data_source.dart';
import 'package:emotcare_apps/features/schedule_control/data/repositories/schedule_repository_impl.dart';
import 'package:emotcare_apps/features/schedule_control/domain/usecases/get_schedules.dart';
import 'package:emotcare_apps/features/schedule_control/presentation/cubit/schedule_control_cubit.dart';
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

import 'package:emotcare_apps/features/video_education/domain/usecases/mark_video_as_watched.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('id_ID', null);

  await dotenv.load(fileName: ".env");

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
  final educationRemoteDataSource = EducationRemoteDataSourceImpl(
    client: httpClient,
  );
  final scheduleRemoteDataSource = ScheduleRemoteDataSourceImpl(
    client: httpClient,
  );
  // --- TAMBAHKAN DATASOURCE BANNER ---
  final bannerRemoteDataSource = BannerRemoteDataSourceImpl(
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
  final educationRepository = EducationRepositoryImpl(
    remoteDataSource: educationRemoteDataSource,
  );
  final scheduleRepository = ScheduleRepositoryImpl(
    remoteDataSource: scheduleRemoteDataSource,
  );
  // --- TAMBAHKAN REPO BANNER ---
  final bannerRepository = BannerRepositoryImpl(
    remoteDataSource: bannerRemoteDataSource,
  );

  // Usecases
  final registerUser = RegisterUser(authRepository);
  final loginUser = LoginUser(authRepository);
  final getUserProfile = GetUserProfile(authRepository);
  final getToken = GetToken(authRepository);
  final saveToken = SaveToken(authRepository);
  final removeToken = RemoveToken(authRepository);
  final getCredentials = GetCredentials(authRepository);
  final saveCredentials = SaveCredentials(authRepository);
  final removeCredentials = RemoveCredentials(authRepository);
  final getMedicines = GetMedicines(medicineRepository);
  final addPrescription = AddPrescription(prescriptionRepository);
  final getPrescriptions = GetPrescriptions(prescriptionRepository);
  final getVideoEducations = GetVideoEducations(educationRepository);
  final markVideoAsWatched = MarkVideoAsWatched(educationRepository);
  final getSchedules = GetSchedules(scheduleRepository);
  final getBanners = GetBanners(bannerRepository);

  // AuthCubit
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

  // Hapus await checkAuthStatus() dari sini

  final appRouter = AppRouter(authCubit: authCubit);

  runApp(
    MainApp(
      authCubit: authCubit,
      router: appRouter.router,
      getMedicinesUsecase: getMedicines,
      addPrescriptionUsecase: addPrescription,
      getPrescriptionsUsecase: getPrescriptions,
      getVideoEducationsUsecase: getVideoEducations,
      markVideoAsWatchedUsecase: markVideoAsWatched,
      getSchedulesUsecase: getSchedules,
      // --- KIRIM USECASE BANNER ---
      getBannersUsecase: getBanners,
    ),
  );
}

class MainApp extends StatelessWidget {
  final AuthCubit authCubit;
  final GoRouter router;
  final GetMedicines getMedicinesUsecase;
  final AddPrescription addPrescriptionUsecase;
  final GetPrescriptions getPrescriptionsUsecase;
  final GetVideoEducations getVideoEducationsUsecase;
  final MarkVideoAsWatched markVideoAsWatchedUsecase;
  final GetSchedules getSchedulesUsecase;
  // --- TERIMA USECASE BANNER ---
  final GetBanners getBannersUsecase;

  const MainApp({
    super.key,
    required this.authCubit,
    required this.router,
    required this.getMedicinesUsecase,
    required this.addPrescriptionUsecase,
    required this.getPrescriptionsUsecase,
    required this.getVideoEducationsUsecase,
    required this.markVideoAsWatchedUsecase,
    required this.getSchedulesUsecase,
    required this.getBannersUsecase, // <-- Terima di constructor
  });

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: authCubit),

        // --- TAMBAHKAN PROVIDER UNTUK HOMECUBIT ---
        BlocProvider<HomeCubit>(
          create: (context) => HomeCubit(
            getBanners: getBannersUsecase,
            authCubit: authCubit,
          ),
        ),
        // ----------------------------------------

        BlocProvider<MedicineCubit>(
          create: (context) => MedicineCubit(
            getMedicines: getMedicinesUsecase,
            authCubit: authCubit,
          ),
        ),
        BlocProvider<PrescriptionCubit>(
          create: (context) => PrescriptionCubit(
            addPrescription: addPrescriptionUsecase,
            authCubit: authCubit,
          ),
        ),
        BlocProvider<PrescriptionListCubit>(
          create: (context) => PrescriptionListCubit(
            getPrescriptions: getPrescriptionsUsecase,
            authCubit: authCubit,
          ),
        ),
        BlocProvider<VideoEducationCubit>(
          create: (context) => VideoEducationCubit(
            getVideoEducations: getVideoEducationsUsecase,
            markVideoAsWatched: markVideoAsWatchedUsecase,
            authCubit: authCubit,
          ),
          lazy: false,
        ),
        BlocProvider<ScheduleControlCubit>(
          create: (context) => ScheduleControlCubit(
            getSchedules: getSchedulesUsecase,
            authCubit: authCubit,
          ),
        ),
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
        routerConfig: router,
      ),
    );
  }
}