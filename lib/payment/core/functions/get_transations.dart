import 'package:arrhythmia/payment/Features/checkout/data/models/amount_model/amount_model.dart';
import 'package:arrhythmia/payment/Features/checkout/data/models/amount_model/details.dart';
import 'package:arrhythmia/payment/Features/checkout/data/models/item_list_model/item.dart';

import '../../Features/checkout/data/models/item_list_model/item_list_model.dart';

({AmountModel amount, ItemListModel itemList}) getTransactionsData() {
  var amount = AmountModel(
      total: "5",
      currency: "USD",
      details: Details(shipping: "0", shippingDiscount: 0, subtotal: "5"));
  List<OrderItemModel> orders = [
    OrderItemModel(
      currency: "USD",
      name: "Chat with Doctor",
      price: "5",
      quantity: 1,
    ),
    OrderItemModel(
      currency: "USD",
      name: "Chat with Doctor",
      price: "5",
      quantity: 12,
    ),
  ];

  var itemList = ItemListModel(
    orders: orders,
  );
  return (amount: amount, itemList: itemList);
}
