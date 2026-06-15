from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
import chess
import chess.engine
import chess.polyglot
import random
import time
import sys
import os
import shutil
from fastapi.middleware.cors import CORSMiddleware

STOCKFISH_PATH = shutil.which("stockfish") or "/opt/homebrew/bin/stockfish"
if not shutil.which(STOCKFISH_PATH):
    STOCKFISH_PATH = "/usr/local/bin/stockfish"

# Transposition Table
transposition_table = {}

class TTEntry:
    def __init__(self, score, depth, flag, move):
        self.score = score
        self.depth = depth
        self.flag = flag # 0: Exact, 1: Lowerbound (Alpha), 2: Upperbound (Beta)
        self.move = move

class SearchTimeout(Exception):
    pass

nodes_visited = 0

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Allows all origins
    allow_credentials=True,
    allow_methods=["*"],  # Allows all methods
    allow_headers=["*"],  # Allows all headers
)

class MoveRequest(BaseModel):
    fen: str
    language: str = "en"
    last_player_move: str = None

class AnalyzeRequest(BaseModel):
    fen: str
    move: str
    language: str = "en"

# --- AI Logic ---

# Piece values
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

def evaluate_board(board):
    if board.is_checkmate():
        if board.turn:
            return -9999 # Black wins
        else:
            return 9999 # White wins
    if board.is_stalemate() or board.is_insufficient_material():
        return 0

    eval_score = 0
    
    # Check for endgame phase (no queens or minor pieces only)
    # Simple heuristic: if no queens on board, it's endgame
    white_queens = len(board.pieces(chess.QUEEN, chess.WHITE))
    black_queens = len(board.pieces(chess.QUEEN, chess.BLACK))
    is_endgame = (white_queens == 0 and black_queens == 0)
    
    # Material and Position
    for square in chess.SQUARES:
        piece = board.piece_at(square)
        if not piece:
            continue
            
        value = PIECE_VALUES[piece.piece_type]
        
        # Positional score
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

        # PSTs are defined for White. For Black, we mirror the square index.
        if piece.color == chess.WHITE:
            eval_score += value + pst_score
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

    # print(f"DEBUG: Eval {eval_score} for FEN {board.fen()}", file=sys.stderr)
    return eval_score

def quiescence_search(board, alpha, beta, maximizing_player, start_time, time_limit):
    global nodes_visited
    nodes_visited += 1
    if nodes_visited % 2048 == 0:
        if time.time() - start_time > time_limit:
            raise SearchTimeout

    if board.is_game_over():
        return evaluate_board(board)

    in_check = board.is_check()
    
    if in_check:
        stand_pat = -float('inf')
    else:
        stand_pat = evaluate_board(board)
        if maximizing_player:
            if stand_pat >= beta:
                return beta
            if stand_pat > alpha:
                alpha = stand_pat
        else:
            if stand_pat <= alpha:
                return alpha
            if stand_pat < beta:
                beta = stand_pat

    moves = []
    if in_check:
        moves = list(board.legal_moves) # Generate all evasions
    else:
        moves = [m for m in board.legal_moves if board.is_capture(m)]
        # Sort captures by MVV-LVA
        moves.sort(key=lambda m: (board.piece_at(m.to_square).piece_type if board.piece_at(m.to_square) else 0), reverse=True)

    if maximizing_player:
        for move in moves:
            board.push(move)
            try:
                score = quiescence_search(board, alpha, beta, False, start_time, time_limit)
            finally:
                board.pop()

            if score >= beta:
                return beta
            if score > alpha:
                alpha = score
        
        # If in check and no moves improved alpha (and alpha was -inf), we might be mated.
        # But board.is_game_over() handled that. 
        # If we are here, we have moves. If none raised alpha, we return alpha.
        return alpha
    else:
        for move in moves:
            board.push(move)
            try:
                score = quiescence_search(board, alpha, beta, True, start_time, time_limit)
            finally:
                board.pop()

            if score <= alpha:
                return alpha
            if score < beta:
                beta = score
        return beta

