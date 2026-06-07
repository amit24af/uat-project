import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uat_project/feature/auth/presentation/components/loading.dart';
import 'package:uat_project/feature/auth/presentation/cubits/auth_cubit.dart';
import 'package:uat_project/feature/profile/presentation/components/profile_stats.dart';
import 'package:uat_project/feature/profile/presentation/pages/edit_profile_page.dart';
import 'package:uat_project/feature/profile/presentation/pages/follower_page.dart';
import '../../../auth/domain/entities/app_user.dart';
import '../../../post/components/post_tile.dart';
import '../../../post/presentation/cubits/post_cubit.dart';
import '../../../post/presentation/cubits/post_states.dart';
import '../components/bio_box.dart';
import '../components/follow_button.dart';
import '../cubits/profile_cubit.dart';
import '../cubits/profile_states.dart';

class ProfilePage extends StatefulWidget {
  final String uid;

  const ProfilePage({super.key, required this.uid});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late final authCubit = context.read<AuthCubit>();
  late final profileCubit = context.read<ProfileCubit>();

  late AppUser? currentUser = authCubit.CurrentUser;
  int postCount = 0;

  @override
  void initState() {
    super.initState();
    profileCubit.fetchUserProfile(widget.uid);
  }

  void followButtonPressed(){
    final profileState = profileCubit.state;
    if(profileState is !ProfileLoaded){
      return;
    }
    final profileUser = profileState.profileUser;
    final isFollowing = profileUser.followers.contains(currentUser!.uid);
    setState(() {
      if(isFollowing){
        profileUser.followers.remove(currentUser!.uid);
      }else{
        profileUser.followers.add(currentUser!.uid);
      }
    });

    profileCubit.toggleFollow(currentUser!.uid, widget.uid).catchError((error){
      setState(
          (){
            if(isFollowing){
              profileUser.followers.add(currentUser!.uid);
            }else{
              profileUser.followers.remove(currentUser!.uid);
            }
          }
      );
    });
  }

  @override
  Widget build(BuildContext context) {

    bool isOwnPost = (widget.uid == currentUser!.uid);

    return BlocBuilder<ProfileCubit, ProfileState>(
      builder: (context, state) {
        if (state is ProfileLoaded) {
          final user = state.profileUser;
          return Scaffold(
            appBar: AppBar(
              title: Text(user.name),
              foregroundColor: Theme.of(context).colorScheme.tertiary,
              actions: [
                if(isOwnPost)
                  IconButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfilePage(user: user),
                      ),
                    ),
                    icon: const Icon(Icons.settings),
                  ),
              ],
            ),
            body: ListView(
              children: [
                const SizedBox(height: 15),
                Center(
                  child: Text(
                    user.email,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.inversePrimary,
                    ),
                  ),
                ),

                const SizedBox(height: 35),
                CachedNetworkImage(
                  imageUrl: user.profileImageUrl,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(
                    Icons.person_rounded,
                    size: 72,
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),

                  imageBuilder: (context, imageProvider) => Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: imageProvider,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Bio",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                BioBox(text: user.bio),
                const SizedBox(height: 25),

                ProfileStats(
                  postCount: postCount,
                  followerCount: user.followers.length, followingCount: user.following.length,
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>FollowerPage(followers: user.followers, following: user.following)))
                ),

                if(!isOwnPost)
                  FollowButton(
                      onPressed: followButtonPressed,
                      isFollowing: user.followers.contains(currentUser!.uid),
                  ),

                Padding(
                  padding: const EdgeInsets.only(left: 15.0),
                  child: Row(
                    children: [
                      Text(
                        "Posts",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.inversePrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                BlocBuilder<PostCubit, PostState>(
                  builder: (context, state) {
                    if (state is PostLoaded) {
                      final userPosts = state.posts
                          .where((post) => post.userId == widget.uid)
                          .toList();
                      postCount = userPosts.length;

                      return ListView.builder(
                        itemCount: postCount,
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int index) {
                          final post = userPosts[index];

                          return PostTile(
                            post: post,
                            onDeletePressed: () =>
                                context.read<PostCubit>().deletePost(post.id),
                          );
                        },
                      );
                    } else if (state is PostLoading) {
                      return LoadingScreen();
                    } else {
                      return const Center(child: Text("No posts..."));
                    }
                  },
                ),
              ],
            ),
          );
        } else if (state is ProfileLoading) {
          return const Scaffold(body: LoadingScreen());
        } else {
          return const Center(child: Text("No profile found..."));
        }
      },
    );
  }
}
