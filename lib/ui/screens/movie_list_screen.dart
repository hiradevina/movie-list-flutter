import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../bloc/movie_bloc.dart';
import '../../../bloc/movie_event.dart';
import '../../../bloc/movie_state.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({super.key});

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  late ScrollController _scrollController;
  late MovieBloc _movieBloc;

  @override
  void initState() {
    super.initState();
    _movieBloc = MovieBloc()..add(FetchMovies(page: 1));
    _scrollController = ScrollController()
      ..addListener(_onScroll);
  }

  void _onScroll() {
    if (_isBottom && _movieBloc.state is MovieLoaded) {
      final state = _movieBloc.state as MovieLoaded;
      if (!state.hasReachedEnd) {
        _movieBloc.add(FetchMovies(page: state.currentPage + 1));
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.position.pixels;
    const threshold = 0.9;
    return current >= (max * threshold);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _movieBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: _movieBloc,
      child: Scaffold(
        appBar: AppBar(title: const Text('Popular Movies')),
        body: BlocBuilder<MovieBloc, MovieState>(
          builder: (context, state) {
            if (state is MovieInitial || state is MovieLoading && state is! MovieLoaded) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieLoaded) {
              return ListView.builder(
                controller: _scrollController,
                itemCount: state.hasReachedEnd
                    ? state.movies.length
                    : state.movies.length + 1,
                itemBuilder: (context, index) {
                  if (index >= state.movies.length) {
                    return const Center(child: Padding(
                      padding: EdgeInsets.all(16.0),
                      child: CircularProgressIndicator(),
                    ));
                  }

                  final movie = state.movies[index];
                  return ListTile(
                    leading: Image.network(
                      'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                      width: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(movie.title),
                  );
                },
              );
            } else if (state is MovieError) {
              return Center(child: Text('Error: ${state.message}'));
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
