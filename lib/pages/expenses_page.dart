import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  String selectedCategory = "All";

  final List<Map<String, dynamic>> expenses = [
    {"category": "Food", "name": "Groceries", "amount": 50.00, "date": "Feb 10"},
    {"category": "Food", "name": "Restaurant", "amount": 12.50, "date": "Feb 9"},
    {"category": "Transport", "name": "Gas", "amount": 30.00, "date": "Feb 8"},
    {"category": "Transport", "name": "Public Transport", "amount": 8.75, "date": "Feb 7"},
    {"category": "Entertainment", "name": "Movies", "amount": 20.00, "date": "Feb 6"},
    {"category": "Entertainment", "name": "Concert", "amount": 75.00, "date": "Feb 5"},
    {"category": "Shopping", "name": "Clothes", "amount": 45.99, "date": "Feb 4"},
    {"category": "Shopping", "name": "Electronics", "amount": 100.00, "date": "Feb 3"},
    {"category": "Bills", "name": "Electricity", "amount": 120.00, "date": "Feb 2"},
    {"category": "Bills", "name": "Internet", "amount": 50.00, "date": "Feb 1"},
  ];

  List<Map<String, dynamic>> getFilteredExpenses() {
    if (selectedCategory == "All") return expenses;
    return expenses.where((expense) => expense["category"] == selectedCategory).toList();
  }

  double getTotalExpenses() {
    return expenses.fold(0.0, (sum, item) => sum + (item['amount'] as double));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Expenses",
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.teal[400],
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 📌 Improved Total Expenses Section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.teal[400]!, Colors.teal[600]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    blurRadius: 8,
                    spreadRadius: 2,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Total Expenses",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500, color: Colors.white70),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "\$${getTotalExpenses().toStringAsFixed(2)}",
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 5),
                  Divider(color: Colors.white30, thickness: 1.5, indent: 50, endIndent: 50),
                  SizedBox(height: 5),
                  Text(
                    "Manage your expenses wisely!",
                    style: TextStyle(fontSize: 14, color: Colors.white70, fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // 📌 Category Filter
            Text(
              "Filter by Category",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.teal[800]),
            ),
            SizedBox(height: 10),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: ["All", "Food", "Transport", "Entertainment", "Shopping", "Bills"]
                    .map((category) => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: ChoiceChip(
                            label: Text(category,
                                style: TextStyle(
                                    color: selectedCategory == category ? Colors.white : Colors.teal[800],
                                    fontWeight: FontWeight.bold)),
                            selected: selectedCategory == category,
                            selectedColor: Colors.teal[400],
                            backgroundColor: Colors.grey[300],
                            onSelected: (isSelected) {
                              setState(() {
                                selectedCategory = category;
                              });
                            },
                          ),
                        ))
                    .toList(),
              ),
            ),
            SizedBox(height: 20),

            // 📌 Expenses List
            Expanded(
              child: getFilteredExpenses().isEmpty
                  ? Center(
                      child: Text(
                        "No expenses found",
                        style: TextStyle(fontSize: 18, color: Colors.grey[600]),
                      ),
                    )
                  : ListView.builder(
                      itemCount: getFilteredExpenses().length,
                      itemBuilder: (context, index) {
                        var expense = getFilteredExpenses()[index];

                        String expenseName = expense.containsKey("name") && expense["name"] != null
                            ? expense["name"].toString()
                            : "Unknown Expense";

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 8),
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(Icons.account_balance_wallet, color: Colors.teal[400]),
                            title: Text(
                              expenseName,
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(expense["category"], style: TextStyle(color: Colors.grey[700])),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "\$${expense["amount"].toStringAsFixed(2)}",
                                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.redAccent),
                                ),
                                Text(expense["date"], style: TextStyle(color: Colors.grey[600])),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
