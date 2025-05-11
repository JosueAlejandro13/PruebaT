import 'package:prueb/screens/screens.dart';
import 'package:prueb/services/movie_service.dart';

final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      /// Rutas fuera del Shell
      GoRoute(
        path: '/',
        name: 'welcome',
        builder: (context, state) => const WelcomePage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: '/reset-password',
        name: 'reset-password',
        builder: (context, state) => const Resetpasswordpage(),
      ),
      GoRoute(
        path: '/reset-password1',
        name: 'reset-password1',
        builder: (context, state) => const Resetpassword1page(),
      ),
      GoRoute(
        path: '/signup',
        name: 'signup',
        builder: (context, state) => const Signuppage(),
      ),
      GoRoute(
        path: '/account-verification',
        name: 'account-verification',
        builder: (context, state) => const Accountverpage(),
      ),
      GoRoute(
        path: '/first-page',
        name: 'first-page',
        builder: (context, state) => const Firtspage(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsPage(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const ProfilePage(),
      ),
      GoRoute(
        path: '/ontrend',
        name: 'ontrend',
        builder: (context, state) => const OnTrendPage(),
      ),
      GoRoute(
        path: '/last',
        name: 'last',
        builder: (context, state) => const Latestpage(),
      ),
      GoRoute(
        path: '/mostpopular',
        name: 'mostpopular',
        builder: (context, state) => const Mostpopularpage(),
      ),
      GoRoute(
        path: '/actors',
        name: 'actors',
        builder: (context, state) => const ActorsPage(),
      ),
      GoRoute(
        path: '/actor/:id',
        name: 'actorDetail',
        builder: (context, state) {
          final actorId = int.parse(state.pathParameters['id']!);
          return ActorDetailPage(actorId: actorId);
        },
      ),
      GoRoute(
        path: '/series',
        name: 'series',
        builder: (context, state) => const SeriesPage(),
      ),
      GoRoute(
        path: '/movies',
        name: 'movies',
        builder: (context, state) => const Moviespage(),
      ),
          GoRoute(
      path: '/detail',
      name: 'movieDetail',
      builder: (context, state) {
        final movie = state.extra as Movie;
        return MovieDetailPage(movie: movie);
      },
    ),

      

      /// ShellRoute para páginas con AppBar + BottomNavigation
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/activity',
            name: 'activity',
            builder: (context, state) => const ActivityPage(),
          ),
          GoRoute(
            path: '/list',
            name: 'list',
            builder: (context, state) => const Listpage(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const Searchpage(),
          ),
        ],
      ),
    ],
  );
});
