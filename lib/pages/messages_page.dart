
import 'package:izmir/consts/consts.dart';

class message_page extends StatefulWidget {
  const message_page({Key? key}) : super(key: key);

  @override
  State<message_page> createState() => _message_pageState();
}

class _message_pageState extends State<message_page> {
  @override
  Widget build(BuildContext context) {
    var wdt = (MediaQuery.of(context).size.width);
    var het = (MediaQuery.of(context).size.height);
    return Container(
      color: Colors.white,
      width: wdt,
      height: het,
      child: Column(
        children: [
        ],
      ),
    );
  }
}
