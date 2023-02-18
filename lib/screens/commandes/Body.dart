// import 'package:flutter/cupertino.dart';
// import 'package:flutter/src/foundation/key.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:shop_app/screens/cart/components/empty_cart.dart';

// import '../../constants.dart';
// import '../../size_config.dart';
// import 'empty_com.dart';

// class Body extends StatefulWidget {
//   const Body({Key key}) : super(key: key);

//   @override
//   State<Body> createState() => _BodyState();
// }

// class _BodyState extends State<Body> {
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SizedBox(
//         width: double.infinity,
//         child: Padding(
//           padding:
//               EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
//           child: SingleChildScrollView(
//             child: Column(
//               children: [
//                 SizedBox(height: SizeConfig.screenHeight * 0.03),
//                 Text("Mes commandes", style: headingStyle),
//                 SizedBox(height: SizeConfig.screenHeight * 0.06),
//                 EmptyCommande(),
//                 // SizedBox(height: getProportionateScreenHeight(30)),
//                 // Text(
//                 //   "En continuant, vous confirmez que vous êtes d'accord \navec nos conditions générales.",
//                 //   textAlign: TextAlign.center,
//                 //   style: Theme.of(context).textTheme.caption,
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }