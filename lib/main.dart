import 'package:chatappliaction/get.dart';
import 'package:chatappliaction/msg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as Socket;

void main() {
  Get.put(getdart());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Socket.Socket SOCKET;
  TextEditingController textcontroller = TextEditingController();
  ScrollController scrollContro = ScrollController();
  getdart mmd = getdart();
  @override
  void initState() {
    connectToServer();
    super.initState();
  }

  void connectToServer() {
    SOCKET = Socket.io(
        "http://192.168.0.238:4000",
        Socket.OptionBuilder()
            .setTransports(['websocket'])
            .enableAutoConnect()
            .build());
    lisen();
  }

  void lisen() {
    SOCKET.onConnect((_) {
      print('Connected to socket server');
    });
    fetc();
  }

  void fetc() {
    SOCKET.on('message-rec', (data) {
      mmd.chart.add(message.fromjson(data));
      mmd.update();
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      scrollContro.jumpTo(scrollContro.position.maxScrollExtent);
    });
  }

  void sedmsg(String txt) {
    Map<String, dynamic> messae = {"message": txt, "sender": SOCKET.id};
    SOCKET.emit('my_event', messae);
    mmd.chart.add(message.fromjson(messae));
    textcontroller.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    SOCKET.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Socket.IO'),
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
              child: Obx(
            () => ListView.builder(
              controller: scrollContro,
              shrinkWrap: true,
              itemCount: mmd.chart.length,
              itemBuilder: (context, index) {
                return Align(
                  alignment: SOCKET.id == mmd.chart[index].send
                      ? Alignment.topRight
                      : Alignment.topLeft,
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: SOCKET.id == mmd.chart[index].send ? 0 : 10,
                        right: SOCKET.id == mmd.chart[index].send ? 10 : 0),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                          color: SOCKET.id == mmd.chart[index].send
                              ? Colors.green
                              : Colors.grey,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(8),
                            topRight: Radius.circular(8),
                            bottomLeft: SOCKET.id == mmd.chart[index].send
                                ? Radius.circular(8)
                                : Radius.circular(0),
                            bottomRight: SOCKET.id == mmd.chart[index].send
                                ? Radius.circular(0)
                                : Radius.circular(8),
                          )),
                      padding: const EdgeInsets.all(8),
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2),
                          child: Text(
                            "${mmd.chart[index].messag}",
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          )),
                    ),
                  ),
                );
              },
            ),
          )),
          SizedBox(
            height: 60,
            width: double.infinity,
            child: Center(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                child: TextFormField(
                  controller: textcontroller,
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () => sedmsg(textcontroller.text),
                      icon: const Icon(
                        Icons.send,
                        size: 30,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
