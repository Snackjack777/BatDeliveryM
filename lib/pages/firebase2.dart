import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lotto/pages/filebase.dart';
import 'package:lotto/shared/appdata.dart';
import 'package:provider/provider.dart';

class Filebase2Pages extends StatefulWidget {
  const Filebase2Pages({super.key});

  @override
  State<Filebase2Pages> createState() => _Filebase2PagesState();
}

class _Filebase2PagesState extends State<Filebase2Pages> {
  final TextEditingController docCtl = TextEditingController();
  final TextEditingController nameCtl = TextEditingController();
  final TextEditingController messageCtl = TextEditingController();
  final TextEditingController latitudeCtl = TextEditingController();
  final TextEditingController longitudeCtl = TextEditingController();
  var db = FirebaseFirestore.instance;
  StreamSubscription? listener;
  String collectiontext = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    collectiontext = 'Rider';
    docCtl.text = 'Rider-2545';



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Column(
          children: [
            const Text('Pages2'),
            const Text('Document'),
            TextField(
              controller: docCtl,
            ),
            const Text('Name'),
            TextField(
              controller: nameCtl,
            ),
            const Text('Message'),
            TextField(
              controller: messageCtl,
            ),
            const Text('latitude'),
            TextField(
              controller: latitudeCtl,
            ),
            const Text('longitude'),
            TextField(
              controller: longitudeCtl,
            ),
            FilledButton(
                onPressed: () {
                  var data = {
                    'name': nameCtl.text,
                    'message': messageCtl.text,
                    'latitude':
                        double.parse(latitudeCtl.text), 
                    'longitude':
                        double.parse(longitudeCtl.text), 
                    'createAt': DateTime.timestamp()
                  };

                  db.collection(collectiontext).doc(docCtl.text).set(data);
                },
                child: const Text('Add Data')),
            SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: readData, child: const Text('Read Data')),
            SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: queryData, child: const Text('Query Data')),
            SizedBox(
              height: 10,
            ),
            FilledButton(onPressed: queryData2, child: const Text('Query Data2')),
            SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: startRealtimeGet,
                child: const Text('Start Real-time Get')),
            SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: stopRealTime,
                child: const Text('Stop Real-time Get')),
            SizedBox(
              height: 10,
            ),
            FilledButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const FilebasePages()),
                  );
                },
                child: const Text('Page1')),
                FilledButton(
  onPressed: deleteData,
  child: const Text('Delete Data'),
),

          ],
        ),
      ),
    );
  }

  void readData() async {
    var result = await db.collection(collectiontext).doc(docCtl.text).get();
    var data = result.data();
    log(data!['message']);
    log((data['createAt'] as Timestamp).millisecondsSinceEpoch.toString());
    log((data['name'] ));

  }

  void deleteData() async {
  try {
    await db.collection(collectiontext).doc(docCtl.text).delete();
    log("Document ${docCtl.text} deleted successfully");
    Get.snackbar("Success", "Document deleted successfully");
  } catch (e) {
    log("Failed to delete document: $e");
    Get.snackbar("Error", "Failed to delete document");
  }
}


  void queryData() async {
    var inboxRef = db.collection(collectiontext);
    var query = inboxRef.where("name", isEqualTo: nameCtl.text);
    var result = await query.get();
    if (result.docs.isNotEmpty) {
      log(result.docs.first.data()['message']);
    }
  }

  void queryData2() async {
  var inboxRef = db.collection(collectiontext);
  var query = inboxRef.where("name", isEqualTo: nameCtl.text);
  var result = await query.get();

  if (result.docs.isNotEmpty) {
    for (var doc in result.docs) {
      log("Document ID: ${doc.id}");
      log("Message: ${doc.data()['message']}");
      log("Name: ${doc.data()['name']}");
      log("Latitude: ${doc.data()['latitude']}");
      log("Longitude: ${doc.data()['longitude']}");
    }
  } else {
    log("No documents found");
  }
}


  void startRealtimeGet() {
    final docRef = db.collection(collectiontext).doc(docCtl.text);

    if (context.read<AppData>().listener != null) {
      context.read<AppData>().listener!.cancel();
      context.read<AppData>().listener = null;
      log('Listener Stop');
    }

    context.read<AppData>().listener = docRef.snapshots().listen(
      (event) {
        var data = event.data();
        Get.snackbar(data!['name'].toString(), data['message'].toString());
        log("current data: ${event.data()}");
      },
      onError: (error) => log("Listen failed: $error"),
    );
  }

  void stopRealTime() {
    if (context.read<AppData>().listener != null) {
      context.read<AppData>().listener!.cancel();
      context.read<AppData>().listener = null;
      log('Listener Stop');
    }
  }
}
