import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:discover/ui/lokacija_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';

import '../backend.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  double? lat;
  double? long;

  Future<Position> getMyLocation() async {
    return await Geolocator.getCurrentPosition();
  }

  @override
  void initState() {
    super.initState();
    getMyLocation().then((value) {
      setState(() {
        lat = value.latitude;
        long = value.longitude;
      });
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final backend = Provider.of<Backend>(context);
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          title: const Text("Map"),
          backgroundColor: Theme.of(context).colorScheme.surface.withAlpha(0),
          elevation: 0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 7, sigmaY: 7),
              child: Container(
                color: Theme.of(context).colorScheme.surface.withAlpha(204),
              ),
            ),
          ),
        ),
        body: lat == null || long == null
            ? const Center(child: CircularProgressIndicator())
            : FlutterMap(
                options: MapOptions(
                  initialCameraFit: CameraFit.coordinates(
                      maxZoom: 17, coordinates: [LatLng(lat!, long!)]),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: [
                      Marker(
                        height: 80,
                        width: 80,
                        rotate: true,
                        point: LatLng(
                            lat! + (70 / 1000000), long! - (70 / 1000000)),
                        child: const Icon(
                          Icons.person_pin_circle,
                          color: Colors.blue,
                          size: 60,
                        ),
                      ),
                    ]..addAll(backend.lokacije
                        .map((e) => Marker(
                            height: 80,
                            width: 80,
                            rotate: true,
                            point: LatLng(e.lat ?? 0, e.long ?? 0),
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) =>
                                        LokacijaPage(lokacija: e)));
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Stack(
                                  children: [
                                    CachedNetworkImage(
                                      imageUrl: e.slike.first,
                                      height: 80,
                                      width: 80,
                                      fit: BoxFit.cover,
                                    ),
                                    Positioned(
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        color: Colors.black.withAlpha(128),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e.naziv ?? "",
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 12),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )))
                        .toList()),
                  )
                ],
              ));
  }
}
