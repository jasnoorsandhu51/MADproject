import 'package:flutter/material.dart';

void main() {
  runApp(const RunMyApp());
}

class RunMyApp extends StatefulWidget {
  const RunMyApp({super.key});

  @override
  State<RunMyApp> createState() => _RunMyAppState();
}

class _RunMyAppState extends State<RunMyApp> {
  // Variable to manage the current theme mode
  ThemeMode _themeMode = ThemeMode.system;

  // Method to toggle the theme
  void changeTheme(ThemeMode themeMode) {
    setState(() {
      _themeMode = themeMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Theme Demo',

      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        scaffoldBackgroundColor: Colors.grey[200], // Light mode background
      ),
      darkTheme: ThemeData.dark(), // Dark mode configuration

      themeMode: _themeMode, // Connects the state to the app

      home: Scaffold(
        appBar: AppBar(title: const Text('Theme Demo')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // PART 1 TASK: Container and Text
              AnimatedContainer(
                duration: const Duration(milliseconds: 500), // Task 3
                color: _themeMode == ThemeMode.dark
                    ? Colors.white
                    : Colors.grey, // Task 1
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const Text(
                      'Mobile App Development Testing',
                      style: TextStyle(fontSize: 18),
                    ),

                    // Task 2 & 4: Switch with Dynamic Icon
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _themeMode == ThemeMode.dark
                              ? Icons.nightlight_round
                              : Icons.wb_sunny,
                        ),
                        Switch(
                          // Here's the toggle switch for the themes
                          value: _themeMode == ThemeMode.dark,
                          onChanged: (isDark) {
                            setState(() {
                              _themeMode = isDark
                                  ? ThemeMode.dark
                                  : ThemeMode.light;
                            });
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              const Text('Choose the Theme:', style: TextStyle(fontSize: 16)),

              const SizedBox(height: 10),

              // PART 1 TASK: Controls
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.light),
                    child: const Text('Light Theme'),
                  ),
                  ElevatedButton(
                    onPressed: () => changeTheme(ThemeMode.dark),
                    child: const Text('Dark Theme'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
