import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:global_template/global_template.dart';

import 'src/functions/functions.dart';
import 'src/network/models/person/person_model.dart';
import 'src/providers/providers.dart';

//TODO Simpan generate result ke dalam local storage digunakan untuk historynya

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
      routes: {
        GenerateResultScreen.routeNamed: (ctx) => GenerateResultScreen(
              generateResult: ModalRoute.of(ctx).settings.arguments,
            ),
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.scheduleFrameCallback((_) {
      context.read(settingProvider).read();
    });
  }

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
        child: DrawerSide(),
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
                await FunctionRequest.processGenerate(
                  context,
                  onCompleteGenerate: () {
                    final result = FunctionRequest.generateGroup(context);
                    print(result);
                    Future.delayed(const Duration(milliseconds: 500), () {
                      Navigator.of(context).pushNamed(
                        GenerateResultScreen.routeNamed,
                        arguments: result,
                      );
                    });
                  },
                );
              },
            ),
          ),
        ],
      ),
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

class DrawerSide extends StatelessWidget {
  const DrawerSide({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
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
                          child: Consumer(builder: (context, watch, child) {
                            final settingTotal = watch(settingProvider.state).totalGenerateGroup;
                            return Text('$settingTotal');
                          }),
                        ),
                      ),
                      backgroundColor: colorPallete.accentColor,
                      foregroundColor: colorPallete.white,
                      radius: sizes.width(context) / 30,
                    ),
                    onTap: () async {
                      await showDialog(
                        context: context,
                        builder: (context) => AlertDialog(
                          title: Text(
                            'Total kelompok',
                            style: appTheme.headline6(context),
                          ),
                          content: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormFieldCustom(
                              controller: null,
                              prefixIcon: null,
                              keyboardType: TextInputType.number,
                              inputFormatter: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              onFieldSubmitted: (value) => context.read(settingProvider).save(
                                int.tryParse(value),
                                generateTotal: (total) async {
                                  Navigator.of(context).pop();
                                  await GlobalFunction.showToast(
                                    message: 'Total kelompok disetting menjadi : $total',
                                    toastType: ToastType.Success,
                                    isLongDuration: true,
                                  );
                                },
                              ),
                            ),
                          ),
                          actions: [],
                        ),
                      );
                    },
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

class GenerateResultScreen extends StatelessWidget {
  static const routeNamed = '/generate-result-screen';
  final Map<String, List<PersonModel>> generateResult;

  GenerateResultScreen({@required this.generateResult});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Preview kelompok'),
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: () {
              FunctionRequest.printPDF(generateResult);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ...generateResult
                  .map(
                    (nameGroup, persons) => MapEntry(
                      nameGroup,
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            nameGroup,
                            style: appTheme.headline4(context),
                          ),
                          SizedBox(height: 10),
                          Card(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                            child: ListView.builder(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: persons.length,
                              itemBuilder: (context, index) {
                                final person = persons[index];
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: colorPallete.accentColor,
                                        foregroundColor: colorPallete.white,
                                        child: Text('${index + 1}'),
                                      ),
                                      title: Text(person.name),
                                    ),
                                    if ((index + 1 < persons.length)) Divider(thickness: 1),
                                  ],
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                  )
                  .values
                  .toList()
            ],
          ),
        ),
      ),
    );
  }
}

// child: Column(
//   children: [
//     SizedBox(height: 10),
//     ...generateResult
//         .map(
//           (nameGroup, persons) => MapEntry(
//             nameGroup,
//             Row(children: [Text('11')]),
//           ),
//         )
//         .values
//         .toList(),
//     SizedBox(height: 10),

//   ],
// ),
