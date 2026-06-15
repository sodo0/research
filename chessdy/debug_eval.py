import chess
import chess.engine
import sys

# Copying the evaluation logic from main.py for debugging
PIECE_VALUES = {
    chess.PAWN: 100,
    chess.KNIGHT: 320,
    chess.BISHOP: 330,
    chess.ROOK: 500,
    chess.QUEEN: 900,
    chess.KING: 20000
}

# Simplified Piece-Square Tables (PST)
pawntable = [
    0,  0,  0,  0,  0,  0,  0,  0,
    50, 50, 50, 50, 50, 50, 50, 50,
    10, 10, 20, 30, 30, 20, 10, 10,
    5,  5, 10, 25, 25, 10,  5,  5,
    0,  0,  0, 20, 20,  0,  0,  0,
    5, -5,-10,  0,  0,-10, -5,  5,
    5, 10, 10,-20,-20, 10, 10,  5,
    0,  0,  0,  0,  0,  0,  0,  0
]

knighttable = [
    -50,-40,-30,-30,-30,-30,-40,-50,
    -40,-20,  0,  0,  0,  0,-20,-40,
    -30,  0, 10, 15, 15, 10,  0,-30,
    -30,  5, 15, 20, 20, 15,  5,-30,
    -30,  0, 15, 20, 20, 15,  0,-30,
    -30,  5, 10, 15, 15, 10,  5,-30,
    -40,-20,  0,  5,  5,  0,-20,-40,
    -50,-40,-30,-30,-30,-30,-40,-50
]

bishoptable = [
    -20,-10,-10,-10,-10,-10,-10,-20,
    -10,  0,  0,  0,  0,  0,  0,-10,
    -10,  0,  5, 10, 10,  5,  0,-10,
    -10,  5,  5, 10, 10,  5,  5,-10,
    -10,  0, 10, 10, 10, 10,  0,-10,
    -10, 10, 10, 10, 10, 10, 10,-10,
    -10,  5,  0,  0,  0,  0,  5,-10,
    -20,-10,-10,-10,-10,-10,-10,-20
]

rooktable = [
    0,  0,  0,  0,  0,  0,  0,  0,
    5, 10, 10, 10, 10, 10, 10,  5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    -5,  0,  0,  0,  0,  0,  0, -5,
    0,  0,  0,  5,  5,  0,  0,  0
]

queentable = [
    -20,-10,-10, -5, -5,-10,-10,-20,
    -10,  0,  0,  0,  0,  0,  0,-10,
    -10,  0,  5,  5,  5,  5,  0,-10,
    -5,  0,  5,  5,  5,  5,  0, -5,
    0,  0,  5,  5,  5,  5,  0, -5,
    -10,  5,  5,  5,  5,  5,  0,-10,
    -10,  0,  5,  0,  0,  0,  0,-10,
    -20,-10,-10, -5, -5,-10,-10,-20
]

kingtable = [
    20, 30, 10,  0,  0, 10, 30, 20,
    20, 20,  0,  0,  0,  0, 20, 20,
    -10,-20,-20,-20,-20,-20,-20,-10,
    -20,-30,-30,-40,-40,-30,-30,-20,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30,
    -30,-40,-40,-50,-50,-40,-40,-30
]

king_endgame_table = [
    -50,-40,-30,-20,-20,-30,-40,-50,
    -30,-20,-10,  0,  0,-10,-20,-30,
    -30,-10, 20, 30, 30, 20,-10,-30,
    -30,-10, 30, 40, 40, 30,-10,-30,
    -30,-10, 30, 40, 40, 30,-10,-30,
    -30,-10, 20, 30, 30, 20,-10,-30,
    -30,-30,  0,  0,  0,  0,-30,-30,
    -50,-30,-30,-30,-30,-30,-30,-50
]

def evaluate_board(board, debug=False):
    if board.is_checkmate():
        if board.turn:
            return -9999 # Black wins
        else:
            return 9999 # White wins
    if board.is_stalemate() or board.is_insufficient_material():
        return 0

    eval_score = 0
    
    white_queens = len(board.pieces(chess.QUEEN, chess.WHITE))
    black_queens = len(board.pieces(chess.QUEEN, chess.BLACK))
    is_endgame = (white_queens == 0 and black_queens == 0)
    
    if debug:
        print(f"DEBUG: is_endgame={is_endgame}")

    for square in chess.SQUARES:
        piece = board.piece_at(square)
        if not piece:
            continue
            
        value = PIECE_VALUES[piece.piece_type]
        
        pst_score = 0
        if piece.piece_type == chess.PAWN:
            pst_score = pawntable[square]
        elif piece.piece_type == chess.KNIGHT:
            pst_score = knighttable[square]
        elif piece.piece_type == chess.BISHOP:
            pst_score = bishoptable[square]
        elif piece.piece_type == chess.ROOK:
            pst_score = rooktable[square]
        elif piece.piece_type == chess.QUEEN:
            pst_score = queentable[square]
        elif piece.piece_type == chess.KING:
            if is_endgame:
                pst_score = king_endgame_table[square]
            else:
                pst_score = kingtable[square]

        if piece.color == chess.WHITE:
            eval_score += value + pst_score
            if debug:
                print(f"White {chess.piece_name(piece.piece_type)} at {chess.square_name(square)}: Val={value}, PST={pst_score}, Total={value+pst_score}")
        else:
            mirror_square = square ^ 56
            
            if piece.piece_type == chess.PAWN:
                pst_score = pawntable[mirror_square]
            elif piece.piece_type == chess.KNIGHT:
                pst_score = knighttable[mirror_square]
            elif piece.piece_type == chess.BISHOP:
                pst_score = bishoptable[mirror_square]
            elif piece.piece_type == chess.ROOK:
                pst_score = rooktable[mirror_square]
            elif piece.piece_type == chess.QUEEN:
                pst_score = queentable[mirror_square]
            elif piece.piece_type == chess.KING:
                if is_endgame:
                    pst_score = king_endgame_table[mirror_square]
                else:
                    pst_score = kingtable[mirror_square]
                
            eval_score -= (value + pst_score)
            if debug:
                print(f"Black {chess.piece_name(piece.piece_type)} at {chess.square_name(square)}: Val={value}, PST={pst_score}, Total={-(value+pst_score)}")

    return eval_score

def test_fen(fen):
    print(f"\nAnalyzing FEN: {fen}")
    board = chess.Board(fen)
    score = evaluate_board(board, debug=True)
    print(f"Final Score: {score}")

# Test cases
test_fen("rnbqkbnr/pppppppp/8/8/4P3/8/PPPP1PPP/RNBQKBNR b KQkq e3 0 1") # After 1. e4
test_fen("rnbqkbnr/ppppp1pp/5p2/8/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 0 2") # After 1. e4 f6
