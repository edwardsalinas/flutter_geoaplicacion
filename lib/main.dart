import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load the secret API key first
  await dotenv.load(fileName: "api_key.env");

  // Manually load and parse the public coordinates file
  try {
    String coordinatesString = await rootBundle.loadString('coordinates.env');
    for (String line in coordinatesString.split('\n')) {
      if (line.contains('=')) {
        List<String> parts = line.split('=');
        if (parts.length == 2) {
          dotenv.env[parts[0].trim()] = parts[1].trim();
        }
      }
    }
  } catch (e) {
    print("Could not load coordinates.env: $e");
  }

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
    // Load geographic coordinates from environment, with fallbacks just in case
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
          title: 'Casa',
          snippet: 'Av. Beijing y Blanco Galindo (aprox)',
        ),
      ),
      Marker(
        markerId: const MarkerId('work'),
        position: LatLng(workLat, workLng),
        infoWindow: const InfoWindow(
          title: 'Trabajo',
          snippet: 'Jalasoft',
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
          zoom: 14.0,
        ),
        markers: _createMarkers(),
        mapType: MapType.normal,
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}