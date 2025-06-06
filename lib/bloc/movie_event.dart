import 'package:equatable/equatable.dart';
import 'package:movielist/ui/uimodel/movie_ui_model.dart';

abstract class MovieEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class FetchMovies extends MovieEvent {
  final int page;

  FetchMovies({this.page = 1});

  @override
  List<Object?> get props => [page];
}

class SearchMovies extends MovieEvent {
  final String query;

  SearchMovies(this.query);

  @override
  List<Object?> get props => [query];
}

class AddToFavorite extends MovieEvent {
  final MovieUiModel uiModel;

  AddToFavorite(this.uiModel);

  @override
  List<Object?> get props => [uiModel];
}

class FilterFavorite extends MovieEvent {
  @override
  List<Object?> get props => [];
}
