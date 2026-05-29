import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/home/presentation/components/drawer_tile.dart';
import 'package:uat_project/feature/profile/presentation/pages/profile_page.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../settings/presentation/settings_page.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  void logout(BuildContext context) {
    final authCubit = context.read<AuthCubit>();
    authCubit.logout();
  }

  void confirmLogout(BuildContext context) {
    Navigator.pop(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logout(context);
            },
            child: const Text("Yes"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                const DrawerHeader(child: Icon(Icons.favorite)),
                //home tile
                MyDrawerTile(
                  text: "Home",
                  icon: Icons.home,
                  onTap: () => Navigator.pop(context),
                ),

                MyDrawerTile(
                  text: "Settings",
                  icon: Icons.settings,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SettingsPage()
                      )
                    );
                  },
                ),

                MyDrawerTile(
                  text: "Profile",
                  icon: Icons.person,
                  onTap: () {
                    Navigator.pop(context);
                    final user = context.read<AuthCubit>().CurrentUser;
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProfilePage(uid: user!.uid,),
                        )
                    );
                  },
                ),

              ],
            ),
            MyDrawerTile(
              text: "Log Out",
              icon: Icons.logout,
              onTap: () => confirmLogout(context),
            ),
            // logout tile
          ],
        ),
      ),
    );
  }
}
