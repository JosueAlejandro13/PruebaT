import 'package:prueb/screens/screens.dart';

import 'package:http/http.dart' as http;

class Movie {
  final String title;
  final String releaseDate;
  final String posterPath;
  final double voteAverage;

  Movie({
    required this.title,
    required this.releaseDate,
    required this.posterPath,
    required this.voteAverage,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      title: json['title'],
      releaseDate: json['release_date'],
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] as num).toDouble(),
    );
  }
}

// Clase para manejar la conexión con la API de TMDb
class MovieService {
  final String apiKey = 'f14ec47e057407e498521d3cfd336770';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular';

  // Función para obtener las 3 primeras películas populares
  Future<List<Movie>> fetchMovies() async {
    final url = Uri.parse('$baseUrl?api_key=$apiKey&language=en-US&page=1');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .take(20)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to load movies');
      }
    } catch (error) {
      throw Exception('Error fetching movies: $error');
    }
  }

  // Función para obtener películas aleatorias
  Future<List<Movie>> fetchRandomMovies({int limit = 10}) async {
    final url = Uri.parse('$baseUrl?api_key=$apiKey&language=en-US&page=1');
    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception('Failed to load random movies');
    }

    final data = json.decode(response.body);
    final allMovies =
        (data['results'] as List)
            .map((movie) => Movie.fromJson(movie))
            .toList();

    allMovies.shuffle();
    return allMovies.take(limit).toList();
  }
 
 // Función para obtener películas ultimo trailer
  Future<List<Movie>> fetchLastTrailers({int limit = 10}) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/movie/now_playing?api_key=$apiKey&language=en-US&page=1',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .take(limit)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to load last trailers');
      }
    } catch (error) {
      throw Exception('Error fetching last trailers: $error');
    }
  }

// Función para obtener peliculas tendencia
  Future<List<Movie>> fetchTrendingMovies({int limit = 10}) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .take(limit)
            .map((movie) => Movie.fromJson(movie))
            .toList();
      } else {
        throw Exception('Failed to load trending movies');
      }
    } catch (error) {
      throw Exception('Error fetching trending movies: $error');
    }
  }

// Función para obtener películas populares
  Future<List<Movie>> fetchPopularMovies({int limit = 20}) async {
  final url = Uri.parse(
    'https://api.themoviedb.org/3/movie/popular?api_key=$apiKey&language=en-US&page=1',
  );

  try {
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .take(limit)
          .map((movie) => Movie.fromJson(movie))
          .toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  } catch (error) {
    throw Exception('Error fetching popular movies: $error');
  }
}



}
