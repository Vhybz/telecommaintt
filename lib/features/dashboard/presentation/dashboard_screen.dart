import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../../stations/presentation/station_list_screen.dart';
import '../../faults/presentation/fault_list_screen.dart';
import '../../predictions/presentation/prediction_list_screen.dart';
import '../../predictions/presentation/predictive_maintenance_form.dart';
import '../../auth/presentation/profile_screen.dart';
import '../../equipment/presentation/equipment_list_screen.dart';
import '../../kpis/presentation/kpis_screen.dart';
import '../../maintenance/presentation/maintenance_screen.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../widgets/side_navigation_rail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';
import '../../auth/data/auth_repository.dart';
import '../../stations/data/station_repository.dart';
import '../../predictions/data/prediction_repository.dart';
import '../../predictions/data/model_metadata_repository.dart';
import '../../faults/data/fault_repository.dart';
import '../../maintenance/data/maintenance_repository.dart';
import '../../kpis/data/kpi_repository.dart';
import 'package:intl/intl.dart';

final dashboardMapControllerProvider = StateProvider<google.GoogleMapController?>((ref) => null);
final dashboardMapCenterProvider = StateProvider<google.LatLng>((ref) => const google.LatLng(7.9465, -1.0232)); // Center of Ghana

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

  @override
  void dispose() {
    // Clear map controller when dashboard is disposed to avoid using a dead controller
    ref.read(dashboardMapControllerProvider.notifier).state = null;
    super.dispose();
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildDashboardOverview();
      case 1:
        return const StationListScreen();
      case 2:
        return const EquipmentListScreen();
      case 3:
        return const KpisScreen();
      case 4:
        return const FaultListScreen();
      case 5:
        return const PredictionListScreen();
      case 6:
        return const MaintenanceScreen();
      case 7:
        return const ReportsScreen();
      case 8:
        return const SettingsScreen();
      case 9:
        return const PredictiveMaintenanceForm();
      case 10:
        return const ProfileScreen();
      default:
        return _buildDashboardOverview();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          SideNavigationRail(
            selectedIndex: _selectedIndex,
            onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          ),
          const VerticalDivider(thickness: 1, width: 1),
          Expanded(
            child: Column(
              children: [
                _buildAppBar(),
                Expanded(
                  child: _buildContent(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildAppBar() {
    final profileAsync = ref.watch(userProfileProvider);
    
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        border: Border(
          bottom: BorderSide(
            color: Theme.of(context).dividerColor.withValues(alpha: 0.1),
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Predictive Maintenance Dashboard',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, letterSpacing: -0.5),
                  overflow: TextOverflow.ellipsis,
                ),
                profileAsync.when(
                  data: (profile) => Text(
                    'Welcome back, ${profile?['full_name'] ?? 'User'} 👋',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    overflow: TextOverflow.ellipsis,
                  ),
                  loading: () => const SizedBox(height: 12, width: 100, child: LinearProgressIndicator()),
                  error: (_, error) => Text(
                    'Welcome back 👋',
                    style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Date & Time
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today_outlined, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                const SizedBox(width: 8),
                Text(
                  '${DateTime.now().day} ${_getMonth(DateTime.now().month)} ${DateTime.now().year}, ${_formatTime(DateTime.now())}',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Theme Toggle
          Consumer(
            builder: (context, ref, child) {
              final themeMode = ref.watch(themeModeProvider);
              return IconButton(
                icon: Icon(
                  themeMode == ThemeMode.dark ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
                onPressed: () {
                  ref.read(themeModeProvider.notifier).state = 
                    themeMode == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
                },
              );
            },
          ),
          const SizedBox(width: 8),
          Stack(
            children: [
              IconButton(
                icon: Icon(Icons.notifications_none_rounded, color: Theme.of(context).colorScheme.onSurface),
                onPressed: () => setState(() => _selectedIndex = 4), // Go to Alerts
              ),
              ref.watch(alarmsProvider).when(
                data: (alarms) {
                  final openAlarms = alarms.where((a) => a.status == 'Open').length;
                  if (openAlarms == 0) return const SizedBox.shrink();
                  return Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        openAlarms > 9 ? '9+' : openAlarms.toString(), 
                        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), 
                        textAlign: TextAlign.center
                      ),
                    ),
                  );
                },
                loading: () => const SizedBox.shrink(),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
          const SizedBox(width: 16),
          GestureDetector(
            onTap: () => setState(() => _selectedIndex = 10),
            child: profileAsync.when(
              data: (profile) => CircleAvatar(
                radius: 18,
                backgroundColor: Theme.of(context).colorScheme.primary,
                backgroundImage: profile?['avatar_url'] != null 
                    ? NetworkImage(profile!['avatar_url']) 
                    : null,
                child: profile?['avatar_url'] == null 
                    ? const Icon(Icons.person, color: Colors.white, size: 22)
                    : null,
              ),
              loading: () => const CircleAvatar(radius: 18, child: SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2))),
              error: (_, error) => const CircleAvatar(radius: 18, child: Icon(Icons.person)),
            ),
          ),
        ],
      ),
    );
  }

  String _getMonth(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[month - 1];
  }

  String _formatTime(DateTime dt) {
    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    return '$hour:$minute $ampm';
  }

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAIInsightsHeader(),
          const SizedBox(height: 24),
          _buildStatCardsRow(),
          const SizedBox(height: 24),
          _buildMainDashboardGrid(),
        ],
      ),
    );
  }

  Widget _buildAIInsightsHeader() {
    final predictionsAsync = ref.watch(predictionsProvider);
    
    return predictionsAsync.when(
      data: (predictions) {
        if (predictions.isEmpty) return const SizedBox.shrink();
        
        final topFault = predictions.first.faultType;
        final highRiskCount = predictions.where((p) => p.riskLevel == 'High').length;
        
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                Theme.of(context).colorScheme.secondary.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Icon(Icons.auto_awesome, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AI Maintenance Insights', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(
                      highRiskCount > 0 
                        ? 'Urgent: $highRiskCount high-risk potential faults detected. Primary concern: $topFault.'
                        : 'System stable. Next predicted maintenance event likely related to $topFault.',
                      style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              TextButton(
                onPressed: () => setState(() => _selectedIndex = 5),
                child: const Text('Analyze Patterns'),
              ),
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (error, stack) => const SizedBox.shrink(),
    );
  }

  Widget _buildStatCardsRow() {
    final stationsAsync = ref.watch(stationsProvider);
    final modelMetadataAsync = ref.watch(modelMetadataProvider);
    
    return stationsAsync.when(
      data: (stations) {
        final total = stations.length;
        final healthy = stations.where((s) => s.status == 'Online').length;
        final warning = stations.where((s) => s.status == 'Degraded' || s.status == 'Maintenance').length;
        final critical = stations.where((s) => s.status == 'Offline').length;
        final healthyPercent = total > 0 ? (healthy / total * 100).toStringAsFixed(1) : '0';

        return LayoutBuilder(builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 1400 ? 5 : (constraints.maxWidth > 900 ? 3 : 2);
          // Lower aspect ratio gives more height to cards to prevent bottom overflow
          double aspectRatio = constraints.maxWidth > 1400 ? 2.0 : 1.8;
          
          return GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: aspectRatio,
            children: [
              _buildStatCard('Total Base Stations', total.toString(), Icons.cell_tower, Theme.of(context).colorScheme.primary, 'All Sites'),
              _buildStatCard('Healthy Stations', healthy.toString(), Icons.check_circle_outline, AppColors.success, '$healthyPercent%'),
              _buildStatCard('Warning Stations', warning.toString(), Icons.warning_amber, AppColors.warning, '${total > 0 ? (warning / total * 100).toStringAsFixed(1) : '0'}%'),
              _buildStatCard('Critical Stations', critical.toString(), Icons.error_outline, AppColors.error, '${total > 0 ? (critical / total * 100).toStringAsFixed(1) : '0'}%'),
              modelMetadataAsync.when(
                data: (metadata) => _buildStatCard(
                  'Model Accuracy', 
                  '${(metadata.cvResults['mean']['accuracy'] * 100).toStringAsFixed(1)}%', 
                  Icons.psychology_outlined, 
                  AppColors.secondary, 
                  'v${metadata.version}'
                ),
                loading: () => _buildStatCard('Model Accuracy', '...', Icons.psychology_outlined, AppColors.secondary, 'Loading...'),
                error: (error, stack) => _buildStatCard('Model Accuracy', 'N/A', Icons.psychology_outlined, AppColors.secondary, 'Error'),
              ),
            ],
          );
        });
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => const Center(child: Text('Error loading stats')),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
                Icon(icon, color: color, size: 20),
              ],
            ),
            const Spacer(),
            Text(value, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }

  Widget _buildMainDashboardGrid() {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > 1200) {
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  _buildFaultPredictionSummary(),
                  const SizedBox(height: 24),
                  _buildTrendChart(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildEquipmentHealthOverview(),
                  const SizedBox(height: 24),
                  _buildMiniMap(),
                ],
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              flex: 1,
              child: Column(
                children: [
                  _buildLatestAlerts(),
                  const SizedBox(height: 24),
                  _buildMaintenanceTasksList(),
                ],
              ),
            ),
          ],
        );
      } else {
        return Column(
          children: [
            _buildFaultPredictionSummary(),
            const SizedBox(height: 24),
            _buildEquipmentHealthOverview(),
            const SizedBox(height: 24),
            _buildLatestAlerts(),
            const SizedBox(height: 24),
            _buildTrendChart(),
          ],
        );
      }
    });
  }

  Widget _buildFaultPredictionSummary() {
    final predictionsAsync = ref.watch(predictionsProvider);
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Fault Prediction Summary', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                Icon(Icons.more_horiz),
              ],
            ),
            const SizedBox(height: 20),
            predictionsAsync.when(
              data: (predictions) {
                final displayPredictions = predictions.take(5).toList();
                return Table(
                  columnWidths: const {
                    0: FlexColumnWidth(1.2),
                    1: FlexColumnWidth(2),
                    2: FlexColumnWidth(1),
                    3: FlexColumnWidth(1),
                    4: FlexColumnWidth(1),
                  },
                  children: [
                    _buildTableHeader(),
                    ...displayPredictions.map((p) {
                      String status = 'Active';
                      if (p.riskLevel == 'High') status = 'Urgent';
                      if (p.riskLevel == 'Medium') status = 'Review';
                      
                      return _buildTableRow(
                        (p.stationId != null && p.stationId!.length > 8) ? p.stationId!.substring(0, 8) : (p.stationId ?? 'Unknown'),
                        p.faultType,
                        '${(p.probability * 100).toStringAsFixed(0)}%',
                        p.riskLevel,
                        status,
                      );
                    }),
                  ],
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error loading predictions: $err')),
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => setState(() => _selectedIndex = 5),
                child: const Text('View All Predictions →'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableHeader() {
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Base Station', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Predicted Fault', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Prob.', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Severity', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Text('Status', style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant))),
      ],
    );
  }

  TableRow _buildTableRow(String bs, String fault, String prob, String sev, String status) {
    Color sevColor = sev == 'Critical' ? AppColors.error : AppColors.warning;
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(bs, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(fault, style: const TextStyle(fontSize: 12))),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(prob, style: const TextStyle(fontSize: 12))),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Text(sev, style: TextStyle(fontSize: 12, color: sevColor, fontWeight: FontWeight.bold)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(status, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ),
        ),
      ],
    );
  }

  Widget _buildEquipmentHealthOverview() {
    final stationsAsync = ref.watch(stationsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: stationsAsync.when(
          data: (stations) {
            final total = stations.length;
            final healthy = stations.where((s) => s.status == 'Online').length;
            final warning = stations.where((s) => s.status == 'Degraded' || s.status == 'Maintenance').length;
            final critical = stations.where((s) => s.status == 'Offline').length;
            
            final healthyPercent = total > 0 ? (healthy / total * 100) : 0.0;
            final warningPercent = total > 0 ? (warning / total * 100) : 0.0;
            final criticalPercent = total > 0 ? (critical / total * 100) : 0.0;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Equipment Health Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),
                SizedBox(
                  height: 200,
                  child: Stack(
                    children: [
                      PieChart(
                        PieChartData(
                          sectionsSpace: 0,
                          centerSpaceRadius: 70,
                          sections: [
                            PieChartSectionData(value: healthyPercent, color: AppColors.success, radius: 20, showTitle: false),
                            PieChartSectionData(value: warningPercent, color: AppColors.warning, radius: 20, showTitle: false),
                            PieChartSectionData(value: criticalPercent, color: AppColors.error, radius: 20, showTitle: false),
                          ],
                        ),
                      ),
                      Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text('${healthyPercent.toStringAsFixed(1)}%', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                            Text('Healthy', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _buildLegendItem('Healthy', '$healthy (${healthyPercent.toStringAsFixed(1)}%)', AppColors.success),
                _buildLegendItem('Warning', '$warning (${warningPercent.toStringAsFixed(1)}%)', AppColors.warning),
                _buildLegendItem('Critical', '$critical (${criticalPercent.toStringAsFixed(1)}%)', AppColors.error),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Error: $err')),
        ),
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 12),
          Text(label, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }

  Widget _buildLatestAlerts() {
    final alarmsAsync = ref.watch(alarmsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Latest Alerts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(onPressed: () => setState(() => _selectedIndex = 4), child: const Text('View All', style: TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 10),
            alarmsAsync.when(
              data: (alarms) {
                if (alarms.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text('No active alerts', style: TextStyle(fontSize: 12, color: Colors.grey))),
                  );
                }
                final displayAlarms = alarms.take(4).toList();
                return Column(
                  children: displayAlarms.map((alarm) {
                    Color color = _getSeverityColor(alarm.severity);
                    IconData icon = _getSeverityIcon(alarm.severity);
                    String timeAgo = _formatTimeAgo(alarm.createdAt);
                    
                    return _buildAlertTile(
                      alarm.description,
                      '${alarm.stationId} • Status: ${alarm.status}',
                      timeAgo,
                      color,
                      icon,
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, _) => Center(child: Text('Error: $err')),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return AppColors.critical;
      case 'major':
      case 'error': return AppColors.error;
      case 'minor':
      case 'warning': return AppColors.warning;
      default: return AppColors.success;
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity.toLowerCase()) {
      case 'critical': return Icons.signal_cellular_connected_no_internet_4_bar;
      case 'major':
      case 'error': return Icons.error_outline;
      case 'minor':
      case 'warning': return Icons.warning_amber;
      default: return Icons.check_circle_outline;
    }
  }

  String _formatTimeAgo(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      final diff = DateTime.now().difference(date);
      if (diff.inDays > 0) return '${diff.inDays}d ago';
      if (diff.inHours > 0) return '${diff.inHours}h ago';
      if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
      return 'Just now';
    } catch (_) {
      return 'N/A';
    }
  }

  Widget _buildAlertTile(String title, String subtitle, String time, Color color, IconData icon) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: color.withValues(alpha: 0.1), shape: BoxShape.circle),
        child: Icon(icon, color: color, size: 18),
      ),
      title: Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
      subtitle: Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      trailing: Text(time, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
    );
  }

  Widget _buildMiniMap() {
    final stationsAsync = ref.watch(stationsProvider);
    final predictionsAsync = ref.watch(predictionsProvider);
    final mapCenter = ref.watch(dashboardMapCenterProvider);

    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 280,
        child: stationsAsync.when(
          data: (stations) {
            final predictions = predictionsAsync.asData?.value ?? [];
            
            // Create markers for all stations
            final markers = stations.where((s) => s.latitude != null && s.longitude != null).map((station) {
              // Find latest prediction for this station
              final stationPrediction = predictions.where((p) => p.stationId == station.id).firstOrNull;
              
              double hue = google.BitmapDescriptor.hueAzure;
              if (stationPrediction != null) {
                switch (stationPrediction.riskLevel) {
                  case 'High': hue = google.BitmapDescriptor.hueRed; break;
                  case 'Medium': hue = google.BitmapDescriptor.hueOrange; break;
                  case 'Low': hue = google.BitmapDescriptor.hueGreen; break;
                }
              }

              return google.Marker(
                markerId: google.MarkerId(station.id),
                position: google.LatLng(station.latitude!, station.longitude!),
                icon: google.BitmapDescriptor.defaultMarkerWithHue(hue),
                infoWindow: google.InfoWindow(
                  title: station.name,
                  snippet: stationPrediction != null 
                    ? 'Risk: ${stationPrediction.riskLevel} (${stationPrediction.faultType})'
                    : 'Status: ${station.status}',
                ),
              );
            }).toSet();

            return Stack(
              children: [
                google.GoogleMap(
                  initialCameraPosition: google.CameraPosition(
                    target: mapCenter,
                    zoom: 6.5,
                  ),
                  onMapCreated: (controller) => ref.read(dashboardMapControllerProvider.notifier).state = controller,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapType: google.MapType.normal,
                  markers: markers,
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.1), blurRadius: 4),
                      ],
                    ),
                    child: Text('Live Network Risk Map', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
                  ),
                ),
                // Legend Overlay
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface.withValues(alpha: 0.9),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        _buildMapLegendItem('High Risk', Colors.red),
                        _buildMapLegendItem('Medium Risk', Colors.orange),
                        _buildMapLegendItem('Healthy', Colors.green),
                        _buildMapLegendItem('No Data', Colors.blue),
                      ],
                    ),
                  ),
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => Center(child: Text('Map Error: $err')),
        ),
      ),
    );
  }

  Widget _buildMapLegendItem(String label, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 8, height: 8, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
          const SizedBox(width: 8),
          Text(label, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildMaintenanceTasksList() {
    final tasksAsync = ref.watch(maintenanceTasksProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Maintenance Tasks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                TextButton(
                  onPressed: () => setState(() => _selectedIndex = 6), 
                  child: const Text('View All', style: TextStyle(fontSize: 12))
                ),
              ],
            ),
            const SizedBox(height: 10),
            tasksAsync.when(
              data: (tasks) {
                if (tasks.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 20.0),
                    child: Center(child: Text('No pending tasks', style: TextStyle(fontSize: 12, color: Colors.grey))),
                  );
                }
                final displayTasks = tasks.take(3).toList();
                return Column(
                  children: displayTasks.map((task) {
                    final isCritical = (task['fault_description']?.toLowerCase().contains('critical') ?? false);
                    final color = isCritical ? AppColors.critical : AppColors.warning;
                    final dateStr = task['scheduled_date'] != null 
                        ? DateFormat('dd MMM').format(DateTime.parse(task['scheduled_date']))
                        : 'TBD';
                    
                    return _buildMaintenanceTaskItem(
                      task['fault_description'] ?? 'No Desc',
                      task['base_stations']?['name'] ?? 'Unknown Site',
                      dateStr,
                      isCritical ? 'Critical' : 'Medium',
                      color,
                    );
                  }).toList(),
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => const Text('Error loading tasks'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceTaskItem(String title, String subtitle, String date, String priority, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(4)),
                child: Text(priority, style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text(subtitle, style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant)),
              const Spacer(),
              Text(date, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTrendChart() {
    final kpisAsync = ref.watch(kpiRecordsProvider);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Network Performance Trends', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                ToggleButtons(
                  isSelected: const [true, false, false],
                  onPressed: (i) {},
                  constraints: const BoxConstraints(minHeight: 28, minWidth: 45),
                  borderRadius: BorderRadius.circular(8),
                  children: const [Text('24H', style: TextStyle(fontSize: 10)), Text('7D', style: TextStyle(fontSize: 10)), Text('30D', style: TextStyle(fontSize: 10))],
                ),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 240,
              child: kpisAsync.when(
                data: (kpis) {
                  if (kpis.isEmpty) return const Center(child: Text('No KPI data available'));
                  
                  final reversedKpis = kpis.reversed.toList();
                  
                  return LineChart(
                    LineChartData(
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
                      ),
                      titlesData: const FlTitlesData(
                        leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                        rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        bottomTitles: AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 30)),
                      ),
                      borderData: FlBorderData(show: false),
                      lineBarsData: [
                        _buildLineBar(
                          reversedKpis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.temperature ?? 0)).toList(), 
                          AppColors.error
                        ),
                        _buildLineBar(
                          reversedKpis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value.voltage ?? 0)).toList(), 
                          AppColors.success
                        ),
                        _buildLineBar(
                          reversedKpis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value.availability ?? 0))).toList(), 
                          Theme.of(context).colorScheme.primary
                        ),
                        _buildLineBar(
                          reversedKpis.asMap().entries.map((e) => FlSpot(e.key.toDouble(), (e.value.cssr ?? 0))).toList(), 
                          AppColors.secondary
                        ),
                      ],
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (_, __) => const Center(child: Text('Error loading trends')),
              ),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 16,
              children: [
                _ChartLegendItem(label: 'Temp (°C)', color: AppColors.error),
                _ChartLegendItem(label: 'Voltage (V)', color: AppColors.success),
                _ChartLegendItem(label: 'Avail (%)', isPrimary: true),
                _ChartLegendItem(label: 'CSSR (%)', color: AppColors.secondary),
              ],
            ),
          ],
        ),
      ),
    );
  }

  LineChartBarData _buildLineBar(List<FlSpot> spots, Color color) {
    return LineChartBarData(
      spots: spots,
      isCurved: true,
      color: color,
      barWidth: 2,
      dotData: const FlDotData(show: false),
      belowBarData: BarAreaData(show: false),
    );
  }
}

class _ChartLegendItem extends StatelessWidget {
  final String label;
  final Color? color;
  final bool isPrimary;
  const _ChartLegendItem({required this.label, this.color, this.isPrimary = false});

  @override
  Widget build(BuildContext context) {
    final effectiveColor = isPrimary ? Theme.of(context).colorScheme.primary : (color ?? Colors.grey);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 8, height: 8, decoration: BoxDecoration(color: effectiveColor, shape: BoxShape.circle)),
        const SizedBox(width: 4),
        Text(label, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
      ],
    );
  }
}
