import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart' as osm;
import 'package:latlong2/latlong.dart' as latlong;
import '../data/station_repository.dart';
import '../domain/base_station.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/skeleton_loader.dart';
import 'add_station_dialog.dart';
import '../../predictions/data/prediction_repository.dart';
import '../../maintenance/presentation/add_task_dialog.dart';

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
    final predictionsAsync = ref.watch(predictionsProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          _buildToolBar(),
          Expanded(
            child: stationsAsync.when(
              data: (stations) {
                final predictions = predictionsAsync.asData?.value ?? [];
                return _isMapView 
                    ? _buildMapView(context, stations, predictions) 
                    : _buildStationGrid(stations, predictions);
              },
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
                onPressed: () => showDialog(
                  context: context,
                  builder: (context) => const AddStationDialog(),
                ),
                icon: const Icon(Icons.add),
                label: const Text('Add Site'),
              ),
            ],
          );
        }
      ),
    );
  }

  Widget _buildMapView(BuildContext context, List<BaseStation> stations, List<dynamic> predictions) {
    return _buildOsmMap(stations, predictions);
  }

  Widget _buildOsmMap(List<BaseStation> stations, List<dynamic> predictions) {
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
            
            // Find latest prediction for this station
            final prediction = predictions.where((p) => p.stationId == station.id).firstOrNull;
            
            Color markerColor = station.status == 'Online' ? AppColors.success : AppColors.error;
            if (prediction != null) {
              if (prediction.riskLevel == 'High') {
                markerColor = AppColors.critical;
              } else if (prediction.riskLevel == 'Medium') {
                markerColor = AppColors.warning;
              } else if (prediction.riskLevel == 'Low') {
                markerColor = AppColors.success;
              }
            }

            return osm.Marker(
              point: latlong.LatLng(lat, lng),
              width: 45,
              height: 45,
              child: GestureDetector(
                onTap: () => _showStationDetails(station, prediction),
                child: Container(
                  decoration: BoxDecoration(
                    color: markerColor.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: markerColor, width: 3),
                    boxShadow: [
                      BoxShadow(color: markerColor.withValues(alpha: 0.3), blurRadius: 8, spreadRadius: 2),
                    ],
                  ),
                  child: Icon(Icons.cell_tower, color: markerColor, size: 24),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showStationDetails(BaseStation station, dynamic prediction) {
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(station.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
                  ],
                ),
                const SizedBox(height: 16),
                Text('Site ID: ${station.siteId}'),
                Text('Current Status: ${station.status}', style: TextStyle(
                  color: station.status == 'Online' ? AppColors.success : AppColors.error,
                  fontWeight: FontWeight.bold,
                )),
                if (prediction != null) ...[
                  const Divider(height: 32),
                  const Text('AI Health Insights:', style: TextStyle(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Predicted Fault: ${prediction.faultType ?? "None"}'),
                  Text('Risk Level: ${prediction.riskLevel}', style: TextStyle(
                    color: _getRiskColor(prediction.riskLevel),
                    fontWeight: FontWeight.bold,
                  )),
                ],
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _editStation(station);
                      },
                      icon: const Icon(Icons.edit, size: 16),
                      label: const Text('Edit'),
                    ),
                    const SizedBox(width: 8),
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pop(context);
                        _deleteStation(station);
                      },
                      icon: const Icon(Icons.delete, size: 16, color: Colors.red),
                      label: const Text('Delete', style: TextStyle(color: Colors.red)),
                    ),
                    const Spacer(),
                    if (station.status != 'Online')
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                          showDialog(
                            context: context,
                            builder: (context) => AddTaskDialog(initialStationId: station.id),
                          );
                        },
                        icon: const Icon(Icons.build, size: 16),
                        label: const Text('Create Task'),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _editStation(BaseStation station) {
    showDialog(
      context: context,
      builder: (context) => AddStationDialog(station: station),
    );
  }

  void _deleteStation(BaseStation station) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Base Station'),
        content: Text('Are you sure you want to delete ${station.name}? This action cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () async {
              try {
                await ref.read(stationRepositoryProvider).deleteStation(station.id);
                ref.invalidate(stationsProvider);
                if (context.mounted) {
                  Navigator.pop(context);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Station deleted successfully')),
                  );
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
            child: const Text('Delete'),
          ),
        ],
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

  Widget _buildStationGrid(List<BaseStation> stations, List<dynamic> predictions) {
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
          final prediction = predictions.where((p) => p.stationId == station.id).firstOrNull;
          return _buildStationCard(context, station, prediction);
        },
      );
    });
  }

  Widget _buildStationCard(BuildContext context, BaseStation station, dynamic prediction) {
    Color statusColor = station.status == 'Online' ? AppColors.success : AppColors.error;
    if (prediction != null) {
      if (prediction.riskLevel == 'High') {
        statusColor = AppColors.critical;
      } else if (prediction.riskLevel == 'Medium') {
        statusColor = AppColors.warning;
      }
    }

    return Card(
      child: InkWell(
        onTap: () => _showStationDetails(station, prediction),
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
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        _editStation(station);
                      } else if (value == 'delete') {
                        _deleteStation(station);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'edit', child: Text('Edit')),
                      const PopupMenuItem(value: 'delete', child: Text('Delete', style: TextStyle(color: Colors.red))),
                    ],
                    icon: const Icon(Icons.more_vert),
                  ),
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

  Color _getRiskColor(String? risk) {
    if (risk == null) return AppColors.success;
    switch (risk) {
      case 'High': return AppColors.critical;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return AppColors.success;
    }
  }
}
