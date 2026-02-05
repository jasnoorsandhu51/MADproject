import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(length: 3, child: _TabsNonScrollableDemo()),
    );
  }
}

class _TabsNonScrollableDemo extends StatefulWidget {
  @override
  __TabsNonScrollableDemoState createState() => __TabsNonScrollableDemoState();
}

class __TabsNonScrollableDemoState extends State<_TabsNonScrollableDemo>
    with SingleTickerProviderStateMixin, RestorationMixin {
  late TabController _tabController;
  final RestorableInt tabIndex = RestorableInt(0);
  final tabs = ['Tab 1', 'Tab 2', 'Tab 3', 'Tab 4'];

  @override
  String get restorationId => 'tab_non_scrollable_demo';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(tabIndex, 'tab_index');
    _tabController.index = tabIndex.value;
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(initialIndex: 0, length: 4, vsync: this);
    _tabController.addListener(() {
      setState(() {
        tabIndex.value = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    tabIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // For the To do task hint: consider defining the widget and name of the
    // tabs here

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text('Tabs Demo'),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: false,
          tabs: [for (final tab in tabs) Tab(text: tab)],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Tab 1: Customized text widget with AlertDialog
          _buildTab1(),
          // Tab 2: Image widget
          buildTab2(),
          // Tab 3: Button with Snackbar
          buildTab3(),
          // Tab 4: ListView with Cards
          buildTab4(),
        ],
      ),
    );
  }

  Widget _buildTab1() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Hello and Welcome! This is the text under Tab 1'),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _showAlertDialog();
            },
            child: Text('Show Alert'),
          ),
        ],
      ),
    );
  }

  Widget buildTab2() {
    return Center(
      child: Image.network(
        'https://image2url.com/r2/default/images/1770230965865-02ac78d0-32fe-4496-8c99-bb5599037cee.blob',
        width: 150,
        height: 150,
      ),
    );
  }

  Widget buildTab3() {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Button pressed in ${tabs[2]} tab!')),
          );
        },
        child: Text('Click me'),
      ),
    );
  }

  Widget buildTab4() {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        Card(
          child: ListTile(
            title: Text('Item 1'),
            subtitle: Text('Item 1 details'),
            leading: Icon(Icons.item_1),
          ),
        ),
        Card(
          child: ListTile(
            title: Text('Item 2'),
            subtitle: Text('Item 2 details'),
            leading: Icon(Icons.item_2),
          ),
        ),
      ],
    );
  }

  void _showAlertDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Alert'),
          content: Text('This is an alert from Tab 1'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
