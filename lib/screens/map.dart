import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  final String pageTitle;

  MapPage({Key? key, this.pageTitle = 'Map'}) : super(key: key);

  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const CameraPosition _initialPosition =
  CameraPosition(target: LatLng(43.4725, -80.5331), zoom: 11.5);

  late GoogleMapController _mapController;
  Set<Marker> _markers = Set();

  @override
  void initState() {
    super.initState();

    _addMarkers();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  // Add markers to the map
  void _addMarkers() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId("Super Burger1"),
        position: LatLng(43.4725, -80.5331),
        infoWindow: InfoWindow(title: "Super Burger"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("Super Burger2"),
        position: LatLng(43.4787, -80.5251),
        infoWindow: InfoWindow(title: "Super Burger"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("Super Burger3"),
        position: LatLng(43.4643, -80.5204),
        infoWindow: InfoWindow(title: "Super Burger"),
      ));

      _markers.add(Marker(
        markerId: MarkerId("Super Burger4"),
        position: LatLng(43.4515, -80.5044),
        infoWindow: InfoWindow(title: "Super Burger"),
      ));

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          widget.pageTitle,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);  // Go back to previous screen
          },
        ),
      ),
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: _initialPosition,
        markers: _markers,  // Add markers to the map
      ),
    );
  }
}
