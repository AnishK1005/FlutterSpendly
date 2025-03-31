import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'overview_page.dart'; // Import the overview page
import 'expenses_page.dart'; // Import the expenses page
import 'incomes_page.dart';
import 'reports_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // App Header (Smaller and Separate)
              Column(
                children: [
                  Text(
                    'Spendly',
                    style: TextStyle(
                      fontSize: 24, // Slightly smaller than before
                      fontWeight: FontWeight.bold,
                      color: Colors.teal.shade800,
                    ),
                  ),
                  SizedBox(height: 8), // Space between header and divider
                  Divider(thickness: 2, color: Colors.teal.shade300), // Divider for separation
                ],
              ),
              SizedBox(height: 20), // Moved Hello, User! down a bit

              // "Hello, User!" Section
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Hello, User!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Lobster', // Pretty Font
                    color: Colors.teal.shade700,
                  ),
                ),
              ),
              SizedBox(height: 20), // Added more spacing before the graph

              // Modern Pie Chart Section
              Container(
                height: 250,
                padding: EdgeInsets.all(16),
                decoration: _modernBoxDecoration(),
                child: PieChart(
                  PieChartData(
                    sections: [
                      PieChartSectionData(
                        color: Colors.greenAccent,
                        value: 2500,
                        title: 'Income\n\$2500',
                        titleStyle: _chartTextStyle(),
                      ),
                      PieChartSectionData(
                        color: Colors.redAccent,
                        value: 1800,
                        title: 'Expenses\n\$1800',
                        titleStyle: _chartTextStyle(),
                      ),
                      PieChartSectionData(
                        color: Colors.blueAccent,
                        value: 700,
                        title: 'Budget\n\$700',
                        titleStyle: _chartTextStyle().copyWith(color: Colors.white),
                      ),
                    ],
                    sectionsSpace: 4,
                    centerSpaceRadius: 45,
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Overview Section
              Container(
                padding: EdgeInsets.all(20),
                decoration: _modernBoxDecoration().copyWith(color: Colors.teal.shade50),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // Keeps them closer
                      children: [
                        _buildOverviewItem('Income', '\$2500', Colors.green),
                        _buildOverviewItem('Expenses', '\$1800', Colors.redAccent),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Remaining Budget: \$700',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey.shade700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 15), // Adjusted to remove bottom empty space

              // Buttons Section (Stretch Across the Screen)
              Expanded(
                child: ListView(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  children: [
                    _buildNavButton(context, 'Overview', Icons.dashboard, Colors.blue, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OverviewPage()),
                      );
                    }),
                     _buildNavButton(context, 'Incomes', Icons.attach_money, Colors.green, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => IncomesPage()), // ✅ Added routing for IncomesPage
                      );
                    }),
                    _buildNavButton(context, 'Expenses', Icons.money_off, Colors.red, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ExpensesPage()), // Navigates to Expenses Page
                      );
                    }),
                    _buildNavButton(context, 'Reports', Icons.bar_chart, Colors.orange, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => ReportsPage()), // Navigates to Expenses Page
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function for the overview items (Income, Expenses)
  Widget _buildOverviewItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        SizedBox(height: 4),
        Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  // Function for Full-Width Navigation Buttons
  Widget _buildNavButton(BuildContext context, String title, IconData icon, Color color, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: SizedBox(
        width: double.infinity, // Makes button stretch across the screen
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            padding: EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            elevation: 4,
          ),
          icon: Icon(icon, color: Colors.white),
          label: Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
          onPressed: onTap,
        ),
      ),
    );
  }

  // Modernized BoxDecoration
  BoxDecoration _modernBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
    );
  }

  // Chart Text Style
  TextStyle _chartTextStyle() {
    return TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black);
  }
}
