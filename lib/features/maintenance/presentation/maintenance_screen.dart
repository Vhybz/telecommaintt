import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import '../../../core/theme/app_colors.dart';

class MaintenanceScreen extends StatefulWidget {
  const MaintenanceScreen({super.key});

  @override
  State<MaintenanceScreen> createState() => _MaintenanceScreenState();
}

class _MaintenanceScreenState extends State<MaintenanceScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
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
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            dividerColor: Colors.transparent,
            tabs: const [
              Tab(text: 'Active (12)'),
              Tab(text: 'Scheduled (8)'),
              Tab(text: 'Completed (45)'),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildTaskList('Active'),
                _buildTaskList('Scheduled'),
                _buildTaskList('Completed'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTaskList(String status) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => _buildTaskCard(index),
    );
  }

  Widget _buildTaskCard(int index) {
    final priorities = ['Critical', 'Major', 'Minor'];
    final priority = priorities[index % 3];
    final priorityColor = priority == 'Critical' ? AppColors.critical : (priority == 'Major' ? AppColors.error : AppColors.warning);

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
                          Text('Task #MNT-${829 + index}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(color: priorityColor.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
                            child: Text(priority, style: TextStyle(color: priorityColor, fontWeight: FontWeight.bold, fontSize: 12)),
                          ),
                        ],
                      ),
                      const Text('Signal interference at North Tower B2', style: TextStyle(fontSize: 14)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          const Text('Site ID: NY-921', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                          const SizedBox(width: 16),
                          const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.textSecondary),
                          const SizedBox(width: 4),
                          const Text('Due: Aug 12, 2026', style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
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
                    const Text('Tech: Alex Rivera', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
                  ],
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('View Details')),
                    const SizedBox(width: 8),
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
