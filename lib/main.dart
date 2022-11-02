import 'package:flutter/material.dart';
import 'package:faker/faker.dart';
import 'package:flutter_svg/flutter_svg.dart';

void main(List<String> args) {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: WelcomeScreen(),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final _controller = PageController();
  int _activePage = 0;
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemCount: 3,
            controller: _controller,
            onPageChanged: ((value) {
              setState(() {
                _activePage = value;
              });
            }),
            itemBuilder: ((context, index) {
              return PageItem(
                index: index,
                ctrl: _controller,
              );
            }),
          ),
          DotIndicator(controller: _controller, activePage: _activePage),
        ],
      ),
    );
  }
}

class DotIndicator extends StatelessWidget {
  const DotIndicator({
    Key? key,
    required PageController controller,
    required int activePage,
  })  : _controller = controller,
        _activePage = activePage,
        super(key: key);

  final PageController _controller;
  final int _activePage;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 100,
      left: 0,
      right: 0,
      height: 40,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List<Widget>.generate(
          3,
          (index) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: InkWell(
              onTap: () {
                _controller.animateToPage(index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeIn);
              },
              child: CircleAvatar(
                radius: 5,
                // check if a dot is connected to the current page
                // if true, give it a different color
                backgroundColor: _activePage == index
                    ? Colors.greenAccent
                    : const Color.fromARGB(77, 160, 191, 160),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PageItem extends StatelessWidget {
  const PageItem({super.key, required this.index, required this.ctrl});
  final int index;
  final PageController ctrl;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 40,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgPicture.asset('assets/$index.svg', height: size.height / 2),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
            child: Text(
              faker.lorem.sentences(5).toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Gothic'),
            ),
          ),
          SizedBox(
            width: 150,
            height: 40,
            child: ElevatedButton(
              onPressed: () {
                if (index == 2) {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: ((context) => const HomePage()),
                    ),
                  );
                }
                ctrl.nextPage(
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.ease);
              },
              child: Text(index == 2 ? 'Continue' : 'Next'),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'Welcome back',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
