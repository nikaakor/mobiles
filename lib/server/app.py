import sqlite3
from flask import Flask, jsonify, request
from flask_cors import CORS

app = Flask(__name__)
CORS(app)  

DATABASE = 'events.db'

def init_db():
    with sqlite3.connect(DATABASE) as conn:
        conn.execute('''
            CREATE TABLE IF NOT EXISTS schedule (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                title TEXT NOT NULL,
                speaker TEXT,
                startTime TEXT,
                location TEXT
            )
        ''')
        conn.commit()
    print("База даних готова до роботи")

@app.route('/schedule', methods=['GET', 'POST'])
def schedule_collection():
    with sqlite3.connect(DATABASE) as conn:
        conn.row_factory = sqlite3.Row
        
        if request.method == 'GET':
            rows = conn.execute("SELECT * FROM schedule").fetchall()
            return jsonify([dict(row) for row in rows])
        
        if request.method == 'POST':
            data = request.json
            print(f"📥 Отримано дані: {data}")
            
            title = data.get('title', 'Без назви')
            speaker = data.get('speaker', '')
            start_time = data.get('startTime') or data.get('start_time') or '00:00'
            location = data.get('location', '')

            cur = conn.execute(
                "INSERT INTO schedule (title, speaker, startTime, location) VALUES (?, ?, ?, ?)",
                (title, speaker, start_time, location)
            )
            conn.commit()
            return jsonify({"id": cur.lastrowid}), 201

@app.route('/schedule/<int:item_id>', methods=['DELETE'])
def schedule_item(item_id):
    with sqlite3.connect(DATABASE) as conn:
        conn.execute("DELETE FROM schedule WHERE id = ?", (item_id,))
        conn.commit()
        return '', 204

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5001, debug=True)