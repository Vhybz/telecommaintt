import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/prediction_repository.dart';
import '../domain/prediction.dart';
import '../../../core/theme/app_colors.dart';
import '../../../widgets/skeleton_loader.dart';

class PredictionListScreen extends ConsumerWidget {
  const PredictionListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final predictionsAsync = ref.watch(predictionsProvider);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: predictionsAsync.when(
            data: (predictions) => _buildPredictionList(predictions),
            loading: () => const ListSkeleton(),
            error: (err, stack) => Center(child: Text('Error: $err')),
          ),
    );
  }

  Widget _buildPredictionList(List<Prediction> predictions) {
    return ListView.builder(
      padding: const EdgeInsets.all(24),
      itemCount: predictions.length,
      itemBuilder: (context, index) {
        final prediction = predictions[index];
        return _buildPredictionCard(context, prediction);
      },
    );
  }

  Widget _buildPredictionCard(BuildContext context, Prediction prediction) {
    Color riskColor = _getRiskColor(prediction.riskLevel);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.online_prediction, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 12),
                    Text(
                      prediction.faultType,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: riskColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '${prediction.riskLevel} Risk',
                    style: TextStyle(color: riskColor, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 16),
            Row(
              children: [
                _buildInfoItem(context, 'Probability', '${(prediction.probability * 100).toInt()}%'),
                const SizedBox(width: 48),
                _buildInfoItem(context, 'Station ID', prediction.stationId.substring(0, 8)),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Recommended Action:',
              style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(prediction.recommendedAction ?? 'N/A'),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                child: const Text('Create Maintenance Task'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem(BuildContext context, String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(color: Theme.of(context).colorScheme.onSurfaceVariant, fontSize: 12)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }

  Color _getRiskColor(String risk) {
    switch (risk) {
      case 'High': return AppColors.error;
      case 'Medium': return AppColors.warning;
      case 'Low': return AppColors.success;
      default: return Colors.blue;
    }
  }
}
