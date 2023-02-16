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
    super.initState();
    getCarouselImage();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          AspectRatio(
            aspectRatio: 2.5,
            child: CarouselSlider(
              options: CarouselOptions(
                height: 200,
                aspectRatio: 16 / 9,
                viewportFraction: 0.9,
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
          Wrap(
            spacing: 12.0, // gap between adjacent chips
            runSpacing: 12.0, // gap between lines
            children: <Widget>[
              BoxWidget(
                onTap: () {},
                icon: Icons.health_and_safety,
                text: 'Find a Donor',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.bloodtype,
                text: 'Blood Bank',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.message,
                text: 'Request',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.settings,
                text: 'Other',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.location_on,
                text: 'Location',
              ),
              BoxWidget(
                onTap: () {},
                icon: Icons.settings,
                text: 'Setting',
              )
            ],
          ),
        ],
      ),
    );
  }
}

class BoxWidget extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final MainAxisAlignment? mainAxisAlignment;
  final void Function()? onTap;
  const BoxWidget(
      {Key? key, this.icon, this.text = '', this.onTap, this.mainAxisAlignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.height * 0.15
                : MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).orientation == Orientation.portrait
                ? MediaQuery.of(context).size.width * 0.27
                : MediaQuery.of(context).size.width * 0.28,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: const Offset(1, 2), // changes position of shadow
                ),
              ],
              color: primaryColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? MediaQuery.of(context).size.height * 0.07
                          : MediaQuery.of(context).size.height * 0.2,
                  color: whiteColor,
                ),
                Text(
                  text!,
                  style: const TextStyle(color: whiteColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
