import 'package:chess/chess.dart';
void main() {
  final c = Chess();
  try {
    c.load('8/8/8/8/4P3/8/8/8 w - - 0 1');
    print('Pawn No Kings Allowed: ${c.generate_moves()}');
  } catch (e) {
    print('Pawn No Kings Error: $e');
  }
}
