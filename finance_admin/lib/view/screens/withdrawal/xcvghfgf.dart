import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WithdrawalScreen extends StatefulWidget {
  @override
  _WithdrawalScreenState createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  int totalCount = 0;
  String filterType = 'all'; // Default filter type set to 'all'
  int currentPage = 1;
  int pageSize = 10;

  @override
  void initState() {
    super.initState();
    fetchData(filterType, currentPage, pageSize);
  }

  Future<void> fetchData(String type, int page, int size) async {
    try {
      var url = Uri.parse(
          'http://localhost:5000/v1/withDrow/allWithdrow?page=$page&pageSize=$size');

      // Adjust URL based on filter type
      if (type != 'all') {
        url = Uri.parse(
            'http://localhost:5000/v1/withDrow/allWithdrow?page=$page&pageSize=$size&type=$type');
      }

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (kDebugMode) {
          print('Response body: $jsonData');
        }
        setState(() {
          users = List<Map<String, dynamic>>.from(jsonData['data']);
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
    setState(() {
      currentPage++;
      fetchData(filterType, currentPage, pageSize);
    });
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

  Future<void> updateStatus(String id, String field, bool value) async {
    final url =
        Uri.parse('http://localhost:5000/v1/withDrow/updateWithdrow/$id');
    try {
      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({field: value}),
      );

      if (response.statusCode == 200) {
        setState(() {
          users = users.map((user) {
            if (user["_id"] == id) {
              user[field] = value;
              if (field == "IsVerify" && value == true) {
                user["IsRejected"] = false; // Reset rejection if verifying
              } else if (field == "IsRejected" && value == true) {
                user["IsVerify"] = false; // Reset verification if rejecting
              }
            }
            return user;
          }).toList();
          filteredUsers = filteredUsers.map((user) {
            if (user["_id"] == id) {
              user[field] = value;
              if (field == "IsVerify" && value == true) {
                user["IsRejected"] = false; // Reset rejection if verifying
              } else if (field == "IsRejected" && value == true) {
                user["IsVerify"] = false; // Reset verification if rejecting
              }
            }
            return user;
          }).toList();
        });
        if (kDebugMode) {
          print('Update successful');
        }
      } else {
        if (kDebugMode) {
          print('Failed to update user: ${response.body}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during update: $e');
      }
    }
  }

  void showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
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
                Container(
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
                DropdownButton<String>(
                  value: filterType,
                  onChanged: (String? newValue) {
                    setState(() {
                      filterType = newValue!;
                      currentPage = 1; // Reset page number on filter change
                      users.clear(); // Clear existing users when filter changes
                      fetchData(filterType, currentPage, pageSize);
                    });
                  },
                  items: <String>['all', 'pending', 'rejected', 'completed']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: DataTable(
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
                  DataCell(Text(user['CreatedDate'].split('T').first)),
                  DataCell(
                    InkWell(
                      onTap: () {
                        if (!user["IsRejected"]) {
                          updateStatus(
                              user["_id"], "IsVerify", !user["IsVerify"]);
                        } else {
                          showSnackbar(
                              "Cannot verify because withdrawal is already rejected.");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              user["IsVerify"] ? Colors.green : Colors.yellow,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          user["IsVerify"] ? "Verified" : "Pending",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () {
                        if (!user["IsVerify"]) {
                          updateStatus(
                              user["_id"], "IsRejected", !user["IsRejected"]);
                        } else {
                          showSnackbar(
                              "Cannot reject because withdrawal is already verified.");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              user["IsRejected"] ? Colors.red : Colors.yellow,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          user["IsRejected"] ? "Rejected" : "Pending",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  DataCell(
                    InkWell(
                      onTap: () {
                        if (user["IsVerify"]) {
                          updateStatus(
                              user["_id"], "IsComleted", !user["IsComleted"]);
                        } else {
                          showSnackbar(
                              "Cannot complete withdrawal without verification.");
                        }
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color:
                              user["IsComleted"] ? Colors.green : Colors.yellow,
                        ),
                        padding: EdgeInsets.all(5),
                        child: Text(
                          user["IsComleted"] ? "Completed" : "Pending",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: currentPage > 1
                      ? () {
                          setState(() {
                            currentPage--;
                            fetchData(filterType, currentPage, pageSize);
                          });
                        }
                      : null,
                  child: Text('Previous'),
                ),
                Text('Page $currentPage'),
                ElevatedButton(
                  onPressed: filteredUsers.length < pageSize
                      ? null
                      : () {
                          setState(() {
                            currentPage++;
                            fetchData(filterType, currentPage, pageSize);
                          });
                        },
                  child: Text('Next'),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Total Users: $totalCount',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
