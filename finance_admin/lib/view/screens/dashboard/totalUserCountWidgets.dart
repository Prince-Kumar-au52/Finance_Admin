import 'package:finance_admin/view/screens/user/userListScreen.dart';
import 'package:finance_admin/view/screens/withdrawal/completeWithdrawalScreen.dart';
import 'package:finance_admin/view/screens/withdrawal/pendingWithdrawalScreen.dart';
import 'package:finance_admin/view/screens/withdrawal/rejectWithdrawalScreen.dart';
import 'package:finance_admin/view/screens/withdrawal/withdrawalScreen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UserCountWidget extends StatefulWidget {
  @override
  _UserCountWidgetState createState() => _UserCountWidgetState();
}

class _UserCountWidgetState extends State<UserCountWidget> {
  int userCount = 0;
  int withdrowData = 0;
  int withdrowComplete = 0;
  int withdrowPending = 0;
  int withdrowRejected = 0;
  int totalWalletMoney = 0;
  int totalWithdrawnMoney = 0;
  int remainMoney = 0;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    fetchUserCount();
  }

  Future<void> fetchUserCount() async {
    final url = Uri.parse('http://localhost:5000/v1/auth/totalUser');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          userCount = data['userCount'];
          withdrowData = data['withdrowData'];
          withdrowComplete = data['withdrowComplete'];
          withdrowPending = data['withdrowPending'];
          withdrowRejected = data['withdrowRejected'];
          totalWalletMoney = data['totalWalletMoney'];
          totalWithdrawnMoney = data['totalWithdrawnMoney'];
          remainMoney = data['remainMoney'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          isError = true;
        });
      }
    } catch (error) {
      setState(() {
        isLoading = false;
        isError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : isError
            ? const Text('Error fetching user count')
            : Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Icon(
                      //   Icons.people,
                      //   size: 24,
                      //   color: Colors.grey,
                      // ),
                      // SizedBox(width: 8),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => UserListScreen()),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 171, 212, 218),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.people),
                              const Text("Total Users"),
                              Text(
                                "$userCount",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WithdrawalScreen()),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 236, 220, 197),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.money_off),
                              const Text("Total Withdrawal"),
                              Text(
                                "$withdrowData",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    CompleteWithdrawalScreen()),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 221, 249, 201),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.done_all),
                              const Text("Complete Withdrawal"),
                              Text(
                                "$withdrowComplete",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    PendingWithdrawalScreen()),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 249, 250, 204),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.pending),
                              const Text("Pending Withdrawal"),
                              Text(
                                "$withdrowPending",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    RejectedWithdrawalScreen()),
                          );
                        },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 254, 196, 196),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cancel),
                              const Text("Verification Rejected"),
                              Text(
                                "$withdrowRejected",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             RejectedWithdrawalScreen()),
                        //   );
                        // },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 233, 253, 167),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance_wallet),
                              const Text("Total Wallet Money"),
                              Text(
                                "₹$totalWalletMoney",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             RejectedWithdrawalScreen()),
                        //   );
                        // },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 253, 184, 253),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.attach_money),
                              const Text("Total Withdrawn Money"),
                              Text(
                                "₹$totalWithdrawnMoney",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        // onTap: () {
                        //   Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) =>
                        //             RejectedWithdrawalScreen()),
                        //   );
                        // },
                        child: Container(
                          height: 150,
                          width: size.width * .15 - 10,
                          decoration: BoxDecoration(
                              color: Color.fromARGB(255, 196, 200, 247),
                              borderRadius: BorderRadius.circular(20)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.account_balance_wallet),
                              const Text("Remain Balance"),
                              Text(
                                "₹$remainMoney",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              );
  }
}
