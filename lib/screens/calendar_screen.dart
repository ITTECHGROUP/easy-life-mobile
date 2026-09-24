import 'package:easy_life_club/constants/constants.dart';
import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/utils.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../providers/providers.dart';
import '../widgets/base/base.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int currentYear = kToday.year;

  @override
  Widget build(BuildContext context) {
    final kToday = DateTime.now();

    List<int> firsFiveYears = List.generate(5, (index) => kToday.year + index);

    final calendarProvider = Provider.of<CalendarProvider>(context);
    final loadingMoreCalendars = calendarProvider.isLoadingMoreCalendars;
    bool loading = loadingMoreCalendars;

    List<Widget> calendars = List.generate(
      calendarProvider.calendarAmount,
      (index) {
        return _TableRangeExampleState(
          firstDay: DateTime.utc(
            // kToday.year,
            currentYear,
            kToday.month + index,
            1,
          ),
          lastDay: DateTime.utc(currentYear, kToday.month + index, 40),
          calendarProvider: calendarProvider,
        );
      },
    );

    ScrollController scrollController = ScrollController(
      initialScrollOffset: 0.0,
      keepScrollOffset: true,
    );

    scrollController.addListener(
      () {
        int calendarAmount = calendarProvider.calendarAmount;
        loading = loadingMoreCalendars;
        if (scrollController.offset >
                (scrollController.position.maxScrollExtent - 300) &&
            !loading) {
          loading = true;
          calendarProvider.loadingMoreCalendars(true);
          calendarProvider.updateCalendarAmout(calendarAmount + 3);
        }
      },
    );

    return Scaffold(
      backgroundColor: const Color(0xff1A1E23),
      appBar: const CustomAppBar(
        title: "BOOK",
        showArrowBack: true,
      ),
      body: SafeArea(
        child: Stack(
          children: [
            const Background(),
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              controller: scrollController,
              child: Column(
                children: [
                  Container(
                    clipBehavior: Clip.none,
                    padding: const EdgeInsets.all(6),
                    margin: const EdgeInsets.symmetric(vertical: 10),
                    width: MediaQuery.of(context).size.width * 0.6,
                    decoration: BoxDecoration(
                      color: const Color(0xff1A1E23),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 26,
                            ),
                            elevation: 0,
                            backgroundColor: const Color(0xff6A6A6A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text("Month"),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            // color: const Color(0xff6A6A6A),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: const EdgeInsets.only(
                            top: 2,
                            bottom: 2,
                            right: 16,
                            left: 20,
                          ),
                          child: DropdownButton(
                            style: const TextStyle(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.circular(20),
                            dropdownColor: const Color(0xff6A6A6A),
                            isDense: true,
                            underline: Container(),
                            iconEnabledColor: Colors.white,
                            value: currentYear,
                            items: firsFiveYears
                                .map<DropdownMenuItem<int>>((int value) {
                              return DropdownMenuItem<int>(
                                value: value,
                                child: Text(value.toString()),
                              );
                            }).toList(),
                            onChanged: (int? newValue) {
                              currentYear = newValue!;
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [...calendars],
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

void showBookingDialog(
  BuildContext context,
  CalendarProvider calendarProvider,
  String productName,
) {
  showDialog(
    barrierDismissible: true,
    barrierColor: Colors.black54,
    context: context,
    builder: (context) => const LoadingDialog(
      message: "Redirecting to WhatsApp...",
    ),
  );
  calendarProvider.sendWhatsAppMessageWithDate(
    "*$productName*",
    "*${getMonthName(calendarProvider.rangeStart!.month)} ${calendarProvider.rangeStart!.day}, ${calendarProvider.rangeStart!.year}*",
    "*${getMonthName(calendarProvider.rangeEnd!.month)} ${calendarProvider.rangeEnd!.day}, ${calendarProvider.rangeEnd!.year}*",
  );
  Navigator.pop(context);
}

class _TableRangeExampleState extends StatefulWidget {
  const _TableRangeExampleState({
    Key? key,
    required this.firstDay,
    required this.lastDay,
    required this.calendarProvider,
  }) : super(key: key);

  final DateTime firstDay;
  final DateTime lastDay;
  final CalendarProvider calendarProvider;

  @override
  State<_TableRangeExampleState> createState() =>
      _TableRangeExampleStateState();
}

class _TableRangeExampleStateState extends State<_TableRangeExampleState> {
  CalendarFormat _calendarFormat = CalendarFormat.month;

  // late final ValueNotifier<List<Event>> _selectedEvents;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOn;
  // Can be toggled on/off by longpreszasing a date
  DateTime? _selectedDay;

  // ? work with this, because it is the one that is being selected
  var inSelectedRangeBoxDecoration = BoxDecoration(
    gradient: const RadialGradient(
      colors: [
        Color(0xff1D2126),
        Color.fromRGBO(255, 255, 255, 0.5),
      ],
      radius: 8,
      center: Alignment.bottomCenter,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color(0x33000000),
        offset: Offset(0, 8),
        blurRadius: 6,
        spreadRadius: 1,
      ),
    ],
    borderRadius: BorderRadius.circular(50.0),
    border: Border.all(
      color: const Color(0xff1A1E23),
      width: 0.6,
    ),
  );

  var noAvailableService = BoxDecoration(
    gradient: const RadialGradient(
      colors: [
        Color(0xff1A1E23),
        Color.fromARGB(106, 0, 0, 0),
      ],
      radius: 3,
      center: Alignment.topLeft,
    ),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(106, 0, 0, 0),
        offset: Offset(3, 6),
        blurRadius: 6,
        spreadRadius: 1,
      ),
    ],
    borderRadius: BorderRadius.circular(50.0),
    border: Border.all(
      color: const Color(0xff1A1E23),
      width: 0.6,
    ),
  );

  List<Reservation> _getEventsForDay(DateTime day) {
    var events = widget.calendarProvider.kEvents;
    // Implementation example
    return events![day] ?? [];
  }

  List<Reservation> _getEventsForRange(DateTime start, DateTime end) {
    // Implementation example
    final days = daysInRange(start, end);

    return [
      for (final d in days) ..._getEventsForDay(d),
    ];
  }

  @override
  Widget build(BuildContext context) {
    // _selectedDay = _focusedDay;
    // _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    // final calendarProvider = Provider.of<CalendarProvider>(context);

    final servicesProvider = Provider.of<ServicesProvider>(context);

    final selectedProduct = servicesProvider.selectedProduct;

    DateTime? rangeStart = widget.calendarProvider.rangeStart;
    DateTime? rangeEnd = widget.calendarProvider.rangeEnd;

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF14171C),
            Color(0xff16191E),
          ],
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: TableCalendar(
        headerStyle: const HeaderStyle(
          formatButtonVisible: false,
          titleCentered: true,
          titleTextStyle: TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
          // leftChevronIcon: Icon(
          //   Icons.chevron_left,
          //   color: Colors.white,
          // ),
          // rightChevronIcon: Icon(
          //   Icons.chevron_right,
          //   color: Colors.white,
          // ),
          leftChevronVisible: false,
          rightChevronVisible: false,
        ),
        daysOfWeekStyle: const DaysOfWeekStyle(
          weekdayStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
          weekendStyle: TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
        daysOfWeekHeight: 40,
        // firstDay: firstDay,
        // lastDay: kLastDay,
        focusedDay: widget.firstDay,
        firstDay: DateTime.utc(widget.firstDay.year, widget.firstDay.month,
            widget.firstDay.day - 7),
        lastDay: widget.lastDay,
        // focusedDay: DateTime.utc(2022, 11, 9),
        selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
        rangeStartDay: rangeStart,
        rangeEndDay: rangeEnd,
        calendarFormat: _calendarFormat,
        availableCalendarFormats: const {
          CalendarFormat.month: '',
        },
        availableGestures: AvailableGestures.none,
        rangeSelectionMode: _rangeSelectionMode,
        startingDayOfWeek: StartingDayOfWeek.monday,
        // eventLoader: _getEventsForDay,

        // onDaySelected: (selectedDay, focusedDay) {
        //   if (!isSameDay(_selectedDay, selectedDay)) {
        //     print("onDaySelected");
        //     setState(() {
        //       _selectedDay = selectedDay;
        //       _focusedDay = focusedDay;
        //       _rangeStart = null; // Important to clean those
        //       _rangeEnd = null;
        //       _rangeSelectionMode = RangeSelectionMode.toggledOff;
        //     });
        //   }
        // },
        calendarBuilders: CalendarBuilders(
          selectedBuilder: (context, date, events) =>
              _SelectedOrUnavaibleDayContainer(day: date.day.toString()),
          todayBuilder: (context, date, events) =>
              _SelectedOrUnavaibleDayContainer(day: date.day.toString()),
          rangeStartBuilder: (context, date, events) =>
              _SelectedOrUnavaibleDayContainer(day: date.day.toString()),
          rangeEndBuilder: (context, date, events) =>
              _SelectedOrUnavaibleDayContainer(day: date.day.toString()),
          defaultBuilder: (context, date, events) {
            bool noEvent = _getEventsForDay(date).isEmpty;
            // print("--------------------------------------");
            // print("Date: ");
            // print(date);
            // print("Events: ");
            _getEventsForDay(date).isNotEmpty;
            // print("--------------------------------------");

            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 7.0,
                horizontal: 4.0,
              ),
              alignment: Alignment.center,
              decoration: noEvent
                  ? BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color(0xFFE7E7E7),
                        width: 0.6,
                      ),
                    )
                  : noAvailableService,
              child: Text(date.day.toString(),
                  style: TextStyle(
                    color: noEvent
                        ? const Color(0xD1DBDBDB)
                        : const Color(0x28BBBBBB),
                  )),
            );
          },
          outsideBuilder: (context, date, events) =>
              _OutsideDay(day: date.day.toString()),
          rangeHighlightBuilder: (context, day, isWithinRange) {
            return Container(
              margin: const EdgeInsets.symmetric(
                vertical: 7.0,
                horizontal: 4.0,
              ),
              alignment: Alignment.center,
              decoration: isWithinRange
                  ? inSelectedRangeBoxDecoration
                  : BoxDecoration(
                      borderRadius: BorderRadius.circular(50.0),
                      border: Border.all(
                        color: const Color(0xff1A1E23),
                        width: 0.6,
                      ),
                    ),
            );
          },
          withinRangeBuilder: (context, date, events) =>
              _SelectedOrUnavaibleDayContainer(day: date.day.toString()),
        ),
        onRangeSelected: (start, end, focusedDay) async {
          if (rangeStart != null && rangeEnd != null) {
            await widget.calendarProvider.resetRange();
          }

          if (widget.calendarProvider.rangeStart == null) {
            widget.calendarProvider.updateRangeStart(start!);
          } else if (widget.calendarProvider.rangeEnd == null) {
            if (widget.calendarProvider.rangeStart!.isAfter(start!)) {
              widget.calendarProvider.updateRangeStart(start);
            } else {
              widget.calendarProvider.updateRangeEnd(end ?? start);
            }
          }

          if (widget.calendarProvider.rangeStart!.isBefore(DateTime.now())) {
            widget.calendarProvider.resetRange();
            if (!mounted) return;
            showDialog(
              barrierDismissible: true,
              barrierColor: Colors.black54,
              context: context,
              builder: (context) => const ToastNotification(
                message: "Error, you can't select a date in the past",
                error: true,
              ),
            );
          }

          if (widget.calendarProvider.rangeStart != null &&
              widget.calendarProvider.rangeEnd != null) {
            var events = _getEventsForRange(widget.calendarProvider.rangeStart!,
                widget.calendarProvider.rangeEnd!);
            if (events.isNotEmpty) {
              widget.calendarProvider.resetRange();
              if (!mounted) return;
              showDialog(
                barrierDismissible: true,
                barrierColor: Colors.black54,
                context: context,
                builder: (context) => const ToastNotification(
                  message:
                      "Error, you can't select a date without available services",
                  error: true,
                ),
              );
            }
          }

          _selectedDay = null;
          if (!mounted) return;
          widget.calendarProvider.rangeEnd != null
              ? showModalBottomSheet<void>(
                  context: context,
                  backgroundColor: Colors.transparent,
                  barrierColor: Colors.black54,
                  isScrollControlled: true,
                  isDismissible: false,
                  builder: (BuildContext context) {
                    return Container(
                      height: 320,
                      decoration: const BoxDecoration(
                        color: AppTheme.primary,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                            spreadRadius: 20,
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 10,
                            right: 10,
                            child: GestureDetector(
                              onTap: () {
                                widget.calendarProvider.resetRange();
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 40,
                                width: 40,
                                decoration: const BoxDecoration(
                                  color: AppTheme.primary,
                                  borderRadius: BorderRadius.only(
                                    topRight: Radius.circular(20),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.close,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          Column(
                            children: [
                              const SizedBox(height: 20),
                              Container(
                                height: 5,
                                width: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.5),
                                  borderRadius: BorderRadius.circular(50),
                                ),
                              ),
                              const SizedBox(height: 30),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    height: 100,
                                    width: 130,
                                    clipBehavior: Clip.antiAlias,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Image(
                                      image: NetworkImage(
                                        selectedProduct!.images.isEmpty
                                            ? Constants.noImageURL
                                            : selectedProduct.images[0].image,
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        width: 200,
                                        child: Text(
                                          // ignore: unnecessary_null_comparison
                                          selectedProduct != null
                                              ? selectedProduct.name
                                              : "No Product Selected",
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w800,
                                            fontSize: 22,
                                          ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "From: ${getMonthName(rangeStart!.month)} ${rangeStart.day}, ${rangeStart.year}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Text(
                                        "To: ${getMonthName(widget.calendarProvider.rangeEnd!.month)} ${widget.calendarProvider.rangeEnd!.day}, ${widget.calendarProvider.rangeEnd!.year}",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w400,
                                          fontSize: 18,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 40),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 40),
                                child: GestureDetector(
                                  onTap: () => showBookingDialog(
                                    context,
                                    widget.calendarProvider,
                                    selectedProduct.name,
                                  ),
                                  child: const PrimaryButton(
                                    text: "Book Now",
                                  ),
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                )
              : null;
        },
        onFormatChanged: (format) {
          if (_calendarFormat != format) {
            _calendarFormat = format;
          }
        },
        onDayLongPressed: (selectedDay, focusedDay) {
          _rangeSelectionMode = RangeSelectionMode.toggledOn;
          // setState(() {});
        },
        onPageChanged: (focusedDay) {
          // _focusedDay = focusedDay;
        },
        // disable page change
      ),
    );
  }
}

class _OutsideDay extends StatelessWidget {
  const _OutsideDay({
    Key? key,
    required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 7.0,
        horizontal: 4.0,
      ),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50.0),
        border: Border.all(color: Colors.white24),
      ),
      child: Text(
        day,
        style: const TextStyle(color: Colors.white24),
      ),
    );
  }
}

class _SelectedOrUnavaibleDayContainer extends StatelessWidget {
  const _SelectedOrUnavaibleDayContainer({
    Key? key,
    required this.day,
  }) : super(key: key);

  final String day;

  @override
  Widget build(BuildContext context) {
    var inSelectedRangeBoxDecoration = BoxDecoration(
      gradient: const RadialGradient(
        colors: [
          Color(0xff1D2126),
          Color.fromRGBO(255, 255, 255, 0.5),
        ],
        radius: 8,
        center: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(50.0),
      border: Border.all(
        color: const Color(0xff1A1E23),
        width: 0.6,
      ),
    );

    return Container(
      margin: const EdgeInsets.symmetric(
        vertical: 7.0,
        horizontal: 4.0,
      ),
      alignment: Alignment.center,
      decoration: inSelectedRangeBoxDecoration,
      child: Text(
        day,
        style: const TextStyle(color: Colors.white70),
      ),
    );
  }
}

getMonthName(int month) {
  switch (month) {
    case 1:
      return "Jan";
    case 2:
      return "Feb";
    case 3:
      return "Mar";
    case 4:
      return "Apr";
    case 5:
      return "May";
    case 6:
      return "Jun";
    case 7:
      return "Jul";
    case 8:
      return "Aug";
    case 9:
      return "Sep";
    case 10:
      return "Oct";
    case 11:
      return "Nov";
    case 12:
      return "Dec";
    default:
      return "Jan";
  }
}
