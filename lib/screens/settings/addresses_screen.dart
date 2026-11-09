import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../providers/settings_provider.dart';
import '../../widgets/app_snack.dart';

class AddressesScreen extends StatelessWidget {
  const AddressesScreen({super.key});

  void _addAddress(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => const _AddAddressSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final addresses = context.watch<SettingsProvider>().addresses;

    return Scaffold(
      appBar: AppBar(title: const Text('Saved Addresses')),
      body: addresses.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(32),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.location_off_outlined,
                        size: 64, color: AppColors.textSecondary),
                    SizedBox(height: 12),
                    Text('No saved addresses',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (_, i) => Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.location_on_outlined,
                        color: AppColors.orange),
                    const SizedBox(width: 12),
                    Expanded(child: Text(addresses[i])),
                    IconButton(
                      icon: const Icon(Icons.delete_outline,
                          color: AppColors.error),
                      onPressed: () {
                        context.read<SettingsProvider>().removeAddress(i);
                        showAppSnack(context, 'Address removed');
                      },
                    ),
                  ],
                ),
              ),
            ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: AppColors.orange,
        foregroundColor: Colors.white,
        onPressed: () => _addAddress(context),
        icon: const Icon(Icons.add),
        label: const Text('Add address'),
      ),
    );
  }
}

class _AddAddressSheet extends StatefulWidget {
  const _AddAddressSheet();

  @override
  State<_AddAddressSheet> createState() => _AddAddressSheetState();
}

class _AddAddressSheetState extends State<_AddAddressSheet> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    context.read<SettingsProvider>().addAddress(_controller.text);
    showAppSnack(context, 'Address saved');
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('New address',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 16),
            TextFormField(
              controller: _controller,
              autofocus: true,
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: 'Street, city, country',
              ),
              validator: (v) {
                final value = v?.trim() ?? '';
                if (value.isEmpty) return 'Please enter an address';
                if (value.length < 6) return 'Address is too short';
                return null;
              },
            ),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: _save, child: const Text('Save address')),
          ],
        ),
      ),
    );
  }
}
