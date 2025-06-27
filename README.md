# رحلة العودة - مونوبولي
## Return Journey - Monopoly Style Board Game

A Flutter desktop application for a Monopoly-style board game with Arabic theme and historical cities.

![Game Preview](https://img.shields.io/badge/Flutter-Desktop%20App-blue)
![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20macOS%20%7C%20Linux-green)

## 🎮 Game Features

### Core Gameplay
- **6 Teams**: Each represented by unique icons and colors
- **37 Board Squares**: Including cities, stations, actions, penalties, and special tiles
- **Team Movement**: Select team, enter steps, and move around the board
- **Real-time Updates**: Visual feedback and position tracking
- **Arabic Support**: Full RTL text support and Arabic naming

### Board Layout
The game includes historically significant locations:
- **Cities**: مكة، المدينة، غزة، دمشق، القدس، بغداد، القاهرة، قرطبة، etc.
- **Stations**: محطة الغزاة، الرباط، محطة لنصر، محطة العودة
- **Special Tiles**: غنيمة، دار الضيافة، السجن، صندوق الفاتحين
- **Action/Penalty**: Various gameplay mechanics

### Teams
1. **الفريق الأحمر** (Red Team) - Walking Icon
2. **الفريق الأزرق** (Blue Team) - Running Icon  
3. **الفريق الأخضر** (Green Team) - People Icon
4. **الفريق الأصفر** (Yellow Team) - Person Icon
5. **الفريق البنفسجي** (Purple Team) - Accessibility Icon
6. **الفريق البرتقالي** (Orange Team) - Martial Arts Icon

## 🏗️ Architecture

### Project Structure
```
lib/
├── main.dart                 # Main application entry
├── models/
│   ├── game_square.dart     # Board square definitions
│   └── team.dart            # Team model and data
├── services/
│   └── game_service.dart    # Game state management
└── widgets/
    ├── board_widget.dart    # Custom board painter
    └── control_panel.dart   # Game controls UI
```

### Key Components

#### GameService (State Management)
- Manages team positions and game state
- Handles team movement logic
- Provides game messages and notifications
- Uses Flutter's `ChangeNotifier` for reactive updates

#### BoardWidget (Custom Painter)
- Renders the circular board layout
- Color-coded squares by type
- Real-time team position visualization
- Responsive square sizing

#### ControlPanel
- Team selection dropdown
- Step input validation
- Move and reset functionality
- Live team position display

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (>=3.8.1)
- Dart SDK
- Desktop development tools (Windows/macOS/Linux)

### Installation
1. Clone or download the project
2. Navigate to project directory:
   ```bash
   cd rahla_alawda_monopoly
   ```
3. Install dependencies:
   ```bash
   flutter pub get
   ```
4. Run the application:
   ```bash
   flutter run -d windows
   # or for web
   flutter run -d chrome
   ```

### Dependencies
- `flutter`: Core Flutter framework
- `provider`: State management solution
- `cupertino_icons`: iOS-style icons

## 🎯 How to Play

1. **Select a Team**: Choose from 6 available teams using the dropdown
2. **Enter Steps**: Input the number of steps to move (1-12 typical)
3. **Move**: Click the "تحرك" (Move) button to advance the team
4. **Track Progress**: Monitor team positions in the side panel
5. **Reset Game**: Use "إعادة تعيين" to reset all teams to start

### Game Mechanics
- Teams move clockwise around the board
- Movement wraps around (position 37 → position 0)
- Multiple teams can occupy the same square
- Each square type has different colors for easy identification

## 🔧 Customization & Extension

### Adding New Features
The architecture supports easy extension:

1. **New Square Types**: Add to `GameSquare.type` enum
2. **Property System**: Extend `GameSquare` with ownership data
3. **Card Actions**: Implement card drawing mechanics
4. **Economy System**: Add money/resource management
5. **Dice Rolling**: Replace manual step input with dice
6. **Player Profiles**: Add player names and avatars

### Board Modifications
- Edit `boardSquares` list in `game_square.dart`
- Modify square colors in `BoardPainter._getSquareColor()`
- Adjust board layout in `BoardPainter._getSquarePosition()`

### UI Customization
- Modify team icons and colors in `team.dart`
- Customize themes in `main.dart`
- Adjust responsive breakpoints in `GameScreen`

## 🐛 Known Issues

1. **Path with Arabic Characters**: May cause build issues on Windows
2. **Square Text Size**: Very small on smaller screens
3. **Team Overlap**: Multiple teams on same square may overlap

### Solutions
1. Move project to path without special characters
2. Adjust font sizes in `BoardPainter`
3. Implement better team positioning algorithm

## 🛠️ Technical Details

### State Management
Uses Provider pattern with `ChangeNotifier` for reactive UI updates.

### Custom Painting
Board rendering uses Flutter's `CustomPainter` for precise control over:
- Square positioning and sizing
- Text rendering with RTL support
- Team marker placement
- Color coding by square type

### Responsive Design
- Wide screens: Side-by-side layout (board + controls)
- Narrow screens: Stacked layout (board above controls)
- Breakpoint: 1200px width

## 📈 Future Enhancements

### Phase 1: Core Game Mechanics
- [ ] Dice rolling animation
- [ ] Property purchasing system
- [ ] Rent collection
- [ ] Player money management

### Phase 2: Advanced Features
- [ ] Card system implementation
- [ ] AI players
- [ ] Save/load game state
- [ ] Multiplayer support

### Phase 3: Polish & UX
- [ ] Sound effects
- [ ] Animations for team movement
- [ ] Better mobile responsive design
- [ ] Themes and customization options

## 📄 License

This project is created for educational and demonstration purposes.

## 🤝 Contributing

This is a demonstration project. Feel free to fork and extend for your own use cases.

---

**Built with Flutter** 💙 **Supports Arabic** 🌟 **Desktop Ready** 🖥️
