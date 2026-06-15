import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' hide Color;
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../services/statistics_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class CoachPage extends StatefulWidget {
  const CoachPage({super.key});

  @override
  State<CoachPage> createState() => _CoachPageState();
}

class _CoachPageState extends State<CoachPage>
    with SingleTickerProviderStateMixin {
  final ChessBoardController _controller = ChessBoardController();
  bool _isPlayerWhite = true;
  String _gameStatus = '';
  String _aiComment = '';
  String _playerComment = '';
  bool _isThinking = false;
  String _lastFen = '';
  String? _lastPlayerMoveSan;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _lastFen = _controller.getFen();
    _controller.addListener(_checkGameOver);
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.removeListener(_checkGameOver);
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _analyzePlayerMove(String fen, String move) async {
    try {
      final l10n = AppLocalizations.of(context);
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/analyze'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fen': fen,
          'move': move,
          'language': l10n.locale.languageCode,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() {
          _playerComment = data['comment'];
        });
      }
    } catch (e) {
      setState(() {
        _playerComment = 'Analysis unavailable';
      });
    }
  }

  Future<void> _makeAIMove() async {
    if (_isThinking) return;
    setState(() {
      _isThinking = true;
      _gameStatus = '';
      _aiComment = '';
    });
    try {
      final fen = _controller.getFen();
      final l10n = AppLocalizations.of(context);
      final response = await http.post(
        Uri.parse('http://127.0.0.1:8000/move'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'fen': fen,
          'language': l10n.locale.languageCode,
        }),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final move = data['move'];
        final aiComment = data['ai_comment'] ?? '';
        if (move != null) {
          if (move.length > 4) {
            _controller.makeMoveWithPromotion(
                from: move.substring(0, 2),
                to: move.substring(2, 4),
                pieceToPromoteTo: move.substring(4, 5));
          } else {
            _controller.makeMove(
                from: move.substring(0, 2), to: move.substring(2, 4));
          }
          _lastFen = _controller.getFen();
          setState(() {
            _aiComment = aiComment;
          });
        } else {
          setState(() {
            _gameStatus = 'Game Over!';
          });
        }
      }
    } catch (e) {
      setState(() {
        _gameStatus = 'Connection error';
      });
    } finally {
      setState(() {
        _isThinking = false;
      });
    }
  }

  void _resetGame() {
    setState(() {
      _controller.resetBoard();
      _lastFen = _controller.getFen();
      _gameStatus = '';
      _aiComment = '';
      _playerComment = '';
      _isThinking = false;
      _lastPlayerMoveSan = null;
    });
  }

  void _checkGameOver() {
    final game = _controller.game;
    if (game.in_checkmate) {
      final fen = _controller.getFen();
      final isWhiteTurn = fen.split(' ')[1] == 'w';
      bool playerWon = isWhiteTurn ? !_isPlayerWhite : _isPlayerWhite;
      if (playerWon) {
        _handleWin();
      } else {
        setState(() {
          _gameStatus = 'AI Won';
        });
      }
    } else if (game.in_draw || game.in_stalemate) {
      setState(() {
        _gameStatus = 'Draw';
      });
    }
  }

  void _handleWin() async {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _gameStatus = l10n.youWon;
    });
    await StatisticsService().recordAIWin();
    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.congratulations),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Icon(Icons.emoji_events_rounded,
                color: AppTheme.gold, size: 72),
            const SizedBox(height: 16),
            Text(l10n.youBeatAI,
                style: AppTheme.bodyLarge, textAlign: TextAlign.center),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(l10n.awesome),
          ),
        ],
      ),
    );
  }

  // Parse classification keyword from comment like "Good (0.25). ..."
  String? _parseClassification(String comment) {
    final keywords = [
      'Excellent', 'Good', 'Inaccuracy', 'Mistake', 'Blunder',
      'Маш сайн', 'Сайн', 'Анхааралгүй', 'Алдаа', 'Ноцтой алдаа',
    ];
    for (final kw in keywords) {
      if (comment.startsWith(kw)) return kw;
    }
    return null;
  }

  ui.Color _classificationColor(String? cls) {
    if (cls == null) return AppTheme.textMuted;
    if (['Excellent', 'Маш сайн'].contains(cls)) return AppTheme.success;
    if (['Good', 'Сайн'].contains(cls)) return AppTheme.info;
    if (['Inaccuracy', 'Анхааралгүй'].contains(cls)) return AppTheme.warning;
    if (['Mistake', 'Алдаа'].contains(cls)) return AppTheme.ember;
    if (['Blunder', 'Ноцтой алдаа'].contains(cls)) return AppTheme.danger;
    return AppTheme.textMuted;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final playerCls = _parseClassification(_playerComment);
    final ui.Color playerColor = _classificationColor(playerCls);

    return Scaffold(
      backgroundColor:
          isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary,
      body: Column(
        children: [
          // ── Top Commentary Panel ─────────────────────────────
          SizedBox(
            height: 240,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: _CommentaryPanel(
                isDark: isDark,
                l10n: l10n,
                isThinking: _isThinking,
                gameStatus: _gameStatus,
                playerComment: _playerComment,
                aiComment: _aiComment,
                playerCls: playerCls,
                playerColor: playerColor,
                pulseAnimation: _pulseAnimation,
              ),
            ),
          ),

          // ── Chess Board ─────────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: isDark
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    )
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.lightCardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ChessBoard(
                    controller: _controller,
                    boardColor: BoardColor.brown,
                    boardOrientation: _isPlayerWhite
                        ? PlayerColor.white
                        : PlayerColor.black,
                    enableUserMoves: !_isThinking,
                    onMove: () {
                        // Current FEN after the move
                        final fen = _controller.getFen();
                        final isWhiteTurn = fen.split(' ')[1] == 'w';

                        // Calculate if the player just moved
                        // If player is White, they just moved if it's now Black's turn
                        // If player is Black, they just moved if it's now White's turn
                        bool playerJustMoved = (_isPlayerWhite && !isWhiteTurn) ||
                            (!_isPlayerWhite && isWhiteTurn);

                        if (playerJustMoved) {
                          try {
                            final moves = _controller.getSan();
                            if (moves.isNotEmpty) {
                              String rawMove = (moves.last as String?) ?? '';
                              // Remove leading move numbers, dots, and spaces (e.g., "1. e4", "1... e5", "...e5")
                              String cleanedMove = rawMove
                                  .replaceAll(RegExp(r'^[\d\.\s]+'), '')
                                  .trim();
                              if (cleanedMove.isNotEmpty) {
                                // Analyze player's move against the PREVIOUS position
                                _analyzePlayerMove(_lastFen, cleanedMove);
                              }
                            }
                          } catch (_) {}
                        }

                        // Always update the last FEN for the next move
                        _lastFen = fen;

                        if (playerJustMoved) {
                          final game = _controller.game;
                          if (game.in_checkmate || game.in_draw || game.in_stalemate) {
                            return; // Wait, game is over, don't trigger AI
                          }
                          setState(() => _gameStatus = '');
                          Future.delayed(
                              const Duration(milliseconds: 100), _makeAIMove);
                        }
                      },
                  ),
                ),
              ),
            ),
          ),

          // ── Controls ─────────────────────────────────────────
          _ControlsPanel(
            isDark: isDark,
            l10n: l10n,
            isPlayerWhite: _isPlayerWhite,
            onColorChanged: (isWhite) {
              setState(() {
                _isPlayerWhite = isWhite;
                _resetGame();
                if (!_isPlayerWhite) {
                  Future.delayed(
                      const Duration(milliseconds: 500), _makeAIMove);
                }
              });
            },
            onReset: _resetGame,
          ),
        ],
      ),
    );
  }
}

