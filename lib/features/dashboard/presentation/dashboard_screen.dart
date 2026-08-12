import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart' as google;
import '../../stations/presentation/station_list_screen.dart';
import '../../faults/presentation/fault_list_screen.dart';
import '../../predictions/presentation/prediction_list_screen.dart';
import '../../equipment/presentation/equipment_list_screen.dart';
import '../../kpis/presentation/kpis_screen.dart';
import '../../maintenance/presentation/maintenance_screen.dart';
import '../../reports/presentation/reports_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import '../../../widgets/side_navigation_rail.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/theme_provider.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key});

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  int _selectedIndex = 0;

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
      default:
        return Center(child: Text('Module ${_selectedIndex + 1} Coming Soon'));
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
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Predictive Maintenance Dashboard',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: -0.5),
              ),
              Text(
                'Welcome back, Kofi Mensah 👋',
                style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const Spacer(),
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
                const Text(
                  '18 May 2024, 10:30 AM',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
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
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(color: AppColors.error, shape: BoxShape.circle),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                ),
              )
            ],
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 18,
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: const Icon(Icons.person, color: Colors.white, size: 22),
          ),
        ],
      ),
    );
  }

  Widget _buildDashboardOverview() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatCardsRow(),
          const SizedBox(height: 24),
          _buildMainDashboardGrid(),
        ],
      ),
    );
  }

  Widget _buildStatCardsRow() {
    return LayoutBuilder(builder: (context, constraints) {
      int crossAxisCount = constraints.maxWidth > 1400 ? 5 : (constraints.maxWidth > 900 ? 3 : 2);
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 2.2,
        children: [
          _buildStatCard('Total Base Stations', '125', Icons.cell_tower, Theme.of(context).colorScheme.primary, 'All Sites'),
          _buildStatCard('Healthy Stations', '104', Icons.check_circle_outline, AppColors.success, '83.2%'),
          _buildStatCard('Warning Stations', '15', Icons.warning_amber, AppColors.warning, '12.0%'),
          _buildStatCard('Critical Stations', '6', Icons.error_outline, AppColors.error, '4.8%'),
          _buildStatCard('Model Accuracy', '96.8%', Icons.psychology_outlined, AppColors.secondary, 'This Month'),
        ],
      );
    });
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
            Table(
              columnWidths: const {
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(2),
                2: FlexColumnWidth(1),
                3: FlexColumnWidth(1),
                4: FlexColumnWidth(1),
              },
              children: [
                _buildTableHeader(),
                _buildTableRow('BS-022', 'Battery Failure', '95%', 'Critical', 'New'),
                _buildTableRow('BS-008', 'Cooling System', '87%', 'Warning', 'New'),
                _buildTableRow('BS-031', 'RF Power Low', '78%', 'Warning', 'New'),
                _buildTableRow('BS-014', 'High Temp', '65%', 'Warning', 'Ack'),
              ],
            ),
            const SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () {},
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
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
                        PieChartSectionData(value: 83.2, color: AppColors.success, radius: 20, showTitle: false),
                        PieChartSectionData(value: 12.0, color: AppColors.warning, radius: 20, showTitle: false),
                        PieChartSectionData(value: 4.8, color: AppColors.error, radius: 20, showTitle: false),
                      ],
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text('83.2%', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        Text('Healthy', style: TextStyle(fontSize: 12, color: AppColors.success, fontWeight: FontWeight.w600)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildLegendItem('Healthy', '104 (83.2%)', AppColors.success),
            _buildLegendItem('Warning', '15 (12.0%)', AppColors.warning),
            _buildLegendItem('Critical', '6 (4.8%)', AppColors.error),
          ],
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
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 10),
            _buildAlertTile('Critical Signal Loss', 'BS-044 • Sunyani Technical Univ.', 'Just now', AppColors.critical, Icons.signal_cellular_connected_no_internet_4_bar),
            _buildAlertTile('High Temperature', 'BS-034 • Accra Central', '5 min ago', AppColors.error, Icons.thermostat),
            _buildAlertTile('Low Battery Voltage', 'BS-021 • Kumasi Tech', '12 min ago', AppColors.warning, Icons.battery_alert),
            _buildAlertTile('Cooling System Norm.', 'BS-007 • Cape Coast', '1 hr ago', AppColors.success, Icons.check_circle_outline),
          ],
        ),
      ),
    );
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
    return Card(
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 260,
        child: Stack(
          children: [
            // Embedded real map for Sunyani STU
            Positioned.fill(
              child: google.GoogleMap(
                initialCameraPosition: const google.CameraPosition(
                  target: google.LatLng(7.3349, -2.3124), // Sunyani Technical University
                  zoom: 15,
                ),
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapType: google.MapType.hybrid,
                markers: {
                  const google.Marker(
                    markerId: google.MarkerId('stu'),
                    position: google.LatLng(7.3349, -2.3124),
                    infoWindow: google.InfoWindow(title: 'Sunyani STU Hub'),
                  ),
                },
              ),
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
                child: Text('Sunyani STU Hub Status', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMaintenanceTasksList() {
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
                TextButton(onPressed: () {}, child: const Text('View All', style: TextStyle(fontSize: 12))),
              ],
            ),
            const SizedBox(height: 10),
            _buildMaintenanceTaskItem('Antenna Realignment', 'BS-044 • Sunyani STU', 'Today', 'Critical', AppColors.critical),
            _buildMaintenanceTaskItem('Inspect Battery System', 'BS-022 • Accra Central', '19 May 2024', 'High', AppColors.error),
            _buildMaintenanceTaskItem('Clean Cooling Units', 'BS-008 • Kumasi Tech', '20 May 2024', 'Medium', AppColors.warning),
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
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('KPI Trends (BS-022)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
              child: LineChart(
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
                    _buildLineBar(const [FlSpot(0, 75), FlSpot(2, 85), FlSpot(4, 80), FlSpot(6, 90), FlSpot(8, 88), FlSpot(10, 92)], AppColors.error),
                    _buildLineBar(const [FlSpot(0, 60), FlSpot(2, 65), FlSpot(4, 58), FlSpot(6, 70), FlSpot(8, 68), FlSpot(10, 75)], AppColors.success),
                    _buildLineBar(const [FlSpot(0, 40), FlSpot(2, 45), FlSpot(4, 42), FlSpot(6, 50), FlSpot(8, 48), FlSpot(10, 55)], Theme.of(context).colorScheme.primary),
                    _buildLineBar(const [FlSpot(0, 20), FlSpot(2, 25), FlSpot(4, 22), FlSpot(6, 30), FlSpot(8, 28), FlSpot(10, 35)], AppColors.secondary),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            const Wrap(
              spacing: 16,
              children: [
                _ChartLegendItem(label: 'Temp (°C)', color: AppColors.error),
                _ChartLegendItem(label: 'Battery (V)', color: AppColors.success),
                _ChartLegendItem(label: 'Power (%)', isPrimary: true),
                _ChartLegendItem(label: 'Traffic (%)', color: AppColors.secondary),
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
