import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shop_app/components/default_button.dart';
import 'package:shop_app/models/Cart.dart';
import 'package:shop_app/models/product_dao.dart';
import 'package:stripe_payment/stripe_payment.dart';

import '../../../size_config.dart';

class CheckoutCard extends StatefulWidget {
  const CheckoutCard({Key key}) : super(key: key);

  @override
  _CheckoutCardState createState() => _CheckoutCardState();
}

class _CheckoutCardState extends State<CheckoutCard> {
  final Stream<QuerySnapshot> cartProducts = ProductDAO().getCartAmount();
  double amount = 0.0;
  List<Cart> carts = [];

  @override
  initState() {
    super.initState();
    loadData();
    StripePayment.setOptions(StripeOptions(
        publishableKey:
            "pk_test_51K6WKhIgwaOpAFgPWJ1rpwYWc3Cz8Jpuqalw0ICzHvHmewANDPeZamvQkl1xMYemqlYBJyGweeA7k1ILx5c349Pb00yKzNS48L",
        merchantId: "Test",
        androidPayMode: 'test'));
  }

  loadData() async {
    dynamic results = await ProductDAO().getProductForCart();
    setState(() {
      carts = results;
    });
  }

  Future<void> openDialog() async {
    switch (await showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        children: [
          Container(
              height: 300,
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(children: [
                  Icon(
                    Icons.check_circle_outline,
                    color: Colors.green,
                    size: 100.0,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10),
                    child: Text(
                        'Votre commande a été validée. vous recevrez la livraison dans les délais'),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 30),
                    child: DefaultButton(text: "Ok", press: () => {}
                        // Navigator.pushNamed(context, HomeScreen.routeName),
                        ),
                  )
                ]),
              ))
        ],
      ),
    )) {
    }
  }

  Future<void> checkout() async {
    /// retrieve data from the backend
    StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest())
        .then((paymentMethod) {
      carts.forEach((element) {
        ProductDAO().deletedFromCard(element.id);
      });
      openDialog();
    }).catchError((error) => {print('$error')});
  }

  @override
  Widget build(BuildContext context) {
    // ProductDAO productDAO = Provider.of<ProductDAO>(context, listen: true);
    return StreamBuilder<QuerySnapshot>(
        stream: cartProducts,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.data != null) {
            amount = 0.0;
            snapshot.data.docs.forEach((element) {
              amount = element['price'] * element['quantity'] + amount;
            });
          }
          return Container(
            padding: EdgeInsets.symmetric(
              vertical: getProportionateScreenWidth(15),
              horizontal: getProportionateScreenWidth(30),
            ),
            // height: 174,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(30),
                topRight: Radius.circular(30),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, -15),
                  blurRadius: 20,
                  color: Color(0xFFDADADA).withOpacity(0.15),
                )
              ],
            ),
            child: SafeArea(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(10),
                        height: getProportionateScreenWidth(40),
                        width: getProportionateScreenWidth(40),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F6F9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: SvgPicture.asset("assets/icons/receipt.svg"),
                      ),
                      Spacer(),
                    ],
                  ),
                  SizedBox(height: getProportionateScreenHeight(20)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text.rich(
                        TextSpan(text: "Total:\n", children: [
                          TextSpan(
                            text: '\€ ${amount.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 16, color: Colors.black),
                          ),
                        ]),
                      ),
                      SizedBox(
                        width: getProportionateScreenWidth(190),
                        child: DefaultButton(
                            text: "Valider",
                            press: () {
                              if (amount == 0.0) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                        content:
                                            Text('votre panier est vide')));
                              } else {
                                checkout();
                              }
                            }),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
