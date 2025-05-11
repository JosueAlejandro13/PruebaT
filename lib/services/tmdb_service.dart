import 'package:http/http.dart' as http;
import 'package:prueb/screens/screens.dart';


class TMDbService {
  static const String _apiKey = 'f14ec47e057407e498521d3cfd336770';  // API key
  static const String _baseUrl = 'https://api.themoviedb.org/3';

  // Función para obtener películas populares
  Future<List<Movie>> getPopularMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/popular?api_key=$_apiKey&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to load popular movies');
    }
  }

  // Función para realizar la búsqueda de películas
  Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?api_key=$_apiKey&query=$query&language=en-US&page=1'),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      final List<dynamic> results = data['results'];

      return results.map((movie) => Movie.fromJson(movie)).toList();
    } else {
      throw Exception('Failed to search movies');
    }
  }
}

class Movie {
  final int id;
  final String title;
  final String posterPath;
  final String overview;

  Movie({
    required this.id,
    required this.title,
    required this.posterPath,
    required this.overview,
  });

  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie(
      id: json['id'],
      title: json['title'],
      posterPath: json['poster_path'] ?? '', // Asegúrate de manejar el valor nulo
      overview: json['overview'] ?? '', // Lo mismo para overview
    );
  }
}