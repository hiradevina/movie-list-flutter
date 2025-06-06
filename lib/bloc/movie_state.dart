import 'package:equatable/equatable.dart';
import 'package:movielist/ui/uimodel/movie_ui_model.dart';

import '../data/models/movie.dart';


abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState with EquatableMixin {
  final List<MovieUiModel> movies;
  final int currentPage;
  final bool hasReachedEnd;
  final bool isFavorite;

  MovieLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasReachedEnd,
    required this.isFavorite
  });

  MovieLoaded copyWith({
    List<MovieUiModel>? movies,
    int? currentPage,
    bool? hasReachedEnd,
    bool? isFavorite,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
      isFavorite: isFavorite ?? this.isFavorite
    );
  }

  @override
  List<Object?> get props => [movies, currentPage, hasReachedEnd];
}

class MovieError extends MovieState {
  final String message;

  MovieError(this.message);

  @override
  List<Object?> get props => [message];
}
