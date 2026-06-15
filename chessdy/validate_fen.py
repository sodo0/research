import chess

board = chess.Board('r4r1k/pp2N1pp/8/8/4Q3/4R3/8/6K1 w - - 0 1')
print(board)
board.push_san('Qxh7+')
print("Qxh7+ is legal")
board.push_san('Kxh7')
print("Kxh7 is legal")
board.push_san('Rh3#')
print("Rh3# is legal, and is mate:", board.is_checkmate())
