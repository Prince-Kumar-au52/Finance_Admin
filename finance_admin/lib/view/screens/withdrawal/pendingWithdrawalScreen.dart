import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PendingWithdrawalScreen extends StatefulWidget {
  @override
  _PendingWithdrawalScreenState createState() =>
      _PendingWithdrawalScreenState();
}

class _PendingWithdrawalScreenState extends State<PendingWithdrawalScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  int totalCount = 0;
  int currentPage = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchData(currentPage, pageSize);
  }

  Future<void> fetchData(int page, int size) async {
    try {
      var url = Uri.parse(
          'http://localhost:5000/v1/withDrow/allWithdrow?page=$page&pageSize=$size&type=pending');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Response body: $jsonData');
        }
        setState(() {
          users.addAll(List<Map<String, dynamic>>.from(jsonData['data']));
          filteredUsers = users;
          totalCount = jsonData['totalCount'];
        });
      } else {
        if (kDebugMode) {
          print('Failed to load users. Status code: ${response.statusCode}');
        }
        if (kDebugMode) {
          print('Response body: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during API call: $e');
      }
    }
  }

  void loadMoreData() {
    currentPage++;
    fetchData(currentPage, pageSize);
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) => user['CreatedBy']['FullName']
              .toLowerCase()
              .contains(query.toLowerCase()))
          .toList();
    });
  }

  // Color _getStatusColor(Map<String, dynamic> withdrawal) {
  //   if (withdrawal['IsRejected'] == true) {
  //     return Colors.red;
  //   } else if (withdrawal['IsVerify'] == true) {
  //     return Colors.green;
  //   } else {
  //     return Colors.yellow;
  //   }
  // }

  Color _getVerifyColor(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsVerify'] == true) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  Color _getRejectColor(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsRejected'] == true) {
      return Colors.red;
    } else {
      return Colors.yellow;
    }
  }

  Color _getCompletionColor(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsComleted'] == true && withdrawal['IsVerify'] == true) {
      return Colors.green;
    } else {
      return Colors.yellow;
    }
  }

  String _getStatusReject(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsRejected'] == true) {
      return 'Rejected';
    } else {
      return 'Pending';
    }
  }

  String _getStatusVerify(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsVerify'] == true) {
      return 'Verified';
    } else {
      return 'Pending';
    }
  }

  String _getCompleted(Map<String, dynamic> withdrawal) {
    if (withdrawal['IsComleted'] == true && withdrawal['IsVerify'] == true) {
      return 'Completed';
    } else {
      return 'Pending';
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  width: size.width * .3,
                  child: TextField(
                    controller: searchController,
                    onChanged: (value) {
                      filterUsers(value);
                    },
                    decoration: const InputDecoration(
                      isDense: true,
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (ScrollNotification scrollInfo) {
                if (scrollInfo is ScrollEndNotification &&
                    scrollInfo.metrics.pixels ==
                        scrollInfo.metrics.maxScrollExtent) {
                  loadMoreData();
                }
                return true;
              },
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columnSpacing: 50,
                    columns: const [
                      DataColumn(
                          label: Text(
                        'Name and Email',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'UPI ID',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Amount',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Date',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Verify',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Rejected',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                      DataColumn(
                          label: Text(
                        'Completed',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )),
                    ],
                    rows: filteredUsers.map((user) {
                      return DataRow(cells: [
                        DataCell(Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(user["CreatedBy"]["FullName"]),
                            Text(user["CreatedBy"]["EmailId"]),
                          ],
                        )),
                        DataCell(Text(user["UpiId"].toString())),
                        DataCell(Text(user["Amount"].toString())),
                        // DataCell(Text(user['CreatedDate'].split('T').first)),
                        DataCell(Text(
                          _formatDate(user['CreatedDate']),
                        )),
                        DataCell(
                          Text(
                            _getStatusVerify(user),
                            style: TextStyle(color: _getVerifyColor(user)),
                          ),
                        ),
                        DataCell(
                          Text(
                            _getStatusReject(user),
                            style: TextStyle(color: _getRejectColor(user)),
                          ),
                        ),
                        DataCell(
                          Text(
                            _getCompleted(user),
                            style: TextStyle(color: _getCompletionColor(user)),
                          ),
                        ),
                      ]);
                    }).toList(),
                  ),
                ),
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
                  'Total Users: $totalCount',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: currentPage > 1
                        ? () {
                            setState(() {
                              currentPage--;
                              fetchData(currentPage, pageSize);
                            });
                          }
                        : null,
                    child: const Icon(Icons.arrow_back_ios),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Text('Page $currentPage'),
                  const SizedBox(
                    width: 20,
                  ),
                  ElevatedButton(
                    onPressed: users.length < pageSize
                        // onPressed: users.length < pageSize &&
                        // currentPage * pageSize >= totalCount
                        ? null
                        : () {
                            setState(() {
                              currentPage++;
                              fetchData(currentPage, pageSize);
                            });
                          },
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
    // Format date string to a readable format
    DateTime dateTime = DateTime.parse(dateString);
    return '${dateTime.day}-${dateTime.month}-${dateTime.year}';
  }
}
