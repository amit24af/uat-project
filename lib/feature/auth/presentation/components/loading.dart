import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..repeat();

    _scaleAnimation = Tween<double>(
      begin: 0.5,
      end: 1.5,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tertiary = Theme.of(context).colorScheme.tertiary;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Opacity(
                    opacity: 1 - _controller.value,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),

                Transform.scale(
                  scale: (_scaleAnimation.value * 0.75).clamp(0.0, 2.0),
                  child: Opacity(
                    opacity: (1 - ((_controller.value + 0.5) % 1.0)),
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: tertiary,
                          width: 4,
                        ),
                      ),
                    ),
                  ),
                ),

                Container(
                  width: 28,
                  height: 28,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: tertiary,
                    boxShadow: [
                      BoxShadow(
                        color: tertiary.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}