import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import 'src/functions/functions.dart';
import 'src/providers/providers.dart';
import 'src/network/models/person/person.dart';

void main() {
  appConfig.configuration(
    headerFont: 'Montserrat',
    defaultFont: 'Poppins',
  );
  colorPallete.configuration(
    primaryColor: Color(0xFF9e2a2b),
    accentColor: Color(0xFFAE355B),
  );
  runApp(
    ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: colorPallete.primaryColor,
        accentColor: colorPallete.accentColor,
        fontFamily: appConfig.defaultFont,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SplashScreenTemplate(
        navigateAfterSplashScreen: (ctx) => WelcomeScreen(),
        copyRightVersion: CopyRightVersion(),
        image: ShowImageAsset(
          imageUrl: "${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}",
          imageSize: 3,
        ),
      ),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  GlobalKey<AnimatedListState> _animatedListKey;
  final _formKey = GlobalKey<FormState>();

  final namePersonController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((timeStamp) {
      _animatedListKey = GlobalKey<AnimatedListState>();
      context.read(globalContext).state = context;
      context.read(globalAnimatedListKey).state = _animatedListKey;
    });
  }

  @override
  Widget build(BuildContext context) {
    print('rebuild');
    return Scaffold(
      drawer: SafeArea(
        child: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Flexible(
                fit: FlexFit.tight,
                child: UserAccountsDrawerHeader(
                  accountName: const Text('Kelompok Generator'),
                  accountEmail: SizedBox(),
                  decoration: BoxDecoration(
                    color: colorPallete.primaryColor,
                    backgroundBlendMode: BlendMode.darken,
                    image: DecorationImage(
                      image: AssetImage("${appConfig.urlImageAsset}/${appConfig.urlLogoAsset}"),
                      alignment: Alignment.centerRight,
                    ),
                  ),
                ),
              ),
              Flexible(
                fit: FlexFit.tight,
                flex: 3,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      DrawerMenu(
                        showDivider: true,
                        title: 'Setting Generate Kelompok',
                        trailing: CircleAvatar(
                          child: FittedBox(
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text('100'),
                            ),
                          ),
                          backgroundColor: colorPallete.accentColor,
                          foregroundColor: colorPallete.white,
                          radius: sizes.width(context) / 30,
                        ),
                        onTap: () {},
                      ),
                      DrawerMenu(
                        showDivider: true,
                        trailing: Icon(
                          Icons.mobile_friendly,
                        ),
                        title: 'Tentang aplikasi',
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        centerTitle: true,
        title: Text('Kelompok Generator'),
        actions: [
          ProviderListener(
            provider: globalLoading,
            onChange: (context, loading) async {
              if (loading.state) {
                await GlobalFunction.showDialogLoading(context);
              } else {
                Navigator.of(context).pop();
              }
            },
            child: IconButton(
              icon: Icon(Icons.wifi_protected_setup_sharp),
              onPressed: () async {
                FunctionRequest.processGenerate(
                  context,
                  onCompleteGenerate: () async {
                    final result = await FunctionRequest.generateGroup(
                      context,
                      generateTotalGroup: 4,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      // body: Center(child: TextFormFieldCustom(controller: null)),
      body: SizedBox.expand(
        child: Stack(
          children: [
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Daftar Anggota',
                      style: appTheme.headline6(context),
                    ),
                  ),
                  SizedBox(height: 5.0),
                  Expanded(
                    child: Consumer(
                      builder: (context, watch, child) {
                        final persons = watch(personProvider.state);
                        if (persons.isEmpty) {
                          return Center(
                            child: Text('Anggota kelompok masih kosong'),
                          );
                        }
                        return AnimatedList(
                          key: _animatedListKey,
                          initialItemCount: persons.length,
                          itemBuilder: (
                            BuildContext context,
                            int index,
                            Animation<double> animation,
                          ) {
                            final person = persons[index];
                            final newIndex = index + 1;
                            return ListPerson(
                              newIndex: newIndex,
                              person: person,
                              persons: persons,
                              animation: animation,
                            );
                          },
                        );
                      },
                    ),
                  ),
                  SizedBox(height: sizes.statusBarHeight(context) * 2)
                ],
              ),
            ),
            TextFormName(
              formKey: _formKey,
              namePersonController: namePersonController,
            ),
          ],
        ),
      ),
      floatingActionButton: FAB(
        formKey: _formKey,
        namePersonController: namePersonController,
      ),
    );
  }
}

class TextFormName extends StatelessWidget {
  const TextFormName({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.namePersonController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController namePersonController;

  @override
  Widget build(BuildContext context) {
    print('rebuild 2');
    return Positioned(
      child: Form(
        key: _formKey,
        child: TextFormFieldCustom(
          controller: namePersonController,
          disableOutlineBorder: false,
          hintText: 'Tambah nama anggota',
          labelText: 'Nama Anggota',
        ),
      ),
      bottom: 12.0,
      left: 12.0,
      // top: 0,
      right: sizes.width(context) / 5,
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
    @required GlobalKey<FormState> formKey,
    @required this.namePersonController,
  })  : _formKey = formKey,
        super(key: key);

  final GlobalKey<FormState> _formKey;
  final TextEditingController namePersonController;

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, watch, child) {
        final keyAnimatedList = watch(globalAnimatedListKey).state;
        return FloatingActionButton(
          onPressed: () {
            return FunctionRequest.addPerson(
              context,
              formKey: _formKey,
              nameController: namePersonController,
              animatedListKey: keyAnimatedList,
            );
          },
          tooltip: 'Tambah anggota',
          child: Icon(Icons.add),
        );
      },
    );
  }
}

class ListPerson extends StatelessWidget {
  const ListPerson({
    Key key,
    @required this.newIndex,
    @required this.person,
    @required this.persons,
    @required this.animation,
  }) : super(key: key);

  final int newIndex;
  final PersonModel person;
  final List<PersonModel> persons;
  final Animation<double> animation;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SlideTransition(
          position: animation.drive(
            Tween(begin: Offset(1.0, 0.0), end: Offset.zero),
          ),
          child: ListTile(
            leading: CircleAvatar(
              child: Text("$newIndex"),
            ),
            title: Text(person.name),
            trailing: Consumer(
              builder: (context, watch, child) {
                final keyAnimatedList = watch(globalAnimatedListKey).state;
                return KeyboardVisibilityBuilder(
                  builder: (context, child, isKeyboardVisible) {
                    return AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      child: isKeyboardVisible
                          ? SizedBox()
                          : ActionCircleButton(
                              backgroundColor: colorPallete.red,
                              icon: Icons.delete,
                              foregroundColor: colorPallete.white,
                              onTap: () => FunctionRequest.deletePerson(
                                context,
                                person: person,
                                animatedListKey: keyAnimatedList,
                                index: newIndex - 1,
                              ),
                            ),
                    );
                  },
                  child: child,
                );
              },
            ),
          ),
        ),
        if (newIndex != persons.length) Divider(color: colorPallete.accentColor),
      ],
    );
  }
}

class GenerateGroupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold();
  }
}
