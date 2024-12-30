import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:declarative_navigation/utils/result_state.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class StoryDetailScreen extends StatefulWidget {
  final String storyId;
  final Function(LatLng? latLng) onMaps;

  const StoryDetailScreen({
    Key? key,
    required this.storyId,
    required this.onMaps,
  }) : super(key: key);

  @override
  State<StoryDetailScreen> createState() => _StoryDetailScreenState();
}

class _StoryDetailScreenState extends State<StoryDetailScreen> {
  void _onRefresh() async {
    final storyRead = context.read<StoryProvider>();
    await storyRead.getDetailStory(id: widget.storyId);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _onRefresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<StoryProvider>(
        builder: (context, provider, child) {
          if (provider.state == ResultState.loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (provider.state == ResultState.hasData) {
            final storyItem = provider.story;
            final storyLatLng = storyItem?.lat != null && storyItem?.lon != null
                ? LatLng(storyItem?.lat ?? 0.0, storyItem?.lon ?? 0.0)
                : null;
            return SafeArea(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.network(
                      storyItem?.photoUrl ?? '',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      storyItem?.name ?? '',
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      storyItem?.description ?? '',
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (storyLatLng != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => widget.onMaps(storyLatLng),
                          child: const Text('Buka Maps'),
                        ),
                      ),
                    )
                ],
              ),
            );
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
    );
  }
}
