import 'dart:ui' as ui;
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import 'package:chess/chess.dart' as chess_lib;
import '../../services/statistics_service.dart';
import '../../l10n/app_localizations.dart';
import '../../theme/app_theme.dart';
import 'models/puzzle_data.dart';

class InteractiveLessonPage extends StatefulWidget {
  final String lessonId;
  final String lessonTitle;

  const InteractiveLessonPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  State<InteractiveLessonPage> createState() => _InteractiveLessonPageState();
}

class _InteractiveLessonPageState extends State<InteractiveLessonPage> {
  int _currentStep = 0;
  late ChessBoardController _controller;
  bool _isStepCompleted = false;
  String? _coachMessage;
  bool _showMastery = false;
  bool _showVisualGuides = false;
  InteractiveLesson? _lessonData;

  @override
  void initState() {
    super.initState();
    _controller = ChessBoardController();
    
    // Find the current lesson from data
    try {
      _lessonData = LessonData.fundamentals.firstWhere((l) => l.id == widget.lessonId);
    } catch (_) {
      try {
        _lessonData = LessonData.puzzles.firstWhere((l) => l.id == widget.lessonId);
      } catch (_) {
        _lessonData = null;
      }
    }

    _setupBoard();
  }

  void _setupBoard() {
    setState(() {
      _isStepCompleted = false;
      _coachMessage = null;
      _showVisualGuides = false;
    });
    
    if (_lessonData == null) return;
    final stepData = _lessonData!.steps[_currentStep.clamp(0, _lessonData!.steps.length - 1)];
    
    if (stepData.startFen != null) {
      _controller.loadFen(stepData.startFen!);
    }

    
    // Special setup for En Passant: Animate the black move
    if (widget.lessonId == 'About En Passant') {
      // Start with pawn on d7
      _controller.loadFen('4k3/3p4/8/4P3/8/8/8/4K3 b - - 0 1');
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          _controller.makeMove(from: 'd7', to: 'd5');
        }
      });
    }
  }

  String _getLessonFen() {
    switch (widget.lessonId) {
      case 'About the Pieces':
        final pieceFens = [
          'k7/8/8/8/4P3/8/8/7K w - - 0 1', // Pawn
          'k7/8/8/8/4R3/8/8/7K w - - 0 1', // Rook
          'k7/8/8/8/4N3/8/8/7K w - - 0 1', // Knight
          'k7/8/8/8/4B3/8/8/7K w - - 0 1', // Bishop
          'k7/8/8/8/4Q3/8/8/7K w - - 0 1', // Queen
          'k7/8/8/8/4K3/8/8/8 w - - 0 1', // King
        ];
        return pieceFens[_currentStep.clamp(0, pieceFens.length - 1)];
        
      case 'How to Capture':
        final captureFens = [
          'k7/8/8/3r4/8/8/3R4/7K w - - 0 1', // Rook capture
          'k7/8/2b5/8/4B3/8/8/7K w - - 0 1', // Bishop capture
          'k7/8/8/5n2/3N4/8/8/7K w - - 0 1', // Knight capture
          'k7/8/8/3p4/4P3/8/8/7K w - - 0 1', // Pawn capture
          'k7/8/4q3/8/4Q3/8/8/7K w - - 0 1', // Queen capture
          'k7/8/8/4p3/4K3/8/8/8 w - - 0 1', // King capture
        ];
        return captureFens[_currentStep.clamp(0, captureFens.length - 1)];
        
      case 'Worth of the Pieces':
        final worthFens = [
          'k7/8/8/3p4/3P4/8/8/7K w - - 0 1', // Pawn vs Pawn
          'k7/8/8/8/3n4/4B3/8/7K w - - 0 1', // Bishop vs Knight
          'k7/8/8/3r4/3R4/8/8/7K w - - 0 1', // Rook vs Rook
          'k7/8/8/3q4/3Q4/8/8/7K w - - 0 1', // Queen vs Queen
        ];
        return worthFens[_currentStep.clamp(0, worthFens.length - 1)];

      case 'How to Castle':
        final castleFens = [
          '4k3/8/8/8/8/8/8/R3K2R w K - 0 1', // Kingside
          '4k3/8/8/8/8/8/8/R3K2R w Q - 0 1', // Queenside
          '4k3/8/8/8/8/4r3/8/R3K2R w K - 0 1', // Blocked by check
        ];
        return castleFens[_currentStep.clamp(0, castleFens.length - 1)];

      case 'About Check and Checkmate':
        final checkFens = [
          '4r3/8/8/8/8/8/8/4K3 w - - 0 1', // In check (Rook e8), escape
          '6r1/8/8/8/8/R7/8/6K1 w - - 0 1', // Block check (Rook g8, Block with Ra3-g3?) Wait, Ra3 is on a3. King on g1. Rook on g8. Check along g-file. Block at g3? No, block at g2? 
          // Let's try: King e1. Rook e8. White Rook a1. Move Re2? No.
          // Let's stick to the plan:
          // 1. Escape: King e1, Rook e8. Move King.
          // 2. Block: King g1, Rook g8. White Rook a3? No, White Rook g3? No, White Rook h3?
          // Let's use a diagonal check for blocking, it's often clearer.
          // Bishop check?
          // King e1. Bishop a5. Check on diagonal. Block with Pawn c3?
          // FEN: 4k3/8/8/B7/8/2P5/8/4K3 w - - 0 1. (Wait, that's White Bishop).
          // Black Bishop a5. King e1. Pawn c2. Move c3?
          // FEN: 4k3/8/8/b7/8/8/2P5/4K3 w - - 0 1.
          // 3. Capture: King e1. Rook e2 (checking). King takes? Or Queen takes?
          // Let's use Queen takes.
          // FEN: 4k3/8/8/8/8/8/4r3/3QK3 w - - 0 1. Queen d1 takes e2.
          
          '4r3/8/8/8/8/8/8/4K3 w - - 0 1', // Step 1: Escape (Rook e8 checks King e1)
          '4k3/8/8/b7/8/8/2P5/4K3 w - - 0 1', // Step 2: Block (Bishop a5 checks King e1. Move c2-c3)
          '4k3/8/8/8/8/8/4r3/3QK3 w - - 0 1', // Step 3: Capture (Rook e2 checks King e1. Queen d1 captures)
          '4k3/8/8/8/8/8/r7/r3K3 w - - 0 1', // Checkmate (Two Rooks mate)
        ];
        return checkFens[_currentStep.clamp(0, checkFens.length - 1)];

      case 'About En Passant':
        // En Passant target d6. White Pawn e5. Black Pawn d5.
        // FEN: 4k3/8/8/3pP3/8/8/8/4K3 w - d6 0 1
        // Note: The setupBoard will override this with the pre-move state
        return '4k3/8/8/3pP3/8/8/8/4K3 w - d6 0 1';

      default:
        return 'rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1';
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    if (_showMastery) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.lessonTitle)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.stars_rounded, size: 80, color: AppTheme.gold),
                const SizedBox(height: 24),
                Text(l10n.letsReview, style: AppTheme.heading2),
                const SizedBox(height: 16),
                Text(
                  _lookupString(l10n, _lessonData?.masterySummary) ?? l10n.lessonCompleted,
                  textAlign: TextAlign.center,
                  style: AppTheme.bodyLarge,
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  onPressed: _completeLesson,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                  ),
                  child: Text(l10n.finishLesson),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.lessonTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.lightbulb_outline),
            tooltip: l10n.hintButton,
            onPressed: () {
              setState(() {
                if (_lessonData != null) {
                  final step = _lessonData!.steps[_currentStep.clamp(0, _lessonData!.steps.length - 1)];
                  _coachMessage = _lookupString(l10n, step.hint) ?? l10n.makeAMove;
                  _showVisualGuides = true;
                }
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Coach Chat Bubble
          Container(
            padding: const EdgeInsets.all(16),
            color: isDark ? AppTheme.bgSecondary : Colors.teal.shade50,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  backgroundColor: Colors.teal.withOpacity(0.2),
                  radius: 24,
                  child: const Text('🎓', style: TextStyle(fontSize: 24)),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(l10n.coachSays, style: AppTheme.bodySmall.copyWith(fontWeight: FontWeight.bold, color: isDark ? Colors.tealAccent : Colors.teal.shade700)),
                      const SizedBox(height: 4),
                      Text(
                        _coachMessage ?? _getInstructionText(l10n),
                        style: AppTheme.bodyLarge.copyWith(height: 1.4),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Content area
          Expanded(
            child: _buildLessonContent(),
          ),
          
          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (_isStepCompleted && _getTotalSteps() > 0 && _currentStep < _getTotalSteps() - 1)
                  ElevatedButton(
                    onPressed: _nextStep,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(l10n.nextStep),
                  ),
                if (_isStepCompleted && _currentStep == _getTotalSteps() - 1)
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        if (_lessonData?.masterySummary != null) {
                          _showMastery = true;
                        } else {
                          _completeLesson();
                        }
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.success,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    ),
                    child: Text(l10n.finishLesson),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }



  int _getTotalSteps() {
    return _lessonData?.steps.length ?? 0;
  }

  Widget _buildLessonContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Chess board with visual guides
          AspectRatio(
            aspectRatio: 1,
            child: Stack(
              children: [
                ChessBoard(
                  controller: _controller,
                  boardColor: BoardColor.brown,
                  boardOrientation: PlayerColor.white,
                  enableUserMoves: !_isStepCompleted,
                  onMove: _validateMove,
                ),
                // Visual guide overlay (lines showing moves)
                // Only show guides if hint button was pressed
                if (_showVisualGuides)
                  Positioned.fill(
                    child: IgnorePointer(
                      child: CustomPaint(
                        painter: MoveGuidePainter(_getMoveGuides()),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Removed simple instruction text in favor of Coach Message
        ],
      ),
    );
  }

  String _getInstructionText(AppLocalizations l10n) {
    if (_lessonData == null) return l10n.makeAMove;
    if (_isStepCompleted && _currentStep >= _getTotalSteps() - 1) return l10n.lessonComplete;
    
    final stepData = _lessonData!.steps[_currentStep.clamp(0, _lessonData!.steps.length - 1)];
    return _getInstructionStringByKey(l10n, stepData.instructionKey);
  }
  
  String _getInstructionStringByKey(AppLocalizations l10n, String key) {
    if (key == 'movePawn') return "${l10n.moveThe}${l10n.pawnTitle}";
    if (key == 'moveRook') return "${l10n.moveThe}${l10n.rookTitle}";
    if (key == 'moveKnight') return "${l10n.moveThe}${l10n.knightTitle}";
    if (key == 'moveBishop') return "${l10n.moveThe}${l10n.bishopTitle}";
    if (key == 'moveQueen') return "${l10n.moveThe}${l10n.queenTitle}";
    if (key == 'moveKing') return "${l10n.moveThe}${l10n.kingTitle}";
    
    if (key == 'captureRook') return "${l10n.captureThe}${l10n.rookTitle}${l10n.withYour}${l10n.rookTitle}";
    if (key == 'captureBishop') return "${l10n.captureThe}${l10n.bishopTitle}${l10n.withYour}${l10n.bishopTitle}";
    if (key == 'captureKnight') return "${l10n.captureThe}${l10n.knightTitle}${l10n.withYour}${l10n.knightTitle}";
    if (key == 'capturePawn') return "${l10n.captureThe}${l10n.pawnTitle}${l10n.withYour}${l10n.pawnTitle}";
    if (key == 'captureQueen') return "${l10n.captureThe}${l10n.queenTitle}${l10n.withYour}${l10n.queenTitle}";
    if (key == 'captureKing') return "${l10n.captureThe}${l10n.pawnTitle}${l10n.withYour}${l10n.kingTitle}";
    
    if (key == 'castleKingside') return l10n.castleKingside;
    if (key == 'castleQueenside') return l10n.castleQueenside;
    if (key == 'captureEnPassant') return l10n.captureEnPassant;
    
    if (key == 'escapeCheckMove') return l10n.escapeCheckMove;
    if (key == 'blockCheck') return l10n.blockCheck;
    if (key == 'captureAttacker') return l10n.captureAttacker;
    
    if (key == 'solvePuzzle') return l10n.solvePuzzle;
    if (key == 'findMate2') return l10n.findMate2;
    if (key == 'solvePuzzle1') return l10n.solvePuzzle1;
    if (key == 'capturePiece') return l10n.capturePiece;

    return l10n.makeAMove;
  }

  String _getLessonDescription(AppLocalizations l10n) {
    if (_lessonData?.isPuzzle == true) {
      return l10n.puzzleDescription;
    }
    switch (widget.lessonId) {
      case 'About the Pieces':
        return l10n.learnPiecesDesc;
      case 'How to Capture':
        return l10n.captureDesc;
      case 'How to Castle':
        return l10n.castleDesc;
      case 'About En Passant':
        return l10n.enPassantDesc;
      default:
        return "";
    }
  }

  String _getStepExplanation(AppLocalizations l10n) {
    if (_lessonData?.isPuzzle == true) return "";
    switch (widget.lessonId) {
      case 'About the Pieces':
        final explanations = [
          l10n.pawnMoveExp,
          l10n.rookMoveExp,
          l10n.knightMoveExp,
          l10n.bishopMoveExp,
          l10n.queenMoveExp,
          l10n.kingMoveExp,
        ];
        return _currentStep < explanations.length ? explanations[_currentStep] : "";

      case 'How to Capture':
        return l10n.captureExp;

      case 'How to Castle':
        if (_currentStep == 0) return l10n.kingsideCastleExp;
        if (_currentStep == 1) return l10n.queensideCastleExp;
        return l10n.castleCheckExp;

      case 'About En Passant':
        return l10n.enPassantExp;

      case 'About Check and Checkmate':
        if (_currentStep == 0) return l10n.checkExp;
        if (_currentStep == 1) return l10n.blockExp;
        if (_currentStep == 2) return l10n.captureCheckExp;
        return l10n.checkmateExp;

      default:
        return "";
    }
  }

  void _validateMove() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (!mounted) return;
      if (_lessonData == null) return;
      
      final l10n = AppLocalizations.of(context);
      bool isCorrect = false;
      String? errorMsg;
      
      final stepData = _lessonData!.steps[_currentStep.clamp(0, _lessonData!.steps.length - 1)];
      final expectedSan = stepData.expectedMoveSan;
      
      // Get the last move played
      final history = _controller.getSan();
      String? lastMoveSan;
      if (history.isNotEmpty) {
        lastMoveSan = (history.last as String).replaceAll(RegExp(r'^[0-9]+\.\s*'), '').trim();
      }

      // 1) Allow any move if expectedMoveSan is null
      if (expectedSan == null) {
        isCorrect = true;
      } 
      // 2) Exact strict matching
      else if (lastMoveSan == expectedSan) {
        isCorrect = true;
      } else {
        // Coach failure feedback logic
        if (stepData.wrongMoveExplanations != null && lastMoveSan != null && stepData.wrongMoveExplanations!.containsKey(lastMoveSan)) {
           errorMsg = _lookupString(l10n, stepData.wrongMoveExplanations![lastMoveSan]);
        } else {
           errorMsg = "${l10n.coachAlmostRight}${_lookupString(l10n, stepData.hint) ?? l10n.coachTryAgain}";
        }
      }

      setState(() {
        if (isCorrect) {
          _coachMessage = _lookupString(l10n, stepData.successMessage) ?? l10n.correct;
          
          if (stepData.opponentReplySan != null) {
             // Automate opponent's reply
             _isStepCompleted = true; // Lock the board briefly
             Future.delayed(const Duration(milliseconds: 600), () {
                 if (!mounted) return;
                 _controller.makeMoveWithNormalNotation(stepData.opponentReplySan!);
                 
                 // If the lesson expects another move after this, increment step and unlock
                 if (_currentStep < _getTotalSteps() - 1) {
                     setState(() {
                         _currentStep++;
                         _isStepCompleted = false;
                         _coachMessage = l10n.opponentReplied;
                     });
                 }
             });
          } else {
             // Routine generic completion of this manual step
             _isStepCompleted = true;
          }
        } else {
          _coachMessage = errorMsg;
          Future.delayed(const Duration(milliseconds: 500), () {
            _controller.undoMove();
          });
        }
      });
    });
  }

  String? _lookupString(AppLocalizations l10n, String? key) {
    if (key == null) return null;
    switch (key) {
      case 'coachPiecesMastery': return l10n.coachPiecesMastery;
      case 'coachPawnHint': return l10n.coachPawnHint;
      case 'coachPawnSuccess': return l10n.coachPawnSuccess;
      case 'coachRookHint': return l10n.coachRookHint;
      case 'coachRookWrongA4': return l10n.coachRookWrongA4;
      case 'coachRookSuccess': return l10n.coachRookSuccess;
      case 'coachKnightHint': return l10n.coachKnightHint;
      case 'coachKnightSuccess': return l10n.coachKnightSuccess;
      case 'coachBishopHint': return l10n.coachBishopHint;
      case 'coachBishopSuccess': return l10n.coachBishopSuccess;
      case 'coachQueenHint': return l10n.coachQueenHint;
      case 'coachQueenSuccess': return l10n.coachQueenSuccess;
      case 'coachKingHint': return l10n.coachKingHint;
      case 'coachKingSuccess': return l10n.coachKingSuccess;
      case 'coachCaptureMastery': return l10n.coachCaptureMastery;
      case 'coachCaptureHintText': return l10n.coachCaptureHintText;
      case 'coachGreatCapture': return l10n.coachGreatCapture;
      case 'coachWrongCaptureQueen': return l10n.coachWrongCaptureQueen;
      default: return key; 
    }
  }



  List<MoveGuide> _getMoveGuides() {
    final activeSquare = _getActiveSquare();
    if (activeSquare == null) return [];

    final game = _controller.game;
    // Get all legal moves for the active square
    // Note: The chess package moves() method returns a list of Move objects if verbose is true
    // We need to cast or access properties dynamically if the type isn't inferred correctly
    final moves = game.moves({'square': activeSquare, 'verbose': true});
    
    final guides = <MoveGuide>[];
    
    for (final move in moves) {
      // move is likely a Map or a Move object depending on the library version
      // Assuming it has 'to' property which is the algebraic destination (e.g., 'e5')
      // If it returns objects with 'to' as int, we might need conversion, 
      // but usually verbose: true in dart chess returns objects with algebraic 'to' or we can get it.
      // Let's check how to access it. 
      // In the 'chess' package for Dart:
      // move.toAlgebraic is the destination string
      
      String toSquare;
      if (move is chess_lib.Move) {
        toSquare = move.toAlgebraic;
      } else if (move is Map) {
         toSquare = move['to'];
      } else {
         // Fallback or try to inspect
         continue;
      }

      guides.add(MoveGuide(
        from: activeSquare, 
        to: toSquare, 
        color: Colors.blue.withOpacity(0.5)
      ));
    }
    
    return guides;
  }

  String? _getActiveSquare() {
    if (_lessonData == null) return null;
    final stepData = _lessonData!.steps[_currentStep.clamp(0, _lessonData!.steps.length - 1)];
    return stepData.activeSquare;
  }

  void _nextStep() {
    setState(() {
      _currentStep++;
      _showVisualGuides = false;
    });
    _setupBoard();
  }



  void _completeLesson() async {
    final l10n = AppLocalizations.of(context);
    await StatisticsService().markLessonCompleted(widget.lessonId);
    
    if (!mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.lessonCompleted)),
    );
    Navigator.of(context).pop();
  }
}

