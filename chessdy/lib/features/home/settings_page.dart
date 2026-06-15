import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../providers/theme_provider.dart';
import '../../providers/locale_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  bool _soundEnabled = true;
  bool _notificationsEnabled = true;
  double _soundVolume = 0.7;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.settings),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // ── Appearance Section ────────────────────────────────
          SectionLabel('Appearance'),
          const SizedBox(height: 12),

          _SettingsTile(
            isDark: isDark,
            icon: ref.watch(themeProvider) == ThemeMode.dark
                ? Icons.dark_mode_rounded
                : Icons.light_mode_rounded,
            iconColor: ref.watch(themeProvider) == ThemeMode.dark
                ? AppTheme.info
                : AppTheme.warning,
            title: l10n.darkMode,
            subtitle: ref.watch(themeProvider) == ThemeMode.dark
                ? l10n.darkThemeEnabled
                : l10n.lightThemeEnabled,
            trailing: Switch(
              value: ref.watch(themeProvider) == ThemeMode.dark,
              onChanged: (_) => ref.read(themeProvider.notifier).toggleTheme(),
            ),
          ),
          const SizedBox(height: 8),

          _SettingsTile(
            isDark: isDark,
            icon: Icons.translate_rounded,
            iconColor: AppTheme.success,
            title: l10n.language,
            subtitle: ref.watch(localeProvider).languageCode == 'mn'
                ? 'Монгол хэл идэвхтэй'
                : 'English is active',
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'EN',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ref.watch(localeProvider).languageCode == 'en'
                        ? AppTheme.gold
                        : AppTheme.textMuted,
                  ),
                ),
                const SizedBox(width: 6),
                Switch(
                  value: ref.watch(localeProvider).languageCode == 'mn',
                  onChanged: (_) =>
                      ref.read(localeProvider.notifier).toggleLocale(),
                ),
                Text(
                  'MN',
                  style: GoogleFonts.outfit(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: ref.watch(localeProvider).languageCode == 'mn'
                        ? AppTheme.gold
                        : AppTheme.textMuted,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // ── Audio Section ─────────────────────────────────────
          const SectionLabel('Audio'),
          const SizedBox(height: 12),

          _SettingsTile(
            isDark: isDark,
            icon: _soundEnabled
                ? Icons.volume_up_rounded
                : Icons.volume_off_rounded,
            iconColor: AppTheme.ember,
            title: l10n.sound,
            subtitle: _soundEnabled ? 'Sound effects on' : 'Sound effects off',
            trailing: Switch(
              value: _soundEnabled,
              onChanged: (v) => setState(() => _soundEnabled = v),
            ),
          ),

          if (_soundEnabled) ...[
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              decoration: isDark
                  ? AppTheme.glassCard()
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                          Border.all(color: Colors.black.withOpacity(0.06)),
                    ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.graphic_eq_rounded,
                          size: 16, color: AppTheme.textMuted),
                      const SizedBox(width: 8),
                      Text(l10n.volume, style: AppTheme.bodySmall),
                      const Spacer(),
                      Text(
                        '${(_soundVolume * 100).toInt()}%',
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.gold,
                        ),
                      ),
                    ],
                  ),
                  Slider(
                    value: _soundVolume,
                    onChanged: (v) => setState(() => _soundVolume = v),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 24),

          // ── Notifications Section ─────────────────────────────
          const SectionLabel('Notifications'),
          const SizedBox(height: 12),

          _SettingsTile(
            isDark: isDark,
            icon: _notificationsEnabled
                ? Icons.notifications_rounded
                : Icons.notifications_off_rounded,
            iconColor: AppTheme.gold,
            title: l10n.notifications,
            subtitle: _notificationsEnabled
                ? 'Reminders & updates on'
                : 'All notifications off',
            trailing: Switch(
              value: _notificationsEnabled,
              onChanged: (v) => setState(() => _notificationsEnabled = v),
            ),
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Widget trailing;

  const _SettingsTile({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: isDark
          ? AppTheme.glassCard()
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
      child: Row(
        children: [
          GlowIcon(icon: icon, color: iconColor, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.heading3),
                const SizedBox(height: 2),
                Text(subtitle, style: AppTheme.bodySmall),
              ],
            ),
          ),
          trailing,
        ],
      ),
    );
  }
}
