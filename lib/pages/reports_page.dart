import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class ReportsPage extends StatefulWidget {
  @override
  _ReportsPageState createState() => _ReportsPageState();
}

class _ReportsPageState extends State<ReportsPage> {
  final double savingsGoal = 5000;
  final double currentSavings = 3200;
  bool showCharts = true;

  final List<Map<String, dynamic>> expenseCategories = [
    {"category": "Groceries", "amount": 500.0, "color": Colors.blueAccent},
    {"category": "Rent", "amount": 1000.0, "color": Colors.green},
    {"category": "Utilities", "amount": 300.0, "color": Colors.orange},
    {"category": "Entertainment", "amount": 200.0, "color": Colors.purple},
    {"category": "Other", "amount": 100.0, "color": Colors.redAccent},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text('Financial Reports', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        elevation: 4,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildSavingsProgress(),
            SizedBox(height: 20),
            _buildToggleSwitch(),
            SizedBox(height: 20),
            showCharts ? _buildChartsView() : _buildInsightsView(),
          ],
        ),
      ),
    );
  }

  // Redesigned Savings Progress Card
  Widget _buildSavingsProgress() {
    double progress = currentSavings / savingsGoal;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: [Colors.teal.shade400, Colors.teal.shade600]),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, spreadRadius: 2)],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Icon(Icons.savings, color: Colors.white, size: 30),
              SizedBox(width: 10),
              Text("Savings Progress", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
            ],
          ),
          SizedBox(height: 15),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: progress,
                  backgroundColor: Colors.white30,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  strokeWidth: 10,
                ),
              ),
              Column(
                children: [
                  Text("\$${currentSavings.toInt()}", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                  Text("of \$${savingsGoal.toInt()}", style: TextStyle(fontSize: 16, color: Colors.white70)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Toggle Switch
  Widget _buildToggleSwitch() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Show Charts", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[700])),
        Switch(
          value: showCharts,
          onChanged: (value) {
            setState(() {
              showCharts = value;
            });
          },
          activeColor: Colors.teal,
        ),
        Text("Show Insights", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[700])),
      ],
    );
  }

  // Charts View
  Widget _buildChartsView() {
    return Column(
      children: [
        _buildSectionContainer("Expense Breakdown", _buildPieChart()),
        SizedBox(height: 20),
        _buildSectionContainer("Spending Trend", _buildBarChart()),
      ],
    );
  }

  // Insights View
  Widget _buildInsightsView() {
    return _buildSectionContainer("Recent Insights", Column(
      children: [
        _buildInsightTile("Your savings are on track! Keep going."),
        _buildInsightTile("You spent 10% more on groceries this month."),
        _buildInsightTile("Consider reducing entertainment expenses."),
      ],
    ));
  }

  // Section Container
  Widget _buildSectionContainer(String title, Widget child) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: _modernBoxDecoration(),
      child: Column(
        children: [
          Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[700])),
          SizedBox(height: 10),
          child,
        ],
      ),
    );
  }

  // Pie Chart
  Widget _buildPieChart() {
    return SizedBox(
      height: 200,
      child: PieChart(PieChartData(
        sections: expenseCategories.map((data) => PieChartSectionData(
          color: data["color"],
          value: data["amount"],
          title: data["category"],
          radius: 50,
        )).toList(),
      )),
    );
  }

  // Bar Chart
  Widget _buildBarChart() {
    return SizedBox(
      height: 200,
      child: BarChart(
        BarChartData(
          barGroups: expenseCategories.map((data) {
            return BarChartGroupData(
              x: expenseCategories.indexOf(data),
              barRods: [BarChartRodData(toY: data["amount"], color: data["color"], width: 20)],
            );
          }).toList(),
          borderData: FlBorderData(show: false),
        ),
      ),
    );
  }

  // Insight Tile
  Widget _buildInsightTile(String insight) {
    return ListTile(leading: Icon(Icons.lightbulb, color: Colors.amber), title: Text(insight));
  }

  // Box Decoration
  BoxDecoration _modernBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8)],
    );
  }
}
