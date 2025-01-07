import 'package:agusplastik/assets/colors/colors.dart';
import 'package:agusplastik/menus/distributor_menu.dart';
import 'package:agusplastik/menus/gudang_menu.dart';
import 'package:agusplastik/menus/setting_menu.dart';
import 'package:agusplastik/menus/transaksi_menu.dart';
import 'package:agusplastik/popups/exit/logout.dart';
import 'package:agusplastik/popups/verify/verify_admin.dart';
import 'package:agusplastik/sidebarx_lib/src/controller/sidebarx_controller.dart';
import 'package:agusplastik/sidebarx_lib/src/models/sidebarx_item.dart';
import 'package:agusplastik/sidebarx_lib/src/sidebarx_base.dart';
import 'package:agusplastik/sidebarx_lib/src/theme/sidebarx_theme.dart';
import 'package:flutter/material.dart';

class Homepage extends StatefulWidget {
  Homepage({super.key});

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final _controller = SidebarXController(selectedIndex: 0, extended: true);
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  // Menambahkan variabel untuk menyimpan halaman yang aktif
  int _currentPage = 0;

  // Daftar judul untuk setiap halaman
  final List<String> _pageTitles = [
    'Transaksi', // Judul untuk halaman Transaksi
    'Gudang', // Judul untuk halaman Gudang
    'Hutang', // Judul untuk halaman Hutang
    'Piutang', // Judul untuk halaman Piutang
    'Distributor', // Judul untuk halaman Distributor
    'Setting'
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Agus Plastik',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
        canvasColor: canvasColor,
        scaffoldBackgroundColor: scaffoldBackgroundColor,
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 46,
            fontWeight: FontWeight.w800,
          ),
        ),
      ),
      home: Scaffold(
        key: _scaffoldKey,
        drawer: SidebarX(
          controller: _controller,
          theme: SidebarXTheme(
            margin: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: canvasColor,
              borderRadius: BorderRadius.circular(20),
            ),
            textStyle: const TextStyle(color: Colors.white),
            selectedTextStyle: const TextStyle(color: Colors.white),
            itemTextPadding: const EdgeInsets.only(left: 30),
            selectedItemTextPadding: const EdgeInsets.only(left: 30),
            itemDecoration: BoxDecoration(
              border: Border.all(color: canvasColor),
            ),
            selectedItemDecoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: actionColor.withOpacity(0.37),
              ),
              gradient: const LinearGradient(
                colors: [accentCanvasColor, canvasColor],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.28),
                  blurRadius: 30,
                )
              ],
            ),
            iconTheme: const IconThemeData(
              color: Colors.white,
              size: 20,
            ),
          ),
          extendedTheme: const SidebarXTheme(
            width: 200,
            decoration: BoxDecoration(
              color: canvasColor,
            ),
            margin: EdgeInsets.only(right: 10),
          ),
          footerDivider: divider,
          headerBuilder: (context, extended) {
            return SafeArea(
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Image.asset('assets/images/avatar.png'),
                ),
              ),
            );
          },
          items: [
            SidebarXItem(
              icon: Icons.receipt_long,
              label: 'Transaksi',
              onTap: () {
                setState(() {
                  _currentPage = 0; // Menetapkan halaman transaksi
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.warehouse,
              label: 'Gudang',
              onTap: () {
                setState(() {
                  _currentPage = 1; // Menetapkan halaman gudang
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.money_off,
              label: 'Hutang',
              onTap: () {
                setState(() {
                  _currentPage = 2; // Menetapkan halaman hutang
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.attach_money,
              label: 'Piutang',
              onTap: () {
                setState(() {
                  _currentPage = 3; // Menetapkan halaman piutang
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.local_shipping,
              label: 'Distributor',
              onTap: () {
                setState(() {
                  _currentPage = 4; // Menetapkan halaman distributor
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.settings,
              label: 'Settings',
              onTap: () {
                setState(() {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return VerifyAdmin(
                        onSuccess: () {
                          setState(() {
                            _currentPage = 5; // Pindah ke halaman Setting
                          });
                        },
                      );
                    },
                  );
                });
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
            SidebarXItem(
              icon: Icons.exit_to_app,
              label: 'Logout',
              onTap: () {
                setState(() {
                  Logout.showExitPopup(context);
                });
                // Menutup sidebar tanpa mengubah halaman
                _scaffoldKey.currentState?.openEndDrawer();
              },
            ),
          ],
        ),
        appBar: AppBar(
          backgroundColor: canvasColor,
          title: Text(
            _pageTitles[
                _currentPage], // Mengubah judul sesuai halaman yang aktif
            style: const TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(Icons.menu_rounded),
            color: Colors.white,
          ),
        ),
        body: IndexedStack(
          index: _currentPage, // Memilih halaman yang aktif
          children: [
            const TransaksiMenu(), // Halaman Transaksi
            const GudangMenu(), // Halaman Gudang
            PlaceholderWidget('Hutang'), // Halaman Hutang (Placeholder)
            PlaceholderWidget('Piutang'), // Halaman Piutang (Placeholder)
            const DistributorMenu(),
            const SettingMenu()
          ],
        ),
      ),
    );
  }
}

// Widget Placeholder untuk halaman yang belum ada
class PlaceholderWidget extends StatelessWidget {
  final String label;
  const PlaceholderWidget(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Halaman $label belum tersedia',
        style: const TextStyle(fontSize: 24),
      ),
    );
  }
}
