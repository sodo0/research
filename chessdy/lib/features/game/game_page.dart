import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart' hide Color;
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  final ChessBoardController _controller = ChessBoardController();
  Timer? _whiteTimer;
  Timer? _blackTimer;
  int _whiteTimeSeconds = 600;
  int _blackTimeSeconds = 600;
  bool _isWhiteTurn = true;
  bool _isRunning = false;
  String? _gameStatus;

  @override
  void dispose() {
    _whiteTimer?.cancel();
    _blackTimer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    if (!_isRunning) return;
    if (_isWhiteTurn) {
      _whiteTimer?.cancel();
      _whiteTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!_isWhiteTurn || !_isRunning) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_whiteTimeSeconds > 0) {
            _whiteTimeSeconds--;
          } else {
            timer.cancel();
            _showTimeUpDialog('White');
          }
        });
      });
    } else {
      _blackTimer?.cancel();
      _blackTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_isWhiteTurn || !_isRunning) {
          timer.cancel();
          return;
        }
        setState(() {
          if (_blackTimeSeconds > 0) {
            _blackTimeSeconds--;
          } else {
            timer.cancel();
            _showTimeUpDialog('Black');
          }
        });
      });
    }
  }

  void _showTimeUpDialog(String player) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('$player ${l10n.timeUp}'),
        content: Text(l10n.timeHasRunOut),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text(l10n.newGame),
          ),
        ],
      ),
    );
  }

  void _resetGame() {
    setState(() {
      _whiteTimer?.cancel();
      _blackTimer?.cancel();
      _isRunning = false;
      _isWhiteTurn = true;
      _gameStatus = null;
      _controller.resetBoard();
    });
  }

  void _checkGameStatus() {
    try {
      final game = _controller.game;
      if (game != null) {
        if (game.in_checkmate) {
          setState(() {
            _gameStatus = 'checkmate';
            _isRunning = false;
            _whiteTimer?.cancel();
            _blackTimer?.cancel();
          });
          _showCheckmateDialog(_isWhiteTurn ? 'Black' : 'White');
        } else if (game.in_check) {
          setState(() => _gameStatus = 'check');
        } else if (game.in_stalemate || game.in_draw) {
          setState(() {
            _gameStatus = 'stalemate';
            _isRunning = false;
            _whiteTimer?.cancel();
            _blackTimer?.cancel();
          });
          _showStalemateDialog();
        } else {
          setState(() => _gameStatus = null);
        }
      }
    } catch (_) {}
  }

  void _showCheckmateDialog(String winner) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('$winner ${l10n.wins}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.emoji_events_rounded, color: AppTheme.gold, size: 64),
            const SizedBox(height: 12),
            Text(l10n.checkmateWinner(winner), textAlign: TextAlign.center),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text(l10n.newGame),
          ),
        ],
      ),
    );
  }

  void _showStalemateDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.stalemate),
        content: Text(l10n.stalemateDesc),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _resetGame();
            },
            child: Text(l10n.newGame),
          ),
        ],
      ),
    );
  }

  void _toggleTimer() {
    setState(() {
      _isRunning = !_isRunning;
      if (_isRunning) {
        _startTimer();
      } else {
        _whiteTimer?.cancel();
        _blackTimer?.cancel();
      }
    });
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  void _showTimeSettingsDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) {
        int whiteMinutes = _whiteTimeSeconds ~/ 60;
        int blackMinutes = _blackTimeSeconds ~/ 60;
        return StatefulBuilder(
          builder: (context, setDialogState) => AlertDialog(
            title: Text(l10n.adjustClock),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(l10n.whiteTime, style: AppTheme.bodySmall),
                Slider(
                  value: whiteMinutes.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  label: '$whiteMinutes ${l10n.minutes}',
                  onChanged: (v) =>
                      setDialogState(() => whiteMinutes = v.toInt()),
                ),
                Text('$whiteMinutes ${l10n.minutes}', style: AppTheme.bodySmall),
                const SizedBox(height: 12),
                Text(l10n.blackTime, style: AppTheme.bodySmall),
                Slider(
                  value: blackMinutes.toDouble(),
                  min: 1,
                  max: 60,
                  divisions: 59,
                  label: '$blackMinutes ${l10n.minutes}',
                  onChanged: (v) =>
                      setDialogState(() => blackMinutes = v.toInt()),
                ),
                Text('$blackMinutes ${l10n.minutes}', style: AppTheme.bodySmall),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(l10n.cancel)),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _whiteTimeSeconds = whiteMinutes * 60;
                    _blackTimeSeconds = blackMinutes * 60;
                  });
                  Navigator.of(context).pop();
                },
                child: Text(l10n.apply),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? AppTheme.bgPrimary : AppTheme.lightBgPrimary;

    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        title: Text(l10n.play),
        actions: [
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: _showTimeSettingsDialog,
            tooltip: l10n.adjustClock,
          ),
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: _resetGame,
            tooltip: l10n.newGame,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // ── Clock Row ───────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: _ClockCard(
                    label: l10n.white,
                    time: _formatTime(_whiteTimeSeconds),
                    isActive: _isWhiteTurn && _isRunning,
                    isDark: isDark,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: GestureDetector(
                    onTap: _toggleTimer,
                    child: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _isRunning
                            ? (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.15)
                            : (isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder),
                        border: Border.all(
                          color: _isRunning
                              ? (isDark ? AppTheme.gold : AppTheme.goldDark)
                              : (isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder),
                          width: 2,
                        ),
                        boxShadow: _isRunning ? [
                          BoxShadow(
                            color: (isDark ? AppTheme.gold : AppTheme.goldDark).withOpacity(0.3),
                            blurRadius: 16,
                            spreadRadius: 1,
                          )
                        ] : [],
                      ),
                      child: Icon(
                        _isRunning ? Icons.pause_rounded : Icons.play_arrow_rounded,
                        color: _isRunning ? (isDark ? AppTheme.gold : AppTheme.goldDark) : AppTheme.mutedColor(isDark),
                        size: 24,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: _ClockCard(
                    label: l10n.black,
                    time: _formatTime(_blackTimeSeconds),
                    isActive: !_isWhiteTurn && _isRunning,
                    isDark: isDark,
                    alignRight: true,
                  ),
                ),
              ],
            ),
          ),

          // ── Chess Board ─────────────────────────────────────
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: isDark
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppTheme.cardBorder),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.4),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        )
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
                        )
                      ],
                    ),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ChessBoard(
                    controller: _controller,
                    boardColor: BoardColor.brown,
                    boardOrientation: PlayerColor.white,
                    enableUserMoves: true,
                    onMove: () {
                      setState(() {
                        _isWhiteTurn = !_isWhiteTurn;
                        if (_isRunning) _startTimer();
                      });
                      Future.delayed(
                          const Duration(milliseconds: 100), _checkGameStatus);
                    },
                  ),
                ),
              ),
            ),
          ),

          // ── Status Banner ────────────────────────────────────
          if (_gameStatus != null)
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: _gameStatus == 'checkmate'
                    ? AppTheme.danger.withOpacity(0.15)
                    : _gameStatus == 'check'
                        ? AppTheme.warning.withOpacity(0.15)
                        : AppTheme.info.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: _gameStatus == 'checkmate'
                      ? AppTheme.danger.withOpacity(0.5)
                      : _gameStatus == 'check'
                          ? AppTheme.warning.withOpacity(0.5)
                          : AppTheme.info.withOpacity(0.5),
                  width: 1.5,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _gameStatus == 'checkmate'
                        ? Icons.flag_rounded
                        : _gameStatus == 'check'
                            ? Icons.warning_amber_rounded
                            : Icons.handshake_rounded,
                    color: _gameStatus == 'checkmate'
                        ? AppTheme.danger
                        : _gameStatus == 'check'
                            ? AppTheme.warning
                            : AppTheme.info,
                    size: 20,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    _gameStatus == 'checkmate'
                        ? l10n.checkmate
                        : _gameStatus == 'check'
                            ? l10n.check
                            : l10n.stalemate,
                    style: GoogleFonts.outfit(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: _gameStatus == 'checkmate'
                          ? AppTheme.danger
                          : _gameStatus == 'check'
                              ? AppTheme.warning
                              : AppTheme.info,
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 120),
        ],
      ),
    );
  }
}

class _ClockCard extends StatelessWidget {
  final String label;
  final String time;
  final bool isActive;
  final bool isDark;
  final bool alignRight;

  const _ClockCard({
    required this.label,
    required this.time,
    required this.isActive,
    required this.isDark,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    final activeColor = isDark ? AppTheme.gold : AppTheme.goldDark;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
      decoration: BoxDecoration(
        color: isActive
            ? activeColor.withOpacity(0.12)
            : AppTheme.cardColor(isDark),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isActive ? activeColor : (isDark ? AppTheme.cardBorder : AppTheme.lightCardBorder),
          width: isActive ? 2 : 1,
        ),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: activeColor.withOpacity(0.2),
                  blurRadius: 16,
                  spreadRadius: 2,
                )
              ]
            : (isDark ? [] : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]),
      ),
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: AppTheme.bodySmall.copyWith(
              color: isActive ? activeColor : AppTheme.mutedColor(isDark),
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            time,
            style: AppTheme.monoLarge.copyWith(
              color: isActive ? activeColor : AppTheme.primaryColor(isDark),
            ),
          ),
        ],
      ),
    );
  }
}
