import 'dart:developer';
import 'package:easy_life_club/constants/features.dart';
import 'package:easy_life_club/providers/auth/auth_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_life_club/widgets/marketing_opt_in_sheet.dart';
import 'package:easy_life_club/screens/home_screen/components/social_networks_widget.dart';
import 'package:flutter/material.dart';
import 'package:easy_life_club/models/menu_option.dart';
import 'package:easy_life_club/providers/providers.dart';
import 'package:easy_life_club/screens/select_location_screen.dart';
import 'package:easy_life_club/theme/app_theme.dart';
import 'package:easy_life_club/tools/push_notification_service.dart';
import 'package:easy_life_club/utils/app_secure_storage.dart';
import 'package:easy_life_club/widgets/base/base.dart';
import 'package:easy_life_club/widgets/widgets.dart';
import 'package:easy_life_club/screens/home_screen/components/partners_carousel.dart';
import 'package:easy_life_club/screens/home_screen/components/event_dialog.dart';

/// Dorado de la webpage (Easy Life Cars)
const Color _kGold = Color(0xFFD4AF37);

const double _cardRadius = 22;
const double _cardMarginH = 0;
const double _cardMarginV = 12;

const double _imageInsetH = 8;
const double _imageInsetTop = 12;
const double _imageBottomFraction = 0.77;
const double _imageRadius = 17;

