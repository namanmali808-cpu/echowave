import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:echowave/presentation/screens/splash_screen.dart';
import 'package:echowave/presentation/screens/onboarding_screen.dart';
import 'package:echowave/presentation/screens/login_screen.dart';
import 'package:echowave/presentation/screens/register_screen.dart';
import 'package:echowave/presentation/screens/forgot_password_screen.dart';
import 'package:echowave/presentation/screens/home_screen.dart';
import 'package:echowave/presentation/screens/search_screen.dart';
import 'package:echowave/presentation/screens/now_playing_screen.dart';
import 'package:echowave/presentation/screens/library_screen.dart';
import 'package:echowave/presentation/screens/playlist_screen.dart';
import 'package:echowave/presentation/screens/favorites_screen.dart';
import 'package:echowave/presentation/screens/history_screen.dart';
import 'package:echowave/presentation/screens/settings_screen.dart';
import 'package:echowave/presentation/screens/profile_screen.dart';
import 'package:echowave/presentation/screens/album_detail_screen.dart';
import 'package:echowave/presentation/screens/artist_detail_screen.dart';
import 'package:echowave/presentation/providers/player_provider.dart';
import 'package:echowave/presentation/widgets/mini_player.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/splash',
    debugLogDiagnostics: true,
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/forgot-password',
        name: 'forgotPassword',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return Consumer(
            builder: (context, ref, _) {
              final playerState = ref.watch(playerProvider);
              return Scaffold(
                body: Column(
                  children: [
                    Expanded(child: child),
                    if (playerState.currentSong != null) const MiniPlayer(),
                  ],
                ),
                bottomNavigationBar: BottomNavigationBar(
                  currentIndex: _calculateIndex(state),
                  onTap: (index) {
                    switch (index) {
                      case 0:
                        context.go('/home');
                      case 1:
                        context.go('/search');
                      case 2:
                        context.go('/library');
                    }
                  },
                  items: const [
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home_outlined),
                      activeIcon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.search_outlined),
                      activeIcon: Icon(Icons.search),
                      label: 'Search',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.library_music_outlined),
                      activeIcon: Icon(Icons.library_music),
                      label: 'Library',
                    ),
                  ],
                ),
              );
            },
          );
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: '/search',
            name: 'search',
            builder: (context, state) => const SearchScreen(),
          ),
          GoRoute(
            path: '/library',
            name: 'library',
            builder: (context, state) => const LibraryScreen(),
          ),
        ],
      ),
      GoRoute(
        path: '/now-playing',
        name: 'nowPlaying',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const NowPlayingScreen(),
      ),
      GoRoute(
        path: '/playlist/:id',
        name: 'playlist',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PlaylistScreen(id: id);
        },
      ),
      GoRoute(
        path: '/favorites',
        name: 'favorites',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FavoritesScreen(),
      ),
      GoRoute(
        path: '/history',
        name: 'history',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const HistoryScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/settings',
        name: 'settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/album/:id',
        name: 'album',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return AlbumDetailScreen(albumId: id);
        },
      ),
      GoRoute(
        path: '/artist/:id',
        name: 'artist',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ArtistDetailScreen(artistId: id);
        },
      ),
    ],
  );
});

int _calculateIndex(GoRouterState state) {
  final location = state.uri.toString();
  if (location.startsWith('/home')) return 0;
  if (location.startsWith('/search')) return 1;
  if (location.startsWith('/library')) return 2;
  return 0;
}
