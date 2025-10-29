import 'package:flutter/material.dart';import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

void main() {

void main() {  runApp(const MyApp());

  runApp(const GroceryManagerApp());}

}

class MyApp extends StatelessWidget {

class GroceryManagerApp extends StatelessWidget {  const MyApp({super.key});

  const GroceryManagerApp({super.key});

  // This widget is the root of your application.

  @override  @override

  Widget build(BuildContext context) {  Widget build(BuildContext context) {

    return MaterialApp(    return MaterialApp(

      title: 'Grocery Manager',      title: 'Flutter Demo',

      theme: ThemeData(      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),        // This is the theme of your application.

        useMaterial3: true,        //

      ),        // TRY THIS: Try running your application with "flutter run". You'll see

      debugShowCheckedModeBanner: false,        // the application has a blue toolbar. Then, without quitting the app,

      home: const HomeScreen(),        // try changing the seedColor in the colorScheme below to Colors.green

    );        // and then invoke "hot reload" (save your changes or press the "hot

  }        // reload" button in a Flutter-supported IDE, or press "r" if you used

}        // the command line to start the app).

        //

class HomeScreen extends StatefulWidget {        // Notice that the counter didn't reset back to zero; the application

  const HomeScreen({super.key});        // state is not lost during the reload. To reset the state, use hot

        // restart instead.

  @override        //

  State<HomeScreen> createState() => _HomeScreenState();        // This works for code too, not just values: Most code changes can be

}        // tested with just a hot reload.

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),

class _HomeScreenState extends State<HomeScreen> {        useMaterial3: true,

  int _currentIndex = 0;      ),

        home: const MyHomePage(title: 'Flutter Demo Home Page'),

  final List<Widget> _tabs = [    );

    const InventoryTab(),  }

    const MenuTab(),}

    const NotificationsTab(),

    const ProfileTab(),class MyHomePage extends StatefulWidget {

  ];  const MyHomePage({super.key, required this.title});



  @override  // This widget is the home page of your application. It is stateful, meaning

  Widget build(BuildContext context) {  // that it has a State object (defined below) that contains fields that affect

    return Scaffold(  // how it looks.

      body: _tabs[_currentIndex],

      bottomNavigationBar: BottomNavigationBar(  // This class is the configuration for the state. It holds the values (in this

        type: BottomNavigationBarType.fixed,  // case the title) provided by the parent (in this case the App widget) and

        currentIndex: _currentIndex,  // used by the build method of the State. Fields in a Widget subclass are

        onTap: (index) {  // always marked "final".

          setState(() {

            _currentIndex = index;  final String title;

          });

        },  @override

        items: const [  State<MyHomePage> createState() => _MyHomePageState();

          BottomNavigationBarItem(}

            icon: Icon(Icons.inventory),

            label: 'Inventario',class _MyHomePageState extends State<MyHomePage> {

          ),  int _counter = 0;

          BottomNavigationBarItem(

            icon: Icon(Icons.restaurant_menu),  void _incrementCounter() {

            label: 'Menús',    setState(() {

          ),      // This call to setState tells the Flutter framework that something has

          BottomNavigationBarItem(      // changed in this State, which causes it to rerun the build method below

            icon: Icon(Icons.notifications),      // so that the display can reflect the updated values. If we changed

            label: 'Alertas',      // _counter without calling setState(), then the build method would not be

          ),      // called again, and so nothing would appear to happen.

          BottomNavigationBarItem(      _counter++;

            icon: Icon(Icons.person),    });

            label: 'Perfil',  }

          ),

        ],  @override

      ),  Widget build(BuildContext context) {

    );    // This method is rerun every time setState is called, for instance as done

  }    // by the _incrementCounter method above.

}    //

    // The Flutter framework has been optimized to make rerunning build methods

// Inventory Tab    // fast, so that you can just rebuild anything that needs updating rather

class InventoryTab extends StatelessWidget {    // than having to individually change instances of widgets.

