import 'package:booking/Management/ThongKe/resources/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Thongke extends StatefulWidget {
  const Thongke({super.key});

  @override
  State<Thongke> createState() => _LineChartSample2State();
}

class _LineChartSample2State extends State<Thongke> {
  List<Color> gradientColors = [
    AppColors.contentColorCyan,
    AppColors.contentColorBlue,
  ];

  bool showAvg = false;
List<int> lstCount = List<int>.filled(4, 0); // Khởi tạo biến để lưu số lượng người dùng

  @override
  void initState() {
    super.initState();
    fetchUserCount();
    
  }
  Future<int> getUserCount() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('user').get();
    return querySnapshot.size; // Trả về số lượng tài liệu
  } catch (e) {
    print("Error getting user count: ${e.toString()}");
    return 0; // Trả về 0 nếu có lỗi
  }
  
}
Future<int> getBookingHistory() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('HistoryCustomer').get();
    return querySnapshot.size; // Trả về số lượng tài liệu
  } catch (e) {
    print("Error getting BookingCustomer count: ${e.toString()}");
    return 0; // Trả về 0 nếu có lỗi
  }
  
}
Future<int> getRoom() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Room').get();
    return querySnapshot.size; // Trả về số lượng tài liệu
  } catch (e) {
    print("Error getting Room count: ${e.toString()}");
    return 0; // Trả về 0 nếu có lỗi
  }
  
}
Future<int> getTable() async {
  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('Table').get();
    return querySnapshot.size; // Trả về số lượng tài liệu
  } catch (e) {
    print("Error getting Table count: ${e.toString()}");
    return 0; // Trả về 0 nếu có lỗi
  }
  
}

  Future<void> fetchUserCount() async {
    int count = await getUserCount();
    int bk=await getBookingHistory();
    int room=await getRoom();
    int table=await getTable();

    setState(() {
       lstCount[0]=count;
       lstCount[1]=bk;
       lstCount[2]=room;
       lstCount[3]=table;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.black,
      child: Center(
        child: Stack(
          children: <Widget>[
            AspectRatio(
              aspectRatio: 1.70,
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 18,
                  left: 12,
                  top: 24,
                  bottom: 12,
                ),
                child: LineChart(
                  showAvg ? avgData() : mainData(),
                ),
              ),
            ),
            SizedBox(
              width: 60,
              height: 34,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    showAvg = !showAvg;
                  });
                },
                child: Text(
                  '',
                  style: TextStyle(
                    fontSize: 12,
                    color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: Colors.white
    );
    Widget text;
    switch (value.toInt()) {
      case 2:
        text = const Text('USER', style: style);
        break;
      case 4:
        text = const Text('Booking History', style: style);
        break;
      case 6:
        text = const Text('Room', style: style);
        break;
      case 8:
        text = const Text('Table', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: text,
    );
  }

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 15,
      color: Colors.white
    );
    String text;
    switch (value.toInt()) {
      case 10:
        text = '10';
        break;
      case 20:
        text = '20';
        break;
      case 30:
        text = '30';
        break;
      case 40:
        text = '40';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.left);
  }

  LineChartData mainData() {
    return LineChartData(
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: AppColors.mainGridLineColor,
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            interval: 1,
            getTitlesWidget: bottomTitleWidgets,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            interval: 1,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 40,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(0, 0),
            FlSpot(2, lstCount[0].toDouble()),
            FlSpot(4, lstCount[1].toDouble()),
            FlSpot(6, lstCount[2].toDouble()),
            FlSpot(8, lstCount[3].toDouble()),
            FlSpot(9.5, 3),
            FlSpot(11, 4),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: gradientColors,
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: gradientColors
                  .map((color) => color.withOpacity(0.3))
                  .toList(),
            ),
          ),
        ),
      ],
    );
  }

  LineChartData avgData() {
    return LineChartData(
      lineTouchData: const LineTouchData(enabled: false),
      gridData: FlGridData(
        show: true,
        drawHorizontalLine: true,
        verticalInterval: 1,
        horizontalInterval: 1,
        getDrawingVerticalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
        getDrawingHorizontalLine: (value) {
          return const FlLine(
            color: Color(0xff37434d),
            strokeWidth: 1,
          );
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 30,
            getTitlesWidget: bottomTitleWidgets,
            interval: 1,
          ),
        ),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: leftTitleWidgets,
            reservedSize: 42,
            interval: 1,
          ),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      ),
      borderData: FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      ),
      minX: 0,
      maxX: 11,
      minY: 0,
      maxY: 6,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(0, 4),
            FlSpot(2.6, 2),
            FlSpot(4.9, 3.44),
            FlSpot(6.8, 3.44),
            FlSpot(8, 3.44),
            FlSpot(9.5, 3.44),
            FlSpot(11, 3.44),
          ],
          isCurved: true,
          gradient: LinearGradient(
            colors: [
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
              ColorTween(begin: gradientColors[0], end: gradientColors[1])
                  .lerp(0.2)!,
            ],
          ),
          barWidth: 5,
          isStrokeCapRound: true,
          dotData: const FlDotData(
            show: false,
          ),
          belowBarData: BarAreaData(
            show: true,
            gradient: LinearGradient(
              colors: [
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
                ColorTween(begin: gradientColors[0], end: gradientColors[1])
                    .lerp(0.2)!
                    .withOpacity(0.1),
              ],
            ),
          ),
        ),
      ],
    );
  }
}