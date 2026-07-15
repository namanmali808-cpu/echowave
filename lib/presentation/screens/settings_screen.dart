import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:echowave/core/providers/theme_provider.dart';
import 'package:echowave/presentation/extensions/context_extensions.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final toggleTheme = ref.watch(toggleThemeProvider);

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1a0533),
              Color(0xFF0D0D0D),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    _SectionTitle(title: 'Appearance'),
                    _SettingsTile(
                      icon: Icons.dark_mode,
                      title: 'Dark Mode',
                      subtitle: isDarkMode ? 'Dark theme is active' : 'Light theme is active',
                      trailing: Switch(
                        value: isDarkMode,
                        onChanged: (_) => toggleTheme(),
                        activeColor: const Color(0xFF6C63FF),
                      ),
                    ),
                    _SectionTitle(title: 'Playback'),
                    _SettingsTile(
                      icon: Icons.language,
                      title: 'Language',
                      subtitle: 'English',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => context.showSnackBar('Language settings coming soon'),
                    ),
                    _SettingsTile(
                      icon: Icons.high_quality,
                      title: 'Streaming Quality',
                      subtitle: 'High (320 kbps)',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => _showQualitySelector(context),
                    ),
                    _SectionTitle(title: 'Storage'),
                    _SettingsTile(
                      icon: Icons.storage,
                      title: 'Clear Cache',
                      subtitle: '245 MB',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            backgroundColor: const Color(0xFF1A1A1A),
                            title: const Text('Clear Cache', style: TextStyle(color: Colors.white)),
                            content: const Text(
                              'This will clear all cached data. Downloaded songs will not be affected.',
                              style: TextStyle(color: Colors.white70),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx),
                                child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(ctx);
                                  context.showSnackBar('Cache cleared');
                                },
                                child: const Text('Clear', style: TextStyle(color: Color(0xFF6C63FF))),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    _SectionTitle(title: 'About'),
                    _SettingsTile(
                      icon: Icons.info_outline,
                      title: 'About EchoWave',
                      subtitle: 'Version 1.0.0',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () => context.showSnackBar('EchoWave v1.0.0'),
                    ),
                    _SettingsTile(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {},
                    ),
                    _SettingsTile(
                      icon: Icons.privacy_tip_outlined,
                      title: 'Privacy Policy',
                      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
                      onTap: () {},
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showQualitySelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1A1A1A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Streaming Quality',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              _QualityOption(label: 'Low (96 kbps)', subtitle: 'Uses less data'),
              _QualityOption(label: 'Normal (160 kbps)', subtitle: 'Balanced quality'),
              _QualityOption(label: 'High (320 kbps)', subtitle: 'Best quality, more data'),
              _QualityOption(label: 'Very High (FLAC)', subtitle: 'Lossless audio, premium only'),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;

  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 24, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF6C63FF),
          fontSize: 13,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white.withOpacity(0.7), size: 24),
      title: Text(title, style: const TextStyle(color: Colors.white, fontSize: 16)),
      subtitle: subtitle != null
          ? Text(subtitle!, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 13))
          : null,
      trailing: trailing,
      onTap: onTap,
    );
  }
}

class _QualityOption extends StatelessWidget {
  final String label;
  final String subtitle;

  const _QualityOption({required this.label, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(label, style: const TextStyle(color: Colors.white)),
      subtitle: Text(subtitle, style: TextStyle(color: Colors.white.withOpacity(0.5), fontSize: 12)),
      onTap: () {
        Navigator.pop(context);
        context.showSnackBar('Quality set to $label');
      },
    );
  }
}
