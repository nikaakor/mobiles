import paho.mqtt.client as mqtt
import time
import random

BROKER = "broker.emqx.io"
PORT = 1883

TOPICS = {
    "people": "smart_event/hall_1/people",
    "temp": "smart_event/hall_1/temp",
    "air": "smart_event/hall_1/air",
    "food": "smart_event/hall_1/food"
}

client = mqtt.Client()

try:
    client.connect(BROKER, PORT, 60)
    print(f"✅ Емулятор підключено до {BROKER}")
except Exception as e:
    print(f"❌ Помилка: {e}")
    exit()

while True:
    data = {
        "people": str(random.randint(40, 150)),
        "temp": str(round(random.uniform(18.0, 25.0), 1)),
        "air": str(random.randint(400, 900)),
        "food": str(random.randint(0, 50))
    }

    for key, value in data.items():
        client.publish(TOPICS[key], value)
    
    print(f"📡 Відправлено: Люди:{data['people']}, Темп:{data['temp']}, Повітря:{data['air']}, Їжа:{data['food']}")
    time.sleep(5)