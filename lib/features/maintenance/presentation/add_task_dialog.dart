import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/maintenance_repository.dart';
import '../../stations/data/station_repository.dart';
import '../../auth/data/auth_repository.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  final String? initialStationId;
  const AddTaskDialog({super.key, this.initialStationId});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  String? _selectedStationId;
  String? _selectedTechId;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));

  @override
  void initState() {
    super.initState();
    _selectedStationId = widget.initialStationId;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStationId == null) return;

    final task = {
      'id': const Uuid().v4(),
      'station_id': _selectedStationId,
      'assigned_to': _selectedTechId,
      'fault_description': _descriptionController.text.trim(),
      'scheduled_date': _selectedDate.toIso8601String(),
      'status': 'Pending',
    };

    try {
      await ref.read(maintenanceRepositoryProvider).createMaintenanceTask(task);
      ref.invalidate(maintenanceTasksProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error creating task: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);

    return AlertDialog(
      title: const Text('Create Maintenance Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              stationsAsync.when(
                data: (stations) => DropdownButtonFormField<String>(
                  value: _selectedStationId,
                  decoration: const InputDecoration(labelText: 'Base Station'),
                  items: stations.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() => _selectedStationId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const Text('Error loading stations'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: 'Fault Description'),
                maxLines: 3,
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: const Text('Scheduled Date'),
                subtitle: Text('${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: const Text('Create Task')),
      ],
    );
  }
}
