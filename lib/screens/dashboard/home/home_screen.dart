import 'package:blood_donor/constants/color_constant.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _carouselImages = [];
  var _dotPostion = 0;
  Future getCarouselImage() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn = await firestore.collection('stores').get();
    setState(() {
      for (int i = 0; i < qn.docs.length; i++) {
        _carouselImages.add(qn.docs[i]['img']);
        print("${qn.docs[i]["img"]}");
      }
    });
    return qn.docs;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCarouselImage();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 2.2,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 400,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 3),
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                autoPlayCurve: Curves.fastOutSlowIn,
                enlargeCenterPage: true,
                enlargeFactor: 0.3,
                scrollDirection: Axis.horizontal,
                onPageChanged: (index, carouselPageChangeReason) {
                  setState(() {
                    _dotPostion = index;
                  });
                },
              ),
              items: _carouselImages.map((i) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          image: DecorationImage(
                              image: NetworkImage(i), fit: BoxFit.fitWidth)),
                    );
                  },
                );
              }).toList(),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          DotsIndicator(
            dotsCount: _carouselImages.isEmpty ? 1 : _carouselImages.length,
            position: _dotPostion.toDouble(),
            decorator: DotsDecorator(
              size: const Size.square(9.0),
              activeSize: const Size(18.0, 9.0),
              activeColor: primaryColor,
              activeShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BoxWidget(
                onTap: () {},
                icon: Icons.health_and_safety,
                text: 'Find a Donor',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.bloodtype,
                text: 'Blood Bank',
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const [
              BoxWidget(
                icon: Icons.message,
                text: 'Request',
              ),
              BoxWidget(
                icon: Icons.settings,
                text: 'Other',
              )
            ],
          ),
        ],
      ),
    ));
  }
}

class BoxWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final void Function()? onTap;
  const BoxWidget({Key? key, this.icon, this.text = '', this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.2,
            width: MediaQuery.of(context).size.width * 0.4,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(1, 2), // changes position of shadow
                ),
              ],
              color: whiteColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 90,
                  color: primaryColor,
                ),
                Text(text!)
              ],
            ),
          )
        ],
      ),
    );
  }
}
