import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart'; // for compute

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compute Fibonacci Demo',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const FibonacciDemo(),
    );
  }
}

class FibonacciDemo extends StatefulWidget {
  const FibonacciDemo({super.key});

  @override
  State<FibonacciDemo> createState() => _FibonacciDemoState();
}

class _FibonacciDemoState extends State<FibonacciDemo>
    with SingleTickerProviderStateMixin {
  String _result = '';
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Naive recursive Fibonacci (slow for demonstration)
  static int fibonacci(int n) {
    if (n <= 1) return n;
    return fibonacci(n - 1) + fibonacci(n - 2);
  }

  Future<void> _calcWithoutCompute() async {
    setState(() => _result = "Calculating...");
    final stopwatch = Stopwatch()..start();
    final value = fibonacci(42); // Large enough for visible blocking
    stopwatch.stop();
    setState(() => _result =
        "Fibonacci(42) = $value\nMain Isolate: ${stopwatch.elapsedMilliseconds} ms");
  }

  Future<void> _calcWithCompute() async {
    setState(() => _result = "Calculating...");
    final stopwatch = Stopwatch()..start();
    final value = await compute(fibonacci, 42);
    stopwatch.stop();
    setState(() => _result =
        "Fibonacci(42) = $value\nWith compute: ${stopwatch.elapsedMilliseconds} ms");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter compute() Fibonacci Demo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RotationTransition(
              turns: _controller,
              child: const FlutterLogo(size: 100),
            ),
            const SizedBox(
              height: 24,
              width: double.infinity,
            ),
            ElevatedButton(
              onPressed: _calcWithoutCompute,
              child: const Text("Calculate Without Compute"),
            ),
            ElevatedButton(
              onPressed: _calcWithCompute,
              child: const Text("Calculate With Compute"),
            ),
            const SizedBox(height: 24),
            Text(_result, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
