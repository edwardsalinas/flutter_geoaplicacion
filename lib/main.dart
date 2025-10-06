import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: "coordinates.env");
  await dotenv.load(fileName: "api_key.env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Geolocation App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? mapController;
  late String apiKey;
  late double homeLat;
  late double homeLng;
  late double workLat;
  late double workLng;

  @override
  void initState() {
    super.initState();
    _loadEnvironmentVariables();
  }

  void _loadEnvironmentVariables() {
    // Load API key from environment
    apiKey = dotenv.env['GOOGLE_MAPS_API_KEY'] ?? '';
    
    // Load geographic coordinates from environment
    homeLat = double.tryParse(dotenv.env['HOME_LAT'] ?? '-33.4489') ?? -33.4489;
    homeLng = double.tryParse(dotenv.env['HOME_LNG'] ?? '-70.6693') ?? -70.6693;
    workLat = double.tryParse(dotenv.env['WORK_LAT'] ?? '-33.4295') ?? -33.4295;
    workLng = double.tryParse(dotenv.env['WORK_LNG'] ?? '-70.6033') ?? -70.6033;
  }

  Set<Marker> _createMarkers() {
    return <Marker>{
      Marker(
        markerId: const MarkerId('home'),
        position: LatLng(homeLat, homeLng),
        infoWindow: const InfoWindow(
          title: 'Home',
          snippet: 'Your home location',
        ),
      ),
      Marker(
        markerId: const MarkerId('work'),
        position: LatLng(workLat, workLng),
        infoWindow: const InfoWindow(
          title: 'Work',
          snippet: 'Your work location',
        ),
      ),
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Geolocation Map'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(homeLat, homeLng),
          zoom: 12.0,
        ),
        markers: _createMarkers(),
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