def minimax(board, depth, alpha, beta, maximizing_player, start_time, time_limit):
    global nodes_visited
    nodes_visited += 1
    if nodes_visited % 2048 == 0:
        if time.time() - start_time > time_limit:
            raise SearchTimeout

    # Transposition Table Lookup
    zobrist = chess.polyglot.zobrist_hash(board)
    if zobrist in transposition_table:
        entry = transposition_table[zobrist]
        if entry.depth >= depth:
            if entry.flag == 0: # Exact
                return entry.score
            elif entry.flag == 1: # Lowerbound (Alpha)
                alpha = max(alpha, entry.score)
            elif entry.flag == 2: # Upperbound (Beta)
                beta = min(beta, entry.score)
            
            if alpha >= beta:
                return entry.score

    if depth <= 0 or board.is_game_over():
        return quiescence_search(board, alpha, beta, maximizing_player, start_time, time_limit)

    best_move = None
    original_alpha = alpha
    
    # Move Ordering
    legal_moves = list(board.legal_moves)
    # 1. PV Move (from TT)
    tt_move = None
    if zobrist in transposition_table:
         tt_move = transposition_table[zobrist].move

    # Score moves for sorting
    def move_score(move):
        if move == tt_move:
            return 1000000
        
        score = 0
        # MVV-LVA (Most Valuable Victim - Least Valuable Aggressor)
        if board.is_capture(move):
            victim = board.piece_at(move.to_square)
            if victim:
                score += PIECE_VALUES[victim.piece_type] - PIECE_VALUES[board.piece_at(move.from_square).piece_type] / 100
        
        return score

    legal_moves.sort(key=move_score, reverse=True)

    if maximizing_player:
        max_eval = -float('inf')
        
        # Check Extension
        extension = 0
        if board.is_check():
            extension = 1
            
        for move in legal_moves:
            board.push(move)
            try:
                eval = minimax(board, depth - 1 + extension, alpha, beta, False, start_time, time_limit)
            finally:
                board.pop()
            
            if eval > max_eval:
                max_eval = eval
                best_move = move
                
            alpha = max(alpha, eval)
            if beta <= alpha:
                break
        
        # Store in TT
        flag = 0 # Exact
        if max_eval <= original_alpha:
            flag = 2 # Upperbound (Beta)
        elif max_eval >= beta:
            flag = 1 # Lowerbound (Alpha)
            
        transposition_table[zobrist] = TTEntry(max_eval, depth, flag, best_move)
        return max_eval
    else:
        min_eval = float('inf')
        
        # Check Extension
        extension = 0
        if board.is_check():
            extension = 1
            
        for move in legal_moves:
            board.push(move)
            try:
                eval = minimax(board, depth - 1 + extension, alpha, beta, True, start_time, time_limit)
            finally:
                board.pop()
            
            if eval < min_eval:
                min_eval = eval
                best_move = move
                
            beta = min(beta, eval)
            if beta <= alpha:
                break
                
        # Store in TT
        flag = 0 # Exact
        if min_eval <= original_alpha:
            flag = 2 # Upperbound (Beta) # Wait, for minimizing player? 
            # If min_eval <= alpha, it means we found a move worse than what white can already guarantee.
            # So this node is an upper bound? No, fail low?
            # Let's stick to standard definition:
            # Fail Low: score <= alpha. We couldn't find anything better than alpha. Upper bound.
            # Fail High: score >= beta. We found something too good. Lower bound.
            pass
            
        # Correct TT logic for Minimax:
        # If score <= alpha: We know the value is at most 'score' (Upper Bound)
        # If score >= beta: We know the value is at least 'score' (Lower Bound)
        # Else: Exact value
        
        if min_eval <= original_alpha:
             flag = 2 # Upperbound
        elif min_eval >= beta:
             flag = 1 # Lowerbound
             
        transposition_table[zobrist] = TTEntry(min_eval, depth, flag, best_move)
        return min_eval