class MoveGuide {
  final String from;
  final String to;
  final ui.Color color;

  MoveGuide({required this.from, required this.to, required this.color});
}

class MoveGuidePainter extends CustomPainter {
  final List<MoveGuide> guides;

  MoveGuidePainter(this.guides);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.blue.shade600
      ..strokeWidth = 4
      ..style = PaintingStyle.stroke;

    for (final guide in guides) {
      paint.color = guide.color.withOpacity(0.7);
      final fromPos = _squareToPosition(guide.from, size);
      final toPos = _squareToPosition(guide.to, size);
      
      // Draw line
      canvas.drawLine(fromPos, toPos, paint);
      
      // Draw arrow head
      _drawArrow(canvas, fromPos, toPos, paint);
    }
  }

  Offset _squareToPosition(String square, Size size) {
    final file = square[0].codeUnitAt(0) - 'a'.codeUnitAt(0);
    final rank = 8 - int.parse(square[1]);
    final squareSize = size.width / 8;
    return Offset(
      file * squareSize + squareSize / 2,
      rank * squareSize + squareSize / 2,
    );
  }

  void _drawArrow(Canvas canvas, Offset from, Offset to, Paint paint) {
    final direction = to - from;
    final angle = math.atan2(direction.dy, direction.dx);
    final arrowLength = 15.0;
    final arrowAngle = 0.5;
    
    final path = Path()
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowLength * math.cos(angle - arrowAngle),
        to.dy - arrowLength * math.sin(angle - arrowAngle),
      )
      ..moveTo(to.dx, to.dy)
      ..lineTo(
        to.dx - arrowLength * math.cos(angle + arrowAngle),
        to.dy - arrowLength * math.sin(angle + arrowAngle),
      );
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant MoveGuidePainter oldDelegate) {
    return true; // Always repaint when the painter is rebuilt with new guides
  }
}
