import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';
import '../../../core/theme/app_colors.dart';
import '../data/maintenance_repository.dart';

class MaintenanceScreen extends ConsumerStatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  ConsumerState<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends ConsumerState<MaintenanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final tasksAsync = ref.watch(maintenanceTasksProvider);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 16,
            runSpacing: 16,
            children: [
              const Text('Maintenance Tasks', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('New Ticket'),
              ),
            ],
          ),
          const SizedBox(height: 24),
          tasksAsync.when(
            data: (tasks) => Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    tabs: [
                      Tab(text: 'Active (${tasks.where((t) => t['status'] == 'In Progress' || t['status'] == 'Pending').length})'),
                      Tab(text: 'Scheduled (${tasks.where((t) => t['scheduled_date'] != null && t['status'] == 'Pending').length})'),
                      Tab(text: 'Completed (${tasks.where((t) => t['status'] == 'Completed').length})'),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildTaskList(tasks.where((t) => t['status'] == 'In Progress' || t['status'] == 'Pending').toList()),
                        _buildTaskList(tasks.where((t) => t['scheduled_date'] != null && t['status'] == 'Pending').toList()),
                        _buildTaskList(tasks.where((t) => t['status'] == 'Completed').toList()),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (err, _) => Center(child: Text('Error: $err')),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(List<Map<String, dynamic>> tasks) {
    if (tasks.isEmpty) {
      return const Center(child: Text('No tasks in this category.'));
    }
    return ListView.builder(
      itemCount: tasks.length,
      itemBuilder: (context, index) => _buildTaskCard(tasks[index]),
    );
  }

  Widget _buildTaskCard(Map<String, dynamic> task) {
    final status = task['status'] ?? 'Pending';
    final priority = (task['fault_description']?.toLowerCase().contains('critical') ?? false) ? 'Critical' : 'Medium';
    final priorityColor = priority == 'Critical' ? AppColors.critical : AppColors.warning;
    final dateStr = task['scheduled_date'] != null 
        ? DateFormat('MMM dd, yyyy').format(DateTime.parse(task['scheduled_date']))
        : 'Not Set';

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), shape: BoxShape.circle),
                  child: Lottie.network(
                    'https://lottie.host/9e504c55-320d-4076-963d-045389658f89/W6eSve7O6m.json',
                    height: 40,
                    width: 40,
                    errorBuilder: (context, error, stackTrace) => 
                      Icon(Icons.build, color: priorityColor, size: 24),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Task #${task['id'].toString().substring(0, 8)}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(priority, style: TextStyle(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      Text(task['fault_description'] ?? 'No description provided', style: const TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text('Site: ${task['base_stations']?['name'] ?? 'N/A'}', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          Text('Due: $dateStr', style: const TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Divider(height: 32),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const CircleAvatar(radius: 14, child: Icon(Icons.person, size: 16)),
                    const SizedBox(width: 8),
                    Text('Tech: ${task['profiles']?['full_name'] ?? 'Unassigned'}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('View Details')),
                    const SizedBox(width: 8),
                    if (status != 'Completed')
                      OutlinedButton(onPressed: () {}, child: const Text('Complete')),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
