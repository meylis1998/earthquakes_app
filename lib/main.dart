import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'app/di/service_locator.dart';
import 'app/router/app_router.dart';
import 'app/theme/app_theme.dart';
import 'presentation/bloc/bloc_exports.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await ServiceLocator.instance.init();

  runApp(const EarthquakesApp());
}

class EarthquakesApp extends StatelessWidget {
  const EarthquakesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<EarthquakeBloc>(
          create: (_) => EarthquakeBloc(
            repository: ServiceLocator.instance.earthquakeRepository,
            locationService: ServiceLocator.instance.locationService,
          ),
        ),
        BlocProvider<FilterCubit>(
          create: (_) => FilterCubit(),
        ),
        BlocProvider<FavoritesCubit>(
          create: (_) => FavoritesCubit(
            favoritesService: ServiceLocator.instance.favoritesService,
          ),
        ),
      ],
      child: MaterialApp.router(
        title: 'Earthquakes',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
      ),
    );
  }
}
