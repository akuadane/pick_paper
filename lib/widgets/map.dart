import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class Map extends StatefulWidget {
  @override
  _MapState createState() => _MapState();
}

class _MapState extends State<Map> {
  GoogleMapController _mapController;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder<GeoPoint>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            GeoPoint currentPosition = snapshot.data;
            return GoogleMap(
              onMapCreated: (GoogleMapController controller) {
                setState(() {
                  _mapController = controller;
                });
              },
              zoomControlsEnabled: false,
              mapType: MapType.normal,
              gestureRecognizers: Set()
                ..add(Factory<EagerGestureRecognizer>(
                    () => EagerGestureRecognizer())),
              initialCameraPosition: CameraPosition(
                target:
                    LatLng(currentPosition.latitude, currentPosition.longitude),
                zoom: 17,
              ),
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<GeoPoint> _getCurrentLocation() async {
    Location location = new Location();

    GeoPoint locationOfEthiopia = GeoPoint(9.1450, 40.4897);

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return locationOfEthiopia;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return locationOfEthiopia;
      }
    }

    _locationData = await location.getLocation();

    return GeoPoint(_locationData.latitude, _locationData.longitude);
  }
}
