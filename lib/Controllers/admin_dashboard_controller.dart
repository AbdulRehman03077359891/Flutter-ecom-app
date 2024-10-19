import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:my_ecom_app/Widgets/notification_message.dart';

class AdminDashBoardController extends GetxController {
  bool isLoading = false;
  RxInt userNCount = 0.obs;
  RxInt userBCount = 0.obs;
  RxInt catergoryCount = 0.obs;
  RxInt dishesCount = 0.obs;
  RxList allOrders = [].obs;
  RxInt pOrders = 0.obs;
  RxInt aOrders = 0.obs;
  RxInt sOrders = 0.obs;
  RxInt dOrders = 0.obs;
  RxInt cOrders = 0.obs;

  setLoading(value) {
    isLoading = value;
    update(); // To notify listeners about the loading state change
  }

  @override
  void onInit() {
    super.onInit();
    getDashBoardData(); // Start fetching data as soon as the controller is initialized
  }

  getDashBoardData() {
    // Listen to NormUsers collection
    FirebaseFirestore.instance.collection("NormUsers").snapshots().listen((QuerySnapshot data) {
      errorMessage("Fetched NormUsers: ", "${data.docs.length}");
      userNCount.value = data.docs.length;
    });

    // Listen to BusinessUsers collection
    FirebaseFirestore.instance.collection("BusinessUsers").snapshots().listen((QuerySnapshot data) {
      errorMessage("Fetched BusinessUsers: ", "${data.docs.length}");
      userBCount.value = data.docs.length;
    });

    // Listen to Category collection
    FirebaseFirestore.instance.collection("Category").snapshots().listen((QuerySnapshot data) {
      errorMessage("Fetched Categories: ", "${data.docs.length}");
      catergoryCount.value = data.docs.length;
    });

    // Listen to Dishes collection
    FirebaseFirestore.instance.collection("Dishes").snapshots().listen((QuerySnapshot data) {
      errorMessage("Fetched Dishes: ", "${data.docs.length}");
      dishesCount.value = data.docs.length;
    });

    // Listen to Orders and categorize them
    FirebaseFirestore.instance.collection("Orders").snapshots().listen((QuerySnapshot data) {
      var ordersData = data.docs.map((doc) => doc.data()).toList();

      // Reset counts for each order status
      pOrders.value = 0;
      aOrders.value = 0;
      sOrders.value = 0;
      dOrders.value = 0;
      cOrders.value = 0;
      allOrders.clear();

      // Loop through each order and categorize it by its status
      for (var order in ordersData) {
        // Check if order is not null and status exists
        if (order != null && order is Map<String, dynamic> && order.containsKey('status')) {
          String? status = order['status'] as String?;

          // Increment the respective order count based on status
          switch (status) {
            case "pending":
              pOrders.value++;
              break;
            case "accepted":
              aOrders.value++;
              break;
            case "shipped":
              sOrders.value++;
              break;
            case "delivered":
              dOrders.value++;
              break;
            case "cancelled":
              cOrders.value++;
              break;
            default:
              allOrders.add(order); // Add to general list if uncategorized
          }
        } else {
          // Handle cases where order or status is null
          allOrders.add(order);  // Optionally add the order to a general list
        }
      }

      // Update with categorized orders and notify UI
      setLoading(false);
      update();
    });
  }
}
