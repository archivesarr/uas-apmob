import 'package:flutter/material.dart';
import 'package:flutter_application_4/screens/add_transaction.dart';
import 'package:flutter_application_4/screens/edit_transaction.dart';
import 'package:flutter_application_4/services/api_services.dart';
import 'package:flutter_application_4/models/transaction.dart';

class HistoryPage extends StatefulWidget {
  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  List<Transaction> dataList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchDataFromAPI();
  }

  Future<void> fetchDataFromAPI() async {
    try {
      final response = await ApiService.getBudgets();
      setState(() {
        dataList = response;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void deleteData(int index) {
    setState(() {
      dataList.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Data berhasil dihapus')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Halaman Histori'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: fetchDataFromAPI,
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : dataList.isEmpty
              ? Center(child: Text('Data belum dimasukkan'))
              : SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('Budget Name')),
                      DataColumn(label: Text('Last Modified')),
                      DataColumn(label: Text('First Month')),
                      DataColumn(label: Text('Last Month')),
                      DataColumn(label: Text('Total Budget Amount')),
                      DataColumn(label: Text('Actions')),
                    ],
                    rows: dataList
                        .asMap()
                        .entries
                        .map(
                          (entry) => DataRow(
                            cells: [
                              DataCell(Text(entry.value.name)),
                              DataCell(Text(entry.value.lastModified)),
                              DataCell(Text(entry.value.firstMonth)),
                              DataCell(Text(entry.value.lastMonth)),
                              DataCell(Text('\$${entry.value.amount.toStringAsFixed(2)}')),
                              DataCell(Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.edit, color: Colors.blue),
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditTransactionPage(
                                            transaction: entry.value,
                                            index: entry.key,
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () => deleteData(entry.key),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddTransactionPage(
                onSave: (transaction) {
                  setState(() {
                    dataList.add(transaction);
                  });
                },
              ),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
