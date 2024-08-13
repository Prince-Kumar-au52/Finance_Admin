import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Transactionscreen extends StatefulWidget {
  @override
  _TransactionscreenState createState() => _TransactionscreenState();
}

class _TransactionscreenState extends State<Transactionscreen> {
  List<dynamic> _data = [];
  List<dynamic> _filteredData = [];
  String _searchTerm = '';
  bool _isLoading = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalCount = 0;
  int _pageSize = 10;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<Map<String, dynamic>> fetchWalletData(String search, int page) async {
    final response = await http.get(Uri.parse(
        'http://localhost:5000/v1/wallet/allWallet?page=$page&pageSize=$_pageSize&search=$search'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    try {
      final response = await fetchWalletData(_searchTerm, _currentPage);
      if (response['success']) {
        setState(() {
          _data = response['data'];
          _filteredData = _data;
          _totalCount = response['totalCount'];
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = 'No data available';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error: $e';
        _isLoading = false;
      });
    }
  }

  void _onSearchChanged(String value) {
    setState(() {
      _searchTerm = value;
      _filteredData = _data.where((item) {
        final createdBy = item['CreatedBy']?['FullName']?.toLowerCase() ?? '';
        return createdBy.contains(_searchTerm.toLowerCase());
      }).toList();
    });
  }

  void _goToPage(int page) {
    if (page > 0 && page <= (_totalCount / _pageSize).ceil()) {
      setState(() {
        _currentPage = page;
        _fetchData();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: size.width * .3,
              child: TextField(
                decoration: const InputDecoration(
                  labelText: 'Search',
                  border: OutlineInputBorder(),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : _filteredData.isEmpty
                        ? const Center(child: Text('No data available'))
                        : SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              columns: const [
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Amount')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Transaction ID')),
                              ],
                              rows: _filteredData.map((item) {
                                return DataRow(
                                  cells: [
                                    DataCell(Text(
                                        item['CreatedBy']?['FullName'] ?? '')),
                                    DataCell(Text(item['Amount'].toString())),
                                    DataCell(Text(
                                      _formatDate(item['CreatedDate']),
                                    )),
                                    DataCell(Text(item['transactionId'])),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                alignment: Alignment.bottomLeft,
                child: Text(
                  'Total Transactions: $_totalCount',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: _currentPage > 1
                        ? () {
                            _goToPage(_currentPage - 1);
                          }
                        : null,
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(width: 20),
                  Text('Page $_currentPage'),
                  const SizedBox(width: 20),
                  ElevatedButton(
                    onPressed: _currentPage < (_totalCount / _pageSize).ceil()
                        ? () {
                            _goToPage(_currentPage + 1);
                          }
                        : null,
                    child: const Icon(Icons.arrow_forward_ios),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatDate(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
}
