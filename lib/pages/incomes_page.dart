import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class IncomesPage extends StatefulWidget {
  @override
  _IncomesPageState createState() => _IncomesPageState();
}

class _IncomesPageState extends State<IncomesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String selectedCategory = "All";

  Future<List<Map<String, dynamic>>> getFilteredIncomes() async {
    QuerySnapshot querySnapshot = await _firestore.collection('incomes').get();
    List<Map<String, dynamic>> firebaseIncomes = querySnapshot.docs.map((doc) {
      return {
        "category": doc["category"],
        "name": doc["name"],
        "amount": doc["amount"],
        "date": doc["date"],
        "recurring": doc["recurring"],
      };
    }).toList();

    if (selectedCategory == "All") return firebaseIncomes;
    return firebaseIncomes.where((income) => income["category"] == selectedCategory).toList();
  }

  double getTotalIncome(List<Map<String, dynamic>> incomes) {
    return incomes.fold(0.0, (sum, income) => sum + (income["amount"] as double));
  }

  List<BarChartGroupData> _buildBarGroups(List<Map<String, dynamic>> allIncomes) {
    Map<String, double> categoryTotals = {};

    for (var income in allIncomes) {
      categoryTotals[income["category"]] = (categoryTotals[income["category"]] ?? 0) + (income["amount"] as double);
    }

    List<BarChartGroupData> bars = [];
    int index = 0;
    categoryTotals.forEach((category, amount) {
      bars.add(BarChartGroupData(
        x: index,
        barRods: [BarChartRodData(toY: amount, color: Colors.teal, width: 20)],
      ));
      index++;
    });

    return bars;
  }

  Widget _getBottomTitles(double value, TitleMeta meta) {
    List<String> categories = ["Salary", "Investments", "Freelance", "Other"];
    return value.toInt() < categories.length
        ? RotatedBox(
            quarterTurns: -1,
            child: Text(categories[value.toInt()], style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          )
        : Container();
  }

  BoxDecoration _modernBoxDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, spreadRadius: 2)],
    );
  }

  void _showAddIncomeDialog() {
    TextEditingController nameController = TextEditingController();
    TextEditingController amountController = TextEditingController();
    TextEditingController dateController = TextEditingController();
    String selectedCategory = "Salary";
    bool isRecurring = false;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Add Income", style: TextStyle(fontWeight: FontWeight.bold)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: "Income Name"),
              ),
              TextField(
                controller: amountController,
                decoration: InputDecoration(labelText: "Amount"),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: dateController,
                decoration: InputDecoration(
                  labelText: "Date",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: () async {
                      DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2100),
                      );
                      if (pickedDate != null) {
                        dateController.text = DateFormat("yyyy-MM-dd").format(pickedDate);
                      }
                    },
                  ),
                ),
                readOnly: true,
              ),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: ["Salary", "Investments", "Freelance", "Other"].map((category) {
                  return DropdownMenuItem(value: category, child: Text(category));
                }).toList(),
                onChanged: (value) {
                  selectedCategory = value!;
                },
                decoration: InputDecoration(labelText: "Category"),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Recurring Income?"),
                  Switch(
                    value: isRecurring,
                    onChanged: (value) {
                      setState(() {
                        isRecurring = value;
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty || amountController.text.isEmpty || dateController.text.isEmpty) return;

                await _firestore.collection("incomes").add({
                  "name": nameController.text,
                  "amount": double.parse(amountController.text),
                  "category": selectedCategory,
                  "date": dateController.text,
                  "recurring": isRecurring,
                });

                Navigator.pop(context);
                setState(() {});
              },
              child: Text("Save"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Income Tracker"),
        backgroundColor: Colors.teal[600],
        centerTitle: true,
        elevation: 4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: getFilteredIncomes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return Center(child: CircularProgressIndicator());
            List<Map<String, dynamic>> allIncomes = snapshot.data!;
            double totalIncome = getTotalIncome(allIncomes);

            return Column(
              children: [
                // Total Incomes Section (Updated Styling)
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.teal[700]!, Colors.teal[300]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(2, 2)),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Total Incomes",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "\$${totalIncome.toStringAsFixed(2)}",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Bar Chart Section (Unchanged)
                Container(
                  height: 220,
                  padding: EdgeInsets.all(16),
                  decoration: _modernBoxDecoration(),
                  child: BarChart(
                    BarChartData(
                      barGroups: _buildBarGroups(allIncomes),
                      titlesData: FlTitlesData(
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(showTitles: true, getTitlesWidget: _getBottomTitles),
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20),

                // Income Entries with Date & Updated Amount Size
                Expanded(
                  child: ListView.builder(
                    itemCount: allIncomes.length,
                    itemBuilder: (context, index) {
                      var income = allIncomes[index];
                      return ListTile(
                        leading: Icon(Icons.attach_money, color: Colors.teal),
                        title: Text(income["name"]),
                        subtitle: Text("${income["category"]} - ${income["date"]}"),
                        trailing: Text(
                          "\$${income["amount"]}",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        child: Icon(Icons.add),
        onPressed: _showAddIncomeDialog,
      ),
    );
  }
}
