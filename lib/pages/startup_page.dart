// import 'package:carousel_slider/carousel_slider.dart' as carousel;
import '../components/start_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StartupPage extends StatelessWidget {
  const StartupPage({super.key});

  static String id = 'StartupPage';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            transform: GradientRotation(180),
            colors: [
              Color(0xfff86c66),
              Color(0xff56B4BE),
            ],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.all(12.0),
              child: Align(
                alignment: Alignment.topLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Text(
                      'Welcome to',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      'Arrhythmia Detection',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Lottie.asset(
                'assets/lottie/Animation - 1707144042503.json',
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: carousel.CarouselSlider(
            //     options: carousel.CarouselOptions(

            //       autoPlay: true,
            //       enlargeCenterPage: true,
            //       viewportFraction: .86,
            //       height: 320.0,
            //     ),
            //     items: const [
            //       ContainerFeature(
            //         widget: ListTile(
            //           title: Padding(
            //             padding: EdgeInsets.only(top: 8, bottom: 8.0),
            //             child: Text(
            //               'What is The Arrhythmia ?',
            //               style: TextStyle(
            //                 fontSize: 20,
            //                 fontWeight: FontWeight.bold,
            //               ),
            //             ),
            //           ),
            //           subtitle: Text(
            //             "is an irregular heartbeat. A heart arrhythmia occurs when the electrical signals that tell the heart to beat don't work properly. The heart may beat too fast or too slow.",
            //             style: TextStyle(
            //               fontSize: 18,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //       ContainerFeature(
            //         widget: ListTile(
            //           title: Text(
            //             'The Application Goal:',
            //             style: TextStyle(
            //               fontSize: 22,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.black,
            //             ),
            //           ),
            //           subtitle: Text(
            //             maxLines: 10,
            //             overflow: TextOverflow.ellipsis,
            //             "Our product aims to detect arrhythmia disease, when the patient logs in, user can add their ECG to detect their condition using ML.\nFacilitate communication: the patient can consult the doctor online.View a statistical report: this is done based on the results of a machine learning model and using data analysis to show the report.",
            //             style: TextStyle(
            //               fontSize: 16,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //       ContainerFeature(
            //         widget: ListTile(
            //           title: Padding(
            //             padding: EdgeInsets.only(top: 8, bottom: 8.0),
            //             child: Text(
            //               'The Application Feature:',
            //               style: TextStyle(
            //                 fontSize: 22,
            //                 fontWeight: FontWeight.bold,
            //                 color: Colors.black,
            //               ),
            //             ),
            //           ),
            //           subtitle: Text(
            //             "Arrhythmia Classification\nConsult with Doctor\nBreathing Exercises\nMedicine Remainder\nAdding Report\nChatGPT",
            //             style: TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.bold,
            //               color: Colors.white,
            //             ),
            //           ),
            //         ),
            //       ),
            //     ],
            //   ),
            // ),
            const StartButton()
          ],
        ),
      ),
    );
  }
}

class ContainerFeature extends StatelessWidget {
  const ContainerFeature({
    super.key,
    required this.widget,
  });

  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromARGB(255, 67, 65, 65),
            offset: Offset(2.0, 2.0), //(x,y)
            blurRadius: 10.0,
          ),
        ],

        color: Color(0xff59b3bd),
        borderRadius: BorderRadius.all(
          Radius.circular(26),
        ),
        // color: Color(0xff59b3bd),
      ),
      child: widget,
    );
  }
}



// class HeartPainter extends CustomPainter {
//   @override
//   void paint(Canvas canvas, Size size) {
//     Paint paint = Paint();
//     paint
//       ..color = Colors.red
//       ..style = PaintingStyle.stroke
//       ..strokeCap = StrokeCap.round
//       ..strokeWidth = 2;

//     Paint paint1 = Paint();
//     paint1
//       ..color = Colors.blue
//       ..style = PaintingStyle.fill
//       ..strokeWidth = 0;

//     double width = size.width;
//     double height = size.height;

//     Path path = Path();
//     path.moveTo(0.5 * width, height * 0.35);
//     path.cubicTo(0.2 * width, height * 0.1, -0.25 * width, height * 0.6,
//         0.5 * width, height);
//     path.moveTo(0.5 * width, height * 0.35);
//     path.cubicTo(0.8 * width, height * 0.1, 1.25 * width, height * 0.6,
//         0.5 * width, height);

//     canvas.drawPath(path, paint1);
//     canvas.drawPath(path, paint);
//   }

//   @override
//   bool shouldRepaint(CustomPainter oldDelegate) {
//     return true;
//   }
// }
