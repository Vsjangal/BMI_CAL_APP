import 'package:flutter/material.dart';

void main() {
  runApp(const BMICalculatorApp());
}

class BMICalculatorApp extends StatelessWidget {
  const BMICalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'BMI Calculator',
      debugShowCheckedModeBanner: false,
      home: InputScreen(),
    );
  }
}

class MaterialAppWithBackground extends StatelessWidget {
  final String title;
  final Widget home;

  const MaterialAppWithBackground({
    required this.title,
    required this.home,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: title,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Stack(
          children: [
            const Background(),
            home,
          ],
        ),
      ),
    );
  }
}

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.blue, Colors.teal], // Your background gradient colors
        ),
      ),
    );
  }
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _InputScreenState createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController heightController = TextEditingController(text: '170');
  final TextEditingController weightController = TextEditingController(text: '70');
  bool isHeightValid = true;
  bool isWeightValid = true;

  @override
  void dispose() {
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextField(
              controller: heightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Height (cm)',
                errorText: !isHeightValid ? 'Height is required' : null,
              ),
              onChanged: (value) {
                setState(() {
                  isHeightValid = value.isNotEmpty;
                });
              },
            ),
            TextField(
              controller: weightController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Weight (kg)',
                errorText: !isWeightValid ? 'Weight is required' : null,
              ),
              onChanged: (value) {
                setState(() {
                  isWeightValid = value.isNotEmpty;
                });
              },
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: isHeightValid && isWeightValid
                  ? () {
                      final double height = double.parse(heightController.text);
                      final double weight = double.parse(weightController.text);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ResultScreen(
                            height: height,
                            weight: weight,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text('Calculate BMI'),
            ),
          ],
        ),
      ),
    );
  }
}

class ResultScreen extends StatelessWidget {
  final double height;
  final double weight;

  const ResultScreen({
    required this.height,
    required this.weight,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    // Calculate BMI
    final double bmi = weight / ((height / 100) * (height / 100));

    return Scaffold(
      appBar: AppBar(
        title: const Text('BMI Result'),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 206, 173, 97),
              Color.fromARGB(255, 174, 150, 123)
            ], // Your cool gradient colors
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Your BMI is:',
                style: TextStyle(
                    fontSize: 24.0, fontWeight: FontWeight.bold),
              ),
              Text(
                bmi.toStringAsFixed(2),
                style: const TextStyle(
                    fontSize: 48.0, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
