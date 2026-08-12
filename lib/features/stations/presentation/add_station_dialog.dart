import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/station_repository.dart';
import '../domain/base_station.dart';
import 'package:uuid/uuid.dart';

class AddStationDialog extends ConsumerStatefulWidget {
  final BaseStation? station;
  const AddStationDialog({super.key, this.station});

  @override
  ConsumerState<AddStationDialog> createState() => _AddStationDialogState();
}

class _AddStationDialogState extends ConsumerState<AddStationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _siteIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _operatorController = TextEditingController();
  final _latitudeController = TextEditingController();
  final _longitudeController = TextEditingController();
  String _selectedStatus = 'Online';
  int? _selectedRegionId;

  bool get _isEditing => widget.station != null;

  @override
  void initState() {
    super.initState();
    if (_isEditing) {
      final s = widget.station!;
      _siteIdController.text = s.siteId;
      _nameController.text = s.name;
      _operatorController.text = s.operator ?? '';
      _latitudeController.text = s.latitude?.toString() ?? '';
      _longitudeController.text = s.longitude?.toString() ?? '';
      _selectedStatus = s.status;
      _selectedRegionId = s.regionId;
    }
  }

  @override
  void dispose() {
    _siteIdController.dispose();
    _nameController.dispose();
    _operatorController.dispose();
    _latitudeController.dispose();
    _longitudeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final station = BaseStation(
      id: _isEditing ? widget.station!.id : const Uuid().v4(),
      siteId: _siteIdController.text.trim(),
      name: _nameController.text.trim(),
      status: _selectedStatus,
      regionId: _selectedRegionId,
      latitude: double.tryParse(_latitudeController.text),
      longitude: double.tryParse(_longitudeController.text),
      operator: _operatorController.text.trim(),
      installationDate: _isEditing ? widget.station!.installationDate : DateTime.now().toIso8601String(),
    );

    try {
      if (_isEditing) {
        await ref.read(stationRepositoryProvider).updateStation(station);
      } else {
        await ref.read(stationRepositoryProvider).createStation(station);
      }
      ref.invalidate(stationsProvider);
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Base Station' : 'Add New Base Station'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Station Name'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              TextFormField(
                controller: _siteIdController,
                decoration: const InputDecoration(labelText: 'Site ID (e.g. GH-ACC-001)'),
                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              ref.watch(regionsProvider).when(
                data: (regions) => DropdownButtonFormField<int>(
                  initialValue: _selectedRegionId,
                  decoration: const InputDecoration(labelText: 'Region'),
                  items: regions.map((r) => DropdownMenuItem<int>(
                    value: r['id'] as int,
                    child: Text(r['name'] as String),
                  )).toList(),
                  onChanged: (v) => setState(() => _selectedRegionId = v),
                  validator: (v) => v == null ? 'Required' : null,
                ),
                loading: () => const LinearProgressIndicator(),
                error: (error, stack) => const Text('Error loading regions'),
              ),
              DropdownButtonFormField<String>(
                value: _selectedStatus,
                decoration: const InputDecoration(labelText: 'Status'),
                items: ['Online', 'Offline', 'Maintenance', 'Degraded'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (v) => setState(() => _selectedStatus = v!),
              ),
              TextFormField(
                controller: _operatorController,
                decoration: const InputDecoration(labelText: 'Operator (e.g. MTN, Telecel)'),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _latitudeController,
                      decoration: const InputDecoration(labelText: 'Latitude'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _longitudeController,
                      decoration: const InputDecoration(labelText: 'Longitude'),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
        ElevatedButton(onPressed: _submit, child: Text(_isEditing ? 'Save Changes' : 'Add Station')),
      ],
    );
  }
}
