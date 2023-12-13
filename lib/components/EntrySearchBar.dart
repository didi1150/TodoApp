import 'package:flutter/material.dart';

class TodoEntrySearchBar extends StatefulWidget {
  Function(String) callback;

  TodoEntrySearchBar({super.key, required this.callback});

  @override
  State<TodoEntrySearchBar> createState() => _TodoEntrySearchBarState();
}

class _TodoEntrySearchBarState extends State<TodoEntrySearchBar> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Material(
          borderRadius: const BorderRadius.all(Radius.circular(20)),
          elevation: 10,
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            onTapOutside: (event) {
              FocusManager.instance.primaryFocus?.unfocus();
            },
            onChanged: (searchText) {
              widget.callback(searchText);
            },
            decoration: InputDecoration(
              hintText: "Search for Todos...",
              prefixIcon: IconButton(
                  onPressed: () {
                    FocusScope.of(context).requestFocus(_searchFocusNode);
                  },
                  icon: Icon(Icons.search)),
              suffixIcon: IconButton(
                onPressed: () {
                  _searchController.clear();
                  widget.callback("");
                },
                icon: Icon(Icons.close),
              ),
              border: InputBorder.none,
            ),
          ),
        ));
  }
}
