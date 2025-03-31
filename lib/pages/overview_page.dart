import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class OverviewPage extends StatelessWidget {
  final List<Map<String, dynamic>> recentTransactions = [
    {"title": "Groceries", "amount": "-\$50.00", "date": "Feb 10", "type": "expense"},
    {"title": "Salary", "amount": "+\$2500.00", "date": "Feb 9", "type": "income"},
    {"title": "Electricity Bill", "amount": "-\$100.00", "date": "Feb 8", "type": "expense"},
    {"title": "Freelance Work", "amount": "+\$600.00", "date": "Feb 7", "type": "income"},
    {"title": "Subscription", "amount": "-\$15.00", "date": "Feb 6", "type": "expense"},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Financial Overview", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Financial Summary Box
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Colors.teal, Colors.green]),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 6, spreadRadius: 1)],
              ),
              child: Column(
                children: [
                  Text(
                    "Financial Summary",
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 10),

                  // Pie Chart for Income vs. Expenses
                  SizedBox(
                    height: 200,
                    child: PieChart(
                      PieChartData(
                        sections: _getChartSections(),
                        borderData: FlBorderData(show: false),
                        centerSpaceRadius: 40,
                        sectionsSpace: 2,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Income, Expenses, and Budget Overview
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildOverviewItem('Income', '\$3100', Colors.greenAccent),
                      _buildOverviewItem('Expenses', '\$2100', Colors.redAccent),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Remaining Budget: \$1000',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Recent Transactions Header
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Recent Transactions",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[700]),
              ),
            ),
            SizedBox(height: 10),

            // Transactions List
            Expanded(
              child: ListView.builder(
                itemCount: recentTransactions.length,
                itemBuilder: (context, index) {
                  final transaction = recentTransactions[index];
                  return _buildTransactionTile(
                    title: transaction["title"],
                    amount: transaction["amount"],
                    date: transaction["date"],
                    type: transaction["type"],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Pie Chart Data for Income vs Expenses
  List<PieChartSectionData> _getChartSections() {
    return [
      PieChartSectionData(
        color: Colors.greenAccent.shade400,
        value: 3100,
        title: 'Income',
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      PieChartSectionData(
        color: Colors.redAccent.shade400,
        value: 2100,
        title: 'Expenses',
        radius: 50,
        titleStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    ];
  }

  // Helper function for the overview items (Income, Expenses)
  Widget _buildOverviewItem(String title, String amount, Color color) {
    return Column(
      children: [
        Text(title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        SizedBox(height: 4),
        Text(amount, style: TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: color)),
      ],
    );
  }

  // Function to create a transaction tile
  Widget _buildTransactionTile({required String title, required String amount, required String date, required String type}) {
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: type == "income" ? Colors.greenAccent : Colors.redAccent,
          child: Icon(type == "income" ? Icons.arrow_upward : Icons.arrow_downward, color: Colors.white),
        ),
        title: Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        subtitle: Text(date, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Text(
          amount,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: type == "income" ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}
