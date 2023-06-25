import 'package:flutter/cupertino.dart';
// import 'package:go_router/go_router.dart';
// import 'package:movies_app/core/presentation/pages/main_page.dart';
// import 'package:movies_app/movies/presentation/views/movie_details_view.dart';
// import 'package:movies_app/movies/presentation/views/movies_view.dart';
// import 'package:movies_app/movies/presentation/views/popular_movies_view.dart';
// import 'package:movies_app/movies/presentation/views/top_rated_movies_view.dart';
// import 'package:movies_app/search/presentation/views/search_view.dart';
// import 'package:movies_app/tv_shows/presentation/views/popular_tv_shows_view.dart';
// import 'package:movies_app/tv_shows/presentation/views/top_rated_tv_shows_view.dart';
// import 'package:movies_app/tv_shows/presentation/views/tv_show_details_view.dart';
// import 'package:movies_app/tv_shows/presentation/views/tv_shows_view.dart';

// import 'package:movies_app/core/resources/app_routes.dart';
// import 'package:movies_app/watchlist/presentation/views/watchlist_view.dart';

// const String moviesPath = '/movies';
// const String movieDetailsPath = 'movieDetails/:movieId';
// const String popularMoviesPath = 'popularMovies';
// const String topRatedMoviesPath = 'topRatedMovies';
// const String tvShowsPath = '/tvShows';
// const String tvShowDetailsPath = 'tvShowDetails/:tvShowId';
// const String popularTVShowsPath = 'popularTVShows';
// const String topRatedTVShowsPath = 'topRatedTVShows';
// const String searchPath = '/search';
// const String watchlistPath = '/watchlist';

// class AppRouter {
  // GoRouter router = GoRouter(
  //   initialLocation: moviesPath,
  //   routes: [
  //     ShellRoute(
  //       builder: (context, state, child) => MainPage(child: child),
  //       routes: [
  //         GoRoute(
  //           name: AppRoutes.moviesRoute,
  //           path: moviesPath,
  //           pageBuilder: (context, state) => const NoTransitionPage(
  //             child: MoviesView(),
  //           ),
  //           routes: [
  //             GoRoute(
  //               name: AppRoutes.movieDetailsRoute,
  //               path: movieDetailsPath,
  //               pageBuilder: (context, state) => CupertinoPage(
  //                 child: MovieDetailsView(
  //                   movieId: int.parse(state.params['movieId']!),
  //                 ),
  //               ),
  //             ),
  //             GoRoute(
  //               name: AppRoutes.popularMoviesRoute,
  //               path: popularMoviesPath,
  //               pageBuilder: (context, state) => const CupertinoPage(
  //                 child: PopularMoviesView(),
  //               ),
  //             ),
  //             GoRoute(
  //               name: AppRoutes.topRatedMoviesRoute,
  //               path: topRatedMoviesPath,
  //               pageBuilder: (context, state) => const CupertinoPage(
  //                 child: TopRatedMoviesView(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         GoRoute(
  //           name: AppRoutes.tvShowsRoute,
  //           path: tvShowsPath,
  //           pageBuilder: (context, state) => const NoTransitionPage(
  //             child: TVShowsView(),
  //           ),
  //           routes: [
  //             GoRoute(
  //               name: AppRoutes.tvShowDetailsRoute,
  //               path: tvShowDetailsPath,
  //               pageBuilder: (context, state) => CupertinoPage(
  //                 child: TVShowDetailsView(
  //                   tvShowId: int.parse(state.params['tvShowId']!),
  //                 ),
  //               ),
  //             ),
  //             GoRoute(
  //               name: AppRoutes.popularTvShowsRoute,
  //               path: popularTVShowsPath,
  //               pageBuilder: (context, state) => const CupertinoPage(
  //                 child: PopularTVShowsView(),
  //               ),
  //             ),
  //             GoRoute(
  //               name: AppRoutes.topRatedTvShowsRoute,
  //               path: topRatedTVShowsPath,
  //               pageBuilder: (context, state) => const CupertinoPage(
  //                 child: TopRatedTVShowsView(),
  //               ),
  //             ),
  //           ],
  //         ),
  //         GoRoute(
  //           name: AppRoutes.searchRoute,
  //           path: searchPath,
  //           pageBuilder: (context, state) => const NoTransitionPage(
  //             child: SearchView(),
  //           ),
  //         ),
  //         GoRoute(
  //           name: AppRoutes.watchlistRoute,
  //           path: watchlistPath,
  //           pageBuilder: (context, state) => const NoTransitionPage(
  //             child: WatchlistView(),
  //           ),
  //         ),
  //       ],
  //     )
  //   ],
  // );
// }
