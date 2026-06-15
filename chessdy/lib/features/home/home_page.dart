import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'settings_page.dart';
import 'statistics_page.dart';
import 'feedback_support_page.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: _HeroSection(l10n: l10n, isDark: isDark),
          ),
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                SectionLabel(l10n.quickAccess),
                const SizedBox(height: 18),
                _MenuCard(
                  icon: Icons.bar_chart_rounded,
                  iconColor: AppTheme.info,
                  title: l10n.statisticsAndAchievements,
                  subtitle: l10n.subtitleStats,
                  isDark: isDark,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const StatisticsPage())),
                ),
                const SizedBox(height: 16),
                _MenuCard(
                  icon: Icons.tune_rounded,
                  iconColor: isDark ? AppTheme.gold : AppTheme.goldDark,
                  title: l10n.settings,
                  subtitle: l10n.subtitleSettings,
                  isDark: isDark,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const SettingsPage())),
                ),
                const SizedBox(height: 16),
                _MenuCard(
                  icon: Icons.chat_bubble_outline_rounded,
                  iconColor: AppTheme.success,
                  title: l10n.feedbackAndSupport,
                  subtitle: l10n.subtitleFeedback,
                  isDark: isDark,
                  onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (_) => const FeedbackSupportPage())),
                ),
                const SizedBox(height: 16),
                _MenuCard(
                  icon: Icons.info_outline_rounded,
                  iconColor: AppTheme.mutedColor(isDark),
                  title: l10n.aboutChessdy,
                  subtitle: l10n.subtitleAbout,
                  isDark: isDark,
                  onTap: () => _showAboutDialog(context, l10n),
                ),
                const SizedBox(height: 120), // Padding to avoid floating nav bar
              ]),
            ),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.cardColor(Theme.of(context).brightness == Brightness.dark),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text(l10n.aboutChessdy, style: AppTheme.heading2),
        content: SingleChildScrollView(
          child: Text(
            l10n.aboutChessdyDesc,
            style: AppTheme.bodyLarge.copyWith(color: AppTheme.mutedColor(Theme.of(context).brightness == Brightness.dark)),
          )
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }
}

// ── Chess Knight Icon (Premium version) ─────────────────────
class _ChessKnightIcon extends StatelessWidget {
  final double size;
  final bool isDark;
  const _ChessKnightIcon({this.size = 56, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldDark;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: goldColor.withOpacity(0.5),
            blurRadius: 20,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
          BoxShadow(
            color: goldColor.withOpacity(0.2),
            blurRadius: 40,
            spreadRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          '♞',
          style: TextStyle(
            fontSize: size * 0.52,
            color: const Color(0xFF140F05),
            height: 1.1, // Adjusted for exact visual center
          ),
        ),
      ),
    );
  }
}

// ── Hero Section ──────────────────────────────────────────────────
class _HeroSection extends StatelessWidget {
  final AppLocalizations l10n;
  final bool isDark;
  const _HeroSection({required this.l10n, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final primaryColor = AppTheme.primaryColor(isDark);
    final mutedColor = AppTheme.mutedColor(isDark);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(28, 70, 24, 40),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.bgSecondary : Colors.white,
        gradient: isDark ? AppTheme.heroGradient : AppTheme.lightHeroGradient,
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(32),
          bottomRight: Radius.circular(32),
        ),
        boxShadow: isDark ? [
           BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 24, offset: const Offset(0, 8))
        ] : [
           BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 16, offset: const Offset(0, 4))
        ]
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Coach badge row
          Row(
            children: [
              _ChessKnightIcon(isDark: isDark),
              const SizedBox(width: 18),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.15),
                      borderRadius: BorderRadius.circular(30),
                      border: Border.all(color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.3), width: 1.5),
                    ),
                    child: Text(
                      l10n.aiCoachLabel, 
                      style: AppTheme.labelGold.copyWith(color: isDark ? AppTheme.gold : AppTheme.goldDark)
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(l10n.readyToTrain,
                      style: AppTheme.bodySmall.copyWith(color: mutedColor, fontWeight: FontWeight.w500)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 36),
          // Headline
          Text(l10n.masterChessToday,
              style: AppTheme.displayLarge.copyWith(color: primaryColor)),
          const SizedBox(height: 12),
          Text(l10n.learnTrainPlay,
              style: AppTheme.bodyLarge.copyWith(color: mutedColor)),
          const SizedBox(height: 32),
          // Feature pills
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _FeaturePill(icon: Icons.bolt, label: l10n.featureAiAnalysis, color: isDark ? AppTheme.gold : AppTheme.goldDark),
              _FeaturePill(icon: Icons.menu_book, label: l10n.featureLessons, color: AppTheme.info),
              _FeaturePill(icon: Icons.people, label: l10n.featurePlayVsHuman, color: AppTheme.success),
              _FeaturePill(icon: Icons.translate, label: l10n.featureLang, color: AppTheme.mutedColor(isDark)),
            ],
          ),
        ],
      ),
    );
  }
}

class _FeaturePill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  const _FeaturePill({required this.icon, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: color.withOpacity(0.3), width: 1.5),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.w600, color: color),
          ),
        ],
      ),
    );
  }
}

// ── Menu Card ─────────────────────────────────────────────────────
class _MenuCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool isDark;
  final VoidCallback onTap;

  const _MenuCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TappableCard(
      onTap: onTap,
      decoration: AppTheme.glassCard(isDark: isDark),
      child: Row(
        children: [
          GlowIcon(icon: icon, color: iconColor, size: 24),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTheme.heading3.copyWith(color: AppTheme.primaryColor(isDark))),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTheme.bodySmall.copyWith(color: AppTheme.mutedColor(isDark))),
              ],
            ),
          ),
          Icon(Icons.chevron_right_rounded, color: AppTheme.mutedColor(isDark).withOpacity(0.5), size: 24),
        ],
      ),
    );
  }
}
