class InteractiveStep {
  final String? startFen;
  final String? expectedMoveSan;
  final String? opponentReplySan;
  final String instructionKey;
  final String activeSquare;
  final String? hint;
  final Map<String, String>? wrongMoveExplanations;
  final String? successMessage;

  const InteractiveStep({
    this.startFen,
    this.expectedMoveSan,
    this.opponentReplySan,
    required this.instructionKey,
    required this.activeSquare,
    this.hint,
    this.wrongMoveExplanations,
    this.successMessage,
  });
}

class InteractiveLesson {
  final String id;
  final bool isPuzzle;
  final List<InteractiveStep> steps;
  final String? masterySummary;

  const InteractiveLesson({
    required this.id,
    required this.steps,
    this.isPuzzle = false,
    this.masterySummary,
  });
}

class LessonData {
  static final List<InteractiveLesson> fundamentals = [
    InteractiveLesson(
      id: 'About the Pieces',
      masterySummary: 'coachPiecesMastery',
      steps: [
        InteractiveStep(
          startFen: 'k7/8/8/8/4P3/8/8/7K w - - 0 1',
          expectedMoveSan: 'e5',
          instructionKey: 'movePawn',
          activeSquare: 'e4',
          hint: 'coachPawnHint',
          successMessage: 'coachPawnSuccess',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/8/4R3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Re5', 
          instructionKey: 'moveRook',
          activeSquare: 'e4',
          hint: 'coachRookHint',
          wrongMoveExplanations: { 'Ra4': 'coachRookWrongA4' },
          successMessage: 'coachRookSuccess',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/8/4N3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Nc5',
          instructionKey: 'moveKnight',
          activeSquare: 'e4',
          hint: 'coachKnightHint',
          successMessage: 'coachKnightSuccess',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/8/4B3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Bd5',
          instructionKey: 'moveBishop',
          activeSquare: 'e4',
          hint: 'coachBishopHint',
          successMessage: 'coachBishopSuccess',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/8/4Q3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Qe5',
          instructionKey: 'moveQueen',
          activeSquare: 'e4',
          hint: 'coachQueenHint',
          successMessage: 'coachQueenSuccess',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/8/4K3/8/8/8 w - - 0 1',
          expectedMoveSan: 'Kd5',
          instructionKey: 'moveKing',
          activeSquare: 'e4',
          hint: 'coachKingHint',
          successMessage: 'coachKingSuccess',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'How to Capture',
      masterySummary: 'coachCaptureMastery',
      steps: [
        InteractiveStep(
          startFen: 'k7/8/8/3r4/8/8/3R4/7K w - - 0 1',
          expectedMoveSan: 'Rxd5',
          instructionKey: 'captureRook',
          activeSquare: 'd2',
          hint: 'coachCaptureHintText',
          successMessage: 'coachGreatCapture',
        ),
        InteractiveStep(
          startFen: 'k7/8/2b5/8/4B3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Bxc6+',
          instructionKey: 'captureBishop',
          activeSquare: 'e4',
          successMessage: 'coachGreatCapture',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/5n2/3N4/8/8/7K w - - 0 1',
          expectedMoveSan: 'Nxf5',
          instructionKey: 'captureKnight',
          activeSquare: 'd4',
          successMessage: 'coachGreatCapture',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/3p4/4P3/8/8/7K w - - 0 1',
          expectedMoveSan: 'exd5',
          instructionKey: 'capturePawn',
          activeSquare: 'e4',
          successMessage: 'coachGreatCapture',
        ),
        InteractiveStep(
          startFen: 'k7/8/4q3/8/4Q3/8/8/7K w - - 0 1',
          expectedMoveSan: 'Qxe6+',
          instructionKey: 'captureQueen',
          activeSquare: 'e4',
          wrongMoveExplanations: { 'Qc2': 'coachWrongCaptureQueen' },
          successMessage: 'coachGreatCapture',
        ),
        InteractiveStep(
          startFen: 'k7/8/8/4p3/4K3/8/8/8 w - - 0 1',
          expectedMoveSan: 'Kxe5',
          instructionKey: 'captureKing',
          activeSquare: 'e4',
          successMessage: 'coachGreatCapture',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'About Check and Checkmate',
      steps: [
        InteractiveStep(
          startFen: '4r3/8/8/8/8/8/8/4K3 w - - 0 1',
          expectedMoveSan: null, // Any valid escape move (Kd1, Kd2, Kf1, Kf2)
          instructionKey: 'escapeCheckMove',
          activeSquare: 'e1',
        ),
        InteractiveStep(
          startFen: '4k3/8/8/b7/8/8/2P5/4K3 w - - 0 1',
          expectedMoveSan: 'c3', 
          instructionKey: 'blockCheck',
          activeSquare: 'c2',
        ),
        InteractiveStep(
          startFen: '4k3/8/8/8/8/8/4r3/3QK3 w - - 0 1',
          expectedMoveSan: 'Qxe2+',
          instructionKey: 'captureAttacker',
          activeSquare: 'd1',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'How to Castle',
      steps: [
        InteractiveStep(
          startFen: '4k3/8/8/8/8/8/8/R3K2R w KQ - 0 1',
          expectedMoveSan: 'O-O',
          instructionKey: 'castleKingside',
          activeSquare: 'e1',
        ),
        InteractiveStep(
          startFen: '4k3/8/8/8/8/8/8/R3K2R w KQ - 0 1',
          expectedMoveSan: 'O-O-O',
          instructionKey: 'castleQueenside',
          activeSquare: 'e1',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'About En Passant',
      steps: [
        InteractiveStep(
          startFen: '4k3/3p4/8/4P3/8/8/8/4K3 w - - 0 1',
          expectedMoveSan: 'exd6',
          opponentReplySan: 'd5',
          instructionKey: 'captureEnPassant',
          activeSquare: 'e5',
        ),
      ],
    ),
  ];

  static final List<InteractiveLesson> puzzles = [
    InteractiveLesson(
      id: 'p1_mate_1_back_rank',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '6k1/5ppp/8/8/8/8/8/4R1K1 w - - 0 1',
          expectedMoveSan: 'Re8#',
          instructionKey: 'solvePuzzle1',
          activeSquare: 'e1',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p2_mate_1_smothered',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '6rk/6pp/8/6N1/8/8/8/7K w - - 0 1',
          expectedMoveSan: 'Nf7#',
          instructionKey: 'solvePuzzle1',
          activeSquare: 'g5',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p3_mate_1_scholar',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: 'r1bqkb1r/pppp1ppp/2n2n2/4p2Q/2B1P3/8/PPPP1PPP/RNB1K1NR w KQkq - 0 1',
          expectedMoveSan: 'Qxf7#',
          instructionKey: 'solvePuzzle1',
          activeSquare: 'h5',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p4_mate_1_queen',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '4r1k1/pp3ppp/3p1q2/8/8/8/8/4Q1K1 w - - 0 1',
          expectedMoveSan: 'Qxe8#',
          instructionKey: 'solvePuzzle1',
          activeSquare: 'e1',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p5_mate_2_ladder',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '6k1/8/8/8/8/8/1R5R/7K w - - 0 1',
          expectedMoveSan: 'Rb7',
          opponentReplySan: 'Kf8',
          instructionKey: 'solvePuzzle',
          activeSquare: 'b2',
        ),
        InteractiveStep(
          expectedMoveSan: 'Rh8#',
          instructionKey: 'findMate2',
          activeSquare: 'h2',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p6_mate_2_anastasia',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: 'r4r1k/pp2N1pp/8/8/4Q3/4R3/8/6K1 w - - 0 1',
          expectedMoveSan: 'Qxh7+',
          opponentReplySan: 'Kxh7',
          instructionKey: 'solvePuzzle',
          activeSquare: 'e4',
        ),
        InteractiveStep(
          expectedMoveSan: 'Rh3#',
          instructionKey: 'findMate2',
          activeSquare: 'e3',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p7_mate_2_back_rank_sac',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '3r2k1/5ppp/8/8/8/8/4Q3/4R1K1 w - - 0 1',
          expectedMoveSan: 'Qe8+',
          opponentReplySan: 'Rxe8',
          instructionKey: 'solvePuzzle',
          activeSquare: 'e2',
        ),
        InteractiveStep(
          expectedMoveSan: 'Rxe8#',
          instructionKey: 'findMate2',
          activeSquare: 'e1',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p8_tactic_knight_fork',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: 'q1k5/8/8/3N4/8/8/8/7K w - - 0 1',
          expectedMoveSan: 'Nb6+',
          opponentReplySan: 'Kc7',
          instructionKey: 'solvePuzzle',
          activeSquare: 'd5',
        ),
        InteractiveStep(
          expectedMoveSan: 'Nxa8',
          instructionKey: 'capturePiece',
          activeSquare: 'b6',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p9_tactic_discovered_attack',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '4k3/3q4/8/8/4B3/8/8/4R1K1 w - - 0 1',
          expectedMoveSan: 'Bc6+',
          opponentReplySan: 'Kd8',
          instructionKey: 'solvePuzzle',
          activeSquare: 'e4',
        ),
        InteractiveStep(
          expectedMoveSan: 'Bxd7',
          instructionKey: 'capturePiece',
          activeSquare: 'c6',
        ),
      ],
    ),
    InteractiveLesson(
      id: 'p10_tactic_skewer',
      isPuzzle: true,
      steps: [
        InteractiveStep(
          startFen: '6k1/7q/8/8/8/8/8/R6K w - - 0 1',
          expectedMoveSan: 'Ra8+',
          opponentReplySan: 'Kg7',
          instructionKey: 'solvePuzzle',
          activeSquare: 'a1',
        ),
        InteractiveStep(
          expectedMoveSan: 'Ra7+',
          instructionKey: 'capturePiece', // we just want Ra7+
          activeSquare: 'a8',
        ),
      ],
    ),
  ];

  static InteractiveLesson? getLesson(String id) {
    try {
      return fundamentals.firstWhere((l) => l.id == id);
    } catch (_) {
      try {
        return puzzles.firstWhere((l) => l.id == id);
      } catch (_) {
        return null; // Return null if not found
      }
    }
  }

  static List<String> getAllPuzzleIds() {
    return puzzles.map((p) => p.id).toList();
  }
}
