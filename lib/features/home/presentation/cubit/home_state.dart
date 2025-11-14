part of 'home_cubit.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object> get props => [];
}

class HomeInitial extends HomeState {}

// Tambahkan state-state ini untuk banner
class BannerLoading extends HomeState {}

class BannerLoaded extends HomeState {
  final List<BannerEntity> banners;
  const BannerLoaded(this.banners);
  @override
  List<Object> get props => [banners];
}

class BannerError extends HomeState {
  final String message;
  const BannerError(this.message);
  @override
  List<Object> get props => [message];
}