import 'package:flutter/material.dart';

class RowFilters extends StatefulWidget {
  const RowFilters({super.key});

  @override
  State<RowFilters> createState() => _RowFiltersState();
}

class _RowFiltersState extends State<RowFilters> {
  List filters = ["All", "Popular", "Recent", "Recommended"];
  late String selectedFilter;

  @override
  void initState() {
    super.initState();
    selectedFilter = filters[0];
  }
  @override
  Widget build(BuildContext context) {

    return Padding(
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
                backgroundColor: selectedFilter == filters[i] ? Theme.of(context).primaryColor : Colors.grey[300],
                onPressed: () {
                  setState(() {
                    selectedFilter = filters[i];
                  });
                },
                labelStyle: TextStyle(color: selectedFilter == filters[i] ? Colors.white : Colors.grey[600]),
              ),
            );
          },
        ),
      ),
    );
  }
}
