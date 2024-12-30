import 'dart:io';

import 'package:declarative_navigation/common.dart';
import 'package:declarative_navigation/flavor_config.dart';
import 'package:declarative_navigation/provider/story_provider.dart';
import 'package:declarative_navigation/provider/upload_provider.dart';
import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:geocoding/geocoding.dart' as geo;

class AddNewStoryScreen extends StatefulWidget {
  final Function onUpload;
  final Function onPicker;
  const AddNewStoryScreen({
    super.key,
    required this.onUpload,
    required this.onPicker,
  });

  @override
  State<AddNewStoryScreen> createState() => _AddNewStoryScreenState();
}

class _AddNewStoryScreenState extends State<AddNewStoryScreen> {
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  LatLng? storyLatLng;
  final formKey = GlobalKey<FormState>();

  @override
  dispose() {
    descriptionController.dispose();
    locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final addNewStoryWatch = context.watch<UploadProvider>();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.addNewStory ?? ''),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  context.watch<StoryProvider>().imagePath == null
                      ? const Align(
                          alignment: Alignment.center,
                          child: Icon(
                            Icons.image,
                            size: 100,
                          ),
                        )
                      : _showImage(),
                  const SizedBox(height: 16),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () => _onGalleryView(),
                        child:
                            Text(AppLocalizations.of(context)?.gallery ?? ''),
                      ),
                      ElevatedButton(
                        onPressed: () => _onCameraView(),
                        child: Text(AppLocalizations.of(context)?.camera ?? ''),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: descriptionController,
                    minLines: 5,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)?.description ?? '',
                      border: const OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)
                                ?.errorTextDescription ??
                            '';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  if (FlavorConfig.instance.values.isPaid)
                    TextFormField(
                      onTap: () async {
                        final pageManager = context.read<PageManager>();
                        widget.onPicker();
                        storyLatLng = await pageManager.waitForLatLngResult();

                        final info = await geo.placemarkFromCoordinates(
                            storyLatLng?.latitude ?? 0.0,
                            storyLatLng?.longitude ?? 0.0);

                        final place = info[0];
                        final street = place.street;
                        final address =
                            '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';

                        locationController.text = '$street, $address';
                        setState(() {});
                      },
                      controller: locationController,
                      decoration: const InputDecoration(
                        hintText: 'Pilih lokasi',
                        border: OutlineInputBorder(),
                      ),
                      readOnly: true,
                    ),
                  const SizedBox(height: 24),
                  addNewStoryWatch.isUploading
                      ? const Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => _onUpload(),
                            child: Text(
                                AppLocalizations.of(context)?.upload ?? ''),
                          ),
                        )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onUpload() async {
    if (formKey.currentState!.validate()) {
      final StoryProvider storyProvider = context.read<StoryProvider>();
      final UploadProvider uploadProvider = context.read<UploadProvider>();
      final imagePath = storyProvider.imagePath;
      final imageFile = storyProvider.imageFile;
      if (imagePath == null || imageFile == null) return;
      final fileName = imageFile.name;
      final bytes = await imageFile.readAsBytes();
      final newBytes = await uploadProvider.compressImage(bytes);

      await uploadProvider.upload(
        newBytes,
        fileName,
        descriptionController.text,
        storyLatLng?.latitude,
        storyLatLng?.longitude,
      );

      if (uploadProvider.uploadResult != null) {
        storyProvider.setImageFile(null);
        storyProvider.setImagePath(null);
        widget.onUpload();
        if (mounted) {
          context.read<PageManager>().returnData(uploadProvider.message);
        }
      }
    }
  }

  _onGalleryView() async {
    final provider = context.read<StoryProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<StoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final picker = ImagePicker();

    final pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 80,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<StoryProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            height: 300,
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            height: 300,
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }
}
