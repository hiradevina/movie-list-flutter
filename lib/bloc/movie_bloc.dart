import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/movie.dart';
import '../data/repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  bool _isFetching = false;
  List<Movie> allMovies = [];

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      if (_isFetching) return;

      _isFetching = true;
      final currentState = state;
      final page = (currentState is MovieLoaded) ? event.page : 1;

      try {
        final movies = await fetchMovies(page);
        allMovies.addAll(movies);
        final hasReachedEnd = movies.isEmpty;

        if (currentState is MovieLoaded) {
          emit(currentState.copyWith(
            movies: currentState.movies + movies,
            currentPage: page,
            hasReachedEnd: hasReachedEnd,
          ));
        } else {
          emit(MovieLoaded(
            movies: movies,
            currentPage: page,
            hasReachedEnd: hasReachedEnd,
          ));
        }
      } catch (e) {
        emit(MovieError(e.toString()));
      } finally {
        _isFetching = false;
      }
    });
  }
}
