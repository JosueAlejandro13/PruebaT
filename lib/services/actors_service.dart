import 'dart:convert';
import 'package:http/http.dart' as http;

class Actor {
  final int id;
  final String name;
  final String? profilePath;
  final double popularity;
  final List<KnownFor> knownFor;

  Actor({
    required this.id,
    required this.name,
    this.profilePath,
    required this.popularity,
    required this.knownFor,
  });

  factory Actor.fromJson(Map<String, dynamic> json) {
    return Actor(
      id: json['id'],
      name: json['name'],
      profilePath: json['profile_path'],
      popularity: (json['popularity'] as num).toDouble(),
      knownFor: (json['known_for'] as List)
          .map((item) => KnownFor.fromJson(item))
          .toList(),
    );
  }
} 
class KnownFor {
  final String? title;
  final String? name; 

  KnownFor({this.title, this.name});

  factory KnownFor.fromJson(Map<String, dynamic> json) {
    return KnownFor(
      title: json['title'],
      name: json['name'],
    );
  }

  String get displayTitle => title ?? name ?? 'Sin título';
}

class ActorsService {
  final String apiKey = 'f14ec47e057407e498521d3cfd336770';
  final String baseUrl = 'https://api.themoviedb.org/3/movie/popular';
// funcion para obtener los actores mas populares
  Future<List<Actor>> fetchPopularActors({int limit = 20}) async {
    final url = Uri.parse(
      'https://api.themoviedb.org/3/person/popular?api_key=$apiKey&language=en-US&page=1',
    );

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return (data['results'] as List)
            .take(limit)
            .map((actor) => Actor.fromJson(actor))
            .toList();
      } else {
        throw Exception('Failed to load popular actors');
      }
    } catch (error) {
      throw Exception('Error fetching popular actors: $error');
    }
  }

    Future<Map<String, dynamic>> fetchActorDetails(int id) async {
    final detailUrl = Uri.parse('https://api.themoviedb.org/3/person/$id?api_key=$apiKey&language=en-US');
    final creditsUrl = Uri.parse('https://api.themoviedb.org/3/person/$id/movie_credits?api_key=$apiKey&language=en-US');

    final detailRes = await http.get(detailUrl);
    final creditsRes = await http.get(creditsUrl);

    if (detailRes.statusCode == 200 && creditsRes.statusCode == 200) {
      final detailData = json.decode(detailRes.body);
      final creditsData = json.decode(creditsRes.body);
      return {
        'profile': detailData,
        'credits': creditsData['cast'] ?? [],
        'collaborators': creditsData['crew'] ?? [],
      };
    } else {
      throw Exception('Error al obtener detalles del actor');
    }
  }

}