  const InventoryTab({super.key});    return Scaffold(

      appBar: AppBar(

  @override        // TRY THIS: Try changing the color here to a specific color (to

  Widget build(BuildContext context) {        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar

    return Scaffold(        // change color while the other colors stay the same.

      appBar: AppBar(        backgroundColor: Theme.of(context).colorScheme.inversePrimary,

        title: const Text('Mi Inventario'),        // Here we take the value from the MyHomePage object that was created by

        automaticallyImplyLeading: false,        // the App.build method, and use it to set our appbar title.

      ),        title: Text(widget.title),

      body: Center(      ),

        child: Column(      body: Center(

          mainAxisAlignment: MainAxisAlignment.center,        // Center is a layout widget. It takes a single child and positions it

          children: [        // in the middle of the parent.

            Icon(        child: Column(

              Icons.inventory_2_outlined,          // Column is also a layout widget. It takes a list of children and

              size: 64,          // arranges them vertically. By default, it sizes itself to fit its

              color: Colors.grey[400],          // children horizontally, and tries to be as tall as its parent.

            ),          //

            const SizedBox(height: 16),          // Column has various properties to control how it sizes itself and

            Text(          // how it positions its children. Here we use mainAxisAlignment to

              'Tu inventario está vacío',          // center the children vertically; the main axis here is the vertical

              style: Theme.of(context).textTheme.titleMedium,          // axis because Columns are vertical (the cross axis would be

            ),          // horizontal).

            const SizedBox(height: 8),          //

            Text(          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"

              'Comienza añadiendo tus primeras compras',          // action in the IDE, or press "p" in the console), to see the

              style: TextStyle(color: Colors.grey[600]),          // wireframe for each widget.

            ),          mainAxisAlignment: MainAxisAlignment.center,

            const SizedBox(height: 24),          children: <Widget>[

            ElevatedButton.icon(            const Text(

              onPressed: () => _showAddPurchaseDialog(context),              'You have pushed the button this many times:',

              icon: const Icon(Icons.add),            ),

              label: const Text('Añadir Compra'),            Text(

            ),              '$_counter',

          ],              style: Theme.of(context).textTheme.headlineMedium,

        ),            ),

      ),          ],

      floatingActionButton: FloatingActionButton(        ),

        onPressed: () => _showAddPurchaseDialog(context),      ),

        child: const Icon(Icons.add),      floatingActionButton: FloatingActionButton(

      ),        onPressed: _incrementCounter,

    );        tooltip: 'Increment',

  }        child: const Icon(Icons.add),

      ), // This trailing comma makes auto-formatting nicer for build methods.

  void _showAddPurchaseDialog(BuildContext context) {    );

    showDialog(  }

      context: context,}

      builder: (context) => AlertDialog(
        title: const Text('Próximamente'),
        content: const Text('La funcionalidad de añadir compras estará disponible cuando configures Firebase.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}

// Menu Tab
class MenuTab extends StatelessWidget {
  const MenuTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menús Sugeridos'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.restaurant_menu,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Menús Inteligentes',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                'Te sugeriremos menús basados en los ingredientes que tienes en tu inventario.',
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Funcionalidad en desarrollo')),
                );
              },
              icon: const Icon(Icons.auto_awesome),
              label: const Text('Generar Sugerencias'),
            ),
          ],
        ),
      ),
    );
  }
}

// Notifications Tab
class NotificationsTab extends StatelessWidget {
  const NotificationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Alertas y Notificaciones'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No tienes notificaciones',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Las alertas de vencimiento aparecerán aquí',
              style: TextStyle(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

// Profile Tab
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi Perfil'),
        automaticallyImplyLeading: false,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircleAvatar(
              radius: 50,
              child: Icon(Icons.person, size: 50),
            ),
            const SizedBox(height: 16),
            Text(
              'Usuario Demo',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'demo@grocerymanager.com',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Configura Firebase para autenticación completa')),
                );
              },
              icon: const Icon(Icons.settings),
              label: const Text('Configurar Perfil'),
            ),
          ],
        ),
      ),
    );
  }
}