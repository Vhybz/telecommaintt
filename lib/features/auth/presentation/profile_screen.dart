import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:go_router/go_router.dart';
import '../data/auth_repository.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isLoading = true;
  bool _isUploading = false;
  bool _isEditing = false;
  bool _isSaving = false;
  Map<String, dynamic>? _profileData;

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _professionController = TextEditingController();
  int? _selectedRoleId;

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _professionController.dispose();
    super.dispose();
  }

  Future<void> _fetchProfile() async {
    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        final data = await ref.read(authRepositoryProvider).getUserProfile(user.id);
        if (mounted) {
          setState(() {
            _profileData = data;
            _isLoading = false;
            if (data != null) {
              _nameController.text = data['full_name'] ?? '';
              _phoneController.text = data['phone'] ?? '';
              _professionController.text = data['profession'] ?? '';
              _selectedRoleId = data['role_id'];
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error fetching profile: $e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        await ref.read(authRepositoryProvider).updateProfile(
          userId: user.id,
          fullName: _nameController.text.trim(),
          phone: _phoneController.text.trim(),
          profession: _professionController.text.trim(),
          roleId: _selectedRoleId,
        );
        
        await _fetchProfile();
        setState(() => _isEditing = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile updated successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Update failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  Future<void> _pickAndUploadImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery, imageQuality: 50);

    if (image == null) return;

    setState(() => _isUploading = true);

    try {
      final user = ref.read(authRepositoryProvider).currentUser;
      if (user != null) {
        final bytes = await image.readAsBytes();
        await ref.read(authRepositoryProvider).uploadAvatar(bytes, image.name, user.id);
        await _fetchProfile(); // Refresh profile to show new image
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Profile picture updated successfully!')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Upload failed: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final user = ref.watch(authRepositoryProvider).currentUser;
    final avatarUrl = _profileData?['avatar_url'];
    final rolesAsync = ref.watch(rolesProvider);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'User Profile',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                if (!_isEditing)
                  TextButton.icon(
                    onPressed: () => setState(() => _isEditing = true),
                    icon: const Icon(Icons.edit_outlined),
                    label: const Text('Edit'),
                  )
                else
                  Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          _fetchProfile(); // Reset fields
                          setState(() => _isEditing = false);
                        },
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: _isSaving ? null : _saveProfile,
                        child: _isSaving 
                          ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Text('Save'),
                      ),
                    ],
                  ),
              ],
            ),
            const SizedBox(height: 32),
            
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                    backgroundImage: avatarUrl != null ? NetworkImage(avatarUrl) : null,
                    child: avatarUrl == null && !_isUploading
                      ? Icon(Icons.person, size: 60, color: Theme.of(context).colorScheme.primary)
                      : _isUploading
                          ? const CircularProgressIndicator()
                          : null,
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: FloatingActionButton.small(
                      onPressed: _isUploading ? null : _pickAndUploadImage,
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 48),
            
            _buildInfoSection(
              title: 'Personal Information',
              children: [
                if (!_isEditing) ...[
                  _buildInfoTile(Icons.person_outline, 'Full Name', _nameController.text),
                  _buildInfoTile(Icons.email_outlined, 'Email', user?.email ?? ''),
                  _buildInfoTile(Icons.phone_outlined, 'Phone', _phoneController.text),
                  _buildInfoTile(Icons.work_outline, 'Profession', _professionController.text),
                ] else ...[
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _nameController,
                          decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                          validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          initialValue: user?.email,
                          enabled: false,
                          decoration: const InputDecoration(labelText: 'Email (Read-only)', prefixIcon: Icon(Icons.email_outlined)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _phoneController,
                          decoration: const InputDecoration(labelText: 'Phone', prefixIcon: Icon(Icons.phone_outlined)),
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _professionController,
                          decoration: const InputDecoration(labelText: 'Profession', prefixIcon: Icon(Icons.work_outline)),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
            
            const SizedBox(height: 24),
            
            _buildInfoSection(
              title: 'Account Role',
              children: [
                if (!_isEditing)
                  _buildInfoTile(
                    Icons.admin_panel_settings_outlined, 
                    'Current Role', 
                    _profileData?['roles']?['name'] ?? 'Technician', 
                    isBadge: true
                  )
                else
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: rolesAsync.when(
                      data: (roles) => DropdownButtonFormField<int>(
                        initialValue: _selectedRoleId,
                        decoration: const InputDecoration(labelText: 'Role', prefixIcon: Icon(Icons.admin_panel_settings_outlined)),
                        items: roles.map((r) => DropdownMenuItem<int>(
                          value: r['id'] as int,
                          child: Text(r['name'] as String),
                        )).toList(),
                        onChanged: (v) => setState(() => _selectedRoleId = v),
                      ),
                      loading: () => const LinearProgressIndicator(),
                      error: (error, stack) => const Text('Error loading roles'),
                    ),
                  ),
              ],
            ),
            
            const SizedBox(height: 48),
            
            if (!_isEditing)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                    if (context.mounted) {
                      context.go('/login');
                    }
                  },
                  icon: const Icon(Icons.logout, color: Colors.red),
                  label: const Text('Logout', style: TextStyle(color: Colors.red)),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: Colors.red),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection({required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value, {bool isBadge = false}) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant, size: 20),
      title: Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      subtitle: isBadge 
        ? Container(
            margin: const EdgeInsets.only(top: 4),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              value,
              style: TextStyle(
                fontSize: 13, 
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          )
        : Text(
            value.isEmpty ? 'Not set' : value,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
          ),
    );
  }
}
