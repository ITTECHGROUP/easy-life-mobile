import 'package:easy_life_club/widgets/video_player_widget.dart';
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key? key,
    this.title,
    this.imgURL,
    this.videoUrl,
    this.price,
    this.route,
    this.tag,
    this.description,
    this.topSpeed,
    this.accelerationTime,
    this.hp,
    this.capacityLiters,
    this.capacityCc,
    this.motorType,
    this.isApartment = false,
    this.duration = 1,
  }) : super(key: key);

  final String? title;
  final String? price;
  final String? imgURL;
  final String? videoUrl;
  final String? route;
  final String? description;
  final String? tag;
  final int? topSpeed;
  final double? accelerationTime;
  final int? hp;
  final double? capacityLiters;
  final double? capacityCc;
  final String? motorType;
  final bool isApartment;
  final int duration;

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);

    return Container(
      padding: const EdgeInsets.all(6),
      width: queryData.size.width - 10,
      margin: const EdgeInsets.symmetric(vertical: 16),
      // height: isApartment ? 220 : 200,
      decoration: BoxDecoration(
        color: const Color(0xff1A1E23),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 4,
            offset: const Offset(0, 4), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: const Radius.circular(20),
              bottom: title != null
                  ? const Radius.circular(0)
                  : const Radius.circular(20),
            ),
            child: 
                videoUrl != null
                ? SizedBox(
                  height: title != null ? 150 : 188,
                  width: double.infinity,
                  child: VideoPlayerWidget(
                    videoUrl: videoUrl!,
                  ),
                ) 
                : imgURL != null && imgURL!.contains('http')
                ? FadeInImage.assetNetwork(
                    placeholder: 'assets/loading_indicator.gif',
                    fadeOutCurve: Curves.easeOutQuad,
                    fadeOutDuration: Duration(milliseconds: duration),
                    placeholderFit: BoxFit.cover,
                    image: imgURL!,
                    height: title != null ? 150 : 188,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  )
                : Image.asset(
                    imgURL!,
                    height: title != null ? 150 : 188,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
          ),
          title != null ? const SizedBox(height: 10) : Container(),
          title != null
              ? Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Stack(
                    // mainAxisAlignment: ,
                    // mainAxisSize: MainAxisSize.min,
                    // mainAxisAlignment: price != null
                    //     ? MainAxisAlignment.spaceBetween
                    //     : MainAxisAlignment.center,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            mainAxisAlignment: price != null
                                ? MainAxisAlignment.start
                                : MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.6,
                                child: Text(
                                  title!,
                                  style: GoogleFonts.poppins(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  textAlign: price != null
                                      ? TextAlign.left
                                      : TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          isApartment
                              ? Text(
                                  'Prices starting at',
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontStyle: FontStyle.normal,
                                  ),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      SizedBox(width: price != null ? 10 : 0),
                      price != null
                          ? Positioned(
                              right: 0,
                              child: Text(
                                '\$ $price',
                                style: GoogleFonts.poppins(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