def get_best_move_iterative(board, time_limit=2.0):
    start_time = time.time()
    best_move = None
    depth = 1
    global nodes_visited
    nodes_visited = 0
    
    try:
        while True:
            if time.time() - start_time > time_limit:
                break
                
            # Root search
            best_val = -float('inf') if board.turn else float('inf')
            alpha = -float('inf')
            beta = float('inf')
            
            # Move ordering at root
            legal_moves = list(board.legal_moves)
            
            # Sort using TT move if available
            zobrist = chess.polyglot.zobrist_hash(board)
            tt_move = None
            if zobrist in transposition_table:
                 tt_move = transposition_table[zobrist].move
                 
            def root_move_score(move):
                if move == tt_move: return 1000000
                if board.is_capture(move):
                     victim = board.piece_at(move.to_square)
                     if victim:
                        return PIECE_VALUES[victim.piece_type]
                return 0
                
            legal_moves.sort(key=root_move_score, reverse=True)
            
            current_best_move = None
            
            for move in legal_moves:
                board.push(move)
                try:
                    # Pass start_time and time_limit to minimax
                    # After pushing, board.turn has flipped to the next player
                    # We want to search from that player's perspective
                    val = minimax(board, depth - 1, alpha, beta, board.turn, start_time, time_limit)
                finally:
                    board.pop()
                
                if board.turn: # White
                    if val > best_val:
                        best_val = val
                        current_best_move = move
                    alpha = max(alpha, val)
                else: # Black
                    if val < best_val:
                        best_val = val
                        current_best_move = move
                    beta = min(beta, val)
                    
            best_move = current_best_move
            print(f"DEBUG: Depth {depth} completed. Best move: {best_move}, Score: {best_val}", file=sys.stderr)
            depth += 1
            
    except SearchTimeout:
        print("DEBUG: Search timed out!", file=sys.stderr)
        
    return best_move

# --- Commentary Logic ---

def get_piece_name(piece_type, lang="en"):
    names = {
        chess.PAWN: {"en": "pawn", "mn": "хүү"},
        chess.KNIGHT: {"en": "knight", "mn": "морь"},
        chess.BISHOP: {"en": "bishop", "mn": "тэмээ"},
        chess.ROOK: {"en": "rook", "mn": "тэрэг"},
        chess.QUEEN: {"en": "queen", "mn": "бэрс"},
        chess.KING: {"en": "king", "mn": "ноён"},
    }
    return names.get(piece_type, {}).get(lang, "piece")

def generate_move_comment(board, move, score, is_ai_move, lang="en"):
    """Generates a simple comment about the move."""
    
    # Pre-move analysis (what was captured?)
    is_capture = board.is_capture(move)
    captured_piece = None
    if is_capture:
        if board.is_en_passant(move):
             captured_piece = chess.PAWN
        else:
             captured_piece_obj = board.piece_at(move.to_square)
             if captured_piece_obj:
                 captured_piece = captured_piece_obj.piece_type

    # Make the move to check post-move status
    board.push(move)
    is_check = board.is_check()
    is_checkmate = board.is_checkmate()
    is_castling = board.is_castling(move)
    
    # Positional Analysis
    to_square = move.to_square
    rank = chess.square_rank(to_square)
    file = chess.square_file(to_square)
    
    # Center control (e4, d4, e5, d5 -> squares 28, 27, 36, 35)
    is_center_control = to_square in [27, 28, 35, 36]
    
    # Development (Knight or Bishop moving from back rank)
    is_development = False
    piece_type = board.piece_at(to_square).piece_type
    if piece_type in [chess.KNIGHT, chess.BISHOP]:
        from_rank = chess.square_rank(move.from_square)
        if (board.turn == chess.BLACK and from_rank == 0) or \
           (board.turn == chess.WHITE and from_rank == 7): # Note: board.turn is flipped after push
             is_development = True

    board.pop() # Restore board

    comment = ""
    
    # 1. Special Moves
    if is_checkmate:
        return "Checkmate!" if lang == "en" else "Мат!"
    
    if is_castling:
        if lang == "en":
            comment = "Castling for safety."
        else:
            comment = "Аюулгүй байдлын үүднээс сэлгээ хийлээ."
            
    # 2. Captures
    elif is_capture and captured_piece:
        piece_name = get_piece_name(captured_piece, lang)
        if is_ai_move:
            if lang == "en":
                comment = f"I am taking your {piece_name}."
            else:
                comment = f"Би таны {piece_name}-г идлээ."
        else:
            if lang == "en":
                comment = f"You took my {piece_name}."
            else:
                comment = f"Та миний {piece_name}-г идлээ."
    
    # 3. Checks
    elif is_check:
        if lang == "en":
            comment = "Check!"
        else:
            comment = "Шаг!"
            
    # 4. Positional / General (Fallback)
    else:
        if is_center_control:
            comment = "Controlling the center." if lang == "en" else "Төвийг хяналтдаа авлаа."
        elif is_development:
            comment = "Developing a piece." if lang == "en" else "Байрлалаа сайжруулж байна."
        else:
            if is_ai_move:
                if score > 200:
                    comment = "I feel confident here." if lang == "en" else "Би итгэлтэй байна."
                elif score < -200:
                    comment = "This is tough for me." if lang == "en" else "Энэ байрлал надад хэцүү байна."
                else:
                    comment = "Developing my position." if lang == "en" else "Байрлалаа сайжруулж байна."
            else:
                comment = "Interesting move." if lang == "en" else "Сонирхолтой нүүдэл."

    return comment

