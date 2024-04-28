import 'package:flutter/material.dart';

class ImageGridView extends StatefulWidget {
  final List<Widget> gridViewItem;

  const ImageGridView({
    super.key,
    required this.gridViewItem,
  });

  @override
  State<ImageGridView> createState() => _ImageGridViewState();
}

class _ImageGridViewState extends State<ImageGridView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      width: double.maxFinite,
      height: MediaQuery.of(context).size.width,
      child: GridView(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        physics: const NeverScrollableScrollPhysics(),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[0],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[1],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[2],
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: widget.gridViewItem[3],
          )
        ],
      ),
    );
  }
}
