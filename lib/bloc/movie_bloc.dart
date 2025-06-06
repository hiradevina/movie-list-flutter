import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:movielist/ui/uimodel/movie_ui_model.dart';
import '../data/models/movie.dart';
import '../data/repository/movie_repository.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  bool _isFetching = false;
  List<MovieUiModel> allMovies = [];

  MovieBloc() : super(MovieInitial()) {
    on<FetchMovies>((event, emit) async {
      if (_isFetching) return;

      _isFetching = true;
      final currentState = state;
      final page = (currentState is MovieLoaded) ? event.page : 1;

      try {
        final movies = await fetchMovies(page);
        final box = Hive.box<Movie>('movies');
        final uiModel = movies
            .map((movie) => MovieUiModel(movie, box.values.contains(movie)))
            .toList();
        allMovies.addAll(uiModel);
        final hasReachedEnd = movies.isEmpty;

        if (currentState is MovieLoaded) {
          emit(currentState.copyWith(
              movies: currentState.movies + uiModel,
              currentPage: page,
              hasReachedEnd: hasReachedEnd,
              isFavorite: false));
        } else {
          emit(MovieLoaded(
              movies: uiModel,
              currentPage: page,
              hasReachedEnd: hasReachedEnd,
              isFavorite: false));
        }
      } catch (e) {
        emit(MovieError(e.toString()));
      } finally {
        _isFetching = false;
      }
    });
    on<SearchMovies>((event, emit) async {
      if (state is MovieLoaded) {
        if (event.query.isNotEmpty) {
          final match = (state as MovieLoaded)
              .movies
              .where((uimodel) => uimodel.movie.title
                  .toLowerCase()
                  .contains(event.query.toLowerCase()))
              .toList();
          if (state is MovieLoaded) {
            emit(MovieLoaded(
                movies: match,
                currentPage: (state as MovieLoaded).currentPage,
                hasReachedEnd: (state as MovieLoaded).hasReachedEnd,
                isFavorite: (state as MovieLoaded).isFavorite));
          }
        } else {
          emit(MovieLoaded(
              movies: (state as MovieLoaded).movies,
              currentPage: (state as MovieLoaded).currentPage,
              hasReachedEnd: (state as MovieLoaded).hasReachedEnd,
              isFavorite: (state as MovieLoaded).isFavorite));
        }
      }
    });
    on<AddToFavorite>((event, emit) async {
      if (state is MovieLoaded) {
        final box = Hive.box<Movie>('movies');
        try {
          if (box.values.contains(event.uiModel.movie)) {
            box.delete(event.uiModel.movie);
          } else {
            box.add(event.uiModel.movie);
          }
        } on Exception catch (_, e) {
          // no op
        }
        final updated = (state as MovieLoaded).movies.map((movieUiModel) {
          if (movieUiModel.movie.title == event.uiModel.movie.title) {
            return movieUiModel.copy(isFavorite: !event.uiModel.isFavorite);
          } else {
            return movieUiModel;
          }
        }).toList();
        if (!(state as MovieLoaded).isFavorite) {
          allMovies = updated;
        }
        emit(MovieLoaded(
            movies: updated,
            currentPage: (state as MovieLoaded).currentPage,
            hasReachedEnd: (state as MovieLoaded).hasReachedEnd,
            isFavorite: (state as MovieLoaded).isFavorite));
      }
    });
    on<FilterFavorite>((event, emit) {
      final box = Hive.box<Movie>('movies');
      if (state is MovieLoaded && (state as MovieLoaded).isFavorite) {
        emit(MovieLoaded(
            movies: allMovies,
            currentPage: (state as MovieLoaded).currentPage,
            hasReachedEnd: (state as MovieLoaded).hasReachedEnd,
            isFavorite: false));
      } else {
        final movies =
            box.values.map((movie) => MovieUiModel(movie, true)).toList();
        emit(MovieLoaded(
            movies: movies,
            currentPage: 0,
            hasReachedEnd: true,
            isFavorite: true));
      }
    });
  }
}
