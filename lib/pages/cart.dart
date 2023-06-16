import 'dart:convert';

import 'package:customizable_counter/customizable_counter.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:counter/counter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_dapoer/pages/homepage.dart';

import '../utils/api_url.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  List data = [];
  bool isLoading = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  void getData() async {
    setState(() {
      isLoading = true;
    });
    var url = "$base_url/transaksi";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: header);
    var resbody = jsonDecode(response.body);
    if (response.statusCode == 200) {
      print(resbody['data']);
      setState(() {
        data = resbody['data'];
      });
    }
    setState(() {
      isLoading = false;
    });
  }

  void order_menu() async {
    var url = "$base_url/transaksi/order";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         "Pemesanan akan diantar ketika pesanan sudah selesai.. silahkan tunggu terlebih dahulu")));
      Get.off(Homepage());
    } else {
      print(response.body);
    }
  }

  tambah_pesanan(int id, qty, harga) async {
    print("tambah qty");
    var url = "$base_url/transaksi/order/qty/$id";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token",
      "content-type": "application/json",
    };
    final body = {
      "quantity": qty,
      "harga": harga,
    };
    http.Response response = await http.post(Uri.parse(url),
        headers: header, body: jsonEncode(body));
    print(response.body);
    if (response.statusCode == 200) {
      // getData();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         "Pemesanan akan diantar ketika pesanan sudah selesai.. silahkan tunggu terlebih dahulu")));
      // Get.off(Homepage());
    } else {
      print(response.body);
    }
  }

  void hapus_pesanan(int id) async {
    var url = "$base_url/transaksi/order/delete/$id";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString("token");
    final header = {
      "Accept": "application/json",
      "Authorization": "Bearer $token"
    };
    http.Response response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      getData();
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      //     content: Text(
      //         "Pemesanan akan diantar ketika pesanan sudah selesai.. silahkan tunggu terlebih dahulu")));
      // Get.off(Homepage());
    } else {
      print(response.body);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              CupertinoIcons.left_chevron,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {
              Get.back();
            }),
        backgroundColor: const Color(0xFFFAFAFA),
        title: Text(
          "Keranjang",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold),
        ),
      ),
      body: isLoading
          ? Center(
              child: Text("Loading..."),
            )
          : data.isEmpty
              ? Center(
                  child: Text("Keranjang Kosong"),
                )
              : Container(
                  margin: const EdgeInsets.all(5.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.separated(
                          itemCount: data.length,
                          separatorBuilder: (_, __) => Divider(),
                          itemBuilder: (context, index) {
                            return Card(
                              child: ListTile(
                                  isThreeLine: true,
                                  leading: Container(
                                    width: 100,
                                    height: 100,
                                    decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: NetworkImage(
                                                "https://cdn.pixabay.com/photo/2018/02/01/14/09/yellow-3123271_960_720.jpg"))),
                                  ),
                                  title: Text(
                                    data[index]['nama_barang'],
                                    style: TextStyle(
                                      fontFamily:
                                          GoogleFonts.poppins().fontFamily,
                                    ),
                                  ),
                                  trailing: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFF17532),
                                    ),
                                    onPressed: () {
                                      _alert(data[index]['id']);
                                    },
                                    child: Icon(Icons.delete),
                                  ),
                                  subtitle: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4.0),
                                        child: Text(
                                          NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 2,
                                          ).format(double.parse(
                                              data[index]['harga'])),
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.poppins()
                                                .fontFamily,
                                          ),
                                        ),
                                      ),
                                      // Counter(
                                      //   initial: data[index]['quantity'],
                                      //   min: 0,
                                      //   max: 10,
                                      //   step: 1,
                                      //   onValueChanged: (value) {
                                      //     print(value);
                                      //     tambah_pesanan(
                                      //         data[index]['id'],
                                      //         data[index]['quantity'],
                                      //         data[index]['harga']);
                                      //   },
                                      // ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            top: 4.0, bottom: 4.0),
                                        child: Text(
                                          "Total: \n${NumberFormat.currency(
                                            locale: 'id',
                                            symbol: 'Rp ',
                                            decimalDigits: 2,
                                          ).format(double.parse(data[index]['subtotal']))}",
                                          style: TextStyle(
                                              fontFamily: GoogleFonts.poppins()
                                                  .fontFamily,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  )),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Grand Total : ${NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 2,
                              ).format(grand_total())}",
                            ),
                            ElevatedButton(
                              onPressed: () {
                                _confirmationDialog();
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFF17532)),
                              child: Container(
                                width: double.infinity,
                                child: Center(
                                  child: Text(
                                    "Pesan",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
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

  double grand_total() {
    double total = 0.0;
    for (var i = 0; i < data.length; i++) {
      total = total + double.parse(data[i]['subtotal']);
    }
    return total;
  }

  void _confirmationDialog() {
    Get.defaultDialog(
      title: "Apakah anda yakin untuk melanjutkan ?",
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Batal",
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFF17532))),
            onPressed: () {
              order_menu();
              print("Konfirmasi");
            },
            child: Text(
              "Konfirmasi",
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ))
      ],
      titleStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.bold),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 300,
            height: 200,
            child: ListView.separated(
              itemCount: data.length,
              separatorBuilder: (_, __) => Divider(),
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                      isThreeLine: true,
                      leading: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                            image: DecorationImage(
                                image: NetworkImage(
                                    "https://cdn.pixabay.com/photo/2018/02/01/14/09/yellow-3123271_960_720.jpg"))),
                      ),
                      title: Text(
                        data[index]['nama_barang'],
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                        ),
                      ),
                      subtitle: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 4.0, bottom: 4.0),
                            child: Text(
                              "Total: \n${NumberFormat.currency(
                                locale: 'id',
                                symbol: 'Rp ',
                                decimalDigits: 2,
                              ).format(double.parse(data[index]['subtotal']))}",
                              style: TextStyle(
                                  fontFamily: GoogleFonts.poppins().fontFamily,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )),
                );
              },
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              "Grand Total : ${NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp ',
                decimalDigits: 2,
              ).format(grand_total())}",
            ),
          ),
        ],
      ),
    );
  }

  void _alert(int id) async {
    Get.defaultDialog(
      // barrierDismissible: true,
      title: "Apakah anda yakin untuk menghapus?",
      titleStyle: TextStyle(
          fontFamily: GoogleFonts.poppins().fontFamily,
          fontSize: 17,
          fontWeight: FontWeight.bold),
      content: Center(
        child: Text(
          "Pesanan anda akan dihapus. proses ini tidak bisa dibatalkan",
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            fontSize: 12,
          ),
        ),
      ),
      actions: [
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.black)),
            onPressed: () {
              Get.back();
            },
            child: Text(
              "Batal",
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            )),
        ElevatedButton(
            style: ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all(const Color(0xFFF17532))),
            onPressed: () {
              hapus_pesanan(id);
              Get.back();
              print("Konfirmasi");
            },
            child: Text(
              "Konfirmasi",
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ))
      ],
    );
  }
}
