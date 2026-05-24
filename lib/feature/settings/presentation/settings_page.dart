import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/settings/presentation/settings_tile.dart';

import '../../auth/presentation/cubits/auth_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void confirmAccountDeletion() {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleAccountDeletion();
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  Future<void> handleAccountDeletion() async {
    try {
      showDialog(
        context: context,
        builder: (context) => Center(child: CircularProgressIndicator()),
      );
      final authCubit = context.read<AuthCubit>();
      await authCubit.deleteAccount();
      if (mounted) {
        Navigator.pop(context); // for rm of loading circle
        Navigator.pop(context); // for rm of settings page
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Settings")),
      body: Column(
        children: [
          // delete account
          MySettingsTile(
            title: "Delete Account",
            action: IconButton(
              onPressed: confirmAccountDeletion,
              icon: const Icon(Icons.delete_forever),
            ),
          ),
        ],
      ),
    );
  }
}
