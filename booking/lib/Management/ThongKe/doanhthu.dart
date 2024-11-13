import 'package:booking/Management/ThongKe/resources/app_colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
Map<int, List<double>> yearlyMonthlyTotals = {};
Future<void> calculateYearlyMonthlyTotal() async {
  // Khởi tạo Firestore
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Lấy tất cả các tài liệu từ collection 'bill'
  QuerySnapshot snapshot = await firestore.collection('Bill').get();
yearlyMonthlyTotals={};
  // Tạo một Map để lưu tổng giá trị theo năm và tháng

  for (var doc in snapshot.docs) {
    // Lấy giá trị price
    double price = doc['price']?.toDouble() ?? 0.0;

    // Lấy giá trị start và kiểm tra kiểu dữ liệu
    dynamic startValue = doc['start'];
    DateTime dateTime;

    // Kiểm tra kiểu dữ liệu
    if (startValue is Timestamp) {
      dateTime = startValue.toDate(); // Nếu là Timestamp
    } else if (startValue is String) {
      dateTime = DateTime.parse(startValue); // Nếu là String, chuyển đổi thành DateTime
    } else {
      continue; // Bỏ qua nếu không phải kiểu hợp lệ
    }

    // Lấy năm và tháng từ dateTime
    int year = dateTime.year;
    int monthIndex = dateTime.month - 1; // Chuyển đổi thành chỉ số từ 0 đến 11

    // Khởi tạo danh sách cho năm nếu chưa có
    if (!yearlyMonthlyTotals.containsKey(year)) {
      yearlyMonthlyTotals[year] = List<double>.filled(12, 0.0);
    }

    // Cộng dồn giá trị price cho tháng tương ứng trong năm
    yearlyMonthlyTotals[year]![monthIndex] += price;
  }

  // Sắp xếp các năm
  var sortedYears = yearlyMonthlyTotals.keys.toList()..sort();

  // In ra tổng giá trị theo năm và tháng
  for (var year in sortedYears) {
    print('Năm: $year');
    for (int i = 0; i < yearlyMonthlyTotals[year]!.length; i++) {
      String month = '${i + 1}'; // Tạo chuỗi tháng (1-12)
      double total = yearlyMonthlyTotals[year]![i];
      print('  Tháng: $month, Tổng giá: $total');
    }
  }

  
}
 final List<String> list = <String>['2021', '2022', '2023', '2024'];
 String year='2024';
class Doanhthu extends StatefulWidget {
  const Doanhthu({super.key});

  @override
  State<Doanhthu> createState() => _DoanhthuState();
}

