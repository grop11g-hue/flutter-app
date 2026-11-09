import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_constants.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/tab_provider.dart';
import '../../widgets/app_snack.dart';
import '../orders/orders_screen.dart';
import '../settings/addresses_screen.dart';
import '../settings/settings_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }

  void _editProfile(BuildContext context) {
    final auth = context.read<AuthProvider>();
    if (auth.isGuest) {
      showAppSnack(context, 'Please log in to edit your profile', error: true);
      return;
    }
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _EditProfileSheet(),
    );
  }

  Future<void> _logout(BuildContext context) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.card,
        title: const Text('Logout'),
        content: const Text('Are you sure you want to log out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel',
                style: TextStyle(color: AppColors.textSecondary)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
    if (ok == true && context.mounted) {
      context.read<TabProvider>().setIndex(0);
      await context.read<AuthProvider>().logout();
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final user = auth.currentUser;

    return SafeArea(
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        children: [
          const Text('Profile',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: AppColors.card,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.fromBorderSide(
                      BorderSide(color: AppColors.orange, width: 2),
                    ),
                  ),
                  child: ClipOval(
                    child: Image.asset(
                      AppConstants.avatar,
                      width: 92,
                      height: 92,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(user.name,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                _InfoRow(
                  Icons.email_outlined,
                  user.email.isEmpty ? 'No email' : user.email,
                ),
                const SizedBox(height: 4),
                _InfoRow(
                  Icons.phone_outlined,
                  user.phone.isEmpty ? 'No phone number' : user.phone,
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: () => _editProfile(context),
                    icon: const Icon(Icons.edit_outlined, size: 20),
                    label: const Text('Edit Profile'),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          _MenuTile(
            icon: Icons.receipt_long_outlined,
            label: 'My Orders',
            onTap: () => _open(context, const OrdersScreen()),
          ),
          _MenuTile(
            icon: Icons.favorite_border,
            label: 'My Favorites',
            onTap: () => context.read<TabProvider>().setIndex(2),
          ),
          _MenuTile(
            icon: Icons.location_on_outlined,
            label: 'Saved Addresses',
            onTap: () => _open(context, const AddressesScreen()),
          ),
          _MenuTile(
            icon: Icons.settings_outlined,
            label: 'Settings',
            onTap: () => _open(context, const SettingsScreen()),
          ),
          _MenuTile(
            icon: Icons.info_outline,
            label: 'About SPORTIX',
            onTap: () => showAboutDialog(
              context: context,
              applicationName: AppConstants.appName,
              applicationVersion: AppConstants.version,
              applicationLegalese: AppConstants.tagline,
              children: const [
                SizedBox(height: 12),
                Text('A modern sports store app built with Flutter.'),
              ],
            ),
          ),
          _MenuTile(
            icon: Icons.logout,
            label: auth.isGuest ? 'Exit guest mode' : 'Logout',
            color: AppColors.error,
            onTap: () => _logout(context),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.icon, this.text);

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: AppColors.textSecondary),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
        ),
      ],
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color = Colors.white,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Row(
              children: [
                Icon(icon, color: color == Colors.white ? AppColors.orange : color),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label,
                      style: TextStyle(
                          color: color, fontWeight: FontWeight.w500)),
                ),
                const Icon(Icons.chevron_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EditProfileSheet extends StatefulWidget {
  const _EditProfileSheet();

  @override
  State<_EditProfileSheet> createState() => _EditProfileSheetState();
}

class _EditProfileSheetState extends State<_EditProfileSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _email;
  late final TextEditingController _phone;

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthProvider>().currentUser;
    _name = TextEditingController(text: user.name);
    _email = TextEditingController(text: user.email);
    _phone = TextEditingController(text: user.phone);
  }

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    _phone.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    await context.read<AuthProvider>().updateProfile(
          name: _name.text,
          email: _email.text,
          phone: _phone.text,
        );
    if (!mounted) return;
    showAppSnack(context, 'Profile updated successfully');
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        0,
        24,
        24 + MediaQuery.of(context).viewInsets.bottom,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Edit Profile',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700)),
              const SizedBox(height: 18),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Full name',
                  prefixIcon:
                      Icon(Icons.person_outline, color: AppColors.textSecondary),
                ),
                validator: AuthProvider.validateName,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  hintText: 'Email address',
                  prefixIcon:
                      Icon(Icons.email_outlined, color: AppColors.textSecondary),
                ),
                validator: AuthProvider.validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phone,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Phone number',
                  prefixIcon:
                      Icon(Icons.phone_outlined, color: AppColors.textSecondary),
                ),
                validator: AuthProvider.validatePhone,
              ),
              const SizedBox(height: 20),
              ElevatedButton(onPressed: _save, child: const Text('Save changes')),
            ],
          ),
        ),
      ),
    );
  }
}
