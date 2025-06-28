import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_square.dart';
import '../models/team.dart';
import '../services/game_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'dart:math';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        final squares = gameService.boardSquares;

        if (squares.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final boardSize = constraints.maxWidth;

                    return Stack(
                      children: [
                        // Board background image
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: Image.asset(
                            'assets/images/board.jpg',
                            width: boardSize,
                            height: boardSize,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: boardSize,
                                height: boardSize,
                                color: Colors.grey.shade300,
                                child: const Center(
                                  child: Text(
                                    'Board image not found\nPlease ensure board.jpg is in assets/images/',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),

                        // Team circles overlay
                        ..._buildAllTeamCircles(
                          context,
                          gameService,
                          boardSize,
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildAllTeamCircles(
    BuildContext context,
    GameService gameService,
    double boardSize,
  ) {
    final teams = gameService.teams;
    List<Widget> teamWidgets = [];

    // Group teams by position
    Map<int, List<Team>> teamsByPosition = {};
    for (var team in teams) {
      if (!teamsByPosition.containsKey(team.position)) {
        teamsByPosition[team.position] = [];
      }
      teamsByPosition[team.position]!.add(team);
    }

    // Create team widgets for each position
    for (var entry in teamsByPosition.entries) {
      final position = entry.key;
      final teamsAtPosition = entry.value;

      teamWidgets.add(
        _buildTeamCirclesOnSquare(
          context,
          position,
          teamsAtPosition,
          boardSize,
          gameService,
        ),
      );
    }

    return teamWidgets;
  }

  Widget _buildTeamCirclesOnSquare(
    BuildContext context,
    int position,
    List<Team> teams,
    double boardSize,
    GameService gameService,
  ) {
    final squarePosition = _getSquarePositionOnImage(position, boardSize);
    final teamCircleSize = boardSize * 0.03; // Slightly smaller for better fit

    return Positioned(
      left: squarePosition.dx - (teamCircleSize * 1.5),
      top: squarePosition.dy - (teamCircleSize * 1.5),
      child: SizedBox(
        width: teamCircleSize * 3,
        height: teamCircleSize * 3,
        child: Stack(
          children: teams.asMap().entries.map((entry) {
            final index = entry.key;
            final team = entry.value;

            // Calculate circular position around the center
            final offset = _getTeamCircularOffset(
              index,
              teams.length,
              teamCircleSize,
            );

            return Positioned(
              left: (teamCircleSize * 1.5) + offset.dx - (teamCircleSize / 2),
              top: (teamCircleSize * 1.5) + offset.dy - (teamCircleSize / 2),
              child: GestureDetector(
                onTap: () => _showTeamMenu(context, team),
                child: Container(
                  width: teamCircleSize,
                  height: teamCircleSize,
                  decoration: BoxDecoration(
                    color: team.color,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        blurRadius: 3,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: team.imagePath != null
                      ? ClipOval(
                          child: Image.file(
                            File(team.imagePath!),
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Icon(
                                Icons.person,
                                color: Colors.white,
                                size: teamCircleSize * 0.6,
                              );
                            },
                          ),
                        )
                      : Icon(
                          Icons.person,
                          color: Colors.white,
                          size: teamCircleSize * 0.6,
                        ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Offset _getTeamCircularOffset(
    int teamIndex,
    int totalTeams,
    double circleSize,
  ) {
    if (totalTeams == 1) {
      // Single team stays at center
      return Offset.zero;
    }

    // Calculate angle for this team's position in the circle
    final angle = (teamIndex * 2 * pi) / totalTeams;

    // Radius depends on number of teams - closer together for fewer teams
    double radius;
    if (totalTeams == 2) {
      radius = circleSize * 0.3; // Close for 2 teams
    } else if (totalTeams <= 4) {
      radius = circleSize * 0.5; // Medium for 3-4 teams
    } else {
      radius = circleSize * 0.7; // Farther for 5+ teams
    }

    // Calculate x and y offset using trigonometry
    return Offset(radius * cos(angle), radius * sin(angle));
  }

  // Map square positions to coordinates on the board image
  Offset _getSquarePositionOnImage(int index, double boardSize) {
    // Calculate square positioning directly on the board image
    // Calculate square width considering 9 regular squares + 1 corner (1.73x)
    final squareWidth =
        boardSize / (9 + 1.73 + 1.73); // Total: 10.73 units per side
    final cornerSize = squareWidth * 1.73; // Corners are 1.73x larger

    if (index <= 10) {
      // Bottom edge: right to left (نقطة البداية to السجن)
      if (index == 0) {
        // Corner square - bottom right
        return Offset(
          boardSize - (cornerSize / 2),
          boardSize - (cornerSize / 2),
        );
      } else if (index == 10) {
        // Corner square - bottom left
        return Offset(cornerSize / 2, boardSize - (cornerSize / 2));
      } else {
        // Regular bottom edge squares
        return Offset(
          boardSize -
              cornerSize -
              ((index - 1) * squareWidth) -
              (squareWidth / 2),
          boardSize - (squareWidth / 2),
        );
      }
    } else if (index <= 20) {
      // Left edge: bottom to top (السجن to دار الضيافة)
      if (index == 20) {
        // Corner square - top left
        return Offset(cornerSize / 2, cornerSize / 2);
      } else {
        // Regular left edge squares
        return Offset(
          squareWidth / 2,
          boardSize -
              cornerSize -
              ((index - 11) * squareWidth) -
              (squareWidth / 2),
        );
      }
    } else if (index <= 30) {
      // Top edge: left to right (دار الضيافة to اذهب إلى السجن)
      if (index == 30) {
        // Corner square - top right
        return Offset(boardSize - (cornerSize / 2), cornerSize / 2);
      } else {
        // Regular top edge squares
        return Offset(
          cornerSize + ((index - 21) * squareWidth) + (squareWidth / 2),
          squareWidth / 2,
        );
      }
    } else {
      // Right edge: top to bottom (اذهب إلى السجن to نقطة البداية)
      return Offset(
        boardSize - (squareWidth / 2),
        cornerSize + ((index - 31) * squareWidth) + (squareWidth / 2),
      );
    }
  }

  void _showTeamMenu(BuildContext context, Team team) {
    final gameService = Provider.of<GameService>(context, listen: false);
    final TextEditingController stepsController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.6,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: team.color,
                    radius: 25,
                    child: team.imagePath != null
                        ? ClipOval(
                            child: Image.file(
                              File(team.imagePath!),
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                );
                              },
                            ),
                          )
                        : const Icon(Icons.person, color: Colors.white),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    team.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              const Text(
                'الصورة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  ElevatedButton.icon(
                    onPressed: () => _pickImageFromGallery(context, team),
                    icon: const Icon(Icons.photo_library),
                    label: const Text('من المعرض'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton.icon(
                    onPressed: () => _pickImageFromCamera(context, team),
                    icon: const Icon(Icons.camera_alt),
                    label: const Text('التقاط صورة'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),

              if (team.imagePath != null) ...[
                const SizedBox(height: 10),
                ElevatedButton.icon(
                  onPressed: () {
                    gameService.updateTeamImage(team.id, null);
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.delete),
                  label: const Text('حذف الصورة'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],

              const SizedBox(height: 20),

              const Text(
                'الموقع الحالي:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.location_on, color: team.color, size: 30),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الموقع: ${team.position}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (team.position < gameService.boardSquares.length)
                            Text(
                              gameService.boardSquares[team.position].name,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              const Text(
                'تحريك الفريق:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stepsController,
                      decoration: const InputDecoration(
                        labelText: 'عدد الخطوات',
                        border: OutlineInputBorder(),
                        hintText: 'أدخل رقم من 1 إلى 12',
                      ),
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      final steps = int.tryParse(stepsController.text);
                      if (steps != null && steps > 0 && steps <= 12) {
                        gameService.moveTeam(team.id, steps);
                        Navigator.pop(context);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('يرجى إدخال رقم صحيح من 1 إلى 12'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: team.color,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 16,
                      ),
                    ),
                    child: const Text('تحريك'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery(BuildContext context, Team team) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final gameService = Provider.of<GameService>(context, listen: false);
      gameService.updateTeamImage(team.id, pickedFile.path);
      Navigator.pop(context);
    }
  }

  Future<void> _pickImageFromCamera(BuildContext context, Team team) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    if (pickedFile != null) {
      final gameService = Provider.of<GameService>(context, listen: false);
      gameService.updateTeamImage(team.id, pickedFile.path);
      Navigator.pop(context);
    }
  }
}
