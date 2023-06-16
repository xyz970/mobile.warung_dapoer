import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(0xFF545D68),
          ),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: Text(
          'Pesan',
          style: TextStyle(
            fontFamily: GoogleFonts.poppins().fontFamily,
            color: const Color(0xFF545D68),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notifications_none,
              color: Color(0xFF545D68),
            ),
            onPressed: () {},
          ),
        ],
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
                fontWeight: FontWeight.bold,
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
                    print("pesan cuy");
                    // await FlutterLaunch.launchWhatsapp(
                    //   phone: '6285640899224',
                    //   message:
                    //       'Hi Bahri Cakery,Saya mau order $nama_menu untuk hari ini, apa bisa diantar kerumah?',
                    // );
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
