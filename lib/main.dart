import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quickloc8',
      theme: ThemeData(
        primaryColor: const Color(0xFFFF5722),
        colorScheme: ThemeData().colorScheme.copyWith(
              secondary: const Color(0xFF2e302f),
            ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => const MapScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Image.asset('assets/Quicloc8_logo.png'),
      ),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  List<Marker> allMarkers = [];

  @override
  void initState() {
    super.initState();
    loadVehicleCoordinates().then((vehicles) {
      for (var vehicle in vehicles) {
        BitmapDescriptor.fromAssetImage(
          const ImageConfiguration(devicePixelRatio: 2.0),
          'assets/ic_new_white_taxi.png',
        ).then((icon) {
          setState(() {
            allMarkers.add(
              Marker(
                markerId: MarkerId(vehicle['id']),
                position: LatLng(vehicle['lat'], vehicle['lng']),
                icon: icon,
                rotation: vehicle['direction'],
              ),
            );
          });
        });
      }
    });
  }

  Future<List> loadVehicleCoordinates() async {
    String jsonString =
        await newMethod().loadString('assets/vehicleCoordinates.json');
    List vehicleCoordinates = json.decode(jsonString);
    return vehicleCoordinates.map((vehicle) {
      return {
        'id': vehicle['id'],
        'lat': vehicle['latitude'],
        'lng': vehicle['longitude'],
        'direction': vehicle['heading'],
      };
    }).toList();
  }

  AssetBundle newMethod() => rootBundle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const MessageScreen()));
            },
          ),
        ],
      ),
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: LatLng(-25.757999, 28.201021),
          zoom: 14.0,
        ),
        markers: Set.from(allMarkers),
      ),
    );
  }
}

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  MessageScreenState createState() => MessageScreenState();
}

class MessageScreenState extends State<MessageScreen> {
  List messages = [];

  @override
  void initState() {
    super.initState();
    loadMessages().then((msgs) {
      setState(() {
        messages = msgs;
      });
    });
  }

  Future<List> loadMessages() async {
    String jsonString = await rootBundle.loadString('assets/messages.json');
    return json.decode(jsonString);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
      ),
      body: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(messages[index]['subject']),
            subtitle: Text(messages[index]['message']),
            trailing: Text(messages[index]['display']),
          );
        },
      ),
    );
  }
}
