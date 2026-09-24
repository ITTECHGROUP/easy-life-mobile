// ignore_for_file: lines_longer_than_80_chars

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/base/base.dart';

class FAQScreen extends StatelessWidget {
  const FAQScreen({Key? key}) : super(key: key); 

  @override
  Widget build(BuildContext context) {
    
    return const Scaffold(
      backgroundColor: Color(0xff1A1E23),
      appBar: CustomAppBar(title: 'FAQ',showArrowBack: true,),
      body: SafeArea(
        child: Stack(
          children: [
            Background(),
            Padding(
              padding: EdgeInsets.symmetric(
                vertical: 30.0,
                horizontal: 6,
              ),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: FAQExpansionListPanel(),
              )
            )
          ],
        )
      )
    );
  }
} 

class FAQItem {
  FAQItem({
    required this.expandedValue,
    required this.headerValue,
    this.isExpanded = false,
  });
  
  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<FAQItem> generateItems(List _faqs) {
  return List<FAQItem>.generate(_faqs.length, (int i) {
    return FAQItem(
      headerValue: _faqs[i]['question'],
      expandedValue: _faqs[i]['answer'],
    );
  });
}

class FAQExpansionListPanel extends StatefulWidget {
  const FAQExpansionListPanel({super.key});
  @override
  State<FAQExpansionListPanel> createState() => _FAQExpansionListPanelState();
}

class _FAQExpansionListPanelState extends State<FAQExpansionListPanel> {
  final List<FAQItem> _data = generateItems(_faqs);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        child: _buildPanel(),
      ),
    );
  }  

    Widget _buildPanel() {
    return ExpansionPanelList(
      dividerColor: const Color.fromARGB(183, 224, 224, 224),
      elevation: 0,
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((FAQItem item) {
        return 
        ExpansionPanel(
          // Add transparent background
          backgroundColor: Colors.transparent,
          headerBuilder: (BuildContext context, bool isExpanded) {
            return 
                ListTile(
                  title: Text(
                    item.headerValue,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white.withOpacity(0.8),
                      height: 2.1,
                    ),
                  ),
                );
          },
          body: ListTile(
            title: Text(
              item.expandedValue,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: Colors.white.withOpacity(0.8),
                height: 1.8,
              ),
            ),
          ),
          isExpanded: item.isExpanded,
        );

        
      }).toList(),
    );
  } 

}

List _faqs = [
  {
    'question': 'What is the minimum age to rent a car?',
    'answer': 'To rent a car with Easy Life Club in Miami, FL you need to be at least 21 with a valid license.',
  },
  {
    'question': 'What is the minimum number of days to rent a car?',
    'answer': '1 day is the minimum amount to rent an exotic car, 2 days is the minimum for any other car.',
  },
  {
    'question': 'Is the insurance included in the total price per day?',
    'answer': 'Yes.',
  },
  {
    'question': 'What is the daily milage limit?',
    'answer': '100 miles per day.',
  },
  {
    'question': 'Does the car have to be returned with a full tank of gas?',
    'answer': 'It has to be returned with the same amount of gas it was delivered.',
  },
  {
    'question': 'Can I smoke in the car?',
    'answer': 'No, it is prohibited.',
  },
  {
    'question': 'Is there a delivery fee? How can I avoid it?',
    'answer': 'Yes, there is a \$20USD or \$30USD delivery fee. You can avoid the delivery fee by picking up the car at our office (address is given once car is booked).',
  },
  {
    'question': 'Is a deposit required to rent a car?',
    'answer': 'Yes. The price varies with the type of car.',
  },
  {
    'question': 'What happens if I cancel the car I already reserved?',
    'answer': 'A cancellaton fee is charged, price varies depending on the car. Unless the car is cancelled within 3 weeks in advance, there will be no fee.',
  },
  {
    'question': 'What is the maximum amount of people that can go in a yacht I rent?',
    'answer': 'By law, 13 is the maximum amount of people that can go in the yacht.',
  },
  {
    'question': 'What is included in a yacht rental?',
    'answer': 'Captain, gasoline and soft drinks are included in the yacht rental. The tip for the captain is not included, that should be paid extra and clients usually give a 10% tip.',
  },
  {
    'question': 'Do I have to live in Miami or have an apartment in Miami in order to be an Easy Life Club member?',
    'answer': 'No, there is no need to live in Miami to be a member, our Freestyle membership is perfect for foreigners.',
  },
  {
    'question': 'What services does Easy Life Club offer?',
    'answer': 'Plenty of them, including: Private transportation, personal shopping, access to reservations in any restaurant, access to our private space, invitations to all of our events, special discounts, booking to wellness and health services, and much more.',
  },
  {
    'question': 'Do you offer real estate services?',
    'answer': 'Yes, we do in Florida.',
  }
];

