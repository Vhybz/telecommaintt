import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';

class KpisScreen extends StatelessWidget {
  const KpisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAnimatedSection(child: _buildHeader(context), delay: 0),
          const SizedBox(height: 24),
          _buildAnimatedSection(child: _buildAvailabilitySection(), delay: 200),
          const SizedBox(height: 24),
          _buildAnimatedSection(child: _buildThroughputChart(), delay: 400),
          const SizedBox(height: 24),
          _buildAnimatedSection(child: _buildKpiTable(), delay: 600),
        ],
      ),
    );
  }

  Widget _buildAnimatedSection({required Widget child, required int delay}) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutBack,
      tween: Tween(begin: 0.0, end: 1.0),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 30 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 16,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Lottie.network(
              'https://lottie.host/828770d1-032a-43f1-b99b-00109605481b/f8D2X0yvC5.json',
              height: 50,
              width: 50,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.analytics, 
                color: Theme.of(context).colorScheme.primary, 
                size: 32,
              ),
            ),
            const SizedBox(width: 12),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Network Performance', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                Text('Real-time key performance indicators'),
              ],
            ),
          ],
        ),
        ToggleButtons(
          isSelected: const [false, true, false],
          onPressed: (index) {},
          borderRadius: BorderRadius.circular(12),
          constraints: const BoxConstraints(minHeight: 40, minWidth: 60),
          children: const [Text('1h'), Text('24h'), Text('7d')],
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth < 900) {
          return Column(
            children: [
              _buildAvailabilityCard('Network Availability', 99.8, AppColors.success),
              const SizedBox(height: 16),
              _buildAvailabilityCard('Call Drop Rate', 0.24, AppColors.secondary),
              const SizedBox(height: 16),
              _buildAvailabilityCard('Signal Strength', 88.5, AppColors.accent),
            ],
          );
        }
        return Row(
          children: [
            Expanded(child: _buildAvailabilityCard('Network Availability', 99.8, AppColors.success)),
            const SizedBox(width: 16),
            Expanded(child: _buildAvailabilityCard('Call Drop Rate', 0.24, AppColors.secondary)),
            const SizedBox(width: 16),
            Expanded(child: _buildAvailabilityCard('Signal Strength', 88.5, AppColors.accent)),
          ],
        );
      }
    );
  }

  Widget _buildAvailabilityCard(String title, double percentage, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: TweenAnimationBuilder<double>(
                duration: const Duration(seconds: 2),
                curve: Curves.easeInOutCubic,
                tween: Tween(begin: 0.0, end: percentage / 100),
                builder: (context, value, child) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CircularProgressIndicator(
                        value: value,
                        strokeWidth: 8,
                        backgroundColor: color.withValues(alpha: 0.1),
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                      ),
                      Center(
                        child: Text(
                          '${(value * 100).toStringAsFixed(1)}%',
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: const TextStyle(color: AppColors.textSecondary, fontSize: 14),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Text(
                    'Healthy',
                    style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.success),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThroughputChart() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Data Throughput (Gbps)', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            SizedBox(
              height: 250,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withValues(alpha: 0.1), strokeWidth: 1),
                  ),
                  titlesData: const FlTitlesData(show: false),
                  borderData: FlBorderData(show: false),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (touchedSpot) => AppColors.secondary.withValues(alpha: 0.8),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 1.2), FlSpot(1, 1.8), FlSpot(2, 1.5),
                        FlSpot(3, 2.2), FlSpot(4, 2.8), FlSpot(5, 2.4),
                        FlSpot(6, 3.1), FlSpot(7, 2.9),
                      ],
                      isCurved: true,
                      color: AppColors.secondary,
                      barWidth: 4,
                      isStrokeCapRound: true,
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          colors: [
                            AppColors.secondary.withValues(alpha: 0.3),
                            AppColors.secondary.withValues(alpha: 0.0),
                          ],
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiTable() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('KPI Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            Table(
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(1),
                2: FlexColumnWidth(1),
              },
              children: [
                _buildTableRow('Metric', 'Current', 'Target', isHeader: true),
                _buildTableRow('Latency', '24ms', '< 30ms'),
                _buildTableRow('Jitter', '2.4ms', '< 5ms'),
                _buildTableRow('Packet Loss', '0.01%', '< 0.1%'),
                _buildTableRow('Connection Success', '99.98%', '> 99.5%'),
              ],
            ),
          ],
        ),
      ),
    );
  }

  TableRow _buildTableRow(String c1, String c2, String c3, {bool isHeader = false}) {
    final style = TextStyle(
      fontWeight: isHeader ? FontWeight.bold : FontWeight.normal,
      color: isHeader ? AppColors.textPrimary : AppColors.textSecondary,
    );
    return TableRow(
      children: [
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(c1, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(c2, style: style)),
        Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Text(c3, style: style)),
      ],
    );
  }
}
