import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'interactive_lesson_page.dart';
import 'static_lesson_page.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import '../../services/statistics_service.dart';
import 'models/puzzle_data.dart';

class LessonsPage extends StatefulWidget {
  const LessonsPage({super.key});

  @override
  State<LessonsPage> createState() => _LessonsPageState();
}

class _LessonsPageState extends State<LessonsPage> {
  List<String> _completedLessons = [];

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final completed = await StatisticsService().getCompletedLessons();
    if (mounted) {
      setState(() {
        _completedLessons = completed;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary;

    return Scaffold(
      backgroundColor: bg,
      body: CustomScrollView(
        slivers: [
          // ── Header ─────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.fromLTRB(28, 64, 24, 32),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.bgSecondary : Colors.white,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(32),
                  bottomRight: Radius.circular(32),
                ),
                boxShadow: isDark ? [
                  BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))
                ] : [
                  BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(l10n.lessons, style: AppTheme.displayLarge),
                  const SizedBox(height: 8),
                  Text(
                    l10n.learnTrainPlay,
                    style: AppTheme.bodyLarge.copyWith(color: AppTheme.mutedColor(isDark)),
                  ),
                ],
              ),
            ),
          ),

          // ── Section Label ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 24, 20, 12),
            sliver: SliverToBoxAdapter(
              child: SectionLabel(l10n.basicRules),
            ),
          ),

          // ── Lesson Cards ────────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _LessonCard(
                  title: l10n.aboutThePieces,
                  lessonId: 'About the Pieces',
                  description: l10n.aboutThePiecesDescription,
                  icon: Icons.grid_view_rounded,
                  iconColor: AppTheme.gold,
                  gradientColors: [
                    const Color(0xFF2D2410),
                    const Color(0xFF1A1508)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('About the Pieces'),
                ),
                _LessonCard(
                  title: l10n.howToCapture,
                  lessonId: 'How to Capture',
                  description: l10n.howToCaptureDescription,
                  icon: Icons.gps_fixed_rounded,
                  iconColor: AppTheme.danger,
                  gradientColors: [
                    const Color(0xFF2D1010),
                    const Color(0xFF1A0A0A)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('How to Capture'),
                ),
                _LessonCard(
                  title: l10n.worthOfPieces,
                  lessonId: 'Worth of the Pieces',
                  description: l10n.worthOfPiecesDescription,
                  icon: Icons.leaderboard_rounded,
                  iconColor: AppTheme.success,
                  gradientColors: [
                    const Color(0xFF0D2D1A),
                    const Color(0xFF081A0E)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('Worth of the Pieces'),
                ),
              ]),
            ),
          ),

          // ── Special Moves ───────────────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverToBoxAdapter(
              child: SectionLabel(l10n.specialMoves),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                _LessonCard(
                  title: l10n.howToCastle,
                  lessonId: 'How to Castle',
                  description: l10n.howToCastleDescription,
                  icon: Icons.shield_rounded,
                  iconColor: AppTheme.info,
                  gradientColors: [
                    const Color(0xFF0D1A2D),
                    const Color(0xFF080E1A)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('How to Castle'),
                ),
                _LessonCard(
                  title: l10n.aboutCheckAndCheckmate,
                  lessonId: 'About Check and Checkmate',
                  description: l10n.aboutCheckAndCheckmateDescription,
                  icon: Icons.warning_amber_rounded,
                  iconColor: AppTheme.warning,
                  gradientColors: [
                    const Color(0xFF2D220A),
                    const Color(0xFF1A1408)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('About Check and Checkmate'),
                ),
                _LessonCard(
                  title: l10n.aboutEnPassant,
                  lessonId: 'About En Passant',
                  description: l10n.aboutEnPassantDescription,
                  icon: Icons.arrow_forward_rounded,
                  iconColor: AppTheme.ember,
                  gradientColors: [
                    const Color(0xFF2D1A0D),
                    const Color(0xFF1A0F08)
                  ],
                  isDark: isDark,
                  isCompleted: _completedLessons.contains('About En Passant'),
                ),
              ]),
            ),
          ),
          
          // ── Mating Patterns ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverToBoxAdapter(
              child: SectionLabel(l10n.matingPatterns),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final puzzle = LessonData.puzzles[index];
                  return _PuzzleCard(
                    title: _getPuzzleTitle(l10n, puzzle.id),
                    lessonId: puzzle.id,
                    isDark: isDark,
                    isCompleted: _completedLessons.contains(puzzle.id),
                  );
                },
                childCount: 7, // Mate 1 (4 puzzles) + Mate 2 (3 puzzles)
              ),
            ),
          ),

          // ── Tactics & Puzzles ─────────────────────────────
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
            sliver: SliverToBoxAdapter(
              child: SectionLabel(l10n.advancedTactics),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                childAspectRatio: 1.1,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final puzzle = LessonData.puzzles[7 + index]; // 3 tactical puzzles
                  return _PuzzleCard(
                    title: _getPuzzleTitle(l10n, puzzle.id),
                    lessonId: puzzle.id,
                    isDark: isDark,
                    isCompleted: _completedLessons.contains(puzzle.id),
                  );
                },
                childCount: 3,
              ),
            ),
          ),
          
          const SliverPadding(padding: EdgeInsets.only(bottom: 120)), // Padding to avoid floating nav bar
        ],
      ),
    );
  }

  String _getPuzzleTitle(AppLocalizations l10n, String id) {
    if (id == 'p1_mate_1_back_rank') return l10n.p1_mate_1_back_rank;
    if (id == 'p2_mate_1_smothered') return l10n.p2_mate_1_smothered;
    if (id == 'p3_mate_1_scholar') return l10n.p3_mate_1_scholar;
    if (id == 'p4_mate_1_queen') return l10n.p4_mate_1_queen;
    if (id == 'p5_mate_2_ladder') return l10n.p5_mate_2_ladder;
    if (id == 'p6_mate_2_anastasia') return l10n.p6_mate_2_anastasia;
    if (id == 'p7_mate_2_back_rank_sac') return l10n.p7_mate_2_back_rank_sac;
    if (id == 'p8_tactic_knight_fork') return l10n.p8_tactic_knight_fork;
    if (id == 'p9_tactic_discovered_attack') return l10n.p9_tactic_discovered_attack;
    if (id == 'p10_tactic_skewer') return l10n.p10_tactic_skewer;
    return id;
  }
}

