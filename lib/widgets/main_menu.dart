import 'package:flutter/material.dart';
import 'gridview_list_all.dart';
import 'gridview_list_popular.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  Widget _selectedItem = GridViewListAll();

  List<String> filters = ["All", "iPhone"];
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }

  screenSelector() {
    if (selectedFilter == "All") {
      return GridViewListAll();
    } else if (selectedFilter == "iPhone") {
      return GridViewListIPhone();
    }
    // You can add more cases for other filters if needed
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 10),
          child: SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: filters.length,
              itemBuilder: (context, i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 15),
                  child: ActionChip(
                    label: Text(filters[i]),
                    side: BorderSide.none,
                    backgroundColor:
                    selectedFilter == filters[i] ? Theme.of(context).primaryColor : Colors.grey[300],
                    onPressed: () {
                      setState(() {
                        selectedFilter = filters[i];
                        _selectedItem = screenSelector();
                      });
                    },
                    labelStyle: TextStyle(
                        color: selectedFilter == filters[i] ? Colors.white : Colors.grey[600]),
                  ),
                );
              },
            ),
          ),
        ),
        Container(
          child: _selectedItem,
        ),
      ],
    );
  }
}
