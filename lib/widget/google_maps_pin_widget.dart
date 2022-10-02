import 'package:flutter/material.dart';
import 'package:foldable_app/provider/location_notifier.dart';
import 'package:provider/provider.dart';

import '/data/model/locations.dart' as locations;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsPinWidget extends StatefulWidget {
  final List<locations.Office> googleOffices;
  final locations.Office? office;

  const GoogleMapsPinWidget({
    Key? key,
    required this.googleOffices,
    this.office,
  }) : super(key: key);

  @override
  State<GoogleMapsPinWidget> createState() => GoogleMapsPinWidgetState();
}

class GoogleMapsPinWidgetState extends State<GoogleMapsPinWidget> {
  late BitmapDescriptor sourceIcon;
  late GoogleMapController googleMapController;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          context.watch<LocationNotifier>().isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : GoogleMap(
                  onMapCreated: (controller) {
                    googleMapController = controller;
                    _setMarker();
                    if (widget.office != null) {
                      final camera = CameraUpdate.newLatLngZoom(
                        LatLng(widget.office!.lat, widget.office!.lng),
                        2,
                      );
                      controller.animateCamera(camera);
                    }
                  },
                  initialCameraPosition: const CameraPosition(
                    target: LatLng(-6.8957473, 107.6337669),
                    zoom: 2,
                  ),
                  markers: _setMarker(),
                ),
        ],
      ),
    );
  }

  Set<Marker> _setMarker() {
    final Map<String, Marker> markers = {};
    for (final office in widget.googleOffices) {
      final officeLatLng = LatLng(office.lat, office.lng);
      final marker = Marker(
        markerId: MarkerId(office.name),
        position: officeLatLng,
        infoWindow: InfoWindow(
          title: office.name,
          snippet: office.address,
        ),
        onTap: () {
          showDialog(
            context: context,
            anchorPoint: Offset.infinite,
            builder: (context) {
              return AlertDialog(
                title: Text(office.name),
                content: Text(office.address),
                actions: <Widget>[
                  TextButton(
                    style: TextButton.styleFrom(
                      textStyle: Theme.of(context).textTheme.labelLarge,
                    ),
                    child: const Text('Close'),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      );
      markers[office.name] = marker;
    }
    return markers.values.toSet();
  }
}

