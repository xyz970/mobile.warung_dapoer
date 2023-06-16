import 'dart:convert';

import 'package:customizable_counter/customizable_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_dapoer/pages/homepage.dart';
import 'package:warung_dapoer/utils/api_url.dart';
import 'package:warung_dapoer/widget/stepper.dart';

class DetailMenu extends StatefulWidget {
  final String gambar;
  final int id;
  final int harga;
  final String nama_menu;
  final String keterangan;
  const DetailMenu(
      {super.key,
      required this.gambar,
      required this.harga,
      required this.nama_menu,
      required this.id,
      required this.keterangan});

  @override
  State<DetailMenu> createState() => _DetailMenuState();
}

class _DetailMenuState extends State<DetailMenu> {
  int jumlah_pesanan = 0;

  void tambah_pesanan(
      String nama_barang, int jumlah_pesanan, harga, barang_id) async {
    if (jumlah_pesanan == 0) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Mohon isi jumlah pemesanan")));
      // Get.snackbar("Ooppss", "Mohon isi jumlah pemesanan");
    } else {
      final body = {
        "nama_barang": nama_barang,
        "harga": harga,
        "quantity": jumlah_pesanan,
        "barang_id": barang_id
      };
      var url = "$base_url/transaksi/insert";
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString("token");
      final header = {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "content-type": "application/json",
      };
      http.Response response = await http.post(Uri.parse(url),
          body: jsonEncode(body),
          headers: header,
          encoding: Encoding.getByName("utf-8"));
      var resbody = jsonDecode(response.body);
      if (response.statusCode == 200) {
        // print(response.body);
        Get.off(const Homepage());
      } else {
        print(response.body);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            CupertinoIcons.chevron_back,
            color: Color(0xFF545D68),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Detail Menu',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: const Color(0xFF545D68),
          ),
        ),
      ),
      body: ListView(
        children: [
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: Text(
              widget.nama_menu,
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 40,
                fontWeight: FontWeight.w800,
                color: const Color(0xFFF17532),
              ),
            ),
          ),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 16,
            ),
            child: Hero(
              tag: widget.id,
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(32),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.gambar),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              NumberFormat.currency(
                locale: 'id',
                symbol: 'Rp ',
                decimalDigits: 2,
              ).format(widget.harga),
              style: TextStyle(
                fontFamily: GoogleFonts.poppins().fontFamily,
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: const Color(0xFFF17532),
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: Text(
              widget.nama_menu,
              style: TextStyle(
                color: const Color(0xFF575E67),
                fontFamily: GoogleFonts.poppins().fontFamily,
              ),
            ),
          ),
          SizedBox(height: 16),
          Center(
            child: SizedBox(
              width: MediaQuery.of(context).size.width - 52.0,
              child: Text(
                widget.keterangan,
                maxLines: 4,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontSize: 16,
                  color: const Color(0xFFB4B8B9),
                ),
              ),
            ),
          ),
          SizedBox(height: 28),
          Center(
              child: CustomizableCounter(
            borderColor: const Color(0xFFF17532),
            borderWidth: 5,
            borderRadius: 100,
            showButtonText: false,
            backgroundColor: const Color(0xFFF17532),
            buttonText: "Add Item",
            textColor: Colors.white,
            textSize: 15,
            count: 0,
            step: 1,
            minCount: 0,
            incrementIcon: const Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
            decrementIcon: const Icon(
              CupertinoIcons.minus,
              color: Colors.white,
            ),
            onCountChange: (count) {
              setState(() {
                jumlah_pesanan = count.toInt();
              });
              print(jumlah_pesanan);
            },
            onIncrement: (count) {},
            onDecrement: (count) {},
          )),
          SizedBox(height: 16),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 100.0,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: const Color(0xFFF17532),
              ),
              child: Center(
                child: InkWell(
                  onTap: () async {
                    // print("pesan cuy");
                    tambah_pesanan(widget.nama_menu, jumlah_pesanan,
                        widget.harga, widget.id);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 8),
                      Text(
                        'Pesan Sekarang',
                        style: TextStyle(
                          fontFamily: GoogleFonts.poppins().fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 28),
        ],
      ),
    );
  }
}
