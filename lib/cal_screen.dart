//IM/2021/120 - L.S.Rajapaksha
// Imported necessary Flutter and math libraries
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart'; // Library for parsing and evaluating mathematical expressions
import 'dart:math'; // Math library for trigonometric and square root functions

// widget for the Cal app
class Calculator extends StatefulWidget {
  @override
  State<Calculator> createState() => _CalculatorState();
}

// class to manage UI and logic
class _CalculatorState extends State<Calculator> {
  String userInput = ""; // stores user input
  String result = "0"; // stores calculation result
  List<String> history = []; // stores history of calculations
  bool showHistory = false;
  bool isResultDisplayed = false;

  // Buttons list for calculator
  List<String> buttonList = [
    'AC',
    '(',
    ')',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '+',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    'C',
    '√',
    '%',
    'sin',
    'cos'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color.fromARGB(217, 211, 246, 190), // Background color for app
      body: Column(
        children: [
          // Display section for user input and results
          SizedBox(
            height: MediaQuery.of(context).size.height /
                3.5, // Adjust display size (dynamically)
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.end, // Align display board with the bottom
              children: [
                // Display user input
                Container(
                  padding: const EdgeInsets.all(10),
                  alignment: Alignment.centerRight, // Align text right
                  child: Text(
                    userInput,
                    style: const TextStyle(fontSize: 32, color: Colors.white),
                  ),
                ),
                // display calculation result
                Container(
                  padding: const EdgeInsets.all(20),
                  alignment: Alignment.centerRight,
                  child: Text(
                    result,
                    style: const TextStyle(
                      fontSize: 48,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // button for history display
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start, // Left align button
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(
                        255, 245, 246, 247), // button background
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  ),
                  onPressed: () {
                    setState(() {
                      showHistory = !showHistory;
                    });
                  },
                  child: const Text('History', style: TextStyle(fontSize: 14)),
                ),
              ],
            ),
          ),

          // history section
          if (showHistory)
            Expanded(
              child: Container(
                color: Colors.black54, // Background color for history section
                child: Column(
                  children: [
                    // clear history button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(255, 230, 244, 76),
                        padding: const EdgeInsets.symmetric(
                            vertical: 5, horizontal: 10),
                      ),
                      onPressed: () {
                        setState(() {
                          history.clear(); // Clear history list
                        });
                      },
                      child: const Text('Clear History',
                          style: TextStyle(fontSize: 14)),
                    ),
                    // Display history items (reverse order)
                    Expanded(
                      child: ListView.builder(
                        reverse: true,
                        itemCount: history.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              history[index],
                              style: const TextStyle(
                                  color: Colors.white, fontSize: 18),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

          //if history is hidden display number pallete
          if (!showHistory)
            Expanded(
              child: GridView.builder(
                itemCount: buttonList.length, // button numbers
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4, // 4 buttons per each row
                  crossAxisSpacing: 12, // space between columns
                  mainAxisSpacing: 12, // space between rows
                ),
                itemBuilder: (BuildContext context, int index) {
                  return CustomButton(
                      buttonList[index]); // Create button for each functions
                },
              ),
            ),
        ],
      ),
    );
  }

  // Custom button
  Widget CustomButton(String text) {
    return InkWell(
      splashColor: const Color.fromARGB(255, 246, 221, 238), // splash effect
      onTap: () {
        setState(() {
          appendValue(text); // handle button press
        });
      },
      child: Ink(
        decoration: BoxDecoration(
          color: getBgColor(text), // background color with button type
          borderRadius: BorderRadius.circular(10), // round the corners
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: getColor(text), // Button text color
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  // value allocation for input
  void appendValue(String value) {
    if (isResultDisplayed && value != "=") {
      // auto-clear functions if a result is displayed
      setState(() {
        userInput = ""; // Clear input
        isResultDisplayed = false; // Reset
      });
    }
    handleButtons(value); // button logic
  }

  // text color for buttons
  getColor(String text) {
    if (text == "÷" ||
        text == "×" ||
        text == "+" ||
        text == "-" ||
        text == "C" ||
        text == "(" ||
        text == ")") {
      return const Color.fromARGB(255, 84, 109, 249); // Operators color
    }
    return const Color.fromARGB(255, 18, 18, 17); // default color
  }

  // background color for buttons
  getBgColor(String text) {
    if (text == "AC" || text == "=") {
      return const Color.fromARGB(255, 228, 252, 168); // special buttons color
    }
    return const Color.fromARGB(255, 245, 246, 247); // default background
  }

  // handle button presses
  void handleButtons(String text) {
    if (text == "AC") {
      userInput = ""; // clear input
      result = "0"; // Reset
      isResultDisplayed = false; // Reset for flag
      return;
    }
    if (text == "C") {
      if (userInput.isNotEmpty) {
        userInput = userInput.substring(
            0, userInput.length - 1); // remove last character
        return;
      }
    }
    if (text == "=") {
      result = calculate(); // current calculation
      if (result != "Error") {
        history.add("$userInput = $result"); // Add to history
      }
      isResultDisplayed = true; // setting result displayed flag
      userInput = result; // update input with result
      return;
    }
    if (text == "√" || text == "%" || text == "sin" || text == "cos") {
      handleFunctionButtons(text); // handling special functions
      return;
    }
    userInput += text;
  }

  // handle special function buttons(Sqrt and trigonomettry)
  void handleFunctionButtons(String text) {
    try {
      double value =
          double.tryParse(userInput) ?? double.nan; // Parse input to double
      if (value.isNaN) throw Exception("Invalid input"); // handle invalid input
      if (text == "√") {
        if (value < 0)
          throw Exception(
              "Square root of negative number"); // handle invalid sqrt
        result = sqrt(value).toString();
      } else if (text == "%") {
        result = (value / 100).toString(); // calculation of presentage
      } else if (text == "sin") {
        result = (sin(value * (pi / 180))).toString(); // sine calculation
      } else if (text == "cos") {
        result = (cos(value * (pi / 180))).toString(); // cos calculation
      }
      history.add("$text($userInput) = $result"); // Add to history
      isResultDisplayed = true; // Set flag
      userInput = result; // update input
    } catch (e) {
      result = "Error"; // exceptions handling
    }
  }

  String calculate() {
    try {
      String input = userInput.replaceAll('×', '*').replaceAll('÷', '/');

      // Check whether division by zero
      if (input.contains("/0")) {
        throw Exception("Division by zero");
      }

      //exceptiion handling using try catch block
      var exp = Parser().parse(input);
      var evaluation = exp.evaluate(EvaluationType.REAL, ContextModel());
      return evaluation.toString();
    } catch (e) {
      return "Error";
    }
  }
}
