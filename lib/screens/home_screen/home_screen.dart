import 'dart:developer';
import 'package:easy_life_club/screens/home_screen/components/social_networks_widget.dart';
import 'package:flutter/material.dart';
import 'package:new_version_plus/new_version_plus.dart';
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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool? fetched;
  String error = '';
  List<MenuOption>? storedMenu;
  int _currentEventIndex = 0;

  Future<void> checkNotificationsPermissions() async {
    bool hasPermission = true;
    try {
      hasPermission = await PushNotificationService.hasPermission();
      // ignore: avoid_catches_without_on_clauses
    } catch (e) {
      log('Error checking permissions: $e');
    }
    if (!hasPermission) {
      await PushNotificationService.requestPermission();
    }
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

  Future<void> _checkNewVersion() async {
    final newVersion = NewVersionPlus();
    bool isStoreVersionGreater(String storeVersion, String localVersion) {
      List<int> splittedStoreVersion = storeVersion.split('.').map(int.parse).toList();
      List<int> splitterLocalVersion = localVersion.split('.').map(int.parse).toList();

      for (int i = 0; i < splittedStoreVersion.length; i++) {
        if (splittedStoreVersion[i] > splitterLocalVersion[i]) return true;
      }
      return false;
    }
    try {
      final status = await newVersion.getVersionStatus();
      if (status != null && isStoreVersionGreater(status.storeVersion, status.localVersion )) {
        if (mounted) {
          _showUpdateDialog(status);
        }
      }
    } on Exception catch (e) {
      log('Error checking new version: $e');
    }
  }

  Future<void> _getEvents(EventProvider eventProvider) async {
    await eventProvider.getEvents();
  }

  void _showUpdateDialog(VersionStatus status) {
    final newVersion = NewVersionPlus();
    newVersion.showUpdateDialog(
      context: context,
      versionStatus: status,
      dialogTitle: 'App update available',
      dialogText: 'You are on an older version. Please update to continue using the app.',
      updateButtonText: 'Update Now',    
    );
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
    _checkNewVersion();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final eventProvider = Provider.of<EventProvider>(context, listen: false);
      await _getEvents(eventProvider);
      _showEventDialog();
    });
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
    List<Widget> menuItems = List.generate(
      menu?.length ?? 0,
      (index) {
        return GestureDetector(
          onTap: () async {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return LoadingDialog(
                  message: 'Loading ${menu![index].name}...',
                );
              },
            );

            String itemRoute = menu![index].route;
            servicesProvider.serviceType = menu![index].route;
            servicesProvider.option = menu[index].name;

            if (itemRoute == 'membership') {
              Navigator.of(context).pop();
              Navigator.of(context).pushNamed('members');
            }

            final navigator = Navigator.of(context);
            if (itemRoute == 'others') {
              servicesProvider.selectedServiceId = menu[index].id;
              await servicesProvider.getOtherProductsDetailFromApi(menu[index].id);
              await servicesProvider.getOtherServicesListById(menu[index].id);
              servicesProvider.otherServiceInfo['image'] =
                  menu[index].image;

              servicesProvider.otherServiceInfo['title'] =
                  menu[index].name.toString().toUpperCase();
              navigator.pop();
              navigator.pushNamed('service_detail');
            }
            else if (
              itemRoute == 'service' ||
                itemRoute == 'apartments' ||
                (itemRoute == 'villa' &&
                    menu[index].name == 'Apartments')) {
              servicesProvider.selectedServiceId = menu[index].id;
              servicesProvider.resetProducts();
              await servicesProvider.getProductsDetailFromApi(menu[index].id);

              navigator.pop();
              navigator.pushNamed('products');
            } else if (itemRoute == 'villa') {
              servicesProvider.selectedServiceId = menu[index].id;
              servicesProvider.screeTitle = menu[index].name;
              servicesProvider.resetProducts();
              navigator.pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return SelectLocationScreen(serviceId: menu![index].id);
                  },
                ),
              );
            } else if (itemRoute == 'state') {
              // todo: Change this with 'real_state' when the API is ready
              servicesProvider.selectedServiceId = menu[index].id;
              servicesProvider.resetProducts();

              await servicesProvider.getProductsDetailFromApi(menu[index].id);
              
              navigator.pop();
              navigator.pushNamed('products');
            } else if (itemRoute == 'others') {
              servicesProvider.selectedServiceId = menu[index].id;
              await servicesProvider.getOtherProductsDetailFromApi(menu[index].id);
              navigator.pop();
              navigator.pushNamed('services');
            }
          },
          child: CustomCard(
            imgURL: menu![index].image,
            title: menu[index].name.toUpperCase(),
            route: 'cars',
            tag: menu[index].name,
            duration: (index + 1) * 100,
          ),
        );
      },
    );

      return Scaffold(
      backgroundColor: AppTheme.primary,
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
                          ...menuItems,
                          const PartnersCarousel(),
                          const SizedBox(height: 10),
                          const SocialNetworksWidget(),
                          const SizedBox(height: 20),
                          const DeveloperBy(),
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
