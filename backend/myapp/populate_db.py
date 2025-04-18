import os
import django
import sys
sys.path.append(os.path.dirname(os.path.abspath(__file__)) + "/..")
os.environ.setdefault("DJANGO_SETTINGS_MODULE", "backend.settings")

django.setup()

from myapp.models import Category, Card


# Путь к медиафайлам
AUDIO_CHECK_DIR = "../media/audio"
IMAGE_CHECK_DIR = "../media/images"

AUDIO_DIR = "/audio"
IMAGE_DIR = "/images"

data = {
    "Еда и напитки": [
        ("Water", "Вода"),
        ("Tea", "Чай"),
        ("Milk", "Молоко"),
        ("Juice", "Сок"),
        ("Bread", "Хлеб"),
        ("Apple", "Яблоко"),
        ("Banana", "Банан"),
        ("Pear", "Груша"),
        ("Grapes", "Виноград"),
        ("Orange", "Апельсин"),
        ("Strawberry", "Клубника"),
        ("Watermelon", "Арбуз"),
        ("Yogurt", "Йогурт"),
        ("Chocolate", "Шоколад"),
        ("Candy", "Конфета"),
        ("Cookie", "Печенье"),
        ("Kefir", "Кефир"),
        ("Soup", "Суп"),
        ("Porridge", "Каша"),
        ("Meat", "Мясо"),
        ("Fish", "Рыба"),
        ("Egg", "Яйцо"),
        ("Pasta", "Макароны"),
    ],
    "Одежда и обувь": [
        ("T-shirt", "Футболка"),
        ("Pants", "Брюки"),
        ("Socks", "Носки"),
        ("Shoes", "Обувь"),
        ("Cap", "Кепка"),
        ("Gloves", "Перчатки"),
        ("Jacket", "Куртка"),
        ("Hat", "Шапка"),
        ("Scarf", "Шарф"),
        ("Sneakers", "Кроссовки"),
        ("Boots", "Ботинки"),
        ("Dress", "Платье"),
        ("Tights", "Колготки"),
        ("Pajamas", "Пижама"),
    ],
    "Транспорт": [
        ("Car", "Машина"),
        ("Bus", "Автобус"),
        ("Train", "Поезд"),
        ("Bicycle", "Велосипед"),
        ("Motorcycle", "Мотоцикл"),
        ("Airplane", "Самолет"),
        ("Boat", "Лодка"),
        ("Tram", "Трамвай"),
        ("Subway", "Метро"),
        ("Truck", "Грузовик"),
    ],
    "Животные": [
        ("Dog", "Собака"),
        ("Cat", "Кошка"),
        ("Cow", "Корова"),
        ("Horse", "Лошадь"),
        ("Sheep", "Овца"),
        ("Goat", "Козел"),
        ("Pig", "Свинья"),
        ("Rabbit", "Кролик"),
        ("Chicken", "Курица"),
        ("Duck", "Утка"),
        ("Goose", "Гусь"),
        ("Elephant", "Слон"),
        ("Tiger", "Тигр"),
        ("Lion", "Лев"),
        ("Bear", "Медведь"),
        ("Wolf", "Волк"),
        ("Fox", "Лиса"),
        ("Deer", "Олень"),
        ("Frog", "Лягушка"),
        ("Snake", "Змея"),
    ],
    "Дом и мебель": [
        ("Table", "Стол"),
        ("Chair", "Стул"),
        ("Sofa", "Диван"),
        ("Bed", "Кровать"),
        ("Lamp", "Лампа"),
        ("Window", "Окно"),
        ("Door", "Дверь"),
        ("Wardrobe", "Шкаф"),
        ("Mirror", "Зеркало"),
        ("Curtain", "Штора"),
        ("Carpet", "Ковер"),
        ("Pillow", "Подушка"),
        ("Blanket", "Одеяло"),
    ],
    "Электроника": [
        ("Phone", "Телефон"),
        ("Laptop", "Ноутбук"),
        ("Tablet", "Планшет"),
        ("Computer", "Компьютер"),
        ("TV", "Телевизор"),
        ("Camera", "Камера"),
        ("Headphones", "Наушники"),
        ("Smartwatch", "Смарт-часы"),
    ],
    "Школа и канцелярия": [
        ("Book", "Книга"),
        ("Notebook", "Тетрадь"),
        ("Pen", "Ручка"),
        ("Pencil", "Карандаш"),
        ("Eraser", "Ластик"),
        ("Ruler", "Линейка"),
        ("Bag", "Рюкзак"),
        ("Marker", "Маркер"),
        ("Glue", "Клей"),
    ],
    "Природа": [
        ("Tree", "Дерево"),
        ("Grass", "Трава"),
        ("Flower", "Цветок"),
        ("Leaf", "Лист"),
        ("Mountain", "Гора"),
        ("River", "Река"),
        ("Lake", "Озеро"),
        ("Sea", "Море"),
        ("Sky", "Небо"),
        ("Cloud", "Облако"),
        ("Sun", "Солнце"),
        ("Moon", "Луна"),
        ("Star", "Звезда"),
    ],
    "Части тела": [
        ("Head", "Голова"),
        ("Hair", "Волосы"),
        ("Eye", "Глаз"),
        ("Ear", "Ухо"),
        ("Nose", "Нос"),
        ("Mouth", "Рот"),
        ("Hand", "Рука"),
        ("Foot", "Ступня"),
        ("Leg", "Нога"),
        ("Finger", "Палец"),
    ],
    "Глаголы": [
        ("Run", "Бежать"),
        ("Walk", "Идти"),
        ("Jump", "Прыгать"),
        ("Sleep", "Спать"),
        ("Eat", "Есть"),
        ("Drink", "Пить"),
        ("Read", "Читать"),
        ("Write", "Писать"),
        ("Sing", "Петь"),
        ("Dance", "Танцевать"),
    ],
    "Любимые детские места для игр": [
        ("Playground", "Детская площадка"),
        ("Swing", "Качели"),
        ("Slide", "Горка"),
        ("Sandbox", "Песочница"),
        ("Trampoline", "Батут"),
        ("Pool", "Бассейн"),
        ("Gym", "Спортивный зал"),
        ("Park", "Парк"),
        ("Zoo", "Зоопарк"),
        ("Carousel", "Карусели"),
        ("Cinema", "Кинотеатр"),
    ],
    "Эмоции и чувства": [
        ("Joy", "Радость (весёлый)"),
        ("Sadness", "Грусть (грустный)"),
        ("Anger", "Злость (сердитый)"),
        ("Fear", "Страх (испуганный)"),
        ("Surprise", "Удивление (удивлённый)"),
        ("Calm", "Спокойствие (спокойный)"),
        ("Fatigue", "Усталость (усталый)"),
        ("Excitement", "Волнение (взволнованный)"),
        ("Boredom", "Скука (скучающий)"),
        ("Embarrassment", "Смущение (смущённый)"),
        ("Love", "Любовь (обнимающий)"),
        ("Envy", "Зависть (завистливый)"),
        ("Pride", "Гордость (гордый)"),
    ],
    "Боли и физическое состояние": [
        ("Headache", "Болит голова"),
        ("Stomachache", "Болит живот"),
        ("Toothache", "Болит зуб"),
        ("Earache", "Болит ухо"),
        ("Leg pain", "Болит нога"),
        ("Arm pain", "Болит рука"),
        ("Weakness", "Чувствую слабость"),
        ("Fever", "Жар (повышенная температура)"),
        ("Chills", "Озноб"),
        ("Cough", "Кашель"),
        ("Runny nose", "Насморк"),
        ("Need to go to the toilet", "Хочу в туалет"),
        ("Want to sleep", "Хочу спать"),
        ("Want to eat", "Хочу есть"),
        ("I'm cold", "Мне холодно"),
        ("I'm hot", "Мне жарко"),
    ],
    "Игрушки и игры": [
        ("Ball", "Мяч"),
        ("Toy car", "Машинка"),
        ("Doll", "Кукла"),
        ("Blocks", "Кубики"),
        ("Puzzle", "Пазл"),
        ("Lego", "Конструктор (LEGO)"),
        ("Teddy bear", "Мягкая игрушка (медвежонок)"),
        ("Spinning top", "Юла"),
        ("Board game", "Настольная игра"),
        ("Pinwheel", "Вертушка"),
        ("Wooden figures", "Деревянные фигурки"),
        ("Toy phone", "Игрушечный телефон"),
        ("Toy tool", "Игрушечный инструмент (молоток, отвертка)"),
        ("Musical instrument", "Музыкальный инструмент (барабан, пианино, ксилофон)"),
        ("Picture book", "Книга с картинками"),
        ("Water coloring", "Водные раскраски"),
        ("Remote control car", "Машинка на пульте управления"),
        ("Toy train", "Игрушечный поезд"),
        ("Toy airplane", "Игрушечный самолёт"),
        ("Baby doll", "Пупс"),
        ("Dollhouse", "Домик для кукол"),
        ("Garage for cars", "Гараж для машинок"),
        ("Toy kitchen", "Игрушечная кухня"),
        ("Inflatable ball", "Надувной шар"),
        ("Play tent", "Игровая палатка"),
        ("Slime", "Лизун (слайм)"),
    ],
}


def load_data():
    for category_name, words in data.items():
        category, _ = Category.objects.get_or_create(name=category_name)

        cards = []
        for eng, rus in words:
            audio_path = os.path.join(AUDIO_CHECK_DIR, f"{eng}.mp3")
            image_path = os.path.join(IMAGE_CHECK_DIR, f"{eng}.svg")

            if os.path.exists(audio_path) and os.path.exists(image_path):
                cards.append(Card(category=category, title=rus, audio=f"{AUDIO_DIR}/{eng}.mp3", image=f"{IMAGE_DIR}/{eng}.svg"))
            else:
                print(f"Файл отсутствует: {audio_path if not os.path.exists(audio_path) else ''} "
                      f"{image_path if not os.path.exists(image_path) else ''}")

        if cards:
            Card.objects.bulk_create(cards)

load_data()

