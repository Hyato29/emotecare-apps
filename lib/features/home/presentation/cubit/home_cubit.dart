import 'package:bloc/bloc.dart';
import 'package:emotcare_apps/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:emotcare_apps/features/home/domain/entities/banner.dart';
import 'package:emotcare_apps/features/home/domain/usecases/get_banner.dart';
import 'package:equatable/equatable.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final GetBanners getBanners;
  final AuthCubit authCubit;

  HomeCubit({
    required this.getBanners,
    required this.authCubit,
  }) : super(HomeInitial());

  Future<void> fetchBanners() async {
    final authState = authCubit.state;
    if (authState is! Authenticated) {
      emit(const BannerError("Sesi habis, silakan login ulang."));
      return;
    }

    emit(BannerLoading());
    final result = await getBanners(token: authState.token);

    result.fold(
      (failure) => emit(BannerError(failure.message)),
      (banners) => emit(BannerLoaded(banners)),
    );
  }
}