import 'package:easy_life_club/providers/providers.dart';
import 'package:easy_life_club/widgets/base/base.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../theme/app_theme.dart';
import '../widgets.dart';

class TermsAndConditions extends StatelessWidget {
  const TermsAndConditions({super.key, required this.onAccept});

  final VoidCallback onAccept;

  @override
  Widget build(BuildContext context) {
    final List<String> terms = [
      """TERMS AND CONDITIONS:
Terms of Service:
By activating your account and using the Easy Life Club, you agree to all of the terms and conditions of this Easy Life Club Usage Agreement ("Usage Agreement"). If you do not agree with any of the terms or conditions contained herein, please do not use Easy Life Club. Easy Life Club reserves the right to change, modify, add or remove portions of this Usage Agreement or the terms or conditions contained herein at any time. Changes to the agreement will be periodically made and included in a new "Usage Agreement" which will be posted in replacement of the old "Usage Agreement". Your continued use of Easy Life Club following the posting of any changes will mean that you have accepted the changes.
Payment
All monthly membership packages and à la carte service and hourly services can be paid for up front by personal check, money order or credit card; or divided into 12 monthly installments. We accept Visa, MasterCard and American Express. Any rates listed by Easy Life Club, are for services rendered directly by Easy Life Club and do not include charges for third party vendors, or merchandise purchased to complete the request. One hour minimum on all services requested with billing then being charged in 15 minute increments. We can provide services to you 24/7, however, Easy Life Club hours are 8:00 A.M. to 6:00 P.M. Monday through Friday. Services requested outside of normal business hours and/or on holidays may be subject to additional fees.
Third Party Expenses
At the User's request, Easy Life Clubmay purchase items either over the Internet or on the phone with third party vendors with the User's credit card. In the event that the User initially wants Easy Life Club to make purchases for the User, the User will be asked for a credit card to be used for those charges. Such authorization may be either orally or in writing. Any request over \$300 must be by email, fax, or other written authorization. Easy Life Club shall not purchase any item on behalf of the client from a third party unless first authorized to do so by the client. Easy Life Club does not warrant or stand behind any purchases made on the User's behalf. Easy Life Club is merely acting to facilitate the purchase and all disputes with charges need to be addressed to your Credit Card Company or merchant. All invoices, shipping information, etc. will be sent directly to Users email address for vendor. If Easy Life Club agrees to make a credit card purchase on behalf of the client (i.e. not made directly with the client’s credit card), Easy Life Club reserves the right to charge a convenience fee 2.5% .
Errands
Price for the personal rides and airport pick-up: \$ 5 for the pick up and \$ 3,50 per miles.
Hourly rate for on site errand running begins from the time the office in Bay Harbour is left until the requested task is completed. Mileage over 10 miles of travel currently billable at \$.55 per mile. (Please note mileage rates are subject to change based upon the IRS designated compensation rate.)
Areas of service include the greater Miami area and include the communities of Dade County and Broward County at an extra fee.
Cancellations
Services scheduled with less than 24 hours notice, may incur a convenience fee of \$25.00, to accommodate necessary scheduling changes. Services canceled without prior notice may result in the full price of service being charged.
Access to Property
If the task requested by the client requires access to a business or residence, arrangements must be made to allow Easy Life Club access to the property. If, for any reason, Easy Life Club cannot gain access, the full charge will be assessed to the client. Clients may choose an option of a key safe to arrange for service access or arranging for key pick up and drop off if the client is not available.
SERVICES:
Concierge services are for providing you with informational driven services, limited to virtual telephone oriented, email or online tasks. Our consultants will not physically provide any work such as pick-ups, mailings, drop offs, or any ERRAND SERVICES. Errand services (see below) are available at an hourly rate or a per-request rate and only and only in available areas. In addition, concierge requests do not include providing any secretarial services such checking email, creating spreadsheets or placing postings online. Other than that, we can find, research, book, call, remind, order online and do just about everything else you'd like for us to do on your behalf.
Airport Pick-ups: Areas of service include the greater Miami area and include the communities of Dade County and Broward County at an extra fee. All with a Time Limitation of Thirty minute (30 minutes) upon arrival and calculated time, after that time period there is an additional fee of USD 15.00 per every 30 minutes wait.
Errand running services include all personal assistant services that involve personal errand running, on location and cannot be handled over the phone or Internet. For requests beyond what is covered by concierge requests, the charge will be billed hourly or on a per request basis.
Concierge specialists are always based in our home office location in Bay Harbour, FL but it is not guaranteed that you will speak with or deal with the same concierge consultant each time you place a request, unless stipulated as part of your membership plan. Concierge specialists will do their best possible to provide you with the information or task at hand. However, there will be circumstances where such information or unusual requests are not fulfilled and Easy Life Club will not be held accountable, liable or financially responsible for any inaccurate information provided.
Annual Subscription
You will be billed 1 day prior to the beginning of your membership cycle each month automatically. Your subscription will renew automatically once you purchase your membership online or in person and agree to these terms. Please note that your membership will begin from the date you signed up and automatically renew in 360 days. Memberships are not set to renew at the beginning or ending of each month, rather they begin on the day that you activate your membership. Please make sure that you provide a credit card that you plan on keeping, that you have the appropriate billing address information for and that you plan on using for our charges. Unused credits and requests DO NOT ROLL OVER.
Cancellations
This Agreement may be terminated by either party hereto upon thirty (30) days written notice prior to the expiration date of the annual agreement. EasyLife Club reserves the right to terminate this Agreement for any reason whatsoever.
For any reason, if you want to terminate your account, please email us at info@easylifeclub.com for further instructions on how to cancel your membership.
Upgrades/Renewals/Automatic Billing
Your membership will automatically renew each year and you will be automatically billed. You will not be notified of the renewal. Therefore, you consent and allow Easy Life Club to charge your card each year or month without contacting you in any way, unless you notify us to cancel your account.   You can upgrade / downgrade your account based upon your usage at any time. You are eligible to upgrade or downgrade your account after 15 days have passed since your membership had last renewed. For upgrading you will pay the portion of the new membership, minus the portion you paid for your lower grade membership


Limitations
By agreeing to our terms, you realize that there are inherent limitations to the services we are to provide. We will not make illegal purchases on your behalf or represent you in any unlawful or illegal way. For purchases made on your behalf, Easy Life Club nor its employees will be held accountable for returns, refunds, or guarantees on behalf of the products or services your are purchasing. We will take all the precautions necessary to protect your information, but we will not be held responsible or accountable or liable for any reason whatsoever should your information become exposed or if you are not pleased with the products or services you approved for us to charge on your behalf. Concierge operators will also not lie on your behalf for any reason or be involved or responsible for any of your personal, business, financial or other actions. Our operators will not honor fraudulent outbound calling, money collections, prank calling or other illegal activities.
Time Limitations - Please keep in mind that to better service all of our clients we would appreciate your prompt inquires. Operators will not remain on hold for long periods of time, or provide in depth research with concierge requests. If that is desired, we can perform that task at an hourly or per-request rate. We anticipate that most concierge request calls will commence from beginning to end in approximately 2-4 minutes. If required we will divide the requests 20 minutes = 1 credit. In addition, for ASAP requests, we advise that you make such requests via telephone.
Refunds - There will be no refunds for services that are rendered. As mentioned above, to cancel monthly membership plans we must be notified in writing one month in advance. The current month will be billed for services accordingly, whereas the following month will not. There will also be no refunds for purchases made on your behalf. When you ask for our representatives to make purchases on your behalf, we will not be held accountable should the product or service your are purchasing not meet the expectations you had in mind. Please review on your own, all refund and exchange policies with the service providers you intend for us to make purchases on your behalf, PRIOR to asking that we make any purchases for you.    We will not be held accountable, liable or responsible in anyway for purchases on your behalf that are lost during shipping, tickets arriving late, goods damaged in the mail, etc. We will make purchases on your behalf simply to save you time, but will not be responsible for the goods or services we are purchasing.
Travel Arrangements - Travel Arrangements are also offered as part of our services. Easy Life Club will try to find you the best deal for air travel, hotel accommodations, limo services, etc. We will not be responsible any way and do not represent the quality or vouching of any of these service providers. As the customer, you are accountable for the final selection of your destination or service provider. If you are not pleased with any services referred to by our operators, please contact the service provider rather than Easy Life Club. Once we place, make a purchase or place an order for flights, hotels, or any other travel related services, we will not be held responsible for any refunds or disputes. It will be your responsibility to inquire upon any cancellation rules prior to booking and dispute any concerns you have directly with the service provider. Easy Life Club will not refund, credit or be held responsible whatsoever for any travel related purchases.
Text Messaging - from time to time, an Operator may offer to text you the information you are looking for. Whether you are looking for movie times, directions or a telephone number, we'll send you a text message. You agree that by saying yes to receiving the text message, you may be charged by your cell phone company. Easy Life Club will not reimburse or be responsible for your text message charges.
Should you sign up for our VIP Memberships, you will be assigned to a dedicated team of staff members. These staff persons will be your primary contact points for you to place your requests. You may reach these individuals via the common method of placing requests, however, your dedicated team will be assigned to your requests. Please take note that your individual staff members WILL NOT be available 24/7 (they've got to sleep too). You will be able to reach your dedicated staff team on business days Monday through Friday from 9am - 5pm pacific standard time. For times when they are not available, you will still be able to utilize our services by simply contacting the general concierge and assistants via the email address and telephone number listed in your Welcome Packet. VIP Memberships also allow a second card holder to place requests on your account. Please be advised that the primary account holder's information will be the only information stored on the account. The secondary account holder must be able to provide the primary's member # and verify the account information (email address, mailing address, telephone), etc. to utilize the account.
Gift Memberships - If you were provided with a Gift Membership it is required that you activate your membership within 12 months from the date of purchase. If you have not activated your membership in less than 12 months from receiving your gift membership, you will not be eligible for use of our service. Please note that your gift membership will expire within a predetermined period of time. You must utilize our service during this ACTIVE period of time as unused requests will not be made available for use or refunded whatsoever upon expiration. ALL SALES ARE FINAL.
Membership Card:
Mailing - Your Personalized Concierge Card will be mailed to you along with your Welcome Materials approximately 3 - 5 business days after joining Easy Life Club.
Lost Cards / Replacements - Should you lose your card or would like one replaced, the charge for the card is \$10.00. You may not add additional cards to your account for other users to reap benefits of the cards. There is a maximum of 1 card per membership, unless stipulated otherwise in your membership plan.
Discounts:
The Easy Life Club Card is not a credit card. It is a physical representation of your membership with Easy Life Club. You can use this card to obtain discounts and other benefits at active local discount participating locations.
Use of the Membership signifies acceptance and understanding of these terms and conditions. The Easy Life Club Card will be accepted by businesses listed in our Partner network. Should an "non valid" Concierge Card be presented at one of our local discount providers, the establishments will not accept the card. Please check the discount chart online at www.EasyLifeClub.com prior to visiting a discount provider. Each location and establishment has its own rules and various limitations on the acceptance of the card. When using the discount chart, read each listing carefully and thoroughly, and respect the merchants' participation and employees by not requesting exceptions or substitutions to advertised offers. When tipping, we ask that you base your tip on the entire check before you Easy Life Club Concierge Card discount. This is a true reflection of your satisfaction with the service and your generosity will assure their cheerful and continued participation in the program.
The list of merchants participating in the program is constantly changing. Due to circumstances beyond Easy Life Club's control, merchants periodically drop from the program or change their discount offer. At the same time, new businesses may be accepted to the program. For the most updated listing, please refer to the website. If the merchant does not appear on the website, it is no longer in the program. You are not entitled to a discount if a merchant has dropped out of the program, so be sure to check the website frequently. In the event that a participating merchant changes the discount offer or does not honor the Easy Life Club Concierge Card membership for any reason, Easy Life Club, will not be held responsible. This may occur because of change of ownership, management, or a misinformed employee. However, Easy Life Club, will use reasonable efforts to attempt to secure the merchant's compliance with the program. Please notify us of such inaccuracies at info@Easy Life Club.com. In addition, while

certain franchisees of national merchants with multiple locations may offer a discount, not all franchises or locations participate in the program. For more details about specific merchants, you must visit the business listings.
Privacy
Easy Life Club knows how important privacy is to you and is committed to honoring your privacy.
All personal and credit card information obtained is gathered for the purpose of providing concierge services and billing the client for services rendered. At no time, will the collected information be disclosed to a third party, except for the purpose of completing the client's financial obligation to Easy Life Club.
Limitation of Liability
In no event will Easy Life Club, any of its partners, providers, affiliates, including their respective officers, directors, employees or representatives, be liable for any indirect, incidental, compensatory or punitive damages or damages resulting from loss of p rofits, lost data or business interruption arising out of the use, inability to use, or the results of use of the service.   You agree to indemnify, defend and hold harmless Easy Life Club, its service providers, and each of their subsidiaries, affiliates, officers, directors, shareholders, beneficiaries, members, partners, employees, consultants, attorneys and agents and their respective successors and assigns, if any, (collectively the "Indemnified Parties") from and against all claims, actions, losses, liabilities, damages, costs and expenses (including, but not limited to, attorneys' fees and costs) arising from or relating to your use of the Services . Recommendations of third party vendors are at your own risk and Easy Life Club shall not be held responsible for any dissatisfaction from any service or merchandise. The decision to use any third party service vendor is totally your own, and is only a recommendation by us and holds no guarantees for satisfaction. An complaints, refunds, etc. should be directed to the speci fic vendor and not to Easy Life Club. The concierges' comments and recommendations presented are based on research and opinions collected by the concierges, and are subject to change at any time. In addition, all responses will be provided based upon REASONABLE research and efforts on behalf of our staff. We do not recommend utilizing our services for financial, legal, tax or other sensitive matters.
We use all reasonable endeavours to monitor the goods and/or services provided by our service partners but we can not accept responsibility for any loss, liability or cost incurred by you as a result of any acts or omissions of service partners nor can we guarantee the accuracy of information supplied to you by service partners. No guarantees can be given on behalf of any service partners. You shall require seeking compensation for any loss or damage suffered directly from the service partner.
Easy Life Club holds the right to refuse any business it feels is unsafe and unsuitable for its employees.
Notice:
All notices to a party shall be in writing and shall be made either via e-mail or U.S. mail. Notice shall be deemed given 24 hours after an e-mail that is not returned to the sender is sent, or 3 days after deposit in the U.S. mail, to you at the address provided by you upon registration and to Easy Life Club at the address set forth below.
Attn.: Chief Executive Officer Easy Life Club
1108 Kane Concourse
Office #308
Bay Harbour, Florida 33154
Easy Life Club will from time to time make changes to our terms of use policy as circumstances require. Changes will be effective when they have been posted on the Easy Life Club website.
2017 EASY LIFE CLUB - All rights reserved."""
    ];
    // todo: verify if terms and conditions were accepted
    final calendarProvider = Provider.of<CalendarProvider>(context);
    bool acceptedTermsAndConditions =
        calendarProvider.acceptedTermsAndConditions;

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      insetPadding: const EdgeInsets.all(10),
      contentPadding: const EdgeInsets.all(20),
      backgroundColor: AppTheme.primary,
      elevation: 60,
      content: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const CustomRoundedIconButton(
              backgroundColor: Color(0xff39424D),
              icon: FaIcon(FontAwesomeIcons.fileLines),
            ),
            const SizedBox(height: 20),
            Text(
              "Terms and conditions",
              style: AppTheme.darkTheme.textTheme.headlineMedium,
            ),
            const SizedBox(height: 20),
            Text(
              "Terms and conditions must be accepted in order to book a product/service",
              style: AppTheme.darkTheme.textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            SizedBox(
              height: 280,
              width: MediaQuery.of(context).size.width,
              child: Scrollbar(
                radius: const Radius.circular(20),
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  controller: ScrollController(keepScrollOffset: true),
                  itemCount: terms.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.all(0),
                      visualDensity: const VisualDensity(
                        horizontal: 0,
                        vertical: -4,
                      ),
                      title: Text(
                        terms[index],
                        style: AppTheme.darkTheme.textTheme.bodyLarge,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: acceptedTermsAndConditions,
                  onChanged: (value) async {
                    await calendarProvider
                        .changeTermsAndConditionsStatus(value!);

                  },
                  activeColor: AppTheme.secondary,
                ),
                const Text("I agree to the terms and conditions"),
              ],
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.only(bottom: 20),
      actions: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 80),
          child: GestureDetector(
            onTap: onAccept,
            child: const PrimaryButton(
              text: "Accept",
            ),
          ),
        ),
      ],
    );
  }
}
