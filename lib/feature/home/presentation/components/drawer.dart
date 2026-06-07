import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/home/presentation/components/drawer_tile.dart';
import 'package:uat_project/feature/profile/presentation/pages/profile_page.dart';
import 'package:uat_project/feature/weather/pages/weather_page.dart';

import '../../../auth/presentation/cubits/auth_cubit.dart';
import '../../../search/pages/search_page.dart';
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
        title: Text("Log out?", style: TextStyle(color: Theme.of(context).colorScheme.secondary,)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel", style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary,)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              logout(context);
            },
            child: Text("Yes", style: TextStyle(color: Theme.of(context).colorScheme.secondary,)),
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
                  text: "Search",
                  icon: Icons.search_outlined,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SearchPage()
                        )
                    );
                  },
                ),

                MyDrawerTile(
                  text: "Weather",
                  icon: Icons.sunny_snowing,
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => WeatherPage()
                        )
                    );
                  },
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
