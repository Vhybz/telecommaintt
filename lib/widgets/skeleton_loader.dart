import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonLoader extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const SkeletonLoader({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

class StationSkeleton extends StatelessWidget {
  const StationSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SkeletonLoader(width: 60, height: 20, borderRadius: 8),
                const SkeletonLoader(width: 20, height: 20, borderRadius: 4),
              ],
            ),
            const Spacer(),
            const SkeletonLoader(width: 140, height: 24),
            const SizedBox(height: 8),
            const SkeletonLoader(width: 80, height: 16),
            const SizedBox(height: 12),
            const SkeletonLoader(width: 100, height: 16),
          ],
        ),
      ),
    );
  }
}

class ListSkeleton extends StatelessWidget {
  const ListSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(24),
      itemCount: 6,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) => Card(
        child: ListTile(
          leading: const SkeletonLoader(width: 40, height: 40, borderRadius: 20),
          title: const SkeletonLoader(width: 200, height: 20),
          subtitle: const SkeletonLoader(width: 150, height: 16),
          trailing: const SkeletonLoader(width: 80, height: 24, borderRadius: 20),
        ),
      ),
    );
  }
}
