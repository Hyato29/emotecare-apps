// lib/features/home/domain/entities/banner_entity.dart
import 'package:equatable/equatable.dart';

class BannerEntity extends Equatable {
  final int id;
  final String title;
  final String imageUrl;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [id, title, imageUrl];
}