import 'package:equatable/equatable.dart';

import '../data/models/movie.dart';


abstract class MovieState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MovieInitial extends MovieState {}

class MovieLoading extends MovieState {}

class MovieLoaded extends MovieState {
  final List<Movie> movies;
  final int currentPage;
  final bool hasReachedEnd;

  MovieLoaded({
    required this.movies,
    required this.currentPage,
    required this.hasReachedEnd,
  });

  MovieLoaded copyWith({
    List<Movie>? movies,
    int? currentPage,
    bool? hasReachedEnd,
  }) {
    return MovieLoaded(
      movies: movies ?? this.movies,
      currentPage: currentPage ?? this.currentPage,
      hasReachedEnd: hasReachedEnd ?? this.hasReachedEnd,
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
