import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/auth_repository.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _surnameController = TextEditingController();
  final _professionController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  bool _isLoading = false;
  bool _obscurePassword = true;
  double _strength = 0;
  String _strengthText = '';
  Color _strengthColor = Colors.grey;
  int? _selectedRoleId;

  void _checkPasswordStrength(String value) {
    double strength = 0;
    if (value.isEmpty) {
      strength = 0;
    } else if (value.length < 6) {
      strength = 0.25;
    } else {
      strength = 0.5;
      if (RegExp(r'[A-Z]').hasMatch(value) && RegExp(r'[0-9]').hasMatch(value)) {
        strength = 0.75;
      }
      if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value) && value.length >= 8) {
        strength = 1.0;
      }
    }

    setState(() {
      _strength = strength;
      if (strength <= 0.25) {
        _strengthText = 'Weak';
        _strengthColor = Colors.red;
      } else if (strength <= 0.5) {
        _strengthText = 'Fair';
        _strengthColor = Colors.orange;
      } else if (strength <= 0.75) {
        _strengthText = 'Good';
        _strengthColor = Colors.blue;
      } else {
        _strengthText = 'Strong';
        _strengthColor = Colors.green;
      }
    });
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    
    try {
      final authRepo = ref.read(authRepositoryProvider);
      final fullName = "${_firstNameController.text} ${_surnameController.text}";
      
      await authRepo.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        fullName: fullName,
        roleId: _selectedRoleId ?? 3,
        phone: _phoneController.text.trim(),
        profession: _professionController.text.trim(),
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Verification email sent! Please check your inbox.')),
        );
        context.go('/login');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left side: Image/Branding
          if (MediaQuery.of(context).size.width > 800)
            Expanded(
              flex: 1,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset(
                      'assets/images/denny-muller-JyRTi3LoQnc-unsplash.jpg',
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.85),
                    ),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.network(
                          'https://lottie.host/828770d1-032a-43f1-b99b-00109605481b/f8D2X0yvC5.json',
                          height: 200,
                          errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.person_add, size: 100, color: Colors.white),
                        ),
                        const SizedBox(height: 24),
                        const Text(
                          'Join Telecom AI',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40),
                          child: Text(
                            'Create an account to start managing your network infrastructure with AI-driven insights.',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          // Right side: Sign Up Form
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(48.0),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Create Account',
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                        ),
                        const SizedBox(height: 8),
                        const Text('Enter your details to get started'),
                        const SizedBox(height: 32),
                        
                        // Name Row
                        Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                controller: _firstNameController,
                                label: 'First Name',
                                icon: Icons.person_outline,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: _buildTextField(
                                controller: _surnameController,
                                label: 'Surname',
                                icon: Icons.person_outline,
                                textCapitalization: TextCapitalization.words,
                                validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _professionController,
                          label: 'Profession',
                          icon: Icons.work_outline,
                          textCapitalization: TextCapitalization.sentences,
                          validator: (v) => v?.isEmpty ?? true ? 'Enter profession' : null,
                        ),
                        const SizedBox(height: 20),

                        ref.watch(rolesProvider).when(
                          data: (roles) => DropdownButtonFormField<int>(
                            value: _selectedRoleId,
                            decoration: InputDecoration(
                              labelText: 'Account Role',
                              prefixIcon: const Icon(Icons.admin_panel_settings_outlined),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
                              ),
                            ),
                            items: roles.map((r) => DropdownMenuItem<int>(
                              value: r['id'] as int,
                              child: Text(r['name'] as String),
                            )).toList(),
                            onChanged: (v) => setState(() => _selectedRoleId = v),
                            validator: (v) => v == null ? 'Please select a role' : null,
                          ),
                          loading: () => const LinearProgressIndicator(),
                          error: (_, __) => const Text('Error loading roles'),
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _phoneController,
                          label: 'Phone Number',
                          icon: Icons.phone_outlined,
                          keyboardType: TextInputType.phone,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          validator: (v) => (v?.length ?? 0) < 10 ? 'Enter valid phone' : null,
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _emailController,
                          label: 'Email Address',
                          icon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                          validator: (v) {
                            if (v == null || !v.contains('@')) return 'Enter valid email';
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _passwordController,
                          label: 'Password',
                          icon: Icons.lock_outline,
                          obscureText: _obscurePassword,
                          onChanged: _checkPasswordStrength,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.6),
                            ),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                          validator: (v) => (v?.length ?? 0) < 6 ? 'Min 6 characters' : null,
                        ),
                        if (_passwordController.text.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: _strength,
                              backgroundColor: Colors.grey.withValues(alpha: 0.1),
                              color: _strengthColor,
                              minHeight: 4,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Password strength: $_strengthText',
                            style: TextStyle(fontSize: 12, color: _strengthColor, fontWeight: FontWeight.bold),
                          ),
                        ],
                        const SizedBox(height: 20),
                        
                        _buildTextField(
                          controller: _confirmPasswordController,
                          label: 'Confirm Password',
                          icon: Icons.lock_clock_outlined,
                          obscureText: _obscurePassword,
                          textInputAction: TextInputAction.done,
                          inputFormatters: [FilteringTextInputFormatter.deny(RegExp(r'\s'))],
                          validator: (v) {
                            if (v != _passwordController.text) return 'Passwords do not match';
                            return null;
                          },
                        ),
                        
                        const SizedBox(height: 32),
                        ElevatedButton(
                          onPressed: _isLoading ? null : _signUp,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                                )
                              : const Text('Create Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        
                        const SizedBox(height: 24),
                        Wrap(
                          alignment: WrapAlignment.center,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            const Text("Already have an account?"),
                            TextButton(
                              onPressed: () => context.go('/login'),
                              child: const Text('Login'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    List<TextInputFormatter>? inputFormatters,
    TextCapitalization textCapitalization = TextCapitalization.none,
    TextInputAction textInputAction = TextInputAction.next,
    bool obscureText = false,
    Widget? suffixIcon,
    Function(String)? onChanged,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      inputFormatters: inputFormatters,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.withValues(alpha: 0.2)),
        ),
      ),
      validator: validator,
    );
  }
}
