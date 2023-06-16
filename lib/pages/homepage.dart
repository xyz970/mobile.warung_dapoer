import 'dart:convert';

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:warung_dapoer/pages/cart.dart';
import 'package:warung_dapoer/pages/detail_menu.dart';
import 'package:warung_dapoer/pages/login.dart';
import 'package:http/http.dart' as http;
import 'package:warung_dapoer/pages/popularfoods.dart';

import '../animations/scale_route.dart';
import '../utils/api_url.dart';
import '../widget/bottomnav.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  List menu = [];
  String nama = '';

  @override
  void initState() {
    super.initState();
    getDataMenu();
    // print(menu);
  }

  Future getDataMenu() async {
    var url = "$base_url/barang";
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final header = {"Accept": "application/json"};
    http.Response response = await http.get(Uri.parse(url), headers: header);
    if (response.statusCode == 200) {
      var resbody = jsonDecode(response.body);
      setState(() {
        menu = resbody['data'];
        nama = prefs.getString("nama") ?? '';
      });
      print(menu);
    }
  }

  void logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("token");
    prefs.remove("nama");
    prefs.remove("email");
    await Get.offAll(const Login());
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAFAFA),
        elevation: 0,
        leading: IconButton(
            icon: Icon(
              Icons.logout,
              color: Color(0xFF3a3737),
            ),
            onPressed: () {
              logout();
            }),
        title: Text(
          "Home",
          style: TextStyle(
              color: Color(0xFF3a3737),
              fontSize: 20,
              fontFamily: GoogleFonts.poppins().fontFamily,
              fontWeight: FontWeight.bold),
        ),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.shopping_cart,
                color: Color(0xFF3a3737),
              ),
              onPressed: () {
                Get.to(const Cart());
              })
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.only(left: 10, top: 10),
            child: Text(
              "Halo $nama",
              style: TextStyle(
                  color: Color(0xFF3a3737),
                  fontSize: 12,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemCount: menu.length,
                itemBuilder: (_, index) {
                  return CustomCard(
                      id: menu[index]['id'],
                      keterangan: menu[index]['keterangan'],
                      harga: menu[index]['harga'],
                      title: menu[index]['nama_barang'],
                      image:
                          "https://cdn.pixabay.com/photo/2018/02/01/14/09/yellow-3123271_960_720.jpg");
                }),
          )
        ],
      ),
      // body: GridView.count(
      //   //widget yang akan ditampilkan dalam 1 baris adalah 2
      //   crossAxisCount: 2,
      //   children: [
      //     //card ditampilkan disini
      //     //saya membuat custom card di bawah agar kodingan tidak terlalu panjang
      //     CustomCard(
      //         title: "Judul Card Kedua",
      //         image:
      //             "https://cdn.pixabay.com/photo/2018/02/01/14/09/yellow-3123271_960_720.jpg"),
      //     CustomCard(
      //         title: "Judul Card Ketiga",
      //         image:
      //             "https://cdn.pixabay.com/photo/2016/08/27/14/38/mountains-1624284__340.jpg"),
      //     CustomCard(
      //         title: "Judul Card Keempat",
      //         image:
      //             "https://cdn.pixabay.com/photo/2016/11/29/02/23/cliffs-1866832__340.jpg"),
      //     CustomCard(
      //         title: "Judul Card Kelima",
      //         image:
      //             "https://cdn.pixabay.com/photo/2016/09/18/23/23/sugarloaf-mountain-1679285__340.jpg"),
      //   ],
      // ),
      // bottomNavigationBar: BottomNavBarWidget(),
    );
  }
}

//membuat customcard yang bisa kita panggil setiap kali dibutuhkan
class CustomCard extends StatelessWidget {
  //ini adalah konstruktor, saat class dipanggil parameter konstruktor wajib diisi
  //parameter ini akan mengisi title dan gambar pada setiap card
  CustomCard(
      {super.key,
      required this.id,
      required this.title,
      required this.keterangan,
      required this.image,
      required this.harga});

  String title;
  int id;
  String keterangan;
  int harga;
  String image;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(DetailMenu(
          gambar: image,
          harga: harga,
          nama_menu: title,
          id: id,
          keterangan: keterangan,
        ));
      },
      child: Padding(
        padding: const EdgeInsets.only(top: 10, left: 5, right: 5),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          //menambahkan bayangan
          elevation: 2,
          child: Container(
            width: MediaQuery.of(context).size.width / 3,
            height: MediaQuery.of(context).size.height / 4,
            child: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10), // Image border
                  child: SizedBox.fromSize(
                    // Image radius
                    child: Hero(
                        tag: id,
                        child: Image.network(image, fit: BoxFit.cover)),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5, top: 5),
                  child: Text(
                    title,
                    style: TextStyle(
                      color: Color(0xFF3a3737),
                      fontFamily: GoogleFonts.poppins().fontFamily,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(
                    NumberFormat.currency(
                      locale: 'id',
                      symbol: 'Rp ',
                      decimalDigits: 2,
                    ).format(harga),
                    style: TextStyle(
                        color: Color(0xFF3a3737),
                        fontFamily: GoogleFonts.poppins().fontFamily,
                        fontWeight: FontWeight.bold),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
