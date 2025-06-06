import 'package:equatable/equatable.dart';

import '../../data/models/movie.dart';

class MovieUiModel extends Equatable {
  final Movie movie;
  final bool isFavorite;

  MovieUiModel(this.movie, bool? isFavorite) : isFavorite = isFavorite ?? false;

  MovieUiModel copy({Movie? movie, bool? isFavorite}) {
    return MovieUiModel(movie ?? this.movie, isFavorite ?? this.isFavorite);
  }

  @override
  List<Object?> get props => [movie, isFavorite];
}