/// Orden del home:
/// 0 Rental cars, 1 Rental yachts, 2 Private transports, 3 Private jets,
/// 4 Rental villas, 5 Rental apartments, 6 Real state, 7 Cars for sale,
/// 8 (cualquier otro ítem no listado), 9 Club members
int _menuRank(MenuOption item) {
  final name = item.name.toLowerCase();
  final route = item.route.toLowerCase();

  if (name.contains('club members') || route.contains('membership')) return 9;
  if (name.contains('cars for sale')) return 7;
  if (name.contains('cars for rent') || name.contains('rental cars') || name == 'cars') return 0;
  if (name.contains('yacht')) return 1;
  if (name.contains('private transport')) return 2;
  if (name.contains('private jet')) return 3;
  if (name.contains('apartment')) return 5;
  if (name.contains('villa')) return 4;
  if (name.contains('real state') || name.contains('real estate')) return 6;
  return 8;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? fetched;
  String error = '';
  List<MenuOption>? storedMenu;
  // Order saved from the admin panel (Firestore `config/menu`); empty = default ranking.
  List<String> _remoteOrder = const [];
  int _currentEventIndex = 0;

  Future<void> checkNotificationsPermissions() async {
    bool hasPermission = true;
    try {
      hasPermission = await PushNotificationService.hasPermission();
    } catch (e) {
      log('Error checking permissions: $e');
    }
    if (!hasPermission) {
      await PushNotificationService.requestPermission();
    }
  }

  Future<void> _loadMenuOrder() async {
    try {
      final snap = await FirebaseFirestore.instance.collection('config').doc('menu').get();
      final order = List<String>.from((snap.data()?['order'] as List?) ?? const []);
      if (mounted && order.isNotEmpty) setState(() => _remoteOrder = order);
    } catch (e) {
      log('Menu order unavailable, using default: $e');
    }
  }

  int _rank(MenuOption item) {
    final key = item.id == 8888 ? 'cars_for_sale' : 'service:${item.id}';
    final i = _remoteOrder.indexOf(key);
    return i >= 0 ? i : _remoteOrder.length + _menuRank(item);
  }

  Future<void> preLoadMenu() async {
    storedMenu = await AppSecureStorage.getMenu();
    setState(() {});
  }

  Future<void> fetchMenu(MenuProvider menuProvider) async {
    setState(() {
      fetched = false;
    });
    error = await menuProvider.getMenuFromAPI() ?? '';
    setState(() {
      fetched = true;
    });
  }

  Future<void> _getEvents(EventProvider eventProvider) async {
    await eventProvider.getEvents();
  }

  void _showEventDialog() {
    final eventProvider = Provider.of<EventProvider>(context, listen: false);
    if (eventProvider.events == null || eventProvider.events!.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return EventDialog(
          currentIndex: _currentEventIndex,
          onNext: _showNextEvent,
        );
      },
    );
  }

  void _showNextEvent() {
    setState(() {
      _currentEventIndex++;
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      if (_currentEventIndex < eventProvider.events!.length) {
        _showEventDialog();
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkNotificationsPermissions();
    preLoadMenu();
    _loadMenuOrder();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      await _getEvents(eventProvider);
      _showEventDialog();
      if (mounted && kEmailMarketingEnabled) maybeShowMarketingOptIn(context);
    });
  }

  Widget _newItemOverlay() {
    return const Positioned.fill(
      child: IgnorePointer(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: _cardMarginH,
            vertical: _cardMarginV,
          ),
          child: CustomPaint(
            painter: _NewCardPainter(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuProvider = Provider.of<MenuProvider>(context);
    List<MenuOption>? menu = menuProvider.menu;

    final servicesProvider = Provider.of<ServicesProvider>(context);

    if (fetched == null) {
      fetchMenu(menuProvider);
    }
    menu ??= storedMenu;

    if (menu != null) {
      // Ocultamos el item 'health' redundante si viniera del backend
      menu = menu.where((item) => item.name.toLowerCase() != 'health').toList();

      // Modificamos el nombre del elemento de autos existente a "Cars for rent"
      for (int i = 0; i < menu.length; i++) {
        final item = menu[i];
        if (item.name.toLowerCase() == 'cars' || item.route.toLowerCase() == 'cars') {
          menu[i] = MenuOption(
            id: item.id,
            name: 'Cars for rent',
            route: item.route,
            image: item.image,
          );
        }
      }

      // Insertar el elemento "Cars for sale" como nuevo con tu nueva imagen de fondo
      bool exists = menu.any((item) => item.name.toLowerCase().contains('cars for sale'));
      if (!exists) {
        menu.add(
          MenuOption(
            id: 8888,
            name: 'Cars for sale',
            route: 'cars',
            image: 'assets/carsForSaleBackground.jpeg',
          ),
        );
      }

      menu.sort((a, b) {
        final cmp = _rank(a).compareTo(_rank(b));
        if (cmp != 0) return cmp;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    }

    List<Widget> menuItems = List.generate(
      menu?.length ?? 0,
      (index) {
        final currentMenu = menu![index];
        final bool isNewItem = currentMenu.name.toLowerCase() == 'cars for sale';

        Widget cardContent = Stack(
          children: [
            CustomCard(
              imgURL: currentMenu.image,
              title: currentMenu.name.toUpperCase(),
              route: 'cars',
              tag: currentMenu.name,
              duration: (index + 1) * 100,
            ),
            if (isNewItem) _newItemOverlay(),
            if (isNewItem)
              const Positioned(
                top: 32,
                right: 16,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _kGold,
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                    child: Text(
                      'NEW',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        );

        return GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (BuildContext context) {
                return LoadingDialog(
                  message: 'Loading ${currentMenu.name}...',
                );
              },
            );

            final navigator = Navigator.of(context);

            // Si se toca "Cars for sale", consulta a Firebase directamente
            if (currentMenu.name.toLowerCase() == 'cars for sale') {
              servicesProvider.serviceType = 'cars_for_sale';
              await servicesProvider.fetchVehiclesFromFirebase();
              servicesProvider.screeTitle = 'Cars for Sale';

              navigator.pop();
              navigator.pushNamed('products');
              return;
            }

            String itemRoute = currentMenu.route;
            var itemId = currentMenu.id;

            servicesProvider.serviceType = currentMenu.route;
            servicesProvider.option = currentMenu.name;

            if (itemRoute == 'membership') {
              navigator.pop();
              navigator.pushNamed('members');
            } else if (itemRoute == 'others') {
              servicesProvider.selectedServiceId = itemId;
              await servicesProvider.getOtherProductsDetailFromApi(itemId);
              await servicesProvider.getOtherServicesListById(itemId);
              servicesProvider.otherServiceInfo['image'] = currentMenu.image;
              servicesProvider.otherServiceInfo['title'] = currentMenu.name.toString().toUpperCase();
              navigator.pop();
              navigator.pushNamed('service_detail');
            } else if (
              itemRoute == 'service' ||
                itemRoute == 'apartments' ||
                (itemRoute == 'villa' && currentMenu.name == 'Apartments')) {
              servicesProvider.selectedServiceId = itemId;
              servicesProvider.resetProducts();
              await servicesProvider.getProductsDetailFromApi(itemId);

              navigator.pop();
              navigator.pushNamed('products');
            } else if (itemRoute == 'villa') {
              servicesProvider.selectedServiceId = itemId;
              servicesProvider.screeTitle = currentMenu.name;
              servicesProvider.resetProducts();
              navigator.pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return SelectLocationScreen(serviceId: itemId);
                  },
                ),
              );
            } else if (itemRoute == 'state') {
              servicesProvider.selectedServiceId = itemId;
              servicesProvider.resetProducts();

              await servicesProvider.getProductsDetailFromApi(itemId);

              navigator.pop();
              navigator.pushNamed('products');
            }
          },
          child: cardContent,
        );
      },
    );

    final username = '${Provider.of<AuthProvider>(context).user['username'] ?? ''}';

    return Scaffold(
      backgroundColor: AppTheme.baseColor,
      appBar: const CustomAppBar(
        title: 'HOME',
        icon: Icons.settings,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => fetchMenu(menuProvider),
          child: Stack(
            children: [
              const Background(),
              SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: menuItems.isEmpty
                    ? Column(
                        children: [
                          SizedBox(
                            height: fetched == true
                                ? MediaQuery.of(context).size.height * .2
                                : 0,
                          ),
                          fetched == true
                              ? ToastNotification(
                                  message: error,
                                  error: true,
                                  dismissible: false,
                                )
                              : const SimpleShimmerCardList(),
                          SizedBox(
                            height: MediaQuery.of(context).size.height * .4,
                          ),
                        ],
                      )
                    : Column(
                        children: [
                          _WelcomeHeader(username: username),
                          ...menuItems,
                          const PartnersCarousel(),
                          const SizedBox(height: 10),
                          const SocialNetworksWidget(),
                          const SizedBox(height: 32),
                        ],
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NewCardPainter extends CustomPainter {
  const _NewCardPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    final outer = RRect.fromRectAndRadius(rect, const Radius.circular(_cardRadius));

    const imgRadius = Radius.circular(_imageRadius);
    final imageRRect = RRect.fromLTRBAndCorners(
      _imageInsetH,
      _imageInsetTop,
      size.width - _imageInsetH,
      size.height * _imageBottomFraction,
      topLeft: imgRadius,
      topRight: imgRadius,
      bottomLeft: Radius.zero,
      bottomRight: Radius.zero,
    );

    final gradientPath = Path()
      ..fillType = PathFillType.evenOdd
      ..addRRect(outer)
      ..addRRect(imageRRect);

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          _kGold.withOpacity(0.40),
          _kGold.withOpacity(0.28),
          AppTheme.primary.withOpacity(0.0),
        ],
        stops: const [0.0, 0.75, 1.0],
      ).createShader(rect);

    canvas.drawPath(gradientPath, fillPaint);

    const strokeWidth = 1.4;
    final borderRRect = RRect.fromRectAndRadius(
      rect.deflate(strokeWidth / 2),
      const Radius.circular(_cardRadius),
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [_kGold, Color(0x33D4AF37)],
      ).createShader(rect);

    canvas.drawRRect(borderRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant _NewCardPainter oldDelegate) => false;
}

class _WelcomeHeader extends StatelessWidget {
  const _WelcomeHeader({required this.username});
  final String username;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = hour < 12 ? 'Good morning' : (hour < 19 ? 'Good afternoon' : 'Good evening');
    // Full width so the parent Column (which centers its children) can't center the block.
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'EASY LIFE CLUB',
            style: GoogleFonts.poppins(fontSize: 11, letterSpacing: 2.4, fontWeight: FontWeight.w600, color: AppTheme.gold),
          ),
          const SizedBox(height: 4),
          Text(
            username.isEmpty ? greeting : '$greeting, $username',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.poppins(fontSize: 24, fontWeight: FontWeight.w600, color: Colors.white),
          ),
          const SizedBox(height: 2),
          Text(
            'What would you like to enjoy today?',
            style: GoogleFonts.poppins(fontSize: 13, color: AppTheme.secondary),
          ),
        ],
      ),
    );
  }
}
