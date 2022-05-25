
import 'package:flutter/material.dart';
import 'scripts/ServerState.dart';
import 'scripts/receiveingState.dart';
import 'scripts/tcpImplementation.dart';
import './widgets/button.dart';
import './widgets/receiver.dart';
import './widgets/server.dart';
import './widgets/dialogue.dart';
import 'models/history.dart';
import 'package:open_file/open_file.dart';

const primaryColor = Colors.cyan;
const popupprimary = Color.fromRGBO(238, 238, 238, 1);
var primaryDark = Colors.cyan.shade600;
final _serverState = ServerStatusBloc();
final _recState = ReceivingState();


void main(){

  TCPImplementation tcp = TCPImplementation(port: 5000);
  tcp.startServer(_serverState, _recState);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Roboto",
        primaryColor: Colors.cyan,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const MyHomePage(title: 'Share Karo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  String fileName = "";
  String fileType = "";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: const Duration(seconds: 2),
    )..repeat();
    _recState.getJsonObj.listen((event) {
      fileName = event.getName;
      fileType = event.getType;
    });
  }


  Widget _buildBody() {
    return AnimatedBuilder(
      animation: CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(150 * _controller.value),
            _buildContainer(200 * _controller.value),
            _buildContainer(250 * _controller.value),
            _buildContainer(300 * _controller.value),
            _buildContainer(350 * _controller.value),
            GestureDetector(
              onTap: (){
                DialogueGeneral(callback: Receiver(recState: _recState,fileName: fileName, fileType: fileType,),heightContainer: 170).genDailogue(context);
              },
                child: const Align(child: Icon(Icons.download_sharp, size: 44,))
            ),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.cyan.withOpacity(1 - _controller.value),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(widget.title),

      ),
      body: Center(

        child: Stack(
          alignment: Alignment.topCenter,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 50.0),
                  child: SizedBox(
                      height: 300,
                      width: 300,
                      child: _buildBody()
                  ),
                ),
              ],
            ),
            History(context: context)
          ],
        ),
      )
    );
  }
}

// ignore: must_be_immutable
class History extends StatefulWidget{

  History ({Key? key, required this.context}) : super(key: key);

  BuildContext context;

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<HistoryModel> history = historyModels;
  late BuildContext cont;

  @override
  void initState(){
    super.initState();
     _recState.getMessage.listen((event){
      DialogueGeneral(callback: acceptMessage(event),heightContainer: 120).genDailogue(context);
    });
    _serverState.serverstatus.listen((event) {
      if(event){
        DialogueGeneral(callback: Server(), heightContainer: 100).genDailogue(context);
      }if(!event){
        if(Navigator.canPop(context)){
          Navigator.pop(context);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    cont = context;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 500,
          // color: Colors.grey.shade200,
          child: DraggableScrollableSheet(
            initialChildSize: .50,
            minChildSize: .45,
            maxChildSize: .7,
            builder: (BuildContext context, ScrollController scrollController){
              return  Column(
                children: [
                  headings(),
                  Expanded(
                    // width: MediaQuery.of(context).size.width,
                    // height: 500,
                      child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        controller: scrollController,
                        itemCount: history.length,
                        itemBuilder: (context, index){
                          return Container(
                            padding: const EdgeInsets.all(5),
                            child: ExpansionTile(
                              backgroundColor: Colors.grey.shade300,
                              collapsedBackgroundColor: Colors.grey.shade200,
                              title: Text(
                                "${history[index].getName}",
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize:16,color: Color.fromRGBO(0, 0, 0, 0.62),),
                              ),
                              subtitle: Text(
                                "${history[index].getPath}",
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize:8,color: Color.fromRGBO(0, 0, 0, 0.62),

                                ),
                              ),
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 4.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.fromLTRB(20, 10, 0, 10),
                                            child: Text("${history[index].getDateTime}", style: const TextStyle(fontSize:12,color: Color.fromRGBO(0, 0, 0, 0.62),),),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        height: 30,
                                        width: 70,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0))),
                                              backgroundColor: MaterialStateProperty.all<Color>(primaryDark),
                                              foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                          ),
                                          onPressed: (){
                                            setState(() {
                                              OpenFile.open("${history[index].getPath}/${history[index].getName}");
                                            });
                                          },
                                          child:Text("${history[index].getType}",style: const TextStyle(fontSize:12)),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 40,
                                        width: 70,
                                        child: Center(
                                          child: ElevatedButton(
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0))),
                                                backgroundColor: MaterialStateProperty.all<Color>(primaryDark),
                                                foregroundColor: MaterialStateProperty.all<Color>(Colors.white)
                                            ),
                                            onPressed: (){
                                              setState(() {
                                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text("Deleted ${history[index].getName}",
                                                    style: const TextStyle(color: Colors.black54,),),
                                                  backgroundColor: Colors.cyan,
                                                  elevation: 0.5,
                                                  dismissDirection: DismissDirection.horizontal,
                                                ));
                                                history.removeAt(index);
                                              });
                                            },
                                            child: const Icon(Icons.delete, size: 20,),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },

                      )

                  )
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  Widget headings(){
    return (
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: const [
                Text("Your history", style: TextStyle(fontFamily: "Roboto", fontSize: 24.0, color: primaryColor,fontWeight: FontWeight.w600)),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(image: AssetImage("assets/images/history.png")),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: OutlinedButton(
              style: ButtonStyle(
                side: MaterialStateProperty.all<BorderSide>(const BorderSide(color: Color.fromRGBO(62, 118, 121, 0.67), width: 1.5)),
                shape: MaterialStateProperty.all<OutlinedBorder>(RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)))
              ),
              onPressed: (){
                DialogueGeneral(callback: clearAll(), heightContainer: 120).genDailogue(widget.context);
            }, child: const Text("clear all", style: TextStyle(fontSize: 15.0, color: primaryColor)))
          ),

        ],
      )
    );
  }

  Widget clearAll(){
      return Column(
        textDirection: TextDirection.ltr,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text("Are you sure you want to clear all?",
                style: TextStyle(fontFamily: "Roboto", color: primaryDark, fontSize: 15, fontWeight: FontWeight.normal,decoration: TextDecoration.none)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Button(color: Colors.transparent,text: "Cancel", textColor:primaryDark, callback: (){Navigator.pop(context);},)
                  ),
                ),
              Button(color: primaryDark, text:"Yes", textColor: Colors.white, callback: (){
                historyModels.clear();
                Navigator.pop(context);
                }
              )
              ],
            ),
          )
        ],
      );
  }

  Widget acceptMessage(msg){
      return Column(
        textDirection: TextDirection.ltr,
        children: [
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Row(
              children: [
                Text("$msg",
                style: TextStyle(fontFamily: "Roboto", color: primaryDark, fontSize: 17, fontWeight: FontWeight.normal,decoration: TextDecoration.none)),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20,0,20,0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50.0)
                    ),
                    child: Button(color: Colors.transparent,text: "Cancel", textColor:primaryDark, callback: (){
                      _recState.sendResp.add("n");
                      Navigator.pop(context);
                    },)
                  ),
                ),
              Button(color: primaryDark, text:"Yes", textColor: Colors.white, callback: (){
                  _recState.sendResp.add("y");
                  Navigator.pop(context);
                })
              ],
            ),
          )
        ],
      );
    }
}