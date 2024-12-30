import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/data/model/story.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:declarative_navigation/widgets/flag_icon_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth_provider.dart';

class StoriesListScreen extends StatefulWidget {
  final Function(String) onTapped;
  final Function() onLogout;
  final Function() onAddNewStory;

  const StoriesListScreen({
    Key? key,
    required this.onTapped,
    required this.onLogout,
    required this.onAddNewStory,
  }) : super(key: key);

  @override
  State<StoriesListScreen> createState() => _StoriesListScreenState();
}

class _StoriesListScreenState extends State<StoriesListScreen> {
  final ScrollController scrollController = ScrollController();

  Future<void> _onRefresh() async {
    final storyRead = context.read<StoryProvider>();
    storyRead.getAllStories(isRefresh: true);
  }

  @override
  void initState() {
    super.initState();
    final storyRead = context.read<StoryProvider>();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent) {
        if (storyRead.pageItems != null) {
          storyRead.getAllStories(isRefresh: false);
        }
      }
    });

    Future.microtask(() async => storyRead.getAllStories(isRefresh: false));
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authWatch = context.watch<AuthProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Story App"),
        actions: [
          const FlagIconWidget(),
          IconButton(
            onPressed: () async {
              final authRead = context.read<AuthProvider>();
              await authRead.logout();
              if (authRead.state == ResultState.hasData) {
                widget.onLogout();
              }
            },
            icon: authWatch.state == ResultState.loading
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(Icons.logout),
          ),
        ],
      ),
      body: Consumer<StoryProvider>(
        builder: (context, provider, _) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            return _buildListStory(provider.storiesResult, provider.pageItems);
          } else if (provider.state == ResultState.noData) {
            return Center(
              child: Text(AppLocalizations.of(context)?.emptyData ?? ''),
            );
          } else if (provider.state == ResultState.error) {
            return Center(
              child: Text(provider.message ?? ''),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final scaffoldMessengerState = ScaffoldMessenger.of(context);
          final pageManager = context.read<PageManager>();
          widget.onAddNewStory();
          final dataString = await pageManager.waitForResult();

          scaffoldMessengerState.showSnackBar(
            SnackBar(content: Text(dataString)),
          );

          _onRefresh();
        },
        tooltip: AppLocalizations.of(context)?.addNewStory ?? '',
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildListStory(List<Story> storiesResult, int? pageItems) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: RefreshIndicator.adaptive(
        onRefresh: _onRefresh,
        child: ListView.builder(
          controller: scrollController,
          itemCount: storiesResult.length + (pageItems != null ? 1 : 0),
          itemBuilder: (context, index) {
            if (index == storiesResult.length && pageItems != null) {
              return const Center(
                child: Padding(
                  padding: EdgeInsets.all(8),
                  child: CircularProgressIndicator(),
                ),
              );
            }
            final storyItem = storiesResult[index];
            return GestureDetector(
              onTap: () => widget.onTapped(storyItem.id),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: SizedBox(
                        height: 200,
                        width: double.infinity,
                        child: Image.network(
                          storyItem.photoUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        storyItem.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
