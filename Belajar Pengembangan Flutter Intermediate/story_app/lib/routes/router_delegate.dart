import 'package:declarative_navigation/screen/add_new_story_screen.dart';
import 'package:declarative_navigation/screen/maps_screen.dart';
import 'package:declarative_navigation/screen/picker_screen.dart';
import 'package:declarative_navigation/screen/register_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../data/db/auth_repository.dart';
import '../screen/login_screen.dart';
import '../screen/story_detail_screen.dart';
import '../screen/stories_list_screen.dart';
import '../screen/splash_screen.dart';

class MyRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey;
  final AuthRepository authRepository;

  MyRouterDelegate(
    this.authRepository,
  ) : _navigatorKey = GlobalKey<NavigatorState>() {
    _init();
  }

  _init() async {
    final token = await authRepository.getToken();
    isLoggedIn = token?.isNotEmpty ?? false;
    notifyListeners();
  }

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  String? selectedStory;
  LatLng? storyLatLng;

  List<Page> historyStack = [];
  bool? isLoggedIn;
  bool isRegister = false;
  bool isAddNewStory = false;
  bool isPicker = false;

  @override
  Widget build(BuildContext context) {
    if (isLoggedIn == null) {
      historyStack = _splashStack;
    } else if (isLoggedIn == true) {
      historyStack = _loggedInStack;
    } else {
      historyStack = _loggedOutStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: historyStack,
      onPopPage: (route, result) {
        final didPop = route.didPop(result);
        if (!didPop) {
          return false;
        }

        isRegister = false;
        if (isPicker == false) {
          isAddNewStory = false;
        }
        if (storyLatLng == null) {
          selectedStory = null;
        }

        storyLatLng = null;
        isPicker = false;
        notifyListeners();

        return true;
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}

  List<Page> get _splashStack => const [
        MaterialPage(
          key: ValueKey("SplashScreen"),
          child: SplashScreen(),
        ),
      ];

  List<Page> get _loggedOutStack => [
        MaterialPage(
          key: const ValueKey("LoginPage"),
          child: LoginScreen(
            onLogin: () {
              isLoggedIn = true;
              notifyListeners();
            },
            onRegister: () {
              isRegister = true;
              notifyListeners();
            },
          ),
        ),
        if (isRegister == true)
          MaterialPage(
            key: const ValueKey("RegisterPage"),
            child: RegisterScreen(
              onRegister: () {
                isRegister = false;
                notifyListeners();
              },
              onLogin: () {
                isRegister = false;
                notifyListeners();
              },
            ),
          ),
      ];

  List<Page> get _loggedInStack => [
        MaterialPage(
          key: const ValueKey("StoriesListPage"),
          child: StoriesListScreen(
            onTapped: (String quoteId) {
              selectedStory = quoteId;
              notifyListeners();
            },
            onLogout: () {
              isLoggedIn = false;
              notifyListeners();
            },
            onAddNewStory: () {
              isAddNewStory = true;
              notifyListeners();
            },
          ),
        ),
        if (selectedStory != null)
          MaterialPage(
            key: ValueKey(selectedStory),
            child: StoryDetailScreen(
              storyId: selectedStory ?? '',
              onMaps: (LatLng? latLng) {
                storyLatLng = latLng;
                notifyListeners();
              },
            ),
          ),
        if (isAddNewStory == true)
          MaterialPage(
            key: const ValueKey("AddNewStoryPage"),
            child: AddNewStoryScreen(
              onUpload: () {
                isAddNewStory = false;
                notifyListeners();
              },
              onPicker: () {
                isPicker = true;
                notifyListeners();
              },
            ),
          ),
        if (storyLatLng != null)
          MaterialPage(
            key: const ValueKey("MapsScreen"),
            child: MapsScreen(
              latLng: storyLatLng,
            ),
          ),
        if (isPicker != false)
          MaterialPage(
            key: const ValueKey("PickerScreen"),
            child: PickerScreen(
              onSave: () {
                isPicker = false;
                notifyListeners();
              },
            ),
          )
      ];
}
