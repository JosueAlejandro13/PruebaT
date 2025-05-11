import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/series_services.dart';

class SeriesPage extends StatefulWidget {
  const SeriesPage({super.key});

  @override
  State<SeriesPage> createState() => _SeriesPageState();
}

class _SeriesPageState extends State<SeriesPage> {
  late Future<List<TvShow>> _popularSeries;
  final SeriesService _seriesService = SeriesService();

  List<TvShow> _allSeries = [];
  List<TvShow> _filteredSeries = [];

  final TextEditingController _searchController = TextEditingController();
  String selectedGenre = "";

  @override
  void initState() {
    super.initState();
    _popularSeries = _seriesService.fetchPopularSeries();
    _loadSeries();
  }

  void _loadSeries() async {
    final data = await _seriesService.fetchPopularSeries();
    setState(() {
      _allSeries = data;
      _filteredSeries = data;
    });
  }

  // Filtro por nombre
  void _filterSeries(String query) {
    setState(() {
      selectedGenre = "";
      _filteredSeries =
          _allSeries
              .where((s) => s.name.toLowerCase().contains(query.toLowerCase()))
              .toList();
    });
  }

  // Filtro por género
  void _filterByGenre(String genre) {
    setState(() {
      selectedGenre = genre;
      _searchController.clear();
      _filteredSeries =
          _allSeries.where((s) => (s.genreNames).contains(genre)).toList();
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
      body: FutureBuilder<List<TvShow>>(
        future: _popularSeries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No hay series disponibles."));
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 10),
              Text(
                "Series",
                style: TextStyle(fontSize: screenWidth * 0.045),
              ),
              const SizedBox(height: 10),

              // Buscador
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search series...',
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                  ),
                  onChanged: _filterSeries,
                ),
              ),
              const SizedBox(height: 12),

              // Filtros de género
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Wrap(
                  spacing: 8,
                  children: [
                    _buildGenreButton("Action"),
                    _buildGenreButton("Comedy"),
                    _buildGenreButton("Reality"),
                    _buildGenreButton("Drama"),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Grid de series
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.5,
                  ),
                  itemCount: _filteredSeries.length,
                  itemBuilder: (context, index) {
                    final tvShow = _filteredSeries[index];
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      clipBehavior: Clip.antiAlias,
                      child: Column(
                        children: [
                          Image.network(
                            'https://image.tmdb.org/t/p/w500${tvShow.posterPath}',
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
                              tvShow.name,
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
                              "⭐ ${tvShow.voteAverage.toStringAsFixed(1)}",
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
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGenreButton(String genre) {
    return ElevatedButton(
      onPressed: () => _filterByGenre(genre),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      child: Text(genre),
    );
  }
}
