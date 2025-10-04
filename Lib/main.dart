import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fl_chart/fl_chart.dart';

void main() {
  runApp(const SmartBioBricks());
}

class SmartBioBricks extends StatelessWidget {
  const SmartBioBricks({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Smart Bio Bricks',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        textTheme: GoogleFonts.poppinsTextTheme(),
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
  Map<String, double> wasteData = {
    "Vegetable peels": 8,
    "Sawdust": 5,
    "Dry leaves": 4,
    "Plastic shreds": 2,
    "E-waste": 1,
  };

  double brickMass = 2.0;
  double brickVolume = 0.002;
  double landfillArea = 1000;
  double landfillDepth = 2;

  double get totalWaste => wasteData.values.reduce((a, b) => a + b);
  int get bricksCount => (totalWaste ~/ brickMass);
  double get volumeDiverted => bricksCount * brickVolume;
  double get areaReduced => volumeDiverted / landfillDepth;
  double get percentReduced => (areaReduced / landfillArea) * 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF001F1F),
      appBar: AppBar(
        backgroundColor: Colors.teal.shade700,
        title: const Text("Smart Bio Bricks"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle("Realtime Analytics"),
              _infoCard("Total Waste", "$totalWaste kg"),
              _infoCard("Bricks Producible", "$bricksCount"),
              _infoCard("Volume Diverted", "${volumeDiverted.toStringAsFixed(4)} m³"),
              _infoCard("Landfill Reduced", "${percentReduced.toStringAsFixed(2)}%"),
              const SizedBox(height: 20),
              _sectionTitle("Composition per Brick (kg)"),
              const SizedBox(height: 12),
              SizedBox(
                height: 220,
                child: PieChart(PieChartData(
                    sections: wasteData.entries.map((entry) {
                  final colors = [
                    Colors.greenAccent,
                    Colors.orangeAccent,
                    Colors.blueAccent,
                    Colors.pinkAccent,
                    Colors.yellowAccent
                  ];
                  return PieChartSectionData(
                      color: colors[wasteData.keys.toList().indexOf(entry.key) %
                          colors.length],
                      value: entry.value,
                      title:
                          "${((entry.value / totalWaste) * 100).toStringAsFixed(0)}%",
                      titleStyle: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold));
                }).toList(),
                    sectionsSpace: 2,
                    centerSpaceRadius: 20)),
              ),
              const SizedBox(height: 10),
              ...wasteData.entries.map((e) => ListTile(
                    title: Text(e.key,
                        style: const TextStyle(color: Colors.white70)),
                    trailing: Text("${e.value} kg",
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold)),
                  )),
              const SizedBox(height: 20),
              _sectionTitle("Landfill Reduction Progress"),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: percentReduced / 100,
                backgroundColor: Colors.white12,
                color: Colors.tealAccent,
                minHeight: 10,
              ),
              const SizedBox(height: 10),
              Text("${percentReduced.toStringAsFixed(2)}% reduced",
                  style: const TextStyle(color: Colors.white)),
              const SizedBox(height: 20),
              _sectionTitle("Process Steps"),
              _processStep(1, "Dehumidifying — removes moisture"),
              _processStep(2, "Grinding — uniform fine mix"),
              _processStep(3, "Molding — compact shaping"),
              _processStep(4, "Drying — set and harden bricks"),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(String text) {
    return Text(text,
        style: const TextStyle(
            color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold));
  }

  Widget _infoCard(String title, String value) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white10, borderRadius: BorderRadius.circular(10)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(color: Colors.white70, fontSize: 16)),
          Text(value,
              style: const TextStyle(
                  color: Colors.tealAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold))
        ],
      ),
    );
  }

  Widget _processStep(int step, String desc) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
            radius: 14,
            backgroundColor: Colors.tealAccent,
            child:
                Text("$step", style: const TextStyle(color: Colors.black))),
        const SizedBox(width: 10),
        Expanded(
            child:
                Text(desc, style: const TextStyle(color: Colors.white70))),
      ],
    );
  }
}
