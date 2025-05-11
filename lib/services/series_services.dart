import 'package:prueb/screens/screens.dart';

import 'package:http/http.dart' as http;

class TvShow {
  final String name;
  final String posterPath;
  final double voteAverage;
  final List<String> genreNames; 

  TvShow({
    required this.name,
    required this.posterPath,
    required this.voteAverage,
    required this.genreNames, 
  });

  factory TvShow.fromJson(Map<String, dynamic> json) {
    return TvShow(
      name: json['name'] ?? '',
      posterPath: json['poster_path'] ?? '',
      voteAverage: (json['vote_average'] ?? 0).toDouble(),
      genreNames: _mapGenreIdsToNames(List<int>.from(json['genre_ids'] ?? [])),
    );
  }

 // Mapeo ID de género a nombre
  static List<String> _mapGenreIdsToNames(List<int> genreIds) {
    const genreMap = {
      10759: 'Action',
      35: 'Comedy',
      10764: 'Reality',
      18: 'Drama',
    };

    return genreIds
        .map((id) => genreMap[id])
        .whereType<String>()
        .toList();
  }
}


class SeriesService {
  final String apiKey = 'f14ec47e057407e498521d3cfd336770';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular';
 // Función para obtener series populares
  Future<List<TvShow>> fetchPopularSeries({int limit = 20}) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/tv/popular?api_key=$apiKey&language=en-US&page=1',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .take(limit)
            .map((series) => TvShow.fromJson(series))
            .toList();
      } else {
        throw Exception('Failed to load popular series');
      }
    } catch (error) {
      throw Exception('Error fetching popular series: $error');
    }
  }
}
