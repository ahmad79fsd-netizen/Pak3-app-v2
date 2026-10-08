import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const Pak3App());
}

class Pak3App extends StatelessWidget {
  const Pak3App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PAK 3 Official',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF000033),
        primaryColor: const Color(0xFFFFD700),
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String dopherResult = "123";
  String shaamResult = "456";
  String nightResult = "789";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'PAK 3 OFFICIAL RESULTS',
          style: TextStyle(color: Color(0xFFFFD700), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade900,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.yellow, width: 2),
              ),
              child: const Text(
                'LIVE DRAW TIMINGS\n01:30 PM | 04:30 PM | 08:30 PM',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            _buildDrawCard('PAK 3 DOPHER', '01:30 PM', dopherResult, Colors.amber),
            const SizedBox(height: 15),
            _buildDrawCard('PAK 3 SHAAM', '04:30 PM', shaamResult, Colors.orange),
            const SizedBox(height: 15),
            _buildDrawCard('PAK 3 NIGHT', '08:30 PM', nightResult, Colors.blueAccent),
          ],
        ),
      ),
    );
  }

  Widget _buildDrawCard(String title, String time, String result, Color accentColor) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111122),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: accentColor, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: accentColor)),
              Text(time, style: const TextStyle(fontSize: 14, color: Colors.white70)),
            ],
          ),
          const Divider(color: Colors.white24, height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: result.split('').map((digit) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.yellow),
                ),
                child: Text(
                  digit,
                  style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.yellow),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: Colors.black,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LiveDrawScreen(drawTitle: title, targetNumber: result),
                ),
              );
            },
            child: const Text('WATCH LIVE DRAW', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

class LiveDrawScreen extends StatefulWidget {
  final String drawTitle;
  final String targetNumber;

  const LiveDrawScreen({super.key, required this.drawTitle, required this.targetNumber});

  @override
  State<LiveDrawScreen> createState() => _LiveDrawScreenState();
}

class _LiveDrawScreenState extends State<LiveDrawScreen> {
  List<int> currentDigits = [0, 0, 0];
  bool isSpinning = true;

  @override
  void initState() {
    super.initState();
    _startSpinning();
  }

  void _startSpinning() {
    Timer.periodic(const Duration(milliseconds: 80), (timer) {
      if (!isSpinning) {
        timer.cancel();
        return;
      }
      setState(() {
        currentDigits = [
          Random().nextInt(10),
          Random().nextInt(10),
          Random().nextInt(10),
        ];
      });
    });

    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isSpinning = false;
        currentDigits = widget.targetNumber.split('').map((e) => int.parse(e)).toList();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.drawTitle), backgroundColor: Colors.black),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              isSpinning ? 'SPINNING LIVE...' : 'WINNING NUMBER',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.yellow),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: currentDigits.map((d) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  width: 80,
                  height: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.red, width: 3),
                  ),
                  child: Text(
                    '$d',
                    style: const TextStyle(fontSize: 55, fontWeight: FontWeight.bold, color: Colors.yellow),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 40),
            if (!isSpinning)
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('BACK TO HOME'),
              ),
          ],
        ),
      ),
    );
  }
}
