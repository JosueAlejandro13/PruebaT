import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final movieService = MovieService();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //carrusel random
            FutureBuilder<List<Movie>>(
              future: movieService.fetchRandomMovies(limit: 10),
              builder: (context, snapshot) {
                // 1. Mientras carga
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                // 2. Si hubo error
                if (snapshot.hasError) {
                  return SizedBox(
                    height: 200,
                    child: Center(child: Text('Error: ${snapshot.error}')),
                  );
                }

                // 3. Si la lista viene vacía
                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const SizedBox(
                    height: 200,
                    child: Center(child: Text('No movies found')),
                  );
                }

                // 4. Mostrar el carrusel
                final movies = snapshot.data!;
                return SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: movies.length,
                    controller: PageController(viewportFraction: 0.85),
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildCustomButtonHome(
                  context: context,
                  text: 'Movies',
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onPressed: () => context.push('/movies'),
                ),
                buildCustomButtonHome(
                  context: context,
                  text: 'Series',
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onPressed: () => context.push('/series'),
                ),
                buildCustomButtonHome(
                  context: context,
                  text: 'Actors',
                  isDarkMode: Theme.of(context).brightness == Brightness.dark,
                  onPressed: () => context.push('/actors'),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // Carrusel On Trend
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'On Trend',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    context.push('/ontrend');
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            FutureBuilder<List<Movie>>(
              future: movieService.fetchTrendingMovies(limit: 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No random movies found.');
                }

                final movies = snapshot.data!;
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/detail', extra: movie);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),

            // Carrusel Last Trailers
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Last Trailers',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    context.push('/last');
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            FutureBuilder<List<Movie>>(
              future: movieService.fetchLastTrailers(limit: 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No random movies found.');
                }

                final movies = snapshot.data!;
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/detail', extra: movie);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Carrusel Most Popular
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Most Popular',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed: () {
                    context.push('/mostpopular');
                  },
                ),
              ],
            ),

            const SizedBox(height: 12),
            FutureBuilder<List<Movie>>(
              future: movieService.fetchPopularMovies(limit: 10),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 150,
                    child: Center(child: CircularProgressIndicator()),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Text('No random movies found.');
                }

                final movies = snapshot.data!;
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: movies.length,
                    itemBuilder: (context, index) {
                      final movie = movies[index];
                      return GestureDetector(
                        onTap: () {
                          context.push('/detail', extra: movie);
                        },
                        child: Container(
                          width: 100,
                          margin: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                movie.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
