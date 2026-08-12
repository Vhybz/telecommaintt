import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import 'package:flutter_map/flutter_map.dart' as osm;
import 'package:latlong2/latlong.dart' as latlong;
import '../data/station_repository.dart';
import '../domain/base_station.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/skeleton_loader.dart';

class StationListScreen extends ConsumerStatefulWidget {
  const StationListScreen({super.key});

  @override
  ConsumerState<StationListScreen> createState() => _StationListScreenState();
}

class _StationListScreenState extends ConsumerState<StationListScreen> {
  bool _isMapView = false;

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _buildToolBar(),
          Expanded(
            child: stationsAsync.when(
              data: (stations) => _isMapView ? _buildMapView(context, stations) : _buildStationGrid(stations),
              loading: () => _buildLoadingState(),
              error: (err, stack) => Center(child: Text('Error: $err')),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Wrap(
            spacing: 12,
            runSpacing: 12,
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Use a Wrap here instead of Row to prevent internal overflow
              Wrap(
                spacing: 12,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Text('View Mode:', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(value: false, icon: Icon(Icons.grid_view), label: Text('Grid')),
                      ButtonSegment(value: true, icon: Icon(Icons.map_outlined), label: Text('Map')),
                    ],
                    selected: {_isMapView},
                    onSelectionChanged: (newSelection) {
                      setState(() => _isMapView = newSelection.first);
                    },
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Add Site'),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildMapView(BuildContext context, List<BaseStation> stations) {
    // Force Google Maps for Web regardless of the host OS (Windows/Mac/Linux)
    if (kIsWeb) {
      return _buildGoogleMap(stations);
    }

    // For Native platforms, only use Google Maps on Android and iOS
    final platform = Theme.of(context).platform;
    if (platform == TargetPlatform.android || platform == TargetPlatform.iOS) {
      return _buildGoogleMap(stations);
    }

    // Fallback for native Windows, macOS, and Linux
    return _buildOsmMap(stations);
  }

  Widget _buildGoogleMap(List<BaseStation> stations) {
    return google.GoogleMap(
      initialCameraPosition: const google.CameraPosition(
        target: google.LatLng(7.9465, -1.0232), // Centered on Ghana
        zoom: 7,
      ),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      mapType: google.MapType.normal,
      markers: stations.map((station) {
        final lat = station.latitude ?? 5.6037;
        final lng = station.longitude ?? -0.1870;

        return google.Marker(
          markerId: google.MarkerId(station.id),
          position: google.LatLng(lat, lng),
          infoWindow: google.InfoWindow(
            title: station.name,
            snippet: 'Status: ${station.status}',
          ),
          onTap: () => _showStationDetails(station),
          icon: google.BitmapDescriptor.defaultMarkerWithHue(
            station.status == 'Online' ? google.BitmapDescriptor.hueGreen : google.BitmapDescriptor.hueRed,
          ),
        );
      }).toSet(),
    );
  }

  Widget _buildOsmMap(List<BaseStation> stations) {
    return osm.FlutterMap(
      options: const osm.MapOptions(
        initialCenter: latlong.LatLng(7.9465, -1.0232),
        initialZoom: 7,
      ),
      children: [
        osm.TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.telecomf',
        ),
        osm.MarkerLayer(
          markers: stations.map((station) {
            final lat = station.latitude ?? 5.6037;
            final lng = station.longitude ?? -0.1870;
            final statusColor = station.status == 'Online' ? AppColors.success : AppColors.error;

            return osm.Marker(
              point: latlong.LatLng(lat, lng),
              width: 40,
              height: 40,
              child: GestureDetector(
                onTap: () => _showStationDetails(station),
                child: Container(
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: statusColor, width: 2),
                  ),
                  child: Icon(Icons.cell_tower, color: statusColor, size: 20),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showStationDetails(BaseStation station) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      pageBuilder: (context, anim1, anim2) => Center(
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 40),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(station.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('Site ID: ${station.siteId}'),
                Text('Status: ${station.status}'),
                Text('Region: ${station.regionId}'),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () => Navigator.pop(context), child: const Text('Close')),
                    const SizedBox(width: 8),
                    ElevatedButton(onPressed: () {}, child: const Text('View Full Specs')),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return GridView.builder(
      padding: const EdgeInsets.all(24),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: 8,
      itemBuilder: (context, index) => const StationSkeleton(),
    );
  }

  Widget _buildStationGrid(List<BaseStation> stations) {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 1200 ? 4 : (constraints.maxWidth > 800 ? 2 : 1);
      return GridView.builder(
        padding: const EdgeInsets.all(24),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 1.5,
        ),
        itemCount: stations.length,
        itemBuilder: (context, index) {
          final station = stations[index];
          return _buildStationCard(context, station);
        },
      );
    });
  }

  Widget _buildStationCard(BuildContext context, BaseStation station) {
    Color statusColor = station.status == 'Online' ? AppColors.success : AppColors.error;

    return Card(
      child: InkWell(
        onTap: () => _showStationDetails(station),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      station.status,
                      style: TextStyle(color: statusColor, fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ),
                  const Icon(Icons.more_vert),
                ],
              ),
              const Spacer(),
              Text(
                station.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                station.siteId,
                style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(Icons.location_on_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text('Region ID: ', style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                  Text('${station.regionId ?? "N/A"}', style: const TextStyle(fontSize: 12)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
