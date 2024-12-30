import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart' as geo;

class MapsScreen extends StatefulWidget {
  final LatLng? latLng;
  const MapsScreen({
    super.key,
    this.latLng,
  });

  @override
  State<MapsScreen> createState() => _MapsScreenState();
}

class _MapsScreenState extends State<MapsScreen> {
  geo.Placemark? placemark;

  late GoogleMapController mapController;
  final Set<Marker> markers = {};
  MapType selectedMapType = MapType.normal;

  Future<void> setMapStyle() async {
    String value = await DefaultAssetBundle.of(context)
        .loadString('assets/map_style.json');
    await mapController.setMapStyle(value);
  }

  void defineMarker(LatLng latLng, String street, String address) {
    final marker = Marker(
      markerId: const MarkerId("dicoding"),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Stack(
            children: [
              GoogleMap(
                markers: markers,
                mapType: selectedMapType,
                initialCameraPosition: CameraPosition(
                  zoom: 18,
                  target: widget.latLng!,
                ),
                onMapCreated: (controller) async {
                  final storyLatLng = widget.latLng;
                  final info = await geo.placemarkFromCoordinates(
                    storyLatLng?.latitude ?? 0.0,
                    storyLatLng?.longitude ?? 0.0,
                  );
                  final place = info[0];
                  final street = place.street!;
                  final address =
                      '${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
                  setState(() {
                    placemark = place;
                  });

                  defineMarker(storyLatLng!, street, address);

                  setState(() {
                    mapController = controller;
                  });
                  await setMapStyle();
                },
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
              ),
              Positioned(
                bottom: 16,
                right: 16,
                child: Column(
                  children: [
                    FloatingActionButton.small(
                      heroTag: "zoom-in",
                      onPressed: () {
                        mapController.animateCamera(
                          CameraUpdate.zoomIn(),
                        );
                      },
                      child: const Icon(Icons.add),
                    ),
                    FloatingActionButton.small(
                      heroTag: "zoom-out",
                      onPressed: () {
                        mapController.animateCamera(
                          CameraUpdate.zoomOut(),
                        );
                      },
                      child: const Icon(Icons.remove),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: 16,
                right: 16,
                child: FloatingActionButton.small(
                  onPressed: null,
                  child: PopupMenuButton<MapType>(
                    onSelected: (MapType item) {
                      setState(() {
                        selectedMapType = item;
                      });
                    },
                    offset: const Offset(0, 54),
                    icon: const Icon(Icons.layers_outlined),
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<MapType>>[
                      const PopupMenuItem<MapType>(
                        value: MapType.normal,
                        child: Text('Normal'),
                      ),
                      const PopupMenuItem<MapType>(
                        value: MapType.satellite,
                        child: Text('Satellite'),
                      ),
                      const PopupMenuItem<MapType>(
                        value: MapType.terrain,
                        child: Text('Terrain'),
                      ),
                      const PopupMenuItem<MapType>(
                        value: MapType.hybrid,
                        child: Text('Hybrid'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
