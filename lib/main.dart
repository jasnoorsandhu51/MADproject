import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(MaterialApp(home: DigitalPetApp()));
}

class DigitalPetApp extends StatefulWidget {
  @override
  _DigitalPetAppState createState() => _DigitalPetAppState();
}

class _DigitalPetAppState extends State<DigitalPetApp> {
  String petName = "Tweety";

  int happinessLevel = 50;
  int hungerLevel = 50;
  int energyLevel = 50;

  bool _isGameOver = false;
  bool _isWin = false;

  int _happySeconds = 0;

  Timer? _gameTimer;
  Timer? _hungerTimer;

  @override
  void initState() {
    super.initState();
    _startGameLoop();
    _startHungerTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _hungerTimer?.cancel();
    super.dispose();
  }

  // ---------------- GAME LOOP ----------------

  void _startGameLoop() {
    _gameTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      _checkWinLoss();
    });
  }

  void _startHungerTimer() {
    _hungerTimer = Timer.periodic(Duration(seconds: 30), (timer) {
      if (_isGameOver || _isWin) return;

      setState(() {
        hungerLevel += 5;
        if (hungerLevel > 100) hungerLevel = 100;

        if (hungerLevel == 100) {
          happinessLevel -= 20;
          if (happinessLevel < 0) happinessLevel = 0;
        }
      });
    });
  }

  void _checkWinLoss() {
    if (_isGameOver || _isWin) return;

    // WIN: Happiness > 80 for 3 minutes (180 seconds)
    if (happinessLevel > 80) {
      _happySeconds++;
      if (_happySeconds >= 180) {
        setState(() {
          _isWin = true;
        });
        _stopGame();
      }
    } else {
      _happySeconds = 0;
    }

    // LOSS: Hunger == 100 AND Happiness <= 10
    if (hungerLevel == 100 && happinessLevel <= 10) {
      setState(() {
        _isGameOver = true;
      });
      _stopGame();
    }
  }

  void _stopGame() {
    _gameTimer?.cancel();
    _hungerTimer?.cancel();
  }

  // ---------------- PET ACTIONS ----------------

  void _playWithPet() {
    if (_isGameOver || _isWin) return;

    setState(() {
      happinessLevel += 10;
      energyLevel -= 5;
      if (happinessLevel > 100) happinessLevel = 100;

      hungerLevel += 5;
      if (hungerLevel > 100) hungerLevel = 100;
    });
  }

  void _feedPet() {
    if (_isGameOver || _isWin) return;

    setState(() {
      hungerLevel -= 10;
      energyLevel += 5;
      if (hungerLevel < 0) hungerLevel = 0;

      if (hungerLevel < 30) {
        happinessLevel -= 20;
      } else {
        happinessLevel += 10;
      }

      if (happinessLevel > 100) happinessLevel = 100;
      if (happinessLevel < 0) happinessLevel = 0;
    });
  }

  // ---------------- UI HELPERS ----------------

  Color _moodColor(int happinessLevel) {
    if (happinessLevel > 70) {
      return Colors.green;
    } else if (happinessLevel >= 30) {
      return Colors.yellow;
    } else {
      return Colors.red;
    }
  }

  String _statusText() {
    if (_isWin) return "🎉 You Win! Your pet is thriving!";
    if (_isGameOver) return "💀 Game Over";
    if (happinessLevel > 70) return "Your pet is happy!";
    if (happinessLevel >= 30) return "Your pet is neutral.";
    return "Your pet is sad.";
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Digital Pet')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Name: $petName', style: TextStyle(fontSize: 20)),
            SizedBox(height: 16),
            Text(
              'Happiness Level: $happinessLevel',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 16),
            Text('Hunger Level: $hungerLevel', style: TextStyle(fontSize: 20)),
            SizedBox(height: 32),
            Text('Energy Level: $energyLevel', style: TextStyle(fontSize: 20)),
            SizedBox(height: 32),
            DropdownMenu(
              dropdownMenuEntries: [
                DropdownMenuEntry(value: 'Play', label: 'Run'),
                DropdownMenuEntry(value: 'Feed', label: 'Walk'),
              ],
              onSelected: (value) {
                if (value == 'Play') {
                  setState(() {
                    happinessLevel += 10;
                    energyLevel -= 5;
                  });
                } else if (value == 'Feed') {
                  _feedPet();
                }
              },
            ),
            ColorFiltered(
              colorFilter: ColorFilter.mode(
                _moodColor(happinessLevel),
                BlendMode.modulate,
              ),
              child: Image.asset('assets/pet.png', height: 200),
            ),

            SizedBox(height: 16),
            Text(
              _statusText(),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 32),

            TextField(
              decoration: InputDecoration(labelText: 'Enter Pet Name'),
              onChanged: (value) {
                setState(() {
                  petName = value;
                });
              },
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: (_isGameOver || _isWin) ? null : _playWithPet,
              child: Text('Play with Your Pet'),
            ),

            SizedBox(height: 16),

            ElevatedButton(
              onPressed: (_isGameOver || _isWin) ? null : _feedPet,
              child: Text('Feed Your Pet'),
            ),
          ],
        ),
      ),
    );
  }
}
