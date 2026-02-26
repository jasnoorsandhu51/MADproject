import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // State variable to track the current theme mode
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculator App',
      // Theme Toggle Feature: Switch between light and dark themes
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: CalculatorApp(
        isDarkMode: _isDarkMode,
        onThemeChanged: (isDark) {
          setState(() {
            _isDarkMode = isDark;
          });
        },
      ),
    );
  }
}

class CalculatorApp extends StatefulWidget {
  final bool isDarkMode;
  final Function(bool) onThemeChanged;

  const CalculatorApp({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<CalculatorApp> createState() => _CalculatorAppState();
}

class _CalculatorAppState extends State<CalculatorApp> {
  // Display variables
  String _display = '0';
  String _previousValue = '';
  String _operator = '';
  bool _startNewNumber = true;
  String? _errorMessage;

  /// Handles number button presses
  void _onNumberPressed(String number) {
    setState(() {
      _errorMessage = null; // Clear any previous error messages

      if (_startNewNumber) {
        _display = number;
        _startNewNumber = false;
      } else {
        // Prevent multiple decimal points
        if (number == '.' && _display.contains('.')) {
          return;
        }
        _display += number;
      }
    });
  }

  /// Handles operator button presses
  void _onOperatorPressed(String op) {
    setState(() {
      _errorMessage = null; // Clear any previous error messages

      // Error Handling Feature: Check for incomplete input
      if (_display.isEmpty || _display == '.') {
        _errorMessage = 'Invalid input';
        return;
      }

      if (_operator.isNotEmpty && !_startNewNumber) {
        // If there's already an operator, calculate the result first
        _calculate();
      }

      _previousValue = _display;
      _operator = op;
      _startNewNumber = true;
    });
  }

  /// Performs arithmetic calculations
  /// Uses Dart arithmetic operations for addition, subtraction, multiplication, and division
  void _calculate() {
    if (_previousValue.isEmpty || _operator.isEmpty || _display.isEmpty) {
      return;
    }

    try {
      double num1 = double.parse(_previousValue);
      double num2 = double.parse(_display);
      double result;

      // Perform the arithmetic operation based on the selected operator
      switch (_operator) {
        case '+':
          result = num1 + num2;
          break;
        case '-':
          result = num1 - num2;
          break;
        case '*':
          result = num1 * num2;
          break;
        case '/':
          // Error Handling Feature: Division by zero detection
          if (num2 == 0) {
            setState(() {
              _errorMessage = 'Cannot divide by 0';
              _display = '0';
              _previousValue = '';
              _operator = '';
              _startNewNumber = true;
            });
            return;
          }
          result = num1 / num2;
          break;
        default:
          return;
      }

      // Format the result to remove unnecessary decimal places
      if (result == result.toInt()) {
        _display = result.toInt().toString();
      } else {
        _display = result
            .toStringAsFixed(8)
            .replaceAll(RegExp(r'0+$'), '')
            .replaceAll(RegExp(r'\.$'), '');
      }

      _previousValue = '';
      _operator = '';
      _startNewNumber = true;
    } catch (e) {
      setState(() {
        _errorMessage = 'Error in calculation';
      });
    }
  }

  /// Handles equals button press to show the final result
  void _onEquals() {
    setState(() {
      _errorMessage = null;

      // Error Handling Feature: Check for incomplete input
      if (_operator.isEmpty || _previousValue.isEmpty) {
        _errorMessage = 'Incomplete operation';
        return;
      }

      _calculate();
    });
  }

  /// Clear/AC Button Feature: Resets the calculator to initial state
  void _clearAll() {
    setState(() {
      _display = '0';
      _previousValue = '';
      _operator = '';
      _startNewNumber = true;
      _errorMessage = null;
    });
  }

  /// Builds a calculator button with consistent styling
  Widget _buildButton(
    String label,
    VoidCallback onPressed, {
    Color? backgroundColor,
    Color? textColor,
    double? fontSize,
  }) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: backgroundColor,
            padding: const EdgeInsets.symmetric(vertical: 20),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: onPressed,
          child: Text(
            label,
            style: TextStyle(
              fontSize: fontSize ?? 24,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculator'),
        centerTitle: true,
        actions: [
          // Theme Toggle Button Feature: Switch between light and dark themes
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () {
              widget.onThemeChanged(!widget.isDarkMode);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display Area
          Expanded(
            flex: 2,
            child: Container(
              padding: const EdgeInsets.all(16),
              color: colorScheme.surface,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // Show error message if any
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(
                          fontSize: 18,
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  // Main display
                  Text(
                    _display,
                    style: TextStyle(
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  // Show current operator if one is selected
                  if (_operator.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        'Operator: $_operator',
                        style: TextStyle(
                          fontSize: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Button Grid
          Expanded(
            flex: 3,
            child: Container(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  // Row 1: Clear and operators
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: _clearAll,
                            child: const Text(
                              'AC',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildButton(
                        '/',
                        () => _onOperatorPressed('/'),
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                      ),
                      _buildButton(
                        '*',
                        () => _onOperatorPressed('*'),
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                      ),
                      _buildButton(
                        '-',
                        () => _onOperatorPressed('-'),
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  // Row 2: 7, 8, 9, +
                  Row(
                    children: [
                      _buildButton('7', () => _onNumberPressed('7')),
                      _buildButton('8', () => _onNumberPressed('8')),
                      _buildButton('9', () => _onNumberPressed('9')),
                      _buildButton(
                        '+',
                        () => _onOperatorPressed('+'),
                        backgroundColor: colorScheme.primary,
                        textColor: colorScheme.onPrimary,
                      ),
                    ],
                  ),
                  // Row 3: 4, 5, 6, backspace
                  Row(
                    children: [
                      _buildButton('4', () => _onNumberPressed('4')),
                      _buildButton('5', () => _onNumberPressed('5')),
                      _buildButton('6', () => _onNumberPressed('6')),
                      _buildButton(
                        '⌫',
                        () {
                          setState(() {
                            _errorMessage = null;
                            if (_display.length > 1) {
                              _display = _display.substring(
                                0,
                                _display.length - 1,
                              );
                            } else {
                              _display = '0';
                              _startNewNumber = true;
                            }
                          });
                        },
                        backgroundColor: Colors.orange,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  // Row 4: 1, 2, 3, equals
                  Row(
                    children: [
                      _buildButton('1', () => _onNumberPressed('1')),
                      _buildButton('2', () => _onNumberPressed('2')),
                      _buildButton('3', () => _onNumberPressed('3')),
                      _buildButton(
                        '=',
                        _onEquals,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                      ),
                    ],
                  ),
                  // Row 5: 0 and decimal point
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            onPressed: () => _onNumberPressed('0'),
                            child: const Text(
                              '0',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      _buildButton('.', () => _onNumberPressed('.')),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