def get_engine_eval(board: chess.Board, engine_path: str = STOCKFISH_PATH, time_limit: float = 0.5):
    try:
        with chess.engine.SimpleEngine.popen_uci(engine_path) as engine:
            info = engine.analyse(board, chess.engine.Limit(time=time_limit))
            # Always get the score from White's perspective to be consistent
            score = info["score"].white()
            if score.is_mate():
                return 100.0 if score.mate() > 0 else -100.0
            return score.score() / 100.0
    except Exception as e:
        print(f"Error communicating with Stockfish: {e}", file=sys.stderr)
        # static fallback
        return evaluate_board(board) / 100.0

def classify_move(loss: float, lang: str="en") -> str:
    if loss <= 0.2:
         return "Excellent" if lang == "en" else "Маш сайн"
    elif loss <= 0.5:
         return "Good" if lang == "en" else "Сайн"
    elif loss <= 1.0:
         return "Inaccuracy" if lang == "en" else "Анхааралгүй"
    elif loss <= 2.0:
         return "Mistake" if lang == "en" else "Алдаа"
    else:
         return "Blunder" if lang == "en" else "Ноцтой алдаа"

def get_material_balance(board: chess.Board) -> float:
    balance = 0.0
    for square in chess.SQUARES:
        piece = board.piece_at(square)
        if piece:
            value = PIECE_VALUES[piece.piece_type] / 100.0
            balance += value if piece.color == chess.WHITE else -value
    return balance

def is_piece_hanging(board: chess.Board, square: chess.Square, color: chess.Color) -> bool:
    attackers = board.attackers(not color, square)
    defenders = board.attackers(color, square)
    if attackers and not defenders:
        return True
    return False

def find_hanging_pieces(board: chess.Board, color: chess.Color) -> list:
    hanging = []
    for square in chess.SQUARES:
        piece = board.piece_at(square)
        if piece and piece.color == color:
            if is_piece_hanging(board, square, color):
                hanging.append(chess.square_name(square))
    return hanging

def detect_game_phase(board: chess.Board) -> str:
    move_count = board.fullmove_number
    queens = len(board.pieces(chess.QUEEN, chess.WHITE)) + len(board.pieces(chess.QUEEN, chess.BLACK))
    minor = (len(board.pieces(chess.KNIGHT, chess.WHITE)) + len(board.pieces(chess.BISHOP, chess.WHITE)) +
             len(board.pieces(chess.KNIGHT, chess.BLACK)) + len(board.pieces(chess.BISHOP, chess.BLACK)))
    if move_count <= 12 and minor >= 4:
        return 'opening'
    elif queens == 0 or minor <= 2:
        return 'endgame'
    return 'middlegame'

def count_developed_minor_pieces(board: chess.Board, color: chess.Color) -> int:
    back_rank = 0 if color == chess.WHITE else 7
    return sum(
        1 for pt in [chess.KNIGHT, chess.BISHOP]
        for sq in board.pieces(pt, color)
        if chess.square_rank(sq) != back_rank
    )

def king_is_exposed(board: chess.Board, color: chess.Color) -> bool:
    king_sq = board.king(color)
    if king_sq is None:
        return False
    return len(board.attackers(not color, king_sq)) > 0

def center_control_count(board: chess.Board, color: chess.Color) -> int:
    center = [chess.E4, chess.D4, chess.E5, chess.D5]
    return sum(1 for sq in center if board.is_attacked_by(color, sq))

def generate_explanation(
    board_before: chess.Board,
    board_after: chess.Board,
    move: chess.Move,
    classification: str,
    eval_loss: float,
    lang: str = "en",
    best_move_uci: str = None,
) -> str:
    player_color = board_before.turn
    parts = []
    phase = detect_game_phase(board_before)
    is_mn = lang == "mn"

    # ── 1. Classification opening sentence ────────────────────────
    if classification in ["Excellent", "Маш сайн"]:
        parts.append(
            "Excellent! This is one of the best moves in the position." if not is_mn
            else "Маш сайн! Энэ байрлалын хамгийн оновчтой нүүдлүүдийн нэг."
        )
    elif classification in ["Good", "Сайн"]:
        parts.append(
            "Good move — solid and principled." if not is_mn
            else "Сайн нүүдэл — найдвартай, зарчимтай."
        )
    elif classification in ["Inaccuracy", "Анхааралгүй"]:
        parts.append(
            "Slight inaccuracy — not losing, but a stronger move was available." if not is_mn
            else "Бага зэрэг буруу — хожигдохгүй ч, илүү хүчтэй нүүдэл байсан."
        )
    elif classification in ["Mistake", "Алдаа"]:
        parts.append(
            "Mistake — this gives your opponent a real advantage." if not is_mn
            else "Алдаа — эсрэг тал чинь давуу тал авах боломж олгогдлоо."
        )
    else:  # Blunder
        parts.append(
            "Blunder! This move seriously damages your position." if not is_mn
            else "Ноцтой алдаа! Энэ нүүдэл таны байрлалыг ихээхэн доройтуулж байна."
        )

    # ── 2. Material change ─────────────────────────────────────────
    mat_before = get_material_balance(board_before)
    mat_after  = get_material_balance(board_after)
    mat_diff = (mat_after - mat_before) if player_color == chess.WHITE else (mat_before - mat_after)

    if mat_diff < -0.4:
        lost = abs(round(mat_diff, 1))
        parts.append(
            f"You lost {lost} pawn-worth of material." if not is_mn
            else f"Та {lost} оноотой хөлөг алдлаа."
        )
    elif mat_diff > 0.4 and classification in ["Excellent", "Good", "Маш сайн", "Сайн"]:
        gained = abs(round(mat_diff, 1))
        parts.append(
            f"Nice — you won {gained} pawn-worth of material." if not is_mn
            else f"Сайхан — та {gained} оноотой хөлөг авлаа."
        )

    # ── 3. Hanging pieces ──────────────────────────────────────────
    hanging = find_hanging_pieces(board_after, player_color)
    if hanging:
        sq = ", ".join(hanging)
        parts.append(
            f"Your piece on {sq} is now undefended and can be captured for free." if not is_mn
            else f"Таны {sq} дээрх хөлөг хамгаалалтгүй үлдсэн бөгөөд үнэгүй идэгдэж болно."
        )

    # ── 4. Walked into check ───────────────────────────────────────
    if board_after.is_check():
        parts.append(
            "This move allows your opponent to give check — you are now forced to react." if not is_mn
            else "Энэ нүүдлийн улмаас эсрэг тал шаг тавих боломж авлаа — та ноёноо хамгаалах ёстой."
        )

    # ── 5. Opening principles ──────────────────────────────────────
    if phase == 'opening' and classification not in ["Excellent", "Good", "Маш сайн", "Сайн"]:
        developed = count_developed_minor_pieces(board_after, player_color)
        if developed < 2:
            parts.append(
                "Opening tip: develop your knights and bishops first. Avoid moving the same piece twice before castling." if not is_mn
                else "Эхлэлийн зөвлөгөө: морь, тэмээгээ эхлэлд хөгжүүл. Сэлгэх хүртэл нэг хөлгийг давтан нүүлгэхгүй байгаарай."
            )
        my_center = center_control_count(board_after, player_color)
        if my_center < 2:
            parts.append(
                "Try to control the center: e4, d4, e5, d5 are the key squares in the opening." if not is_mn
                else "Төвийг хянахыг хичээ: e4, d4, e5, d5 нүднүүд эхлэлд хамгийн чухал."
            )

    # ── 6. Middlegame king safety ──────────────────────────────────
    if phase == 'middlegame' and classification in ["Mistake", "Blunder", "Алдаа", "Ноцтой алдаа"]:
        if king_is_exposed(board_after, player_color):
            parts.append(
                "Your king is exposed to attack. Prioritize king safety — castle if you haven't already." if not is_mn
                else "Таны ноён дайралтад өртөх боломжтой. Ноёны аюулгүй байдлыг тэргүүнд тавь — сэлгэж амжаарай."
            )

    # ── 7. Endgame king activity ───────────────────────────────────
    if phase == 'endgame' and classification not in ["Excellent", "Good", "Маш сайн", "Сайн"]:
        parts.append(
            "Endgame tip: activate your king — it becomes a powerful piece in the endgame." if not is_mn
            else "Төгсгөлийн зөвлөгөө: ноёноо идэвхжүүл — төгсгөлд ноён хүчтэй хөлөг болдог."
        )

    # ── 8. Missed checkmate ────────────────────────────────────────
    try:
        with chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH) as engine:
            info_b = engine.analyse(board_before, chess.engine.Limit(depth=15))
            sc_b = info_b["score"].white() if player_color == chess.WHITE else info_b["score"].black()
            if sc_b.is_mate() and sc_b.mate() > 0:
                info_a = engine.analyse(board_after, chess.engine.Limit(depth=12))
                sc_a = info_a["score"].white() if player_color == chess.WHITE else info_a["score"].black()
                if not sc_a.is_mate() or sc_a.mate() <= 0:
                    m = sc_b.mate()
                    parts.append(
                        f"You had a forced checkmate in {m} move(s)! Always look for forcing sequences." if not is_mn
                        else f"Та {m} нүүдлийн дотор мат хийх боломжтой байсан! Хүйтэн нүүдлүүдийг анхааралтай хайгаарай."
                    )
    except Exception:
        pass

    # ── 9. Best move hint ──────────────────────────────────────────
    if best_move_uci and eval_loss >= 0.5:
        try:
            bm = chess.Move.from_uci(best_move_uci)
            best_san = board_before.san(bm)
            parts.append(
                f"The strongest move was {best_san} — try to understand why before playing on." if not is_mn
                else f"Хамгийн хүчтэй нүүдэл бол {best_san} байсан — дараагийн нүүдлийн өмнө яагаад гэдгийг ойлгохыг хичээ."
            )
        except Exception:
            pass

    # ── 10. Generic tactical reminder (fallback) ─────────────────
    if len(parts) == 1 and eval_loss > 0.5:
        parts.append(
            "Before each move, ask: does my opponent have any threats? Can I win material or improve my worst piece?" if not is_mn
            else "Нүүдэл бүрийн өмнө асуу: эсрэг тал ямар заналхийлэл тавьж байна вэ? Хамгийн муу хөлгөө сайжруулж чадах уу?"
        )

    return " ".join(parts)


@app.post("/analyze")
async def analyze_move(request: AnalyzeRequest):
    try:
        board_before = chess.Board(request.fen)
        try:
            move = chess.Move.from_uci(request.move)
        except ValueError:
            try:
                move = board_before.parse_san(request.move)
            except ValueError as e:
                with open("/tmp/chessdy_invalid_moves.log", "a") as f:
                    f.write(f"INVALID MOVE FORMAT: FEN='{request.fen}', MOVE='{request.move}', ERROR='{e}'\n")
                return {"comment": "Invalid move format" if request.language == "en" else "Нүүдлийн формат буруу байна"}

        if move not in board_before.legal_moves:
            return {"comment": "Invalid move" if request.language == "en" else "Буруу нүүдэл"}

        # Get eval before AND the best move suggestion in one Stockfish call
        best_move_uci = None
        eval_before = None
        try:
            with chess.engine.SimpleEngine.popen_uci(STOCKFISH_PATH) as engine:
                info = engine.analyse(board_before, chess.engine.Limit(time=0.5))
                sc = info["score"].white()
                eval_before = 100.0 if sc.is_mate() and sc.mate() > 0 else (-100.0 if sc.is_mate() else sc.score() / 100.0)
                pv = info.get("pv", [])
                if pv:
                    best_move_uci = pv[0].uci()
        except Exception:
            eval_before = get_engine_eval(board_before)

        board_after = board_before.copy()
        board_after.push(move)
        eval_after = get_engine_eval(board_after)

        player_color = board_before.turn
        eval_loss = (eval_before - eval_after) if player_color == chess.WHITE else (eval_after - eval_before)
        eval_loss = max(0.0, eval_loss)

        classification = classify_move(eval_loss, request.language)
        explanation = generate_explanation(
            board_before, board_after, move, classification, eval_loss,
            request.language, best_move_uci
        )

        comment = f"{classification} ({round(eval_loss, 2)}). {explanation}"
        return {"comment": comment}

    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid FEN or Move")


@app.post("/move")
async def get_best_move(request: MoveRequest):
    print(f"DEBUG: Processing move for FEN: {request.fen}", file=sys.stderr)
    try:
        board = chess.Board(request.fen)
    except ValueError:
        raise HTTPException(status_code=400, detail="Invalid FEN")

    response = {
        "move": None,
        "game_over": False,
        "ai_comment": "",
        "player_comment": ""
    }

    # 1. Analyze Player's Last Move (if provided)
    if request.last_player_move:
        try:
            # We need the board state BEFORE the player's move to analyze it correctly
            # But we only have the current FEN (after player move).
            # So we can't easily know what was captured unless we undo the move.
            # However, we don't have the full history.
            # Simplified approach: Just check if the move puts AI in check, etc.
            # Or, we can try to infer. 
            # Better approach for now: Just comment on the current state resulting from player move.
            # Actually, to check for captures, we'd need the previous board.
            # Let's just do simple post-move analysis for player (Check, etc.)
            
            # Wait, the frontend sends the FEN *after* the player moved.
            # So 'board' is the state after player moved.
            # We can check if AI is in check.
            if board.is_check():
                 response["player_comment"] = "Good check!" if request.language == "en" else "Сайн шаг!"
            else:
                 # Generic comment since we can't easily see captures without history
                 response["player_comment"] = "Thinking..." if request.language == "en" else "Бодож байна..."
                 
        except Exception as e:
            print(f"Error analyzing player move: {e}", file=sys.stderr)

    if board.is_game_over():
        response["game_over"] = True
        return response

    # Use Opening Book first if available
    try:
        book_path = os.path.join(os.path.dirname(__file__), "book.bin")
        with chess.polyglot.open_reader(book_path) as reader:
            # Get a random move from the opening book if available
            entry = reader.choice(board)
            move = entry.move
            print(f"DEBUG: Found opening book move: {move}", file=sys.stderr)
    except Exception as e:
        print(f"DEBUG: Opening book not used or not found: {e}", file=sys.stderr)
        move = None

    if move is None:
        # Fall back to Iterative Deepening
        print("DEBUG: Calling Iterative Deepening...", file=sys.stderr)
        move = get_best_move_iterative(board, time_limit=2.0)
        print(f"DEBUG: Iterative Deepening returned: {move}", file=sys.stderr)
    
    if move is None:
        print("DEBUG: Minimax returned None, using random fallback", file=sys.stderr)
        if list(board.legal_moves):
             move = random.choice(list(board.legal_moves))
        else:
             response["game_over"] = True
             return response
    
    # Generate AI Comment
    # We need to evaluate the board *after* the move to give a score-based comment?
    # Or use the score from the search.
    # We don't easily have the score from get_best_move_iterative returned here.
    # Let's just use a quick static eval for the comment or modify get_best_move_iterative to return score.
    # For simplicity, let's just use the static eval of the resulting position.
    
    board.push(move)
    score = evaluate_board(board)
    board.pop()
    
    # Invert score because evaluate_board returns from white's perspective?
    # evaluate_board: +ve White, -ve Black.
    # If AI is White, higher is better. If AI is Black, lower is better.
    # Let's normalize to "AI perspective" for the comment generation.
    ai_score = score if board.turn == chess.WHITE else -score
    
    response["ai_comment"] = generate_move_comment(board, move, ai_score, is_ai_move=True, lang=request.language)
    response["move"] = move.uci()
    
    print(f"DEBUG: Returning move: {move.uci()}", file=sys.stderr)
    return response

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
