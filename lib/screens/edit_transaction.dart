import 'package:flutter/material.dart';
import 'package:flutter_application_4/models/transaction.dart';

class EditTransactionPage extends StatefulWidget {
  final Transaction transaction;
  final int index;

  EditTransactionPage({required this.transaction, required this.index});

  @override
  _EditTransactionPageState createState() => _EditTransactionPageState();
}

class _EditTransactionPageState extends State<EditTransactionPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstMonthController = TextEditingController();
  final TextEditingController _lastMonthController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameController.text = widget.transaction.name;
    _firstMonthController.text = widget.transaction.firstMonth;
    _lastMonthController.text = widget.transaction.lastMonth;
    _amountController.text = widget.transaction.amount.toString();
  }

  void saveData() {
    if (_formKey.currentState!.validate()) {
      final String name = _nameController.text;
      final String firstMonth = _firstMonthController.text;
      final String lastMonth = _lastMonthController.text;
      final double? amount = double.tryParse(_amountController.text);

      if (name.isNotEmpty &&
          firstMonth.isNotEmpty &&
          lastMonth.isNotEmpty &&
          amount != null) {
        final updatedTransaction = Transaction(
          name: name,
          firstMonth: firstMonth,
          lastMonth: lastMonth,
          amount: amount,
          lastModified: DateTime.now().toIso8601String(),
        );

        Navigator.pop(context, updatedTransaction);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Transaction'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Budget Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _firstMonthController,
                decoration: InputDecoration(labelText: 'First Month (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'First Month cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _lastMonthController,
                decoration: InputDecoration(labelText: 'Last Month (YYYY-MM-DD)'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Last Month cannot be empty';
                  }
                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _amountController,
                decoration: InputDecoration(labelText: 'Total Budget Amount (USD)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty || double.tryParse(value) == null) {
                    return 'Amount must be a valid number';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: saveData,
                child: Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
