import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/game_square.dart';
import '../models/team.dart';
import '../services/game_service.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class BoardWidget extends StatelessWidget {
  const BoardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<GameService>(
      builder: (context, gameService, child) {
        final squares = gameService.boardSquares;
        
        if (squares.isEmpty) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return Container(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: AspectRatio(
              aspectRatio: 1.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Colors.black, width: 3),
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
                    final squareSize = boardSize / 11;
                    
                    return Stack(
                      children: [
                        // Board squares
                        ...squares.asMap().entries.map((entry) {
                          final index = entry.key;
                          final square = entry.value;
                          final position = _getSquarePosition(index, squareSize);
                          
                          return Positioned(
                            left: position.dx,
                            top: position.dy,
                            child: _buildSquare(square, squareSize, index, gameService),
                          );
                        }),
                        
                        // Center logo with authentic design
                        Center(
                          child: Container(
                            width: squareSize * 9,
                            height: squareSize * 9,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.red.shade600,
                                  Colors.red.shade800,
                                ],
                              ),
                              border: Border.all(color: Colors.black, width: 3),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                // Top decorative element
                                Container(
                                  width: squareSize * 2,
                                  height: squareSize * 0.8,
                                  decoration: BoxDecoration(
                                    color: Colors.amber.shade400,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                  child: Center(
                                    child: Icon(
                                      Icons.location_on,
                                      color: Colors.red.shade800,
                                      size: squareSize * 0.5,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                
                                // Main title
                                Text(
                                  'رحلة العودة',
                                  style: TextStyle(
                                    fontSize: squareSize * 0.6,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black,
                                        offset: const Offset(1, 1),
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                
                                // Bottom decorative element
                                Container(
                                  width: squareSize * 1.5,
                                  height: squareSize * 0.6,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade400,
                                    borderRadius: BorderRadius.circular(6),
                                    border: Border.all(color: Colors.black, width: 2),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '?',
                                      style: TextStyle(
                                        fontSize: squareSize * 0.4,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        // Team circles
                        ..._buildAllTeamCircles(context, gameService, squareSize),
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

  List<Widget> _buildAllTeamCircles(BuildContext context, GameService gameService, double squareSize) {
    final teams = gameService.teams;
    List<Widget> teamWidgets = [];
    
    Map<int, List<Team>> teamsByPosition = {};
    for (var team in teams) {
      if (!teamsByPosition.containsKey(team.position)) {
        teamsByPosition[team.position] = [];
      }
      teamsByPosition[team.position]!.add(team);
    }
    
    for (var entry in teamsByPosition.entries) {
      final position = entry.key;
      final teamsAtPosition = entry.value;
      
      if (position == 0) {
        teamWidgets.add(_buildTeamCirclesOnStart(context, teamsAtPosition, squareSize));
      } else {
        teamWidgets.add(_buildTeamCirclesOnSquare(context, position, teamsAtPosition, squareSize, gameService));
      }
    }
    
    return teamWidgets;
  }

  Widget _buildTeamCirclesOnStart(BuildContext context, List<Team> teams, double squareSize) {
    final startPosition = _getSquarePosition(0, squareSize);
    
    return Positioned(
      left: startPosition.dx + squareSize * 0.1,
      top: startPosition.dy + squareSize * 0.1,
      child: SizedBox(
        width: squareSize * 0.8,
        height: squareSize * 0.8,
        child: GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            childAspectRatio: 1,
            crossAxisSpacing: 2,
            mainAxisSpacing: 2,
          ),
          itemCount: teams.length,
          itemBuilder: (context, index) {
            final team = teams[index];
            return GestureDetector(
              onTap: () => _showTeamMenu(context, team),
              child: Container(
                decoration: BoxDecoration(
                  color: team.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
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
                              size: squareSize * 0.1,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                        size: squareSize * 0.1,
                      ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTeamCirclesOnSquare(BuildContext context, int position, List<Team> teams, double squareSize, GameService gameService) {
    final squarePosition = _getSquarePosition(position, squareSize);
    
    return Positioned(
      left: squarePosition.dx + squareSize * 0.05,
      top: squarePosition.dy + squareSize * 0.05,
      child: SizedBox(
        width: squareSize * 0.9,
        height: squareSize * 0.3,
        child: Wrap(
          spacing: 2,
          runSpacing: 2,
          children: teams.map((team) {
            return GestureDetector(
              onTap: () => _showTeamMenu(context, team),
              child: Container(
                width: squareSize * 0.18,
                height: squareSize * 0.18,
                decoration: BoxDecoration(
                  color: team.color,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.6),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
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
                              size: squareSize * 0.08,
                            );
                          },
                        ),
                      )
                    : Icon(
                        Icons.person,
                        color: Colors.white,
                        size: squareSize * 0.08,
                      ),
              ),
            );
          }).toList(),
        ),
      ),
    );
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
                                return const Icon(Icons.person, color: Colors.white);
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
                    onPressed: () => _pickImage(context, team, gameService),
                    icon: const Icon(Icons.image),
                    label: const Text('اختر صورة'),
                  ),
                  const SizedBox(width: 10),
                  if (team.imagePath != null)
                    ElevatedButton.icon(
                      onPressed: () => gameService.updateTeamImage(team.id, null),
                      icon: const Icon(Icons.delete),
                      label: const Text('إزالة الصورة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 20),
              
              const Text(
                'الحركة:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: stepsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'عدد الخطوات',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () {
                      final steps = int.tryParse(stepsController.text);
                      if (steps != null && steps > 0) {
                        gameService.moveTeam(team.id, steps);
                        Navigator.pop(context);
                      }
                    },
                    child: const Text('تحرك'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              Text(
                'الموقع الحالي: ${gameService.boardSquares[team.position].name}',
                style: const TextStyle(fontSize: 16),
              ),
              if (gameService.boardSquares[team.position].price != null && gameService.boardSquares[team.position].price! > 0)
                Text(
                  'السعر: ${gameService.boardSquares[team.position].price} دك',
                  style: const TextStyle(fontSize: 14, color: Colors.green),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImage(BuildContext context, Team team, GameService gameService) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      gameService.updateTeamImage(team.id, image.path);
    }
  }

  Widget _buildSquare(GameSquare square, double size, int index, GameService gameService) {
    final isCorner = _isCornerSquare(index);
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: _getSquareColor(square.type, index),
        border: Border.all(color: Colors.black, width: 1.5),
        gradient: _getSquareGradient(square.type, index),
      ),
      child: isCorner ? _buildCornerSquare(square, size, index) : _buildRegularSquare(square, size, index),
    );
  }

  bool _isCornerSquare(int index) {
    return index == 0 || index == 10 || index == 20 || index == 30;
  }

  Widget _buildCornerSquare(GameSquare square, double size, int index) {
    IconData icon;
    Color iconColor;
    
    switch (index) {
      case 0: // Start - انطلق
        icon = Icons.play_arrow;
        iconColor = Colors.white;
        break;
      case 10: // Jail - السجن
        icon = Icons.lock;
        iconColor = Colors.white;
        break;
      case 20: // Free Parking - موقف مجاني
        icon = Icons.local_parking;
        iconColor = Colors.white;
        break;
      case 30: // Go to Jail - اذهب الى السجن
        icon = Icons.arrow_forward;
        iconColor = Colors.white;
        break;
      default:
        icon = Icons.location_on;
        iconColor = Colors.white;
    }

    return Container(
      padding: const EdgeInsets.all(4),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: size * 0.3,
            color: iconColor,
          ),
          const SizedBox(height: 2),
          Flexible(
            child: Text(
              square.name,
              style: TextStyle(
                fontSize: size * 0.08,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [
                  Shadow(
                    color: Colors.black,
                    offset: const Offset(0.5, 0.5),
                    blurRadius: 1,
                  ),
                ],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRegularSquare(GameSquare square, double size, int index) {
    return Container(
      padding: const EdgeInsets.all(3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Property color bar for cities
          if (square.type == 'city')
            Container(
              width: double.infinity,
              height: size * 0.15,
              decoration: BoxDecoration(
                color: _getCityColor(index),
                border: Border.all(color: Colors.black, width: 1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          
          // Square name
          Expanded(
            child: Center(
              child: Text(
                square.name,
                style: TextStyle(
                  fontSize: size * 0.07,
                  fontWeight: FontWeight.bold,
                  color: _getTextColor(_getSquareColor(square.type, index)),
                ),
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          
          // Price
          if (square.price != null && square.price! > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
              child: Text(
                '${square.price} دك',
                style: TextStyle(
                  fontSize: size * 0.055,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
        ],
      ),
    );
  }

  Color _getCityColor(int index) {
    // Assign colors based on city groups from the original board
    if (index >= 1 && index <= 3) return Colors.brown; // Brown group
    if (index >= 6 && index <= 9) return Colors.lightBlue; // Light blue group
    if (index >= 11 && index <= 14) return Colors.pink; // Pink group
    if (index >= 16 && index <= 19) return Colors.orange; // Orange group
    if (index >= 21 && index <= 24) return Colors.red; // Red group
    if (index >= 26 && index <= 29) return Colors.yellow; // Yellow group
    if (index >= 31 && index <= 34) return Colors.green; // Green group
    if (index >= 37 && index <= 39) return Colors.blue; // Blue group
    return Colors.grey;
  }

  Color _getSquareColor(String? type, int index) {
    switch (type) {
      case 'start':
        return Colors.green.shade600;
      case 'city':
        return Colors.grey.shade100;
      case 'station':
        return Colors.grey.shade300;
      case 'utility':
        return Colors.purple.shade300;
      case 'penalty':
        return Colors.red.shade400;
      case 'rest':
        return Colors.green.shade400;
      case 'jail':
        return Colors.red.shade600;
      case 'card':
        return Colors.yellow.shade300;
      default:
        return Colors.white;
    }
  }

  LinearGradient? _getSquareGradient(String? type, int index) {
    if (_isCornerSquare(index)) {
      switch (index) {
        case 0: // Start
          return LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade700],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 10: // Jail
          return LinearGradient(
            colors: [Colors.red.shade500, Colors.red.shade800],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 20: // Free Parking
          return LinearGradient(
            colors: [Colors.green.shade400, Colors.green.shade600],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
        case 30: // Go to Jail
          return LinearGradient(
            colors: [Colors.red.shade600, Colors.red.shade900],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          );
      }
    }
    return null;
  }

  Color _getTextColor(Color backgroundColor) {
    return backgroundColor.computeLuminance() > 0.5 ? Colors.black : Colors.white;
  }

  Offset _getSquarePosition(int index, double squareSize) {
    if (index <= 10) {
      return Offset((10 - index) * squareSize, 10 * squareSize);
    }
    else if (index <= 19) {
      return Offset(0, (19 - index) * squareSize);
    }
    else if (index <= 30) {
      return Offset((index - 20) * squareSize, 0);
    }
    else {
      return Offset(10 * squareSize, (index - 30) * squareSize);
    }
  }
} 