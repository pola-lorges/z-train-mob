import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/app_state_manager.dart';
import 'package:shop_app/models/product_dao.dart';
// import 'package:shop_app/screens/cart/cart_screen.dart';

import '../../../size_config.dart';
import 'icon_btn_with_counter.dart';
import 'search_field.dart';

class HomeHeader extends StatefulWidget {
  @override
  _HomeHeaderState createState() => _HomeHeaderState();
}

class _HomeHeaderState extends State<HomeHeader> {
  int numCartProduct;

  final Stream<QuerySnapshot> productCart = ProductDAO().getCountProductCart();
 

  @override
  Widget build(BuildContext context) {
     final AppStateManager appStateManager =
        Provider.of<AppStateManager>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: productCart,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        return Padding(
          padding:
              EdgeInsets.symmetric(horizontal: getProportionateScreenWidth(20)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SearchField(),
                IconBtnWithCounter(
                svgSrc: "assets/icons/User.svg",
                press: () {
                   appStateManager.setModifyPlofil(true);
                },
              ),
              IconBtnWithCounter(
                svgSrc: "assets/icons/Cart Icon.svg",
                numOfitem:
                    snapshot.data == null ? 0 : snapshot.data.docs.length,
                press: () {
                  // Provider.of<AppStateManager>(context, listen: false)
                  //     .setDisplayProduct(false);
                  Provider.of<AppStateManager>(context, listen: false)
                      .goToCart();
                  // Navigator.pushNamed(context, CartScreen.routeName);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
