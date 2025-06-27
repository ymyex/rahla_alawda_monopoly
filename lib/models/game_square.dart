class GameSquare {
  final String name;
  final String? type; // 'start', 'city', 'station', 'utility', 'card', 'penalty', 'rest', 'jail'
  final int? price;
  final String? description;

  GameSquare({
    required this.name, 
    this.type, 
    this.price,
    this.description,
  });
}

final List<GameSquare> boardSquares = [
  // Starting from bottom right corner, going counterclockwise
  
  // Corner 1: Start (انطلق)
  GameSquare(name: "انطلق", type: "start", description: "نقطة البداية - اجمع 200 دك"),
  
  // Bottom edge (right to left)
  GameSquare(name: "مكة", type: "city", price: 60, description: "المدينة المقدسة"),
  GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة من صندوق الأمة"),
  GameSquare(name: "المدينة", type: "city", price: 60, description: "المدينة المنورة"),
  GameSquare(name: "ضريبة الدخل", type: "penalty", price: 200, description: "ادفع ضريبة 200 دك"),
  GameSquare(name: "محطة الحجازي", type: "station", price: 200, description: "محطة سكة حديد"),
  GameSquare(name: "جدة", type: "city", price: 100, description: "عروس البحر الأحمر"),
  GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
  GameSquare(name: "دمشق", type: "city", price: 100, description: "الشام الشريف"),
  GameSquare(name: "القدس", type: "city", price: 120, description: "مدينة السلام"),
  
  // Corner 2: Jail (السجن)
  GameSquare(name: "السجن", type: "jail", description: "مجرد زيارة أو محبوس"),
  
  // Left edge (bottom to top)
  GameSquare(name: "حمص", type: "city", price: 140, description: "مدينة خالد بن الوليد"),
  GameSquare(name: "شركة الكهرباء", type: "utility", price: 150, description: "شركة الخدمات العامة"),
  GameSquare(name: "حلب", type: "city", price: 140, description: "الشهباء"),
  GameSquare(name: "عمان", type: "city", price: 160, description: "عاصمة الأردن"),
  GameSquare(name: "محطة الشام", type: "station", price: 200, description: "محطة سكة حديد"),
  GameSquare(name: "بيروت", type: "city", price: 180, description: "باريس الشرق"),
  GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة من صندوق الأمة"),
  GameSquare(name: "صور", type: "city", price: 180, description: "مدينة صور التاريخية"),
  GameSquare(name: "صيدا", type: "city", price: 200, description: "مدينة صيدا الأثرية"),
  
  // Corner 3: Free Parking (موقف مجاني)
  GameSquare(name: "موقف مجاني", type: "rest", description: "استراحة مجانية"),
  
  // Top edge (left to right)
  GameSquare(name: "طرابلس", type: "city", price: 220, description: "طرابلس الشام"),
  GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
  GameSquare(name: "اللاذقية", type: "city", price: 220, description: "عروس الساحل السوري"),
  GameSquare(name: "حماة", type: "city", price: 240, description: "مدينة النواعير"),
  GameSquare(name: "محطة العراق", type: "station", price: 200, description: "محطة سكة حديد"),
  GameSquare(name: "بغداد", type: "city", price: 260, description: "عاصمة الرشيد"),
  GameSquare(name: "الكوفة", type: "city", price: 260, description: "مدينة الإمام علي"),
  GameSquare(name: "شركة المياه", type: "utility", price: 150, description: "شركة الخدمات العامة"),
  GameSquare(name: "البصرة", type: "city", price: 280, description: "فيحاء العراق"),
  
  // Corner 4: Go to Jail (اذهب الى السجن)
  GameSquare(name: "اذهب الى السجن", type: "penalty", description: "اذهب مباشرة إلى السجن"),
  
  // Right edge (top to bottom)
  GameSquare(name: "الكويت", type: "city", price: 300, description: "دولة الكويت"),
  GameSquare(name: "عبادان", type: "city", price: 300, description: "مدينة عبادان"),
  GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة من صندوق الأمة"),
  GameSquare(name: "الأحواز", type: "city", price: 320, description: "مدينة الأحواز"),
  GameSquare(name: "محطة الخليج", type: "station", price: 200, description: "محطة سكة حديد"),
  GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
  GameSquare(name: "قطر", type: "city", price: 350, description: "دولة قطر"),
  GameSquare(name: "ضريبة الترف", type: "penalty", price: 100, description: "ادفع ضريبة الترف 100 دك"),
  GameSquare(name: "البحرين", type: "city", price: 400, description: "مملكة البحرين"),
]; 