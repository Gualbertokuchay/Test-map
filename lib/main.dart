import 'package:flutter/material.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MapSample(),
    );
  }
}

class MapSample extends StatefulWidget {
  const MapSample({Key? key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();

  static const CameraPosition _posicion = CameraPosition(
    target: LatLng(37.7749, -122.4194),
    zoom: 14.0,
  );

  late Marker _carroMarker;
  final List<LatLng> coordenadas = [
    LatLng(37.7749, -122.4194),
    LatLng(37.7897, -122.4230),
    LatLng(37.7749, -122.4194),
    LatLng(37.7749, -122.4194),
    LatLng(37.7755, -122.4180),
    LatLng(37.7742, -122.4205),
    LatLng(37.7750, -122.4212),
    LatLng(37.7757, -122.4188),
  ];
  int _markerIndex = 0;

  @override
  void initState() {
    super.initState();

    _carroMarker = Marker(
      markerId: const MarkerId("carro"),
      position: coordenadas.first,
      icon: BitmapDescriptor.defaultMarker,
    );

    _startRouteSimulation();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: _posicion,
        markers: {_carroMarker},
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
        },
      ),
    );
  }

  Future<void> _animacion() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _markerIndex = (_markerIndex + 1) % coordenadas.length;
      _carroMarker = _carroMarker.copyWith(
        positionParam: coordenadas[_markerIndex],
      );
    });
  }

  Future<void> _startRouteSimulation() async {
    while (true) {
      await _animacion();
    }
  }
}
