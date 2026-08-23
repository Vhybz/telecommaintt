import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/maintenance_repository.dart';
import '../../stations/data/station_repository.dart';
import '../../auth/data/auth_repository.dart';
import '../../../services/sms_service.dart';
import 'package:uuid/uuid.dart';

class AddTaskDialog extends ConsumerStatefulWidget {
  final String? initialStationId;
  final String? initialFault;
  const AddTaskDialog({super.key, this.initialStationId, this.initialFault});

  @override
  ConsumerState<AddTaskDialog> createState() => _AddTaskDialogState();
}

class _AddTaskDialogState extends ConsumerState<AddTaskDialog> {
  final _formKey = GlobalKey<FormState>();
  final _faultController = TextEditingController();
  final _detailsController = TextEditingController();
  final _phoneController = TextEditingController();
  final _manualNameController = TextEditingController();
  String? _selectedStationId;
  String? _selectedTechId;
  bool _isManualEntry = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  TimeOfDay _selectedTime = const TimeOfDay(hour: 9, minute: 0);

  @override
  void initState() {
    super.initState();
    _selectedStationId = widget.initialStationId;
    _faultController.text = widget.initialFault ?? '';
  }

  @override
  void dispose() {
    _faultController.dispose();
    _detailsController.dispose();
    _phoneController.dispose();
    _manualNameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedStationId == null) return;

    final String fault = _faultController.text.trim();
    final String details = _detailsController.text.trim();
    final String fullDescription = details.isNotEmpty ? '$fault: $details' : fault;

    final scheduledDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );

    final task = {
      'id': const Uuid().v4(),
      'station_id': _selectedStationId,
      'assigned_to': _isManualEntry ? null : _selectedTechId,
      'manual_assigned_name': _isManualEntry ? _manualNameController.text.trim() : null,
      'fault_description': fullDescription,
      'scheduled_date': scheduledDateTime.toIso8601String(),
      'status': 'Pending',
    };

    try {
      await ref.read(maintenanceRepositoryProvider).createMaintenanceTask(task);
      
      // Get current user name for the SMS
      final userProfile = ref.read(userProfileProvider).value;
      final String assignedBy = userProfile?['full_name'] ?? 'Admin';

      // Send SMS to Technician in background
      final String phone = _phoneController.text.trim();
      if (phone.isNotEmpty) {
        final String receiverName = _isManualEntry 
            ? _manualNameController.text.trim() 
            : (ref.read(allUsersProvider).value?.firstWhere((u) => u['id'] == _selectedTechId, orElse: () => {'full_name': 'Technician'})['full_name'] ?? 'Technician');

        _sendSmsNotification(phone, fullDescription, _selectedStationId!, scheduledDateTime, assignedBy, receiverName);
      }

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

  void _sendSmsNotification(String phone, String description, String stationId, DateTime date, String assignedBy, String receiverName) {
    // We capture the necessary state and run the future without awaiting it in the UI flow
    final stations = ref.read(stationsProvider).value ?? [];
    final station = stations.cast<dynamic>().firstWhere((s) => s.id == stationId, orElse: () => null);
    
    if (station != null) {
      final String formattedDate = '${date.day}/${date.month}/${date.year}';
      final String formattedTime = '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
      final String message = 
          '🛠 TELECOM AI: NEW TASK\n'
          'Hi $receiverName,\n'
          'Assigned By: $assignedBy\n'
          'Site: ${station.name} (${station.siteId})\n'
          'Fault: $description\n'
          'Schedule: $formattedDate at $formattedTime\n'
          'Loc: ${station.latitude ?? "N/A"}, ${station.longitude ?? "N/A"}';
          
      ref.read(smsServiceProvider).sendSms(
        phoneNumber: phone,
        message: message,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final stationsAsync = ref.watch(stationsProvider);
    final usersAsync = ref.watch(allUsersProvider);

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
                  decoration: const InputDecoration(labelText: 'Base Station', prefixIcon: Icon(Icons.cell_tower)),
                  items: stations.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name))).toList(),
                  onChanged: (v) => setState(() => _selectedStationId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const Text('Error loading stations'),
              ),
              const SizedBox(height: 16),
              usersAsync.when(
                data: (users) => Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _isManualEntry ? 'manual' : _selectedTechId,
                      decoration: const InputDecoration(labelText: 'Assign To', prefixIcon: Icon(Icons.person_outline)),
                      items: [
                        ...users.map((t) => DropdownMenuItem(value: t['id'] as String, child: Text(t['full_name'] as String))),
                        const DropdownMenuItem(value: 'manual', child: Text('Other (Manual Entry)')),
                      ],
                      onChanged: (v) {
                        setState(() {
                          if (v == 'manual') {
                            _isManualEntry = true;
                            _selectedTechId = null;
                            _phoneController.clear();
                            _manualNameController.clear();
                          } else {
                            _isManualEntry = false;
                            _selectedTechId = v;
                            final selectedUser = users.firstWhere((t) => t['id'] == v);
                            _phoneController.text = selectedUser['phone'] ?? '';
                          }
                        });
                      },
                      validator: (v) => v == null ? 'Please select a person' : null,
                    ),
                    if (_isManualEntry) ...[
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _manualNameController,
                        decoration: const InputDecoration(
                          labelText: 'Name',
                          prefixIcon: Icon(Icons.person_add_outlined),
                        ),
                        validator: (v) => v == null || v.isEmpty ? 'Name required' : null,
                      ),
                    ],
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        prefixIcon: Icon(Icons.phone_android),
                        hintText: 'e.g. 0552636245',
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (v) {
                        if (v == null || v.isEmpty) return 'Phone number required for SMS';
                        if (v.length != 10) return 'Enter a valid 10-digit number';
                        return null;
                      },
                    ),
                  ],
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const Text('Error loading users'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _faultController,
                decoration: const InputDecoration(labelText: 'Fault Type', prefixIcon: Icon(Icons.report_problem_outlined)),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _detailsController,
                decoration: const InputDecoration(labelText: 'Additional Description', prefixIcon: Icon(Icons.description_outlined)),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              ListTile(
                contentPadding: EdgeInsets.zero,
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
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: const Text('Scheduled Time'),
                subtitle: Text(_selectedTime.format(context)),
                trailing: const Icon(Icons.access_time),
                onTap: () async {
                  final time = await showTimePicker(
                    context: context,
                    initialTime: _selectedTime,
                  );
                  if (time != null) setState(() => _selectedTime = time);
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
