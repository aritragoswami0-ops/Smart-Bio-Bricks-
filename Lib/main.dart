import 'package:flutter/material.dart';

void main() => runApp(const SmartBioBricksApp());

class SmartBioBricksApp extends StatelessWidget {
  const SmartBioBricksApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Bio Bricks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.teal,
        scaffoldBackgroundColor: const Color(0xFF001F1F),
        cardColor: Colors.white10,
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  final Map<String, double> _wasteData = const {
    "Vegetable peels": 8,
    "Sawdust": 5,
    "Dry leaves": 4,
    "Plastic shreds": 2,
    "E-waste": 1,
  };

  double _totalWaste() => _wasteData.values.fold(0.0, (a, b) => a + b);
  int _bricksCount() => (_totalWaste() ~/ 2.0).toInt();
  double _volumeDiverted() => _bricksCount() * 0.002;
  double _areaReduced() => _volumeDiverted() / 2.0;
  double _percentReduced() => (_areaReduced() / 1000.0) * 100.0;

  @override
  Widget build(BuildContext context) {
    final total = _totalWaste();
    final percent = _percentReduced().clamp(0.0, 100.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Bio Bricks'),
        backgroundColor: Colors.teal.shade700,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            _sectionTitle('Realtime Analytics'),
            _infoCard('Total Waste', '${total.toStringAsFixed(2)} kg'),
            _infoCard('Bricks Producible', '${_bricksCount()}'),
            _infoCard('Volume Diverted', '${_volumeDiverted().toStringAsFixed(4)} m³'),
            _infoCard('Landfill Reduced', '${percent.toStringAsFixed(2)}%'),
            const SizedBox(height: 20),
            _sectionTitle('Composition per Brick (kg)'),
            const SizedBox(height: 8),
            ..._wasteData.entries.map((e) => ListTile(
                  title: Text(e.key, style: const TextStyle(color: Colors.white70)),
                  trailing: Text('${e.value} kg', style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
                )),
            const SizedBox(height: 20),
            _sectionTitle('Landfill Reduction Progress'),
            const SizedBox(height: 8),
            LinearProgressIndicator(value: percent / 100, minHeight: 12),
            const SizedBox(height: 8),
            Text('${percent.toStringAsFixed(2)}% reduced', style: const TextStyle(color: Colors.white)),
            const SizedBox(height: 20),
            _sectionTitle('Process Steps'),
            _processStep(1, 'Dehumidifying — removes moisture'),
            _processStep(2, 'Grinding — uniform fine mix'),
            _processStep(3, 'Molding — compact shaping'),
            _processStep(4, 'Drying — set and harden bricks'),
          ]),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      );

  Widget _infoCard(String title, String value) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white10, borderRadius: BorderRadius.circular(8)),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(title, style: const TextStyle(color: Colors.white70)),
        Text(value, style: const TextStyle(color: Colors.tealAccent, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  Widget _processStep(int n, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(children: [
        CircleAvatar(radius: 14, backgroundColor: Colors.tealAccent, child: Text('$n', style: const TextStyle(color: Colors.black))),
        const SizedBox(width: 10),
        Expanded(child: Text(text, style: const TextStyle(color: Colors.white70))),
      ]),
    );
  }
}

