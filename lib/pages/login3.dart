// import 'dart:convert';
// import 'dart:developer';
// import 'package:bcrypt/bcrypt.dart';
// import 'package:flutter/material.dart';
// import 'package:lotto/config/config.dart';
// import 'package:lotto/model/response/LottoNumberGetRespon.dart';
// import 'package:lotto/pages/admin.dart';
// import 'package:lotto/pages/usermain.dart';
// import 'register.dart';
// import 'package:http/http.dart' as http;
// import 'package:get_storage/get_storage.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   TextEditingController inputCtl = TextEditingController();
//   TextEditingController pass1Ctl = TextEditingController();

//   String url = '';

//   @override
//   void initState() {
//     super.initState();
//     //Configguration config = Configguration();

//     Configguration.getConfig().then(
//       (value) {
//         log(value['apiEndpoint']);
//         setState(() {
//           url = value['apiEndpoint'];
//         });
//       },
//     ).catchError((err) {
//       log(err.toString());
//     });
//   }

//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SingleChildScrollView(
//         child: Container(
//           color: const Color.fromARGB(255, 104, 189, 108),
//           height: MediaQuery.of(context).size.height,
//           child: Column(
//             children: [
//               const SizedBox(
//                 height: 80,
//               ),
//               Image.asset(
//                 'assets/images/poto.png',
//                 fit: BoxFit.cover,
//               ),
//               Padding(
//                 padding: const EdgeInsets.all(35.0),
//                 child: SizedBox(
//                   width: MediaQuery.of(context).size.width,
//                   height: 280,
//                   child: Container(
//                     decoration: BoxDecoration(
//                       color: const Color.fromARGB(164, 245, 218, 137),
//                       borderRadius: BorderRadius.circular(16.0),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           const Text(
//                             'Email or Username',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: inputCtl,
//                             keyboardType: TextInputType.emailAddress,
//                             decoration: const InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   width: 2.0,
//                                   color: Colors.black12,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   width: 2.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               contentPadding: EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 16),
//                             ),
//                           ),
//                           const SizedBox(height: 16),
//                           const Text(
//                             'Password',
//                             style: TextStyle(
//                               color: Colors.black,
//                               fontSize: 20,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 8),
//                           TextField(
//                             controller: pass1Ctl,
//                             obscureText: true,
//                             decoration: const InputDecoration(
//                               filled: true,
//                               fillColor: Colors.white,
//                               border: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   width: 2.0,
//                                   color: Colors.black12,
//                                 ),
//                               ),
//                               focusedBorder: OutlineInputBorder(
//                                 borderSide: BorderSide(
//                                   width: 2.0,
//                                   color: Colors.black,
//                                 ),
//                               ),
//                               contentPadding: EdgeInsets.symmetric(
//                                   vertical: 12, horizontal: 16),
//                             ),
//                           ),
//                           const SizedBox(height: 14),
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               SizedBox(
//                                 width: 110,
//                                 child: ElevatedButton(
//                                   onPressed: () {
//                                     Navigator.push(
//                                       context,
//                                       MaterialPageRoute(
//                                         builder: (context) =>
//                                             const RegisterPage(),
//                                       ),
//                                     );
//                                   },
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                         WidgetStateProperty.all(Colors.amber),
//                                     foregroundColor:
//                                         WidgetStateProperty.all(Colors.black),
//                                   ),
//                                   child: const Text('Register'),
//                                 ),
//                               ),
//                               SizedBox(
//                                 width: 110,
//                                 child: ElevatedButton(
//                                   onPressed: () =>
//                                       login(context, inputCtl, pass1Ctl),
//                                   style: ButtonStyle(
//                                     backgroundColor:
//                                         WidgetStateProperty.all(Colors.blue),
//                                     foregroundColor:
//                                         WidgetStateProperty.all(Colors.white),
//                                   ),
//                                   child: const Text('Login'),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void login(BuildContext context, TextEditingController inputCtl,
//       TextEditingController pass1Ctl) async {
//     // final response = await http.get(
//     //   Uri.parse("$url/login/${inputCtl.text}"), // ใช้ input แทน email
//     //   headers: {"Content-Type": "application/json; charset=utf-8"},
//     // );

//     // final response = await http.get(
//     //   Uri.parse("$url/login/miki553"),
//     //   headers: {"Content-Type": "application/json; charset=utf-8"},
//     // );

//     final response = await http.post(
//       Uri.parse(
//           "$url/login/find"), // Changed from GET to POST and removed the input from the URL
//       headers: {"Content-Type": "application/json; charset=utf-8"},
//       body: jsonEncode({"input": 'max'}), // Send input in the body as JSON
//     );

// //
// //
// //

//     if (response.statusCode == 200) {
//       final userList = jsonDecode(response.body) as List<dynamic>;

//       if (userList.isNotEmpty) {
//         final user = userList[0] as Map<String, dynamic>;
//         final hashedPassword = user['password'] as String;

//         // final passwordMatch = BCrypt.checkpw(pass1Ctl.text, hashedPassword);

//         final passwordMatch = BCrypt.checkpw('123', hashedPassword);

//         if (passwordMatch) {
//           late List<LottoNumberGetRespon> LottonumberDB;
//           List<String> LottoShow;
//           try {
//             var res = await http.get(
//               Uri.parse('$url/lottoryNumber/showforsellLotto'),
//               headers: {"Content-Type": "application/json; charset=utf-8"},
//             );

//             if (res.statusCode == 200) {
//               LottonumberDB = lottoNumberGetResponFromJson(res.body);
//               LottoShow =
//                   LottonumberDB.map((item) => item.lottoNumber).toList();
//               final storage = GetStorage();
//               await storage.write('lottoNumber', jsonEncode(LottoShow));
//             } else {
//               throw Exception('Failed to load lottery numbers');
//             }
//           } catch (error) {
//             log('Error fetching lottery numbers: $error');
//           }

//           final storage = GetStorage();
//           // การบันทึกข้อมูลผู้ใช้โดยใช้คีย์ที่ไม่ซ้ำกัน
//           await storage.write('userId', user['member_id'].toString());
//           await storage.write('userUsername', user['username'].toString());
//           await storage.write('userEmail', user['email'].toString());
//           await storage.write(
//               'userWalletBalance', user['wallet_balance'].toString());
//           await storage.write('userType', user['type'].toString());

//           _showDialog(
//             context,
//             'Login successful',
//             'You are logged in successfully.',
//             onOkPressed: () {
//               if (user['type'] == 'user') {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => UsermainPages(),
//                   ),
//                 );
//               } else {
//                 Navigator.pushReplacement(
//                   context,
//                   MaterialPageRoute(builder: (context) => AdminPage()),
//                 );
//               }
//             },
//           );
//         } else {
//           print('Login failed: invalid password');
//           _showDialog(context, 'Login failed', 'Invalid password');
//         }
//       } else {
//         print('Login failed: user not found');
//         _showDialog(context, 'Login failed', 'User not found');
//       }
//     } else if (response.statusCode == 404) {
//       print('Login failed: user not found');
//       _showDialog(context, 'Login failed', 'User not found');
//     } else {
//       print('Error: ${response.reasonPhrase}');
//       _showDialog(context, 'Error', 'Error: ${response.reasonPhrase}');
//     }
//   }

//   void _showDialog(BuildContext context, String title, String message,
//       {VoidCallback? onOkPressed}) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           backgroundColor:
//               const Color(0xFFC6C7A6), // เปลี่ยนสีพื้นหลังของ AlertDialog
//           title: Text(title),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//                 if (onOkPressed != null) {
//                   onOkPressed();
//                 }
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor:
//                     const Color(0xFF6DA47B), // เปลี่ยนสีพื้นหลังของปุ่ม "ตกลง"
//                 foregroundColor: Colors.black, // เปลี่ยนสีข้อความของปุ่ม "ตกลง"
//                 side: const BorderSide(
//                     color: Colors.black, width: 0.5), // เพิ่มขอบสีดำ
//               ),
//               child: const Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
