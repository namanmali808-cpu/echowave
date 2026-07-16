import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:echowave/data/services/update_service.dart';
import 'package:echowave/presentation/providers/auth_provider.dart';
import 'package:echowave/presentation/widgets/update_dialog.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnim;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _scaleAnim = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );
    _controller.forward();
    _checkForUpdate();
    _navigateAfterDelay();
  }

  Future<void> _checkForUpdate() async {
    try {
      final dio = Dio(BaseOptions(
        headers: {'Accept': 'application/vnd.github.v3+json'},
      ));
      final updateService = UpdateService(dio);
      final updateInfo = await updateService.checkForUpdate();
      if (updateInfo != null && mounted) {
        await UpdateDialog.show(
          context,
          updateInfo: updateInfo,
          updateService: updateService,
        );
      }
    } catch (_) {}
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    var authState = ref.read(authProvider);
    if (authState.state == AuthState.loading) {
      await Future.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      authState = ref.read(authProvider);
    }
    if (authState.state == AuthState.authenticated) {
      context.go('/home');
    } else {
      context.go('/onboarding');
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1a0533),
              Color(0xFF0D0D0D),
              Color(0xFF1a0533),
            ],
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnim.value,
                  child: Transform.scale(
                    scale: _scaleAnim.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF6C63FF), Color(0xFFFF6584)],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF6C63FF).withOpacity(0.4),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.music_note_rounded,
                  size: 60,
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'EchoWave',
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ).animate().fadeIn(delay: 500.ms).slideY(begin: 20, end: 0),
            const SizedBox(height: 8),
            Text(
              'Feel the Music',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white.withOpacity(0.7),
                letterSpacing: 4,
              ),
            ).animate().fadeIn(delay: 800.ms).slideY(begin: 10, end: 0),
          ],
        ),
      ),
    );
  }
}