class _DoanhthuState extends State<Doanhthu> {
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
    calculateYearlyMonthlyTotal();
    
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
    Size size = MediaQuery.sizeOf(context);
    // print(yearlyMonthlyTotals);
    return Container(
      width:  double.infinity,
      color:  Colors.black,
      child: SingleChildScrollView(
        child: Column(
        
          children:[ 
            
            Container(
              margin:EdgeInsets.only(top: 20),
              child:const Text('Bảng thống kê số liệu hệ thống', 
              style:  TextStyle(  
                color: Colors.white,
                fontFamily: 'Candal',
                fontSize: 25
              ),),
            ),
            
               Container(
                margin: EdgeInsets.only(left: size.width/6),
                child: Row(children:[
                DropdownMenuExample(),
                GestureDetector(
                onTap: (){
                  setState(() {
                    
                    calculateYearlyMonthlyTotal();
                    
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(left: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      width: 1,
                      color: Colors.white
                    )
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(left: 10,right: 19,top: 3,bottom: 3),
                    child: Text('  Cập nhật',
                    style: TextStyle(color: Colors.white),),
                  ),
                ),
                          )
                          ] 
                          ),
              ),
            
            Container(
            width: size.width/1.5,
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
                    
                      
                      child: Text(
                        'Trăm ngàn',
                        style: TextStyle(
                          fontSize: 12,
                          color: showAvg ? Colors.white.withOpacity(0.5) : Colors.white,
                        ),
                      ),
                    
                  ),
                   
                  
                ],
              ),
            ),
          ),
          Container(
            margin:EdgeInsets.only(top: 20),
            child:const Text('Bảng thống kê số liệu hệ thống chi tiết', 
            style:  TextStyle(  
              color: Colors.white,
              fontFamily: 'Candal',
              fontSize: 25
            ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(left: size.width/5.5, right: size.width/6),
            decoration:   BoxDecoration(
              border: Border.all(
                width: 1,
                color:  Colors.white
              ),
              
            ),
            child: Column(
              children: [ 
                Container(
                  decoration:   BoxDecoration(
                   border: Border.all(
                  width: 1,
                  color:  Colors.white
                  ),
              
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:10,bottom: 10,left: 50,right: 50),
                    child: Row(
                      children: [
                        const Text('Tổng số người dùng : ',
                        style: TextStyle( 
                          color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),),
                        Text(lstCount[0].toString() +'  người', style:
                        const TextStyle(
                           color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),)
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration:   BoxDecoration(
                   border: Border.all(
                  width: 1,
                  color:  Colors.white
                  ),
              
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:10,bottom: 10,left: 50,right: 50),
                    child: Row(
                      children: [
                        const Text('Tổng số lượt đặt phòng, bàn : ',
                        style: TextStyle( 
                          color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),),
                        Text(lstCount[1].toString() +'  đơn', style:
                        const TextStyle(
                           color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),)
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration:   BoxDecoration(
                   border: Border.all(
                  width: 1,
                  color:  Colors.white
                  ),
              
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:10,bottom: 10,left: 50,right: 50),
                    child: Row(
                      children: [
                        const Text('Tổng số phòng : ',
                        style: TextStyle( 
                          color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),),
                        Text(lstCount[2].toString() +'  phòng', style:
                        const TextStyle(
                           color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),)
                      ],
                    ),
                  ),
                ),
                Container(
                  decoration:   BoxDecoration(
                   border: Border.all(
                  width: 1,
                  color:  Colors.white
                  ),
              
                  ),
                  child: Padding(
                    padding: EdgeInsets.only(top:10,bottom: 10,left: 50,right: 50),
                    child: Row(
                      children: [
                        const Text('Tổng số bàn : ',
                        style: TextStyle( 
                          color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),),
                        Text(lstCount[3].toString() +'  bàn', style:
                        const TextStyle(
                           color: Colors.white,
                          fontFamily: 'Candal',
                          fontSize:20
                        ),)
                      ],
                    ),
                  ),
                ),
                
              ],
            ),
          ),
          
          
          ]
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
      case 0:
        text = const Text('Jan', style: style);
        break;
      case 1:
        text = const Text('Feb', style: style);
        break;
      case 2:
        text = const Text('Mar', style: style);
        break;
      case 3:
        text = const Text('Apr', style: style);
        break;
      case 4:
        text = const Text('May', style: style);
        break;
      case 5:
        text = const Text('June', style: style);
        break;
      case 6:
        text = const Text('July', style: style);
        break;
      case 7:
        text = const Text('Aug', style: style);
        break;
      case 8:
        text = const Text('Sep', style: style);
        break;
      case 9:
        text = const Text('Oct', style: style);
        break;
      case 10:
        text = const Text('Nov', style: style);
        break;
      case 11:
        text = const Text('Dec', style: style);
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
        text = '1';
        break;
      case 20:
        text = '2';
        break;
      case 30:
        text = '3';
        break;
      case 40:
        text = '4';
      case 50:
        text = '5';
      case 60:
        text = '6';
      case 70:
        text = '7';
      case 80:
        text = '8';  
      case 90:
        text = '9';  
      case 100:
        text = '10';  
      case 110:
        text = '11';  
      case 120:
        text = '12';
      case 130:
        text = '13';  
      case 140:
        text = '14';  
      case 150:
        text = '15';    
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
      maxY: 150,
      lineBarsData: [
        LineChartBarData(
          spots:  [
            FlSpot(0,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![0]/100000:0),
            FlSpot(1,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![1]/100000:0),
            FlSpot(2,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![2]/100000:0),
            FlSpot(3,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![3]/100000:0),
            FlSpot(4,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![4]/100000:0),
            FlSpot(5,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![5]/100000:0),
            FlSpot(6,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![6]/100000:0),
            FlSpot(7,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![7]/100000:0),
            FlSpot(8,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![8]/100000:0),
            FlSpot(9,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![9]/100000:0),
            FlSpot(10,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year)]![10]/100000:0),
            FlSpot(11,yearlyMonthlyTotals.containsKey(int.parse(year)) ? yearlyMonthlyTotals[int.parse(year!)]![11]/100000:0),
            
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
class DropdownMenuExample extends StatefulWidget {
  const DropdownMenuExample({super.key});

  @override
  State<DropdownMenuExample> createState() => _DropdownMenuExampleState();
}

class _DropdownMenuExampleState extends State<DropdownMenuExample> {
  String dropdownValue = year;

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      textStyle: TextStyle(color: Colors.white),
     
      initialSelection: year,
      onSelected: (String? value) {
        // This is called when the user selects an item.
        setState(() {
          dropdownValue = value!;
          year=value;   
        });
      },
      dropdownMenuEntries: list.map<DropdownMenuEntry<String>>((String value) {
        return DropdownMenuEntry<String>(value: value, label: value);
      }).toList(),
      
      
    );
  }
}