class _LessonCard extends StatelessWidget {
  final String title;
  final String lessonId;
  final String description;
  final IconData icon;
  final Color iconColor;
  final List<Color> gradientColors;
  final bool isDark;
  final bool isCompleted;

  const _LessonCard({
    required this.title,
    required this.lessonId,
    required this.description,
    required this.icon,
    required this.iconColor,
    required this.gradientColors,
    required this.isDark,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: TappableCard(
        onTap: () {
          if (lessonId == 'Worth of the Pieces') {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => StaticLessonPage(
                  lessonId: lessonId,
                  lessonTitle: title,
                ),
              ),
            );
          } else {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) => InteractiveLessonPage(
                  lessonId: lessonId,
                  lessonTitle: title,
                ),
              ),
            );
          }
        },
        padding: EdgeInsets.zero,
        decoration: isDark
            ? BoxDecoration(
                gradient: LinearGradient(
                  colors: gradientColors,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: iconColor.withOpacity(0.3), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 8),
                  ),
                ],
              )
            : BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppTheme.lightCardBorder),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(isDark ? 0.15 : 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                      color: iconColor.withOpacity(0.4), width: 1.5),
                ),
                child: Icon(icon, color: iconColor, size: 28),
              ),
              const SizedBox(width: 16),
              // Text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTheme.heading3.copyWith(color: AppTheme.primaryColor(isDark)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      description,
                      style: AppTheme.bodySmall.copyWith(color: AppTheme.mutedColor(isDark)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isCompleted)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: AppTheme.success.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    size: 16,
                    color: AppTheme.success,
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: (isDark ? AppTheme.bgSecondary : AppTheme.lightBgPrimary),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    size: 14,
                    color: AppTheme.mutedColor(isDark),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PuzzleCard extends StatelessWidget {
  final String title;
  final String lessonId;
  final bool isDark;
  final bool isCompleted;

  const _PuzzleCard({
    required this.title,
    required this.lessonId,
    required this.isDark,
    this.isCompleted = false,
  });

  @override
  Widget build(BuildContext context) {
    return TappableCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => InteractiveLessonPage(
              lessonId: lessonId,
              lessonTitle: title,
            ),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              isDark ? const Color(0xFF2B2B36) : Colors.white,
              isDark ? const Color(0xFF1A1A24) : Colors.grey.shade50,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isCompleted ? AppTheme.success.withOpacity(0.3) : AppTheme.cardBorder.withOpacity(isDark ? 0.3 : 0.8),
            width: 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppTheme.gold.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.extension_rounded, color: AppTheme.gold, size: 20),
                ),
                if (isCompleted)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: AppTheme.success.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check_rounded, size: 14, color: AppTheme.success),
                  ),
              ],
            ),
            Text(
              title,
              style: AppTheme.heading3.copyWith(fontSize: 14, height: 1.2),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
