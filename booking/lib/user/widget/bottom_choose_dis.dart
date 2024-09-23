import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BottomChooseDis {
    static int? selectedIndex; 

  static Future<void> showBottom(BuildContext context, List<dynamic> voucher, Function(String) onDiscountSelected, Function(int) indexs, int  select) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Cho phép điều chỉnh kích thước
      builder: (BuildContext ctx) {
        String formatNumber(int number) {
          final formatter = NumberFormat('#,##0');
          return formatter.format(number);
        }
        
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          height: MediaQuery.of(ctx).size.height * 0.5,
          child: ListView.builder(
            itemCount: voucher.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(top: 20, left: 25, right: 25),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 5,
                        blurRadius: 7,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.all(10),
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: voucher[index]['img'] != null
                              ? DecorationImage(
                                  image: NetworkImage(voucher[index]['img']),
                                  fit: BoxFit.cover,
                                )
                              : null,
                          color: Colors.transparent,
                        ),
                        child: voucher[index]['img'] == null
                            ? const Icon(Icons.image, size: 10)
                            : null,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              voucher[index]['name'],
                              style: const TextStyle(
                                fontFamily: 'Candal',
                                color: Color(0xff57A5EC),
                                fontSize: 15,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 5),
                            Text(
                              voucher[index]['introduc'],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 12,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                            ),
                            SizedBox(height: 5),
                            Text(
                              '${formatNumber(voucher[index]['point'])} VND',
                              style: const TextStyle(
                                color: Colors.red,
                                fontFamily: 'Cabin',
                                fontSize: 30,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            GestureDetector(
                              onTap: () {
                                indexs(index); 
                                if (selectedIndex != null && selectedIndex == index) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Đã chọn voucher')),
                                  );
                                } else {
                                  onDiscountSelected(voucher[index]['point'].toString());
                                  selectedIndex = index; // Cập nhật selectedIndex
                                }
                                Navigator.pop(ctx); // Đóng bottom sheet
                              },
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  select==index?'Selected':'Select',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                height: 26,
                                width: 127,
                                decoration: BoxDecoration(
                                  color: Color(0xff1A4368),
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                            SizedBox(height: 15),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}