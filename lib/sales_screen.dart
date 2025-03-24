import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'entry.dart';

class SalesScreen extends StatefulWidget {
  const SalesScreen({Key? key}) : super(key: key);

  @override
  _SalesScreenState createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen> {
  DateTime? _fromDate;
  DateTime? _toDate;

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _fromDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _fromDate) {
      setState(() {
        _fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _toDate ?? DateTime.now(),
      firstDate: _fromDate ?? DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _toDate) {
      setState(() {
        _toDate = picked;
      });
    }
  }

  double _calculateMotorcycleSales(List<Entry> entries) {
    return entries
        .where(
          (entry) =>
              entry.vehicleType == 'Motorcycle' && entry.exitTime != null,
        )
        .fold(0, (sum, entry) => sum + entry.calculateFee());
  }

  double _calculateCarSales(List<Entry> entries) {
    return entries
        .where((entry) => entry.vehicleType == 'Car' && entry.exitTime != null)
        .fold(0, (sum, entry) => sum + entry.calculateFee());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple, Colors.purpleAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'From:',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectFromDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _fromDate == null
                                      ? 'Select Date'
                                      : DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(_fromDate!),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'To:',
                          style: TextStyle(color: Colors.white70, fontSize: 18),
                        ),
                        const SizedBox(height: 8),
                        InkWell(
                          onTap: () => _selectToDate(context),
                          child: Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.deepPurple.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today,
                                  color: Colors.white70,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  _toDate == null
                                      ? 'Select Date'
                                      : DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(_toDate!),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: ValueListenableBuilder(
                  valueListenable: Hive.box<Entry>('entriesBox').listenable(),
                  builder: (context, Box<Entry> box, _) {
                    final entries = box.values.toList();

                    final filteredEntries =
                        entries.where((entry) {
                          if (_fromDate == null || _toDate == null)
                            return false;
                          return entry.exitTime != null &&
                              entry.exitTime!.isAfter(_fromDate!) &&
                              entry.exitTime!.isBefore(
                                _toDate!.add(const Duration(days: 1)),
                              );
                        }).toList();

                    final motorcycleSales = _calculateMotorcycleSales(
                      filteredEntries,
                    );
                    final carSales = _calculateCarSales(filteredEntries);

                    return Column(
                      children: [
                        Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                Text(
                                  'Motorcycle Sales: ${motorcycleSales.toStringAsFixed(2)} pesos',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Car Sales: ${carSales.toStringAsFixed(2)} pesos',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  'Total Sales: ${(motorcycleSales + carSales).toStringAsFixed(2)} pesos',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
