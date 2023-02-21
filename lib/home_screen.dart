import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';

class MapmarkerMove extends StatefulWidget {
  const MapmarkerMove({Key? key}) : super(key: key);

  @override
  State<MapmarkerMove> createState() => _MapmarkerMoveState();
}

class _MapmarkerMoveState extends State<MapmarkerMove> {
  late String markerAddress = '';
  Completer<GoogleMapController> _controller = Completer();

  static final CameraPosition _kGooglePlex = const CameraPosition(
    target: LatLng(24.625682441102725, 73.67953981086517),
    zoom: 15,
  );

  List<Marker> _marker = [];
  List<Marker> _list = [];

  @override
  void initState() {
    _list = [
      Marker(
        draggable: true,
        markerId: const MarkerId('1'),
        position: LatLng(24.625682441102725, 73.67953981086517),
        onDragEnd: ((LatLng newPosition) async {
          List<Placemark> placemarks = await placemarkFromCoordinates(
              newPosition.latitude, newPosition.longitude);
          String add =
              '${placemarks.reversed.last.subLocality} ${placemarks.reversed.last.subAdministrativeArea}  ${placemarks.reversed.last.locality.toString()}  ${placemarks.reversed.last.administrativeArea.toString()}';

          setState(() {
            markerAddress = add;
          });
        }),
      )
    ];
    super.initState();
    _marker.addAll(_list);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 5, right: 5, top: 5),
              padding: EdgeInsets.only(left: 10, right: 10),
              height: 70,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.withOpacity(0.3)),
              child: Center(
                child: Text(
                  markerAddress,
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            SizedBox(
              child: Divider(
                thickness: 1,
                color: Colors.grey.withOpacity(0.8),
              ),
              height: 5,
            ),
            Expanded(
              child: Container(
                height: MediaQuery.of(context).size.height / 1.2,
                child: GoogleMap(
                  markers: Set.of(_marker),
                  initialCameraPosition: _kGooglePlex,
                  mapType: MapType.normal,
                  onMapCreated: (GoogleMapController controller) {
                    _controller.complete(controller);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
