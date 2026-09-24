import 'package:easy_life_club/theme/app_theme.dart';
import 'package:flutter/material.dart';
import '../widgets/base/base.dart';
import '../widgets/widgets.dart';

class RealStateScreen extends StatelessWidget {
  const RealStateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> cars = [
      {
        "id": 1,
        "name": "real_state 1",
        "pricePerHour": 400,
        "description":
            "Sint ipsum laboris cillum sunt in ea consectetur sunt proident sit laborum ex sint. Velit excepteur ipsum anim ullamco culpa quis pariatur fugiat sit sit et incididunt anim aliquip. Labore sit enim nostrud do non sunt nostrud. Exercitation duis duis ea incididunt enim irure et fugiat id sunt est nulla.",
        "img": "https://picsum.photos/id/1/200/300",
        "hp": 123,
        "capacity_liters": 5.4,
        "capacity_cc": 5.4,
        "motor_type": "Dual Motor",
        "topSpeed": 300,
        "accelerationTime": 2.2,
        "tag": "car1"
      },
      {
        "id": 2,
        "name": "real_state 2",
        "pricePerHour": 350,
        "description":
            "Sint ipsum laboris cillum sunt in ea consectetur sunt proident sit laborum ex sint. Velit excepteur ipsum anim ullamco culpa quis pariatur fugiat sit sit et incididunt anim aliquip. Labore sit enim nostrud do non sunt nostrud. Exercitation duis duis ea incididunt enim irure et fugiat id sunt est nulla.",
        "img": "https://picsum.photos/id/1/200/300",
        "hp": 444,
        "capacity_liters": 5.46,
        "capacity_cc": 3.3,
        "motor_type": "Dual Motor",
        "topSpeed": 300,
        "accelerationTime": 3.8,
        "tag": "car2"
      },
      {
        "id": 3,
        "name": "real_state 3",
        "pricePerHour": 200,
        "description":
            "Sint ipsum laboris cillum sunt in ea consectetur sunt proident sit laborum ex sint. Velit excepteur ipsum anim ullamco culpa quis pariatur fugiat sit sit et incididunt anim aliquip. Labore sit enim nostrud do non sunt nostrud. Exercitation duis duis ea incididunt enim irure et fugiat id sunt est nulla.",
        "img": "https://picsum.photos/id/1/200/300",
        "hp": 510,
        "capacity_liters": 4.2,
        "capacity_cc": 5.3,
        "motor_type": "Dual Motor",
        "topSpeed": 300,
        "accelerationTime": 4.8,
        "tag": "car3"
      },
      {
        "id": 4,
        "name": "real_state 4",
        "pricePerHour": 320,
        "description":
            "Sint ipsum laboris cillum sunt in ea consectetur sunt proident sit laborum ex sint. Velit excepteur ipsum anim ullamco culpa quis pariatur fugiat sit sit et incididunt anim aliquip. Labore sit enim nostrud do non sunt nostrud. Exercitation duis duis ea incididunt enim irure et fugiat id sunt est nulla.",
        "img": "https://picsum.photos/id/1/200/300",
        "hp": 720,
        "capacity_liters": 4.6,
        "capacity_cc": 3.2,
        "motor_type": "Dual Motor",
        "topSpeed": 300,
        "accelerationTime": 5.2,
        "tag": "car4"
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.primary,
      appBar: const CustomAppBar(
        title: "REAL STATE",
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                children: [
                  const _Founder(),
                  _Cards(cars: cars),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Cards extends StatelessWidget {
  const _Cards({
    Key? key,
    required this.cars,
  }) : super(key: key);

  final List<Map<String, dynamic>> cars;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: cars.length,
      itemBuilder: (BuildContext context, int index) {
        return CustomCard(
          imgURL: cars[index]["img"],
          title: cars[index]["name"],
          price: cars[index]["pricePerHour"].toString(),
          route: "car_info",
          description: cars[index]["description"],
          tag: cars[index]["tag"],
          topSpeed: cars[index]["topSpeed"],
          accelerationTime: cars[index]["accelerationTime"],
          hp: cars[index]["hp"],
          capacityLiters: cars[index]["capacity_liters"],
          capacityCc: cars[index]["capacity_cc"],
          motorType: cars[index]["motor_type"],
        );
      },
    );
  }
}

class _Founder extends StatelessWidget {
  const _Founder({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      width: double.infinity,
      color: AppTheme.primary,
      padding: const EdgeInsets.all(40),
      child: const Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            child: Image(
              image: AssetImage("assets/founder.jpg"),
            ),
          ),
          SizedBox(height: 30),
          Text(
            '''Founder of Easy Life Club and Licensed Real Estate Agent, with 5 years of experience, specialized in the Miami Market. He’s young, energetic and entrepreneurial.  He offers clients a first-hand perspective of the quintessential Miami Beach lifestyle.
As a quadrilingual, born in Switzerland and having lived in five (5) countries, Anthony holds an international experience and is able to assist in many fields.
Anthony believes that adding value is of paramount importance and his passion and grand capacity in Real Estate will allow and ensure that you to go through the process smoothly to acquire your dream home in Florida''',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              height: 1.3,
            ),
            textAlign: TextAlign.justify,
          ),
        ],
      ),
    );
  }
}
