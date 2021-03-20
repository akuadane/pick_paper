import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:location/location.dart';
import 'package:pick_paper/handlers/firebase_storage_helper.dart';
import 'package:pick_paper/handlers/firestore_helper.dart';
import 'package:pick_paper/models/saved_location.dart';
import 'package:pick_paper/models/shared_location.dart';
import 'package:pick_paper/models/shared_user.dart';

import 'package:pick_paper/widgets/map.dart';
import 'package:provider/provider.dart';

class CreateRequest extends StatefulWidget {
  @override
  _CreateRequestState createState() => _CreateRequestState();
}

class _CreateRequestState extends State<CreateRequest> {
  int _paperMass = 1;
  QueryDocumentSnapshot _user;
  File _image;

  SavedLocation dropdownValue;
  List<SavedLocation> listOfSavedLocations = [];

  GoogleMapController _mapController;
  Location _location = new Location();
  GeoPoint _centerPosition;

  List<Marker> _markers = [Marker()];
  Marker _currentLocationMarker;
  TextEditingController controller = TextEditingController();

  bool firstTimeLoading = true;

  @override
  Widget build(BuildContext context) {
    this._user = Provider.of<SharedUser>(context).user;
    listOfSavedLocations = [];
    _user["savedAddresses"].forEach((name, location) =>
        listOfSavedLocations.add(SavedLocation(name, location)));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "CREATE REQUEST",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back),
        ),
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Size ~ (Kg)",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Row(
                          children: [
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 35, vertical: 15),
                              decoration: BoxDecoration(
                                  border:
                                      Border.all(color: Colors.black, width: 2),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "${this._paperMass}",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25, top: 15, right: 15, bottom: 15),
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000),
                                  onTap: () {
                                    if (this._paperMass > 1) {
                                      setState(() {
                                        this._paperMass--;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.remove,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Ink(
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.black),
                                    shape: BoxShape.circle),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(1000),
                                  onTap: () {
                                    if (this._paperMass < 15) {
                                      setState(() {
                                        this._paperMass++;
                                      });
                                    }
                                  },
                                  child: Icon(
                                    Icons.add,
                                    size: 35,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ), // Mass input
                SizedBox(
                  height: 20,
                ), // Separator
                Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "Add a picture",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "A recent photograph of the paper to be recycled. Use either the camera or choose pre-taken picture"
                          "from your gallery.",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0XFFEEEEEE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  File tempImage = await ImagePicker.pickImage(
                                      source: ImageSource.gallery);

                                  setState(() {
                                    this._image = tempImage;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.photo,
                                        size: 60,
                                      ),
                                      Text(
                                        "Gallery",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Ink(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0XFFEEEEEE),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(4, 4),
                                  ),
                                ],
                              ),
                              child: InkWell(
                                onTap: () async {
                                  File tempImage = await ImagePicker.pickImage(
                                      source: ImageSource.camera);

                                  setState(() {
                                    this._image = tempImage;
                                  });
                                },
                                child: Padding(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 20),
                                  child: Column(
                                    children: [
                                      Icon(
                                        Icons.camera_enhance_outlined,
                                        size: 60,
                                      ),
                                      Text(
                                        "Camera",
                                        style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: this._image != null,
                        child: Builder(
                          builder: (context) {
                            if (this._image != null)
                              return Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: Image.file(this._image)),
                              );
                            return Container();
                          },
                        ),
                      ),
                    ],
                  ),
                ), // Add a picture
                SizedBox(
                  height: 20,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Choose Pick-Up Location On Map",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height * 0.5,
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: map(),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Text(
                          "Or Choose From Saved Locations",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(5.0),
                          child: DropdownButton<SavedLocation>(
                            value: dropdownValue,
                            icon: const Icon(Icons.arrow_drop_down),
                            iconSize: 24,
                            elevation: 16,
                            onChanged: (SavedLocation newValue) {
                              setState(() {
                                dropdownValue = newValue;
                                _goto(newValue.location);
                              });
                            },
                            items: listOfSavedLocations
                                .map<DropdownMenuItem<SavedLocation>>(
                                    (SavedLocation value) {
                              return DropdownMenuItem<SavedLocation>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                        // Expanded(
                        //   child: Padding(
                        //     padding: const EdgeInsets.all(10.0),
                        //     child: InkWell(
                        //       borderRadius: BorderRadius.circular(30),
                        //       onTap: () {},
                        //       child: Container(
                        //         padding: EdgeInsets.all(10),
                        //         child: Center(
                        //           child: Padding(
                        //             padding: const EdgeInsets.all(5.0),
                        //             child: Text(
                        //               "Map",
                        //               style: TextStyle(
                        //                 fontSize: 15,
                        //                 fontWeight: FontWeight.bold,
                        //               ),
                        //             ),
                        //           ),
                        //         ),
                        //         decoration: BoxDecoration(
                        //           color: Color(0XFFEEEEEE),
                        //           borderRadius: BorderRadius.circular(30),
                        //           boxShadow: [
                        //             BoxShadow(
                        //               color: Colors.grey.withOpacity(0.5),
                        //               spreadRadius: 1,
                        //               blurRadius: 2,
                        //               offset: Offset(4, 4),
                        //             ),
                        //           ],
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(10.0),
                      //   child: InkWell(
                      //     borderRadius: BorderRadius.circular(30),
                      //     onTap: () {},
                      //     child: Container(
                      //       padding: EdgeInsets.all(10),
                      //       child: Center(
                      //         child: Padding(
                      //           padding: const EdgeInsets.all(5.0),
                      //           child: Text(
                      //             "My current location",
                      //             style: TextStyle(
                      //               fontSize: 15,
                      //               fontWeight: FontWeight.bold,
                      //             ),
                      //           ),
                      //         ),
                      //       ),
                      //       decoration: BoxDecoration(
                      //         color: Color(0XFFEEEEEE),
                      //         borderRadius: BorderRadius.circular(30),
                      //         boxShadow: [
                      //           BoxShadow(
                      //             color: Colors.grey.withOpacity(0.5),
                      //             spreadRadius: 1,
                      //             blurRadius: 2,
                      //             offset: Offset(4, 4),
                      //           ),
                      //         ],
                      //       ),
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
                Builder(
                  builder: (context) => InkWell(
                    borderRadius: BorderRadius.circular(30),
                    onTap: () async {
                      if (this._image != null) {
                        showDialog(
                          context: context,
                          builder: (context) => Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                        String photoURL =
                            await FirebaseStorageHelper.uploadPaperPhoto(
                                this._image, this._user.id);

                        if (photoURL.isNotEmpty) {
                          await FirestoreHelper.createRequest(this._user.id,
                              _paperMass, photoURL, _centerPosition);
                        }
                        FirebaseMessaging().subscribeToTopic("test");

                        Navigator.pop(
                            context); // removes the circular progress bar
                        Navigator.pop(
                            context); // goes back to the previous page
                      } else {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text("Please choose an image"),
                          duration: Duration(seconds: 2),
                        ));
                      }
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(10),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            "SEND",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Color(0XFF85FF40),
                              Color(0XFF0CE69C),
                            ],
                            begin: const FractionalOffset(0.0, 1.0),
                            end: const FractionalOffset(1.0, 0.0),
                            stops: [0.0, 1.0],
                            tileMode: TileMode.clamp),
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget map() {
    double mapHeight = (MediaQuery.of(context).size.height * 0.5);
    double mapWidth = (MediaQuery.of(context).size.width);
    double iconSize = 50;

    final _user = Provider.of<SharedUser>(context);
    return Container(
      child: FutureBuilder<GeoPoint>(
        future: _getCurrentLocation(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Stack(
              children: [
                GoogleMap(
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
                    target: LatLng(
                        _centerPosition.latitude, _centerPosition.longitude),
                    zoom: 17,
                  ),
                  myLocationButtonEnabled: true,
                  myLocationEnabled: true,
                  onCameraMove: (CameraPosition position) {
                    _centerPosition = GeoPoint(
                        position.target.latitude, position.target.longitude);
                    print(_centerPosition.longitude);
                  },
                ),
                Positioned(
                  top: mapHeight / 2 - iconSize,
                  left: mapWidth / 2 - iconSize,
                  child: Image.asset(
                    "images/pickPaperMarker.png",
                    scale: 2,
                  ),
                ),
                Positioned(
                  bottom: 10,
                  right: 10,
                  child: Opacity(
                    opacity: 0.9,
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Colors.white70,
                          borderRadius: BorderRadius.circular(2)),
                      child: InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Save location"),
                              content: TextFormField(
                                controller: controller,
                                decoration: InputDecoration(
                                  hintText: "Name this location",
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    if (controller.text != null &&
                                        controller.text != "") {
                                      FirestoreHelper.addToSavedLocation(_user,
                                          controller.text, _centerPosition);
                                      controller.text = "";
                                    }
                                    Navigator.pop(context);
                                  },
                                  child: Text("Save"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Icon(
                          Icons.add,
                          color: Colors.black87,
                          size: 25,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
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
    GeoPoint locationOfEthiopia = GeoPoint(9.1450, 40.4897);
    _currentLocationMarker = Marker(
      position:
          LatLng(locationOfEthiopia.latitude, locationOfEthiopia.longitude),
      infoWindow: InfoWindow(title: "Current location"),
    );
    _markers[0] = _currentLocationMarker;

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await _location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await _location.requestService();
      if (!_serviceEnabled) {
        return locationOfEthiopia;
      }
    }

    _permissionGranted = await _location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await _location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return locationOfEthiopia;
      }
    }

    _locationData = await _location.getLocation();
    _currentLocationMarker = Marker(
      position: LatLng(_locationData.latitude, _locationData.longitude),
      infoWindow: InfoWindow(title: "Current location"),
    );
    _markers[0] = _currentLocationMarker;
    if (firstTimeLoading) {
      _centerPosition =
          GeoPoint(_locationData.latitude, _locationData.longitude);
      firstTimeLoading = false;
    }

    return GeoPoint(_locationData.latitude, _locationData.longitude);
  }

  _goto(GeoPoint position) {
    _mapController.animateCamera(CameraUpdate.newCameraPosition(CameraPosition(
      target: LatLng(position.latitude, position.longitude),
      zoom: 17,
    )));
  }
}
