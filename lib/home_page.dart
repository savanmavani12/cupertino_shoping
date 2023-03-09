import 'package:cupertino_shoping/screens/global.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();

  String name = "";
  String email = "";
  String location = "";

  String date = "";
  List data = [];

  @override
  void initState() {
    super.initState();
    date = DateTime.now().toString();

    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    data = [
      productsPage(context, w),
      searchPage(w),
      cartPage(context, w),
    ];

    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        currentIndex: tabController.index,
        onTap: (val) {
          tabController.index = val;
          setState(() {});
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house),
            label: "Products",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.search_circle),
            label: "Search",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.cart),
            label: "Cart",
          ),
        ],
      ),
      tabBuilder: (context, index) {
        return CupertinoTabView(
          builder: (context) {
            return data[index];
          },
        );
      },
    );
  }

  productsPage(context, width) {
    return SafeArea(
      child: Container(
        color: CupertinoColors.activeBlue,
        child: Column(
          children: [
            const Expanded(
              flex: 1,
              child: Text(
                "Apple Store",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              flex: 10,
              child: ListView(
                children: Global.productsList
                    .map(
                      (e) => Container(
                    color: CupertinoColors.white,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          width: width * 0.27,
                          child: Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.inactiveGray,
                              borderRadius: BorderRadius.circular(10),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(e["image"]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: width * 0.73,
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      e["name"],
                                      style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    Text(
                                      "${e["price"]}",
                                      style: const TextStyle(
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        Global.cartList.add(e);
                                        Global.cartList = Global.cartList
                                            .toSet()
                                            .toList();
                                      });
                                    },
                                    child: const Icon(
                                      CupertinoIcons.add_circled,
                                    )),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  cartPage(context, width) {
    double tax = 0;
    double total = 0;

    for (var e in Global.cartList) {
      total = int.parse(e["price"]) + total;
    }

    return SafeArea(
      child: Container(
        color: CupertinoColors.white,
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            const Expanded(
              child: Text(
                "Shopping Cart",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),
            ),
            Expanded(
              flex: 6,
              child: Container(
                height: double.infinity,
                padding: const EdgeInsets.all(10),
                child: ListView(
                  children: [
                    const SizedBox(height: 5),
                    textField(
                      "Name",
                      CupertinoIcons.person_alt,
                      name,
                    ),
                    const SizedBox(height: 5),
                    textField(
                      "Email",
                      CupertinoIcons.mail,
                      email,
                    ),
                    const SizedBox(height: 5),
                    textField(
                      "Location",
                      CupertinoIcons.location_solid,
                      location,
                    ),
                    const SizedBox(height: 5),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        border: BorderDirectional(
                          bottom: BorderSide(color: CupertinoColors.systemGrey),
                        ),
                      ),
                      child: Row(
                        children: [
                          const Icon(CupertinoIcons.timer_fill,
                              color: CupertinoColors.systemGrey),
                          const SizedBox(width: 5),
                          const Text(
                            "Delivery time",
                            style: TextStyle(color: CupertinoColors.systemGrey),
                          ),
                          const Spacer(),
                          Text(
                            date.toString(),
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 250,
                      child: CupertinoDatePicker(
                        onDateTimeChanged: (val) {
                          setState(() {
                            date = val.toString();
                          });
                        },
                        use24hFormat: false,
                      ),
                    ),
                    Column(
                      children: Global.cartList
                          .map(
                            (e) => Container(
                          color: CupertinoColors.white,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(10),
                                height: 60,
                                width: width * 0.20,
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: CupertinoColors.systemGrey,
                                    borderRadius: BorderRadius.circular(5),
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: AssetImage(e["image"]),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                height: 80,
                                width: width * 0.72,
                                padding: const EdgeInsets.all(10),
                                child: Row(
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        const Spacer(),
                                        Text(
                                          e["name"],
                                          style: const TextStyle(
                                            fontSize: 19,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        const SizedBox(height: 7),
                                        Text(
                                          "₹ ${e["price"]}",
                                          style: const TextStyle(
                                            color:
                                            CupertinoColors.systemGrey,
                                          ),
                                        ),
                                        const Spacer(),
                                      ],
                                    ),
                                    const Spacer(),
                                    Text(
                                      "₹ ${e["price"]}",
                                      style: const TextStyle(
                                        color: CupertinoColors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                          .toList(),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const SizedBox(height: 10),
                          Text(
                            "Total : ₹ ${total.toString()}",
                            style: const TextStyle(
                                color: CupertinoColors.black,
                                fontSize: 25,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  textField(hint, icon, value) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: const BoxDecoration(
        border: BorderDirectional(
          bottom: BorderSide(color: CupertinoColors.systemGrey),
        ),
      ),
      child: CupertinoTextField.borderless(
        placeholder: hint,
        prefix: Icon(
          icon,
          color: CupertinoColors.systemGrey,
        ),
      ),
    );
  }

  searchPage(width) {
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 65,
              padding: const EdgeInsets.all(10),
              child: const CupertinoSearchTextField(),
            ),
            Expanded(
              child: ListView(
                children: Global.productsList
                    .map(
                      (e) => Container(
                    color: CupertinoColors.white,
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          height: 100,
                          width: width * 0.27,
                          child: Container(
                            decoration: BoxDecoration(
                              color: CupertinoColors.systemGrey,
                              borderRadius: BorderRadius.circular(5),
                              image: DecorationImage(
                                fit: BoxFit.cover,
                                image: AssetImage(e["image"]),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          height: 100,
                          width: width * 0.73,
                          padding: const EdgeInsets.all(10),
                          child: Container(
                            decoration: const BoxDecoration(
                              border: BorderDirectional(
                                bottom: BorderSide(
                                  color: CupertinoColors.systemGrey,
                                ),
                              ),
                            ),
                            child: Row(
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Spacer(),
                                    Text(
                                      e["name"],
                                      style: const TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      "₹ ${e["price"]}",
                                      style: const TextStyle(
                                        color: CupertinoColors.systemGrey,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      Global.cartList.add(e);
                                      Global.cartList =
                                          Global.cartList.toSet().toList();
                                    });
                                  },
                                  child: const Icon(
                                    CupertinoIcons.add_circled,
                                  ),
                                ),
                                const SizedBox(width: 10),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
                    .toList(),
              ),
            )
          ],
        ),
      ),
    );
  }
}
