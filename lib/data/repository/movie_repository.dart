import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie.dart';

Future<List<Movie>> fetchMovies(int page) async {
  final response = await http.get(Uri.parse(
    'https://api.themoviedb.org/3/movie/popular?api_key=f27b49140aab9aa4e19590b476fb2dc3&page=$page',
  ));

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    final List results = data['results'];
    return results.map((movie) => Movie.fromJson(movie)).toList();
  } else {
    print(response.body);
    throw Exception('Failed to load movies ${response.statusCode}');
  }
}
