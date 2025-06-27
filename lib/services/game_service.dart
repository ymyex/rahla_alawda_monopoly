import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/game_square.dart';
import '../models/team.dart';

class GameService extends ChangeNotifier {
  List<Team> _teams = [];
  List<GameSquare> _boardSquares = [];
  String? _gameMessage;

  GameService() {
    _initializeGame();
  }

  void _initializeGame() {
    // Initialize teams - hardcode them to ensure they load
    _teams = [
      Team(id: 0, name: "الفريق الأحمر", icon: Icons.directions_walk, color: Colors.red),
      Team(id: 1, name: "الفريق الأزرق", icon: Icons.directions_run, color: Colors.blue),
      Team(id: 2, name: "الفريق الأخضر", icon: Icons.emoji_people, color: Colors.green),
      Team(id: 3, name: "الفريق الأصفر", icon: Icons.person, color: Colors.amber),
      Team(id: 4, name: "الفريق البنفسجي", icon: Icons.accessibility, color: Colors.purple),
      Team(id: 5, name: "الفريق البرتقالي", icon: Icons.sports_martial_arts, color: Colors.orange),
    ];
    
    // Initialize board squares - try importing first, fallback to hardcoded
    try {
      _boardSquares = List.from(boardSquares);
      if (_boardSquares.isEmpty) {
        _createDefaultBoard();
      }
    } catch (e) {
      print('Error loading board squares: $e');
      _createDefaultBoard();
    }
    
    // Debug prints
    print('GameService initialized');
    print('Teams count: ${_teams.length}');
    print('Board squares count: ${_boardSquares.length}');
    if (_boardSquares.isNotEmpty) {
      print('First square: ${_boardSquares[0].name}');
      print('Last square: ${_boardSquares.last.name}');
    }
  }

  void _createDefaultBoard() {
    _boardSquares = [
      // Test board with just a few squares to verify it works
      GameSquare(name: "انطلق", type: "start", description: "نقطة البداية"),
      GameSquare(name: "مكة", type: "city", price: 60, description: "المدينة المقدسة"),
      GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة"),
      GameSquare(name: "المدينة", type: "city", price: 60, description: "المدينة المنورة"),
      GameSquare(name: "ضريبة الدخل", type: "penalty", price: 200, description: "ادفع ضريبة"),
      GameSquare(name: "محطة الحجازي", type: "station", price: 200, description: "محطة سكة حديد"),
      GameSquare(name: "جدة", type: "city", price: 100, description: "عروس البحر الأحمر"),
      GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
      GameSquare(name: "دمشق", type: "city", price: 100, description: "الشام الشريف"),
      GameSquare(name: "القدس", type: "city", price: 120, description: "مدينة السلام"),
      GameSquare(name: "السجن", type: "jail", description: "مجرد زيارة أو محبوس"),
      GameSquare(name: "حمص", type: "city", price: 140, description: "مدينة خالد بن الوليد"),
      GameSquare(name: "شركة الكهرباء", type: "utility", price: 150, description: "شركة الخدمات"),
      GameSquare(name: "حلب", type: "city", price: 140, description: "الشهباء"),
      GameSquare(name: "عمان", type: "city", price: 160, description: "عاصمة الأردن"),
      GameSquare(name: "محطة الشام", type: "station", price: 200, description: "محطة سكة حديد"),
      GameSquare(name: "بيروت", type: "city", price: 180, description: "باريس الشرق"),
      GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة"),
      GameSquare(name: "صور", type: "city", price: 180, description: "مدينة صور"),
      GameSquare(name: "صيدا", type: "city", price: 200, description: "مدينة صيدا"),
      GameSquare(name: "موقف مجاني", type: "rest", description: "استراحة مجانية"),
      GameSquare(name: "طرابلس", type: "city", price: 220, description: "طرابلس الشام"),
      GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
      GameSquare(name: "اللاذقية", type: "city", price: 220, description: "عروس الساحل"),
      GameSquare(name: "حماة", type: "city", price: 240, description: "مدينة النواعير"),
      GameSquare(name: "محطة العراق", type: "station", price: 200, description: "محطة سكة حديد"),
      GameSquare(name: "بغداد", type: "city", price: 260, description: "عاصمة الرشيد"),
      GameSquare(name: "الكوفة", type: "city", price: 260, description: "مدينة الإمام علي"),
      GameSquare(name: "شركة المياه", type: "utility", price: 150, description: "شركة خدمات"),
      GameSquare(name: "البصرة", type: "city", price: 280, description: "فيحاء العراق"),
      GameSquare(name: "اذهب الى السجن", type: "penalty", description: "اذهب مباشرة للسجن"),
      GameSquare(name: "الكويت", type: "city", price: 300, description: "دولة الكويت"),
      GameSquare(name: "عبادان", type: "city", price: 300, description: "مدينة عبادان"),
      GameSquare(name: "صندوق", type: "card", description: "اسحب بطاقة"),
      GameSquare(name: "الأحواز", type: "city", price: 320, description: "مدينة الأحواز"),
      GameSquare(name: "محطة الخليج", type: "station", price: 200, description: "محطة سكة حديد"),
      GameSquare(name: "فرصة", type: "card", description: "اسحب بطاقة فرصة"),
      GameSquare(name: "قطر", type: "city", price: 350, description: "دولة قطر"),
      GameSquare(name: "ضريبة الترف", type: "penalty", price: 100, description: "ادفع ضريبة الترف"),
      GameSquare(name: "البحرين", type: "city", price: 400, description: "مملكة البحرين"),
    ];
  }

  List<Team> get teams => _teams;
  List<GameSquare> get boardSquares => _boardSquares;
  String? get gameMessage => _gameMessage;
  int get boardSize => _boardSquares.length;

  void moveTeam(int teamId, int steps) {
    if (teamId < 0 || teamId >= _teams.length) return;
    if (_boardSquares.isEmpty) return;
    
    final team = _teams[teamId];
    final oldPosition = team.position;
    
    team.moveBy(steps, boardSize);
    
    final newSquare = _boardSquares[team.position];
    String message = "${team.name} انتقل من ${_boardSquares[oldPosition].name} إلى ${newSquare.name}";
    
    if (newSquare.price != null) {
      message += " - السعر: ${newSquare.price} دك";
    }
    
    _gameMessage = message;
    notifyListeners();
  }

  void updateTeamImage(int teamId, String? imagePath) {
    if (teamId >= 0 && teamId < _teams.length) {
      _teams[teamId].imagePath = imagePath;
      notifyListeners();
    }
  }

  void resetGame() {
    for (var team in _teams) {
      team.position = 0;
    }
    _gameMessage = "تم إعادة تعيين اللعبة";
    notifyListeners();
  }

  Team getTeam(int teamId) {
    return _teams[teamId];
  }

  GameSquare getSquare(int position) {
    if (position < 0 || position >= _boardSquares.length) return _boardSquares[0];
    return _boardSquares[position];
  }

  List<Team> getTeamsAtPosition(int position) {
    return _teams.where((team) => team.position == position).toList();
  }

  void clearMessage() {
    _gameMessage = null;
    notifyListeners();
  }
} 