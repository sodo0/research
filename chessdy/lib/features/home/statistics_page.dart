import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import '../../services/statistics_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../lessons/models/puzzle_data.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({super.key});

  @override
  State<StatisticsPage> createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage>
    with SingleTickerProviderStateMixin {
  List<String> _completedLessons = [];
  int _aiWins = 0;
  bool _aiBeaterUnlocked = false;
  bool _isLoading = true;
  late AnimationController _animController;
  late Animation<double> _progressAnim;

  final List<String> _allLessons = [
    'About the Pieces',
    'How to Capture',
    'Worth of the Pieces',
    'How to Castle',
    'About Check and Checkmate',
    'About En Passant',
    ...LessonData.getAllPuzzleIds(),
  ];

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _progressAnim = CurvedAnimation(
      parent: _animController,
      curve: Curves.easeOutCubic,
    );
    _loadStatistics();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Future<void> _loadStatistics() async {
    final service = StatisticsService();
    final completed = await service.getCompletedLessons();
    final wins = await service.getAIWins();
    final unlocked =
        await service.isAchievementUnlocked('achievement_ai_beater');
    if (mounted) {
      setState(() {
        _completedLessons = completed;
        _aiWins = wins;
        _aiBeaterUnlocked = unlocked;
        _isLoading = false;
      });
      _animController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary;

    if (_isLoading) {
      return Scaffold(
        backgroundColor: bg,
        body: const Center(
          child: CircularProgressIndicator(color: AppTheme.gold),
        ),
      );
    }

    final double progress =
        _completedLessons.length / _allLessons.length;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.statisticsAndAchievements),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
        children: [
          // ── Stats Row ────────────────────────────────────────
          Row(
            children: [
              Expanded(
                child: _StatCard(
                  isDark: isDark,
                  icon: Icons.emoji_events_rounded,
                  iconColor: AppTheme.gold,
                  value: '$_aiWins',
                  label: l10n.totalWins,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _StatCard(
                  isDark: isDark,
                  icon: Icons.menu_book_rounded,
                  iconColor: AppTheme.info,
                  value:
                      '${_completedLessons.length}/${_allLessons.length}',
                  label: l10n.lessons,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // ── Progress Ring + Bar ───────────────────────────────
          SectionLabel(l10n.lessonsProgress),
          const SizedBox(height: 14),

          Container(
            padding: const EdgeInsets.all(20),
            decoration: isDark
                ? AppTheme.glassCard()
                : BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border:
                        Border.all(color: Colors.black.withOpacity(0.06)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 8,
                          offset: const Offset(0, 2))
                    ],
                  ),
            child: Row(
              children: [
                // Progress ring
                AnimatedBuilder(
                  animation: _progressAnim,
                  builder: (context, _) => CustomPaint(
                    size: const Size(72, 72),
                    painter: _RingPainter(
                      progress: progress * _progressAnim.value,
                      isDark: isDark,
                    ),
                    child: SizedBox(
                      width: 72,
                      height: 72,
                      child: Center(
                        child: Text(
                          '${(progress * _progressAnim.value * 100).round()}%',
                          style: GoogleFonts.outfit(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.gold,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_completedLessons.length} of ${_allLessons.length} ${l10n.lessonsCompleted}',
                        style: AppTheme.heading3,
                      ),
                      const SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: AnimatedBuilder(
                          animation: _progressAnim,
                          builder: (context, _) => LinearProgressIndicator(
                            value: progress * _progressAnim.value,
                            backgroundColor: isDark
                                ? AppTheme.cardBorder
                                : Colors.grey.shade200,
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                AppTheme.gold),
                            minHeight: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // ── Individual lessons ────────────────────────────────
          ..._allLessons.map((lessonId) {
            final isCompleted = _completedLessons.contains(lessonId);
            return _LessonProgressRow(
              isDark: isDark,
              title: _getLessonTitle(context, lessonId),
              completed: isCompleted,
            );
          }),

          const SizedBox(height: 24),

          // ── Achievement ────────────────────────────────────────
          SectionLabel(l10n.achievements),
          const SizedBox(height: 14),

          _AchievementCard(
            isDark: isDark,
            unlocked: _aiBeaterUnlocked,
            title: l10n.aiBeater,
            subtitle: l10n.winAgainstAI,
            wins: _aiWins,
            l10n: l10n,
          ),

          const SizedBox(height: 100),
        ],
      ),
    );
  }

  String _getLessonTitle(BuildContext context, String lessonId) {
    final l10n = AppLocalizations.of(context);
    switch (lessonId) {
      case 'About the Pieces':
        return l10n.aboutThePieces;
      case 'How to Capture':
        return l10n.howToCapture;
      case 'Worth of the Pieces':
        return l10n.worthOfPieces;
      case 'How to Castle':
        return l10n.howToCastle;
      case 'About Check and Checkmate':
        return l10n.aboutCheckAndCheckmate;
      case 'About En Passant':
        return l10n.aboutEnPassant;
      case 'p1_mate_1_back_rank':
        return l10n.p1_mate_1_back_rank;
      case 'p2_mate_1_smothered':
        return l10n.p2_mate_1_smothered;
      case 'p3_mate_1_scholar':
        return l10n.p3_mate_1_scholar;
      case 'p4_mate_1_queen':
        return l10n.p4_mate_1_queen;
      case 'p5_mate_2_ladder':
        return l10n.p5_mate_2_ladder;
      case 'p6_mate_2_anastasia':
        return l10n.p6_mate_2_anastasia;
      case 'p7_mate_2_back_rank_sac':
        return l10n.p7_mate_2_back_rank_sac;
      case 'p8_tactic_knight_fork':
        return l10n.p8_tactic_knight_fork;
      case 'p9_tactic_discovered_attack':
        return l10n.p9_tactic_discovered_attack;
      case 'p10_tactic_skewer':
        return l10n.p10_tactic_skewer;
      default:
        return lessonId;
    }
  }
}

// ── Stat Card ─────────────────────────────────────────────────────
class _StatCard extends StatelessWidget {
  final bool isDark;
  final IconData icon;
  final Color iconColor;
  final String value;
  final String label;

  const _StatCard({
    required this.isDark,
    required this.icon,
    required this.iconColor,
    required this.value,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: isDark
          ? AppTheme.goldGlassCard()
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black.withOpacity(0.06)),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GlowIcon(icon: icon, color: iconColor, size: 20),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.outfit(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: AppTheme.textPrimary,
            ),
          ),
          const SizedBox(height: 2),
          Text(label, style: AppTheme.bodySmall),
        ],
      ),
    );
  }
}

// ── Lesson Progress Row ───────────────────────────────────────────
class _LessonProgressRow extends StatelessWidget {
  final bool isDark;
  final String title;
  final bool completed;

  const _LessonProgressRow({
    required this.isDark,
    required this.title,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: isDark
            ? (completed
                ? AppTheme.success.withOpacity(0.07)
                : AppTheme.bgCard)
            : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: completed
              ? AppTheme.success.withOpacity(0.3)
              : AppTheme.cardBorder,
        ),
      ),
      child: Row(
        children: [
          Icon(
            completed
                ? Icons.check_circle_rounded
                : Icons.circle_outlined,
            color: completed ? AppTheme.success : AppTheme.textMuted,
            size: 18,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: AppTheme.bodySmall.copyWith(
                color: completed ? AppTheme.textPrimary : AppTheme.textMuted,
              ),
            ),
          ),
          if (completed)
            const Icon(
              Icons.emoji_events_rounded,
              color: AppTheme.gold,
              size: 16,
            ),
        ],
      ),
    );
  }
}

// ── Achievement Card ─────────────────────────────────────────────
class _AchievementCard extends StatelessWidget {
  final bool isDark;
  final bool unlocked;
  final String title;
  final String subtitle;
  final int wins;
  final AppLocalizations l10n;

  const _AchievementCard({
    required this.isDark,
    required this.unlocked,
    required this.title,
    required this.subtitle,
    required this.wins,
    required this.l10n,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: isDark
          ? (unlocked
              ? AppTheme.goldGlassCard()
              : AppTheme.glassCard())
          : BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: unlocked
                    ? AppTheme.gold.withOpacity(0.4)
                    : Colors.black.withOpacity(0.06),
              ),
            ),
      child: Row(
        children: [
          // Badge icon
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: unlocked
                  ? AppTheme.gold.withOpacity(0.15)
                  : AppTheme.cardBorder.withOpacity(0.3),
              border: Border.all(
                color: unlocked
                    ? AppTheme.gold.withOpacity(0.5)
                    : AppTheme.cardBorder,
                width: 2,
              ),
              boxShadow: unlocked
                  ? [
                      BoxShadow(
                        color: AppTheme.gold.withOpacity(0.25),
                        blurRadius: 16,
                        spreadRadius: 2,
                      )
                    ]
                  : [],
            ),
            child: Icon(
              unlocked ? Icons.emoji_events_rounded : Icons.lock_rounded,
              color: unlocked ? AppTheme.gold : AppTheme.textMuted,
              size: 32,
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(title, style: AppTheme.heading3),
                    if (unlocked) ...[
                      const SizedBox(width: 8),
                      MoveBadge(
                          label: 'UNLOCKED', color: AppTheme.gold),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: AppTheme.bodySmall),
                if (unlocked && wins > 0) ...[
                  const SizedBox(height: 6),
                  Text(
                    '${l10n.totalWins}: $wins',
                    style: GoogleFonts.outfit(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.gold,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Ring Progress Painter ─────────────────────────────────────────
class _RingPainter extends CustomPainter {
  final double progress;
  final bool isDark;

  _RingPainter({required this.progress, required this.isDark});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const strokeWidth = 7.0;
    final radius = (size.width - strokeWidth) / 2;

    // Background track
    canvas.drawCircle(
      center,
      radius,
      Paint()
        ..color = isDark ? AppTheme.cardBorder : Colors.grey.shade200
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth,
    );

    // Progress arc
    if (progress > 0) {
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        2 * math.pi * progress,
        false,
        Paint()
          ..color = AppTheme.gold
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_RingPainter old) => old.progress != progress;
}
