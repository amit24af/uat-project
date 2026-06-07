import 'package:flutter/material.dart';
import 'package:uat_project/feature/profile/presentation/cubits/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/user_tile.dart';
class FollowerPage extends StatelessWidget {
  final List<String> followers;
  final List<String> following;
  const FollowerPage({super.key, required this.followers, required this.following});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(length: 2, child: ScaffoldMessenger(child: Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          dividerColor: Theme.of(context).colorScheme.inversePrimary,
          labelColor: Theme.of(context).colorScheme.tertiary,
          unselectedLabelColor: Theme.of(context).colorScheme.secondary,
          tabs: const [
          Tab(text: "Followers"),
          Tab(text: "Following"),
        ],
        ),
      ),
      body: TabBarView(children: [
        _buildUserLIst(followers, "No Followers", context),
        _buildUserLIst(following, "No Following", context)
      ],)
    )));
  }

  Widget _buildUserLIst(
      List<String> uids,
      String emptyMessage,
      BuildContext context,
      ) {
    return uids.isEmpty
        ? Center(child: Text(emptyMessage))
        : ListView.builder(
      itemCount: uids.length,
      itemBuilder: (context, index) {
        final uid = uids[index];

        return FutureBuilder(
          future: context.read<ProfileCubit>().getUserProfile(uid),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final user = snapshot.data;
              return UserTile(user: user);
            } else if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const ListTile(
                title: Text("Loading"),
              );
            } else {
              return const ListTile(
                title: Text("User not found...."),
              );
            }
          },
        );
      },
    );
  }

}
