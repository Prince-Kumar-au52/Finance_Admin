import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  List<Map<String, dynamic>> users = [];
  List<Map<String, dynamic>> filteredUsers = [];
  TextEditingController searchController = TextEditingController();
  int totalCount = 0; // Variable to store total count of users

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:5000/v1/auth/allUser?page=1&pageSize=10'));
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        setState(() {
          users = List<Map<String, dynamic>>.from(jsonData['data']);
          filteredUsers = users; // Initialize filtered list with all users
          totalCount = jsonData['totalCount']; // Update total count
        });
      } else {
        if (kDebugMode) {
          print('Failed to load users');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during API call: $e');
      }
    }
  }

  void filterUsers(String query) {
    setState(() {
      filteredUsers = users
          .where((user) =>
              user['FullName'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  Future<void> deleteUser(String userId) async {
    try {
      final url = 'http://localhost:5000/v1/auth/deleteUser/$userId';
      final response = await http.delete(Uri.parse(url));

      if (response.statusCode == 200) {
        // If successful, fetch updated user list
        fetchData();
      } else {
        if (kDebugMode) {
          print('Failed to delete user');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Exception during delete operation: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: Text('User List'),
      // ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
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
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(
                        label: Text(
                      'Name',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Email',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Password',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                    DataColumn(
                        label: Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    )),
                  ],
                  rows: filteredUsers.map((user) {
                    return DataRow(cells: [
                      DataCell(Text(user['FullName'])),
                      DataCell(Text(user['EmailId'])),
                      DataCell(Text(user['Password'])),
                      DataCell(
                        IconButton(
                          icon: const Icon(Icons.delete_outlined,
                              color: Colors.red),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                  title: const Text('Confirm Deletion'),
                                  content: Text(
                                      'Are you sure you want to delete ${user['FullName']}?'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Cancel'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    TextButton(
                                      child: const Text('Delete'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                        deleteUser(user['_id']);
                                      },
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            alignment: Alignment.bottomLeft,
            child: Text(
              'Total Users: $totalCount',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
