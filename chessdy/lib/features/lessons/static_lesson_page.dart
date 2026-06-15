import 'package:flutter/material.dart';
import 'package:flutter_chess_board/flutter_chess_board.dart';
import '../../services/statistics_service.dart';
import '../../l10n/app_localizations.dart';

class StaticLessonPage extends StatelessWidget {
  final String lessonId;
  final String lessonTitle;

  const StaticLessonPage({
    super.key,
    required this.lessonId,
    required this.lessonTitle,
  });

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(lessonTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ..._getLessonContent(l10n),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: () => _completeLesson(context),
              icon: const Icon(Icons.check_circle),
              label: Text(l10n.completeLesson),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _completeLesson(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    await StatisticsService().markLessonCompleted(lessonId);
    
    if (!context.mounted) return;
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.lessonCompleted)),
    );
    Navigator.of(context).pop();
  }

  List<Widget> _getLessonContent(AppLocalizations l10n) {
    switch (lessonId) {
      case 'Worth of the Pieces':
        return [
          _buildSection(
            title: l10n.pawnTitle,
            description: l10n.pawnDesc,
            fen: 'k7/8/8/8/4P3/8/8/7K w - - 0 1',
          ),
          _buildSection(
            title: l10n.knightTitle,
            description: l10n.knightDesc,
            fen: 'k7/8/8/8/4N3/8/8/7K w - - 0 1',
          ),
          _buildSection(
            title: l10n.bishopTitle,
            description: l10n.bishopDesc,
            fen: 'k7/8/8/8/4B3/8/8/7K w - - 0 1',
          ),
          _buildSection(
            title: l10n.rookTitle,
            description: l10n.rookDesc,
            fen: 'k7/8/8/8/4R3/8/8/7K w - - 0 1',
          ),
          _buildSection(
            title: l10n.queenTitle,
            description: l10n.queenDesc,
            fen: 'k7/8/8/8/4Q3/8/8/7K w - - 0 1',
          ),
        ];
      case 'About Check and Checkmate':
        return [
          _buildSection(
            title: l10n.inCheckTitle,
            description: l10n.inCheckDesc,
            fen: '4r3/8/8/8/8/8/8/4K3 w - - 0 1', 
          ),
          _buildSection(
            title: l10n.blockCheckTitle,
            description: l10n.blockCheckDesc,
            fen: '4k3/8/8/b7/8/8/2P5/4K3 w - - 0 1', 
          ),
          _buildSection(
            title: l10n.captureAttackerTitle,
            description: l10n.captureAttackerDesc,
            fen: '4k3/8/8/8/8/8/4r3/3QK3 w - - 0 1', 
          ),
          _buildSection(
            title: l10n.checkmateTitle,
            description: l10n.checkmateDesc,
            fen: '4k3/8/8/8/8/8/r7/r3K3 w - - 0 1', 
          ),
        ];
      default:
        return [Text(l10n.contentComingSoon)];
    }
  }

  Widget _buildSection({required String title, required String description, required String fen}) {
    final controller = ChessBoardController();
    controller.loadFen(fen);

    return Card(
      margin: const EdgeInsets.only(bottom: 24),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.teal),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 16, height: 1.5),
            ),
            const SizedBox(height: 16),
            AspectRatio(
              aspectRatio: 1,
              child: IgnorePointer(
                child: ChessBoard(
                  controller: controller,
                  boardColor: BoardColor.brown,
                  boardOrientation: PlayerColor.white,
                  enableUserMoves: false, // Static board
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
