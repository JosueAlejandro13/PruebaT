import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

class Moviespage extends StatefulWidget {
  const Moviespage({super.key});

  @override
  State<Moviespage> createState() => _MoviespageState();
}

class _MoviespageState extends State<Moviespage> {
  late Future<List<Movie>> _trendingMovies;
  final MovieService _movieService = MovieService();
  final TextEditingController _searchController = TextEditingController();
  String _selectedGenre = '';

  @override
  void initState() {
    super.initState();
    _trendingMovies = _movieService.fetchRandomMovies();
  }

  void _searchMovies() {
    setState(() {
      _trendingMovies = _movieService.fetchMoviesByGenre(
        _selectedGenre,
        searchTerm: _searchController.text,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final appBarColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.black
            : Colors.white;
    final appBarTextColor =
        Theme.of(context).brightness == Brightness.dark
            ? Colors.white
            : Colors.black;

    return Scaffold(
      appBar: buildCustomAppBarPage(
        context: context,
        appBarColor: appBarColor,
        appBarTextColor: appBarTextColor,
        screenWidth: screenWidth,
      ),
      body: Column(
        children: [
          const SizedBox(height: 10),

          Text("Movies", style: TextStyle(fontSize: screenWidth * 0.045)),
          const SizedBox(height: 10),
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 10),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search Movies...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              onSubmitted: (query) => _searchMovies(),
            ),
          ),
          const SizedBox(height: 12),

          // Buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Wrap(
              spacing: 8,
              children: [
                _buildGenreButton('Action'),
                _buildGenreButton('Comedy'),
                _buildGenreButton('Drama'),
                _buildGenreButton('Romance'),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Movie List
          Expanded(
            child: FutureBuilder<List<Movie>>(
              future: _trendingMovies,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text("No movies found."));
                }

                final movies = snapshot.data!;
                // Diseño de las tarjetas de películas
                return GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: movies.length,
                  itemBuilder: (context, index) {
                    final movie = movies[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            height: 150,
                            width: double.infinity,
                            fit: BoxFit.cover,
                            errorBuilder:
                                (context, error, stackTrace) =>
                                    const Icon(Icons.broken_image, size: 60),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 6,
                            ),
                            child: Text(
                              movie.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: screenWidth * 0.030,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: Text(
                              "⭐ ${movie.voteAverage.toStringAsFixed(1)}",
                              style: TextStyle(
                                fontSize: screenWidth * 0.028,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGenreButton(String genre) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedGenre = genre;
          _searchMovies();
        });
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(genre),
    );
  }
}
