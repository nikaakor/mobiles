import sqlite3

DB_NAME = "events.db"

schedule_items = [
    ("Реєстрація", "Оргкомітет", "10:00", "Хол"),
    ("Лекція: IoT та Flutter", "Андрій Коваль", "11:30", "Зал 1"),
    ("Кава-брейк", "Catering Team", "13:00", "Фудкорт"),
    ("Практика з MQTT", "Олена Бондар", "14:30", "Lab 2"),
]

conn = sqlite3.connect(DB_NAME)
cursor = conn.cursor()

cursor.execute(
    """
    CREATE TABLE IF NOT EXISTS schedule (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT NOT NULL,
        speaker TEXT NOT NULL,
        startTime TEXT NOT NULL, 
        location TEXT NOT NULL
    )
    """
)

cursor.execute("DELETE FROM schedule")

cursor.executemany(
    """
    INSERT INTO schedule (title, speaker, startTime, location) -- І ТУТ ТЕЖ
    VALUES (?, ?, ?, ?)
    """,
    schedule_items,
)

conn.commit()
conn.close()

print("Database generated successfully with startTime column.")