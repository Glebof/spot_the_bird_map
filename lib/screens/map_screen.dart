import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:spot_the_bird/bloc/location_cubit.dart';

class MapScreen extends StatelessWidget {

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<LocationCubit, LocationState>(
        listener: (previousState, currentState) {
          if (currentState is LocationLoaded) {
            _mapController.onReady.then((_) =>
                _mapController.move(
                    LatLng(currentState.latitude, currentState.longitude), 14));
          }
          if (currentState is LocationError) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: Duration(seconds: 5),
                backgroundColor: Colors.red.withOpacity(0.6),
                content: Text("Error, uneble to fetch location...")
            ));
          }
        },
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            center: LatLng(0, 0),
            zoom: 2.3,
            maxZoom: 17,
            minZoom: 3.5,
          ),
          layers: [
            TileLayerOptions(
              urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c'],
              retinaMode: true,
            )
          ],
        ),
      ),

    );
  }
}

