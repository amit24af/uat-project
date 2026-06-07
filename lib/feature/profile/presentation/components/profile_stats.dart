import 'package:flutter/material.dart';

class ProfileStats extends StatelessWidget {
  final int postCount;
  final int followerCount;
  final int followingCount;
  final void Function()? onTap;

  const ProfileStats({
    super.key,
    required this.postCount,
    required this.followerCount,
    required this.followingCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    var textStyleFontCount = TextStyle(
      fontSize: 20,
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    var textStyleFontCategory = TextStyle(
      color: Theme.of(context).colorScheme.inversePrimary,
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(postCount.toString(), style: textStyleFontCount),
                Text("Posts", style: textStyleFontCategory),
              ],
            ),
          ),

          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followerCount.toString(), style: textStyleFontCount),
                Text("Followers", style: textStyleFontCategory),
              ],
            ),
          ),

          SizedBox(
            width: 100,
            child: Column(
              children: [
                Text(followingCount.toString(), style: textStyleFontCount),
                Text("Following", style: textStyleFontCategory),
              ],
            ),
          ),
        ],
      ),
    );
  }
}