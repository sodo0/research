import requests
import json
import time

url = "http://127.0.0.1:8000/analyze"
headers = {'Content-Type': 'application/json'}

def test_move(desc, fen, move):
    print(f"\n--- Testing: {desc} ---")
    data = {"fen": fen, "move": move, "language": "mn"}
    try:
        res = requests.post(url, headers=headers, json=data).json()
        print(f"Move: {move} | Result: {res['comment']}")
    except Exception as e:
        print(f"Error: {e}")

# 1. Good move
test_move("Good Move Setup (e4) in Mongolian", 
          "rnbqkbnr/pppppppp/8/8/8/8/PPPPPPPP/RNBQKBNR w KQkq - 0 1", 
          "e2e4")

# 2. King sacrifice blunder
test_move("King Blunder (Ke2) in Mongolian", 
          "r1bqkbnr/pppp1ppp/2n5/4p3/4P3/5N2/PPPP1PPP/RNBQKB1R w KQkq - 2 3", 
          "e1e2")

# 3. Blundering a Queen
test_move("Queen Blunder (Qg4) in Mongolian", 
          "rnbqkb1r/pppp1ppp/5n2/4p3/4P3/8/PPPP1PPP/RNBQKBNR w KQkq - 2 3", 
          "d1g4")