// ── Commentary Panel ─────────────────────────────────────────────
class _CommentaryPanel extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final bool isThinking;
  final String gameStatus;
  final String playerComment;
  final String aiComment;
  final String? playerCls;
  final Color playerColor;
  final Animation<double> pulseAnimation;

  const _CommentaryPanel({
    required this.isDark,
    required this.l10n,
    required this.isThinking,
    required this.gameStatus,
    required this.playerComment,
    required this.aiComment,
    required this.playerCls,
    required this.playerColor,
    required this.pulseAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedBackground(
      blur: 24,
      borderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(32),
        bottomRight: Radius.circular(32),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.bgSecondary.withOpacity(0.85) : Colors.white.withOpacity(0.85),
          border: Border(
            bottom: BorderSide(
              color: isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder,
            ),
          ),
          boxShadow: isDark ? [
            BoxShadow(color: Colors.black.withOpacity(0.2), blurRadius: 16, offset: const Offset(0, 4))
          ] : [
            BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12, offset: const Offset(0, 4))
          ],
        ),
        padding: const EdgeInsets.fromLTRB(20, 60, 20, 20),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Coach avatar — chess knight icon
            ScaleTransition(
              scale: isThinking ? pulseAnimation : const AlwaysStoppedAnimation(1.0),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  gradient: AppTheme.goldGradient,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isThinking ? AppTheme.gold : Colors.white.withOpacity(0.2),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(isThinking ? 0.5 : 0.2),
                      blurRadius: isThinking ? 24 : 12,
                      spreadRadius: isThinking ? 4 : 1,
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    '♞',
                    style: TextStyle(fontSize: 32, color: ui.Color(0xFF140F05), height: 1.1),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            // Commentary
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row
                  Row(
                    children: [
                      Text(
                        'AI Coach',
                        style: AppTheme.heading3.copyWith(
                          color: AppTheme.primaryColor(isDark),
                          letterSpacing: -0.2,
                        ),
                      ),
                      const Spacer(),
                      if (isThinking)
                        Row(
                          children: [
                            SizedBox(
                              width: 14,
                              height: 14,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: isDark ? AppTheme.gold : AppTheme.goldDark,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(l10n.aiThinking,
                                style: AppTheme.bodySmall
                                    .copyWith(color: isDark ? AppTheme.gold : AppTheme.goldDark, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      if (gameStatus.isNotEmpty && !isThinking)
                        _StatusBadge(status: gameStatus),
                    ],
                  ),
                  const SizedBox(height: 10),
                  // Empty state
                  if (playerComment.isEmpty && aiComment.isEmpty && !isThinking)
                    Text(
                      l10n.coachIsWatching,
                      style: AppTheme.bodySmall
                          .copyWith(fontStyle: FontStyle.italic, color: AppTheme.mutedColor(isDark)),
                    ),
                  // Player move analysis
                  if (playerComment.isNotEmpty) ...[
                    if (playerCls != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: MoveBadge(label: playerCls!, color: playerColor),
                      ),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: playerColor.withOpacity(isDark ? 0.1 : 0.05),
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        border: Border.all(color: playerColor.withOpacity(0.3)),
                      ),
                      child: Text(
                        _stripClassificationPrefix(playerComment),
                        style: AppTheme.bodySmall.copyWith(
                          color: isDark ? AppTheme.textPrimary : AppTheme.lightTextPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                  // AI move comment
                  if (aiComment.isNotEmpty) ...[
                    if (playerComment.isNotEmpty) const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(isDark ? 0.1 : 0.05),
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16),
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.circular(16),
                        ),
                        border: Border.all(color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.3)),
                      ),
                      child: Text(
                        aiComment,
                        style: AppTheme.bodySmall.copyWith(
                          color: isDark ? AppTheme.gold : AppTheme.goldDark,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _stripClassificationPrefix(String comment) {
    // Remove "Excellent (0.07). " prefix
    return comment.replaceFirst(RegExp(r'^[^.]+\.\s*'), '');
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;
  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    ui.Color color = AppTheme.textMuted;
    if (status.contains('Won') || status.contains('хожлоо')) {
      color = AppTheme.success;
    } else if (status.contains('Draw') || status.contains('Тэнцлээ')) {
      color = AppTheme.info;
    } else if (status.contains('AI')) {
      color = AppTheme.danger;
    }
    return MoveBadge(label: status, color: color);
  }
}

// ── Controls Panel ───────────────────────────────────────────────
class _ControlsPanel extends StatelessWidget {
  final bool isDark;
  final AppLocalizations l10n;
  final bool isPlayerWhite;
  final void Function(bool) onColorChanged;
  final VoidCallback onReset;

  const _ControlsPanel({
    required this.isDark,
    required this.l10n,
    required this.isPlayerWhite,
    required this.onColorChanged,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return FrostedBackground(
      blur: 24,
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(32),
        topRight: Radius.circular(32),
      ),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 120), // Bottom padding for floated nav bar
        decoration: BoxDecoration(
          color: isDark ? AppTheme.bgSecondary.withOpacity(0.85) : Colors.white.withOpacity(0.85),
          border: Border(
            top: BorderSide(
              color: isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Color selection
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    Text(l10n.playAs,
                        style: AppTheme.bodySmall
                            .copyWith(color: AppTheme.mutedColor(isDark))),
                    const SizedBox(width: 12),
                    _ColorToggle(
                      isWhite: true,
                      selected: isPlayerWhite,
                      label: l10n.white,
                      isDark: isDark,
                      onTap: () => onColorChanged(true),
                    ),
                    const SizedBox(width: 8),
                    _ColorToggle(
                      isWhite: false,
                      selected: !isPlayerWhite,
                      label: l10n.black,
                      isDark: isDark,
                      onTap: () => onColorChanged(false),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // New game button
            ElevatedButton.icon(
              onPressed: onReset,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: Text(l10n.newGame),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ColorToggle extends StatelessWidget {
  final bool isWhite;
  final bool selected;
  final String label;
  final bool isDark;
  final VoidCallback onTap;

  const _ColorToggle({
    required this.isWhite,
    required this.selected,
    required this.label,
    required this.isDark,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final goldColor = isDark ? AppTheme.gold : AppTheme.goldDark;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? goldColor.withOpacity(0.15) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected ? goldColor : (isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder),
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isWhite ? Colors.white : const ui.Color(0xFF2D2D2D),
                shape: BoxShape.circle,
                border: Border.all(color: AppTheme.cardBorder, width: 1.5),
                boxShadow: selected ? [
                  BoxShadow(color: goldColor.withOpacity(0.3), blurRadius: 4, spreadRadius: 1)
                ] : [],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.outfit(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: selected ? goldColor : AppTheme.mutedColor(isDark),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
