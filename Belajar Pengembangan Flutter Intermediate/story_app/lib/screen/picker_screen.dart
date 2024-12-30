import 'package:declarative_navigation/routes/page_manager.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:provider/provider.dart';

class PickerScreen extends StatefulWidget {
  final Function onSave;
  const PickerScreen({super.key, required this.onSave});

  @override
  State<PickerScreen> createState() => _PickerScreenState();
}

class _PickerScreenState extends State<PickerScreen> {
  final dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  late GoogleMapController mapController;
  late final Set<Marker> markers = {};
  geo.Placemark? placemark;
  LatLng? currentLatLng;

  Future<void> setMapStyle() async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    await mapController.setMapStyle(value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            GoogleMap(
              onMapCreated: (controller) async {
                final Location location = Location();
                late bool serviceEnabled;
                late PermissionStatus permissionGranted;
                late LocationData locationData;

                serviceEnabled = await location.serviceEnabled();
                if (!serviceEnabled) {
                  serviceEnabled = await location.requestService();
                  if (!serviceEnabled) {
                    print("Location services is not available");
                    return;
                  }
                }

                permissionGranted = await location.hasPermission();
                if (permissionGranted == PermissionStatus.denied) {
                  permissionGranted = await location.requestPermission();
                  if (permissionGranted != PermissionStatus.granted) {
                    print("Location permission is denied");
                    return;
                  }
                }

                locationData = await location.getLocation();
                final latLng =
                    LatLng(locationData.latitude!, locationData.longitude!);

                final info = await geo.placemarkFromCoordinates(
                    latLng.latitude, latLng.longitude);

                final place = info[0];
                final street = place.street;
                final address =
                    '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                setState(() {
                  placemark = place;
                });

                defineMarker(latLng, street ?? '', address);

                setState(() {
                  mapController = controller;
                });

                await setMapStyle();

                mapController.animateCamera(
                  CameraUpdate.newLatLng(latLng),
                );
              },
              onLongPress: (LatLng latLng) {
                onLongPressGoogleMap(latLng);
              },
              initialCameraPosition: CameraPosition(
                zoom: 18,
                target: dicodingOffice,
              ),
              markers: markers,
              myLocationEnabled: true,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              myLocationButtonEnabled: false,
            ),
            Positioned(
              top: 16,
              right: 16,
              child: FloatingActionButton(
                child: const Icon(Icons.my_location),
                onPressed: () {
                  onMyLocationButtonPress();
                },
              ),
            ),
            if (placemark == null)
              const SizedBox()
            else
              Positioned(
                bottom: 16,
                right: 16,
                left: 16,
                child: PlacemarkWidget(
                  placemark: placemark!,
                  latLng: currentLatLng ?? const LatLng(0.0, 0.0),
                  onSave: widget.onSave,
                ),
              ),
          ],
        ),
      ),
    );
  }

  void onLongPressGoogleMap(LatLng latLng) async {
    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    final place = info[0];
    final street = place.street!;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });
    defineMarker(latLng, street, address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }

  void defineMarker(LatLng latLng, String street, String address) {
    currentLatLng = latLng;
    final marker = Marker(
      markerId: const MarkerId("source"),
      position: latLng,
      infoWindow: InfoWindow(
        title: street,
        snippet: address,
      ),
    );
    setState(() {
      markers.clear();
      markers.add(marker);
    });
  }

  void onMyLocationButtonPress() async {
    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionGranted;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        print("Location services is not available");
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        print("Location permission is denied");
        return;
      }
    }

    locationData = await location.getLocation();
    final latLng = LatLng(locationData.latitude!, locationData.longitude!);

    final info =
        await geo.placemarkFromCoordinates(latLng.latitude, latLng.longitude);

    final place = info[0];
    final street = place.street;
    final address =
        '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(() {
      placemark = place;
    });

    defineMarker(latLng, street ?? '', address);

    mapController.animateCamera(
      CameraUpdate.newLatLng(latLng),
    );
  }
}

class PlacemarkWidget extends StatelessWidget {
  const PlacemarkWidget(
      {super.key,
      required this.placemark,
      required this.latLng,
      required this.onSave});
  final geo.Placemark placemark;
  final LatLng latLng;
  final Function onSave;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: Colors.grey.withOpacity(0.5),
          )
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  placemark.street!,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                Text(
                  '${placemark.subLocality}, ${placemark.locality}, ${placemark.postalCode}, ${placemark.country}',
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      onSave();
                      context.read<PageManager>().returnLatLng(latLng);
                    },
                    child: const Text('Simpan'),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
