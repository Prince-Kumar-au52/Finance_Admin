import 'package:finance_admin/view/screens/auth/loginScreen.dart';
import 'package:finance_admin/view/screens/dashboard/dashboardScreen.dart';
import 'package:finance_admin/view/screens/transaction/transactionScreen.dart';
import 'package:finance_admin/view/screens/user/bannerScreen.dart';
import 'package:finance_admin/view/screens/user/bannerScreen.dart';
import 'package:finance_admin/view/screens/user/userListScreen.dart';
import 'package:finance_admin/view/screens/withdrawal/withdrawalScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<Widget> _pages = [
    const DashboardScreen(),
    UserListScreen(),
    BannerScreen(), // Add the new screen here
    WithdrawalScreen(),
    Transactionscreen(),
  ];
  int _currentIndex = 0;
  bool _showAddEmployeeOptions = false;
  bool _showWithdrawalListOptions = false;
  bool _isSidebarVisible = true;

  @override
  void initState() {
    super.initState();
  }

  void _navigateToPage(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _toggleEmployeeOptions() {
    setState(() {
      _showAddEmployeeOptions = !_showAddEmployeeOptions;
    });
  }

  void _toggleWithdrawalOptions() {
    setState(() {
      _showWithdrawalListOptions = !_showWithdrawalListOptions;
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.blueGrey[100],
      body: Padding(
        padding: const EdgeInsets.all(29),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: _isSidebarVisible ? 3 : 0,
              child: Visibility(
                visible: _isSidebarVisible,
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(height: 30),
                      ListTile(
                        title: const Text("Dashboard"),
                        leading: const Icon(Icons.home),
                        selected: _currentIndex == 0,
                        tileColor: _currentIndex == 0
                            ? const Color.fromARGB(255, 61, 124, 251)
                            : null,
                        onTap: () {
                          _navigateToPage(0);
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "User",
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: const Icon(Icons.person),
                        onTap: _toggleEmployeeOptions,
                      ),
                      if (_showAddEmployeeOptions) ...[
                        ListTile(
                          title: const Text(
                            "User List",
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: const Icon(Icons.people),
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 40.0),
                          selected: _currentIndex == 1,
                          tileColor: _currentIndex == 1
                              ? const Color.fromARGB(255, 61, 124, 251)
                              : null,
                          onTap: () {
                            _navigateToPage(1);
                          },
                        ),
                        ListTile(
                          title: const Text(
                            "Banners",
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: const Icon(Icons.photo),
                          dense: true,
                          contentPadding: const EdgeInsets.only(left: 40.0),
                          selected: _currentIndex == 2,
                          tileColor: _currentIndex == 2
                              ? const Color.fromARGB(255, 61, 124, 251)
                              : null,
                          onTap: () {
                            _navigateToPage(2);
                          },
                        ),
                      ],
                      ListTile(
                        title: const Text(
                          "Withdrawal",
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: const Icon(Icons.money),
                        onTap: _toggleWithdrawalOptions,
                      ),
                      if (_showWithdrawalListOptions) ...[
                        ListTile(
                          title: const Text(
                            "Withdrawal List",
                            style: TextStyle(fontSize: 12),
                          ),
                          leading: const Icon(Icons.done_all),
                          dense: true,
                          selected: _currentIndex == 3,
                          tileColor: _currentIndex == 3
                              ? const Color.fromARGB(255, 61, 124, 251)
                              : null,
                          contentPadding: const EdgeInsets.only(left: 40.0),
                          onTap: () {
                            _navigateToPage(3);
                          },
                        ),
                      ],
                      ListTile(
                        title: const Text("Transaction"),
                        leading: const Icon(Icons.swap_horiz),
                        selected: _currentIndex == 4,
                        tileColor: _currentIndex == 4
                            ? const Color.fromARGB(255, 61, 124, 251)
                            : null,
                        onTap: () {
                          _navigateToPage(4);
                        },
                      ),
                      ListTile(
                        title: const Text(
                          "Logout",
                          style: TextStyle(fontSize: 14),
                        ),
                        leading: const Icon(Icons.logout),
                        onTap: () {
                          // Show a confirmation dialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Logout"),
                                content: const Text(
                                    "Are you sure you want to logout?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text(
                                      "Cancel",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 61, 124, 251)),
                                    ),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      SharedPreferences prefs =
                                          await SharedPreferences.getInstance();
                                      prefs.clear();

                                      // ignore: use_build_context_synchronously
                                      Navigator.of(context).pushAndRemoveUntil(
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                LoginScreen()),
                                        (route) => false,
                                      );
                                    },
                                    child: const Text(
                                      "Logout",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 61, 124, 251)),
                                    ),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Expanded(
              flex: _isSidebarVisible ? 7 : 9,
              child: Column(
                children: [
                  AppBar(
                    title: Card(
                      color: Colors.blueGrey[100],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.menu, color: Colors.white),
                                onPressed: () {
                                  setState(() {
                                    _isSidebarVisible = !_isSidebarVisible;
                                  });
                                },
                              ),
                              Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Text(
                                  _currentIndex == 0
                                      ? "Dashboard"
                                      : _currentIndex == 1
                                          ? "User List"
                                          : _currentIndex == 2
                                              ? "Banners"
                                              : _currentIndex == 3
                                                  ? "Withdrawal List"
                                                  : _currentIndex == 4
                                                      ? "Transaction"
                                                      : "",
                                  style: const TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                          IconButton(
                              onPressed: () {}, icon: const Icon(Icons.person))
                        ],
                      ),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  Expanded(
                    child: IndexedStack(
                      index: _currentIndex,
                      children: _pages,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// class TransactionScreen extends StatelessWidget {
//   const TransactionScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Text("hfhgfgfg"),
//     );
//   }
// }

class BannerScreen extends StatelessWidget {
  const BannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Banner Screen"),
      ),
    );
  }
}
