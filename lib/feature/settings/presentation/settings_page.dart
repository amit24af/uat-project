import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/settings/presentation/settings_tile.dart';

import '../../auth/presentation/cubits/auth_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  void confirmAccountDeletion() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Delete Account?"),
        content: const Text("This cannot be undone."),
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


  Future<void> handleAccountDeletion({String? password}) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(child: CircularProgressIndicator()),
      );

      await context.read<AuthCubit>().deleteAccount(password: password);

      if (!mounted) return;
      Navigator.of(context).popUntil((route) => route.isFirst);

    } catch (e) {
      if (!mounted) return;
      Navigator.pop(context);

      if (e.toString().contains('requires-recent-login')) {
        _showPasswordDialog();
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(e.toString())));
      }
    }
  }

  void _showPasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Confirm your password"),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text.trim();
              if (password.isEmpty) return;
              Navigator.pop(context);
              handleAccountDeletion(password: password);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
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
