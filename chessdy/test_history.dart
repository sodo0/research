import 'package:chess/chess.dart' as chess_lib;

void main() {
  final game = chess_lib.Chess();
  game.move('e4');
  var history = game.history;
  var last = history.last;
  print("History last type: ${last.runtimeType}");
  if (last is Map) {
    print("last from: ${last['move']}");
    print("last from is Map: ${last['move'] is chess_lib.Move}");
    var m = last['move'] as chess_lib.Move;
    print("Move from: ${m.fromAlgebraic}, to: ${m.toAlgebraic}");
  }
}
