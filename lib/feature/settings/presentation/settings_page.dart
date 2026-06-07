import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/settings/presentation/settings_tile.dart';

import '../../auth/presentation/cubits/auth_cubit.dart';
import '../../themes/theme_cubit.dart';

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
        title: Text("Delete acccount?", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
        content: Text("This cannot be undone.", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              handleAccountDeletion();
            },
            child: Text("Yes", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
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
  // Text("Cancel",
  // style: const TextStyle(fontWeight: FontWeight.bold))

  void _showPasswordDialog() {
    final passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Confirm your password", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,fontWeight: FontWeight.bold)),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: const InputDecoration(labelText: "Password"),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
          ),
          TextButton(
            onPressed: () {
              final password = passwordController.text.trim();
              if (password.isEmpty) return;
              Navigator.pop(context);
              handleAccountDeletion(password: password);
            },
            child: Text("Confirm", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // ← jedina izmjena ovdje
    final themeCubit = context.watch<ThemeCubit>();
    final isDarkMode = themeCubit.isDarkMode;

    return Scaffold(
      appBar: AppBar(title: const Text("Settings")),
      body: Column(
        children: [
          // dark mode toggle
          MySettingsTile(
            title: "Dark Mode",
            action: Switch(
              value: isDarkMode,
              onChanged: (_) => themeCubit.toggleTheme(),
            ),
          ),

          // delete account (netaknuto)
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