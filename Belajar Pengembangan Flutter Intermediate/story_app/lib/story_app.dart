import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/data/api/api_service.dart';
import 'package:declarative_navigation/data/db/auth_repository.dart';
import 'package:declarative_navigation/provider/auth_provider.dart';
import 'package:declarative_navigation/provider/localization_provider.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:declarative_navigation/provider/upload_provider.dart';
import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:declarative_navigation/routes/router_delegate.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoryApp extends StatefulWidget {
  const StoryApp({Key? key}) : super(key: key);

  @override
  State<StoryApp> createState() => _StoryAppState();
}

class _StoryAppState extends State<StoryApp> {
  late MyRouterDelegate myRouterDelegate;

  late AuthProvider authProvider;
  late StoryProvider storyProvider;
  late UploadProvider uploadProvider;

  @override
  void initState() {
    super.initState();
    final authRepository = AuthRepository();
    final apiService = ApiService();

    authProvider = AuthProvider(
      authRepository: authRepository,
      apiService: apiService,
    );

    storyProvider = StoryProvider(
      authRepository: authRepository,
      apiService: apiService,
    );

    uploadProvider = UploadProvider(
      authRepository: authRepository,
      apiService: apiService,
    );

    myRouterDelegate = MyRouterDelegate(authRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => authProvider),
        ChangeNotifierProvider(create: (_) => storyProvider),
        ChangeNotifierProvider(create: (_) => uploadProvider),
        ChangeNotifierProvider(create: (_) => PageManager()),
        ChangeNotifierProvider(create: (_) => LocalizationProvider()),
      ],
      child: Consumer<LocalizationProvider>(
        builder: (context, provider, _) {
          return MaterialApp(
            title: 'Quotes App',
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: provider.locale,
            home: Router(
              routerDelegate: myRouterDelegate,
              backButtonDispatcher: RootBackButtonDispatcher(),
            ),
          );
        },
      ),
    );
  }
}
