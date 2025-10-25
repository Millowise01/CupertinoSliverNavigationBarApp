import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Gallery App',
      theme: CupertinoThemeData(
        brightness: Brightness.light,
        primaryColor: CupertinoColors.systemBlue,
      ),
      home: GalleryScreen(),
    );
  }
}

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  CupertinoDynamicColor _backgroundColor = CupertinoColors.systemBackground;
  final TextEditingController _searchController = TextEditingController();
  List<GalleryItem> _filteredItems = [];
  final Set<int> _favorites = {};
  final List<GalleryItem> items = List.generate(
    20,
    (index) => GalleryItem(
      id: index + 1,
      title: _getPhotoTitle(index),
      subtitle: _getPhotoSubtitle(index),
      imageUrl: _getUnsplashImage(index),
      color: _getRandomColor(index),
    ),
  );

  @override
  void initState() {
    super.initState();
    _filteredItems = items;
    _searchController.addListener(_filterItems);
  }

  void _filterItems() {
    setState(() {
      _filteredItems = items.where((item) =>
        item.title.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    });
  }

  void _toggleFavorite(int id) {
    setState(() {
      if (_favorites.contains(id)) {
        _favorites.remove(id);
      } else {
        _favorites.add(id);
      }
    });
  }

  Future<void> _refreshGallery() async {
    await Future.delayed(Duration(seconds: 1));
    _addMultiplePhotos();
  }

  static String _getUnsplashImage(int index) {
    final imageId = 400 + index;
    return 'https://picsum.photos/id/$imageId/400/400';
  }

  static String _getPhotoTitle(int index) {
    final titles = [
      'Mountain Vista', 'City Lights', 'Ocean Waves', 'Forest Path',
      'Desert Sunset', 'Urban Street', 'Flower Garden', 'Snowy Peak',
      'Beach Paradise', 'Autumn Leaves', 'Night Sky', 'River Valley',
      'Modern Architecture', 'Wildlife Safari', 'Coastal View', 'Country Road',
      'Tropical Island', 'Winter Wonderland', 'Spring Meadow', 'Summer Breeze'
    ];
    return titles[index % titles.length];
  }

  static String _getPhotoSubtitle(int index) {
    final subtitles = [
      'Breathtaking landscape', 'Urban photography', 'Natural beauty', 'Scenic route',
      'Golden hour magic', 'Street photography', 'Colorful blooms', 'Alpine adventure',
      'Tropical paradise', 'Seasonal colors', 'Starry night', 'Peaceful waters',
      'Modern design', 'Wildlife encounter', 'Ocean view', 'Rural charm',
      'Island getaway', 'Snowy landscape', 'Fresh greenery', 'Warm weather'
    ];
    return subtitles[index % subtitles.length];
  }

  static CupertinoDynamicColor _getRandomColor(int index) {
    final colors = [
      CupertinoColors.systemBlue,
      CupertinoColors.systemGreen,
      CupertinoColors.systemOrange,
      CupertinoColors.systemPink,
      CupertinoColors.systemPurple,
      CupertinoColors.systemTeal,
      CupertinoColors.systemIndigo,
      CupertinoColors.systemRed,
    ];
    return colors[index % colors.length];
  }

  void _showOptionsDialog() {
    HapticFeedback.lightImpact();
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Gallery Options'),
        actions: [
          CupertinoActionSheetAction(
            child: Text('Add Photos'),
            onPressed: () {
              Navigator.pop(context);
              _addMultiplePhotos();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Change Background'),
            onPressed: () {
              Navigator.pop(context);
              _showBackgroundOptions();
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _addMultiplePhotos() {
    setState(() {
      for (int i = 0; i < 3; i++) {
        final newIndex = items.length + i;
        items.insert(
          0,
          GalleryItem(
            id: newIndex + 1,
            title: _getPhotoTitle(newIndex),
            subtitle: 'Recently added',
            imageUrl: _getUnsplashImage(newIndex + 100),
            color: _getRandomColor(newIndex),
          ),
        );
      }
    });
  }

  void _showBackgroundOptions() {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        title: Text('Choose Background Color'),
        message: Text('Select a background color for your gallery'),
        actions: [
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBackground.resolveFrom(context),
                    border: Border.all(color: CupertinoColors.systemGrey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Light White'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemBackground);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey6.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Light Grey'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemGrey6);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGrey5.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Medium Grey'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemGrey5);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemBlue.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Ocean Blue'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemBlue);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemGreen.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Nature Green'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemGreen);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemPurple.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Royal Purple'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemPurple);
              Navigator.pop(context);
            },
          ),
          CupertinoActionSheetAction(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: CupertinoColors.systemPink.resolveFrom(context),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                SizedBox(width: 12),
                Text('Sunset Pink'),
              ],
            ),
            onPressed: () {
              setState(() => _backgroundColor = CupertinoColors.systemPink);
              Navigator.pop(context);
            },
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          child: Text('Cancel'),
          onPressed: () => Navigator.pop(context),
        ),
      ),
    );
  }

  void _showItemDetails(GalleryItem item) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => PhotoDetailScreen(item: item),
      ),
    );
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 5;
    if (width > 1000) return 4;
    if (width > 600) return 3;
    return 2;
  }

  double _getCardAspectRatio(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width > 800 ? 0.9 : 0.85;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: _backgroundColor,
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text(
              'Gallery',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                letterSpacing: -0.5,
              ),
            ),
            backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
            border: Border(
              bottom: BorderSide(
                color: CupertinoColors.separator.resolveFrom(context),
                width: 0.5,
              ),
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showBackgroundOptions,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: _backgroundColor.resolveFrom(context),
                      border: Border.all(
                        color: CupertinoColors.systemGrey,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      CupertinoIcons.paintbrush,
                      color: CupertinoColors.label.resolveFrom(context),
                      size: 16,
                    ),
                  ),
                ),
                SizedBox(width: 8),
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _showOptionsDialog,
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: CupertinoColors.systemBlue,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      CupertinoIcons.add,
                      color: CupertinoColors.white,
                      size: 18,
                    ),
                  ),
                ),
              ],
            ),
          ),
          CupertinoSliverRefreshControl(
            onRefresh: _refreshGallery,
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search photos...',
              ),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _getCrossAxisCount(context),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: _getCardAspectRatio(context),
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => GalleryCard(
                  item: _filteredItems[index],
                  isFavorite: _favorites.contains(_filteredItems[index].id),
                  onTap: () => _showItemDetails(_filteredItems[index]),
                  onFavorite: () => _toggleFavorite(_filteredItems[index].id),
                ),
                childCount: _filteredItems.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GalleryItem {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final CupertinoDynamicColor color;

  GalleryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.color,
  });
}

class GalleryCard extends StatelessWidget {
  final GalleryItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const GalleryCard({
    Key? key,
    required this.item,
    required this.isFavorite,
    required this.onTap,
    required this.onFavorite,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.2),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            color: CupertinoColors.systemBackground.resolveFrom(context),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                        child: Image.network(
                          item.imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    item.color.resolveFrom(context),
                                    item.color.resolveFrom(context).withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: CupertinoActivityIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    item.color.resolveFrom(context),
                                    item.color.resolveFrom(context).withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  CupertinoIcons.photo,
                                  size: 40,
                                  color: CupertinoColors.white,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Positioned(
                        top: 8,
                        right: 8,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 32,
                          onPressed: onFavorite,
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: CupertinoColors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: isFavorite ? CupertinoColors.systemRed : CupertinoColors.white,
                              size: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.title,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: CupertinoColors.label.resolveFrom(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 2),
                        Text(
                          item.subtitle,
                          style: TextStyle(
                            fontSize: 12,
                            color: CupertinoColors.secondaryLabel.resolveFrom(context),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PhotoDetailScreen extends StatelessWidget {
  final GalleryItem item;

  const PhotoDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(item.title),
        backgroundColor: CupertinoColors.systemBackground.resolveFrom(context),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: CupertinoColors.systemGrey.withOpacity(0.3),
                        blurRadius: 20,
                        offset: Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                item.color.resolveFrom(context),
                                item.color.resolveFrom(context).withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: CupertinoActivityIndicator(radius: 20),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                item.color.resolveFrom(context),
                                item.color.resolveFrom(context).withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Center(
                            child: Icon(
                              CupertinoIcons.photo,
                              size: 80,
                              color: CupertinoColors.white,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 24),
              Text(
                item.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CupertinoColors.label.resolveFrom(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                item.subtitle,
                style: TextStyle(
                  fontSize: 16,
                  color: CupertinoColors.secondaryLabel.resolveFrom(context),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: CupertinoButton.filled(
                      child: Text('Add Photos'),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => GalleryScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CupertinoButton(
                      color: CupertinoColors.systemGrey4,
                      child: Text(
                        'Change BG',
                        style: TextStyle(color: CupertinoColors.label),
                      ),
                      onPressed: () {
                        HapticFeedback.mediumImpact();
                        Navigator.pop(context);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}