import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'Photo Gallery',
      debugShowCheckedModeBanner: false,
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

class _GalleryScreenState extends State<GalleryScreen> with TickerProviderStateMixin {
  final TextEditingController _searchController = TextEditingController();
  List<GalleryItem> _filteredItems = [];
  final Set<int> _favorites = {};
  bool _isGridView = true;
  late AnimationController _animationController;
  
  final List<GalleryItem> items = List.generate(
    10,
    (index) => GalleryItem(
      id: index + 1,
      title: _getPhotoTitle(index),
      subtitle: _getPhotoSubtitle(index),
      imageUrl: _getUniquePhotoImage(index),
      country: _getPhotoCategory(index),
      population: _getPhotoResolution(index),
      color: _getRandomColor(index),
    ),
  );

  @override
  void initState() {
    super.initState();
    _filteredItems = items;
    _searchController.addListener(_filterItems);
    _animationController = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _filterItems() {
    setState(() {
      _filteredItems = items.where((item) =>
        item.title.toLowerCase().contains(_searchController.text.toLowerCase()) ||
        item.country.toLowerCase().contains(_searchController.text.toLowerCase())
      ).toList();
    });
  }

  void _toggleFavorite(int id) {
    setState(() {
      HapticFeedback.lightImpact();
      _favorites.contains(id) ? _favorites.remove(id) : _favorites.add(id);
    });
  }

  void _toggleView() {
    setState(() {
      _isGridView = !_isGridView;
      HapticFeedback.selectionClick();
    });
  }

  void _showItemDetails(GalleryItem item) {
    HapticFeedback.selectionClick();
    Navigator.push(
      context,
      CupertinoPageRoute(
        builder: (context) => CityDetailScreen(item: item),
      ),
    );
  }

  static String _getUniquePhotoImage(int index) {
    final photoIds = [
      '1506905925346-21bda4d32df4', // Mountain landscape
      '1514565131-fce0801e5785', // City lights at night
      '1505142468610-359e7d316be0', // Ocean waves
      '1441974231531-c6227db76b6e', // Forest path
      '1506197603052-3cc9c3a201bd', // Desert sunset
      '1477959858617-67f85cf4f1df', // Urban street
      '1490750967868-88aa4486c946', // Flower garden
      '1551698618-1dfe5d97d256', // Snowy mountain peak
      '1507525428034-b723cf961d3e', // Tropical beach
      '1507041957456-9c397ce39c97'  // Autumn leaves
    ];
    return 'https://images.unsplash.com/photo-${photoIds[index]}?w=300&h=300&fit=crop&auto=format';
  }

  static String _getPhotoTitle(int index) {
    final titles = [
      'Mountain Vista', 'City Lights', 'Ocean Waves', 'Forest Path', 'Desert Sunset',
      'Urban Street', 'Flower Garden', 'Snowy Peak', 'Beach Paradise', 'Autumn Leaves'
    ];
    return titles[index];
  }

  static String _getPhotoSubtitle(int index) {
    final subtitles = [
      'Breathtaking mountain landscape', 'Urban night photography', 'Powerful ocean waves', 'Peaceful forest trail', 'Golden desert sunset',
      'Vibrant street scene', 'Colorful garden blooms', 'Majestic snowy peak', 'Pristine tropical beach', 'Beautiful autumn foliage'
    ];
    return subtitles[index];
  }

  static String _getPhotoCategory(int index) {
    final categories = [
      'Nature', 'Urban', 'Seascape', 'Forest', 'Desert',
      'Street', 'Macro', 'Winter', 'Beach', 'Seasonal'
    ];
    return categories[index];
  }

  static String _getPhotoResolution(int index) {
    final resolutions = [
      '4K', '8K', 'HD', '2K', '5K',
      'Ultra HD', 'Full HD', '6K', '3K', 'QHD'
    ];
    return resolutions[index];
  }

  static CupertinoDynamicColor _getRandomColor(int index) {
    final colors = [
      CupertinoColors.systemBlue, CupertinoColors.systemGreen, CupertinoColors.systemOrange,
      CupertinoColors.systemPink, CupertinoColors.systemPurple, CupertinoColors.systemTeal,
      CupertinoColors.systemIndigo, CupertinoColors.systemRed,
    ];
    return colors[index % colors.length];
  }

  int _getCrossAxisCount(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    if (width > 1400) return 5;
    if (width > 1000) return 4;
    if (width > 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: CustomScrollView(
        physics: BouncingScrollPhysics(),
        slivers: [
          CupertinoSliverNavigationBar(
            largeTitle: Text('Photo Gallery'),
            backgroundColor: CupertinoColors.systemBackground,
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  onPressed: _toggleView,
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child: Icon(
                      _isGridView ? CupertinoIcons.list_bullet : CupertinoIcons.grid,
                      key: ValueKey(_isGridView),
                      size: 24,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: CupertinoSearchTextField(
                controller: _searchController,
                placeholder: 'Search photos...',
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
          _isGridView ? _buildGridView() : _buildListView(),
        ],
      ),
    );
  }

  Widget _buildGridView() {
    return SliverPadding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      sliver: SliverGrid(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _getCrossAxisCount(context),
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.9,
        ),
        delegate: SliverChildBuilderDelegate(
          (context, index) => FadeTransition(
            opacity: _animationController,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: Offset(0, 0.3),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: _animationController,
                curve: Interval(index * 0.1, 1.0, curve: Curves.easeOut),
              )),
              child: CityCard(
                item: _filteredItems[index],
                isFavorite: _favorites.contains(_filteredItems[index].id),
                onTap: () => _showItemDetails(_filteredItems[index]),
                onFavorite: () => _toggleFavorite(_filteredItems[index].id),
              ),
            ),
          ),
          childCount: _filteredItems.length,
        ),
      ),
    );
  }

  Widget _buildListView() {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) => FadeTransition(
          opacity: _animationController,
          child: CityListTile(
            item: _filteredItems[index],
            isFavorite: _favorites.contains(_filteredItems[index].id),
            onTap: () => _showItemDetails(_filteredItems[index]),
            onFavorite: () => _toggleFavorite(_filteredItems[index].id),
          ),
        ),
        childCount: _filteredItems.length,
      ),
    );
  }
}

class GalleryItem {
  final int id;
  final String title;
  final String subtitle;
  final String imageUrl;
  final String country;
  final String population;
  final CupertinoDynamicColor color;

  GalleryItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    required this.country,
    required this.population,
    required this.color,
  });
}

class CityCard extends StatelessWidget {
  final GalleryItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CityCard({
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
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            color: CupertinoColors.systemBackground,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Hero(
                          tag: 'city-${item.id}',
                          child: Image.network(
                            item.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      item.color.resolveFrom(context),
                                      item.color.resolveFrom(context).withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: Icon(CupertinoIcons.photo, size: 40, color: CupertinoColors.white),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        top: 12,
                        right: 12,
                        child: CupertinoButton(
                          padding: EdgeInsets.zero,
                          minSize: 36,
                          onPressed: onFavorite,
                          child: Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: CupertinoColors.black.withOpacity(0.4),
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: CupertinoColors.white.withOpacity(0.3)),
                            ),
                            child: Icon(
                              isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                              color: isFavorite ? CupertinoColors.systemRed : CupertinoColors.white,
                              size: 18,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.title,
                        style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        '${item.country} • ${item.population}',
                        style: TextStyle(fontSize: 11, color: CupertinoColors.secondaryLabel),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
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

class CityListTile extends StatelessWidget {
  final GalleryItem item;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavorite;

  const CityListTile({
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
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: CupertinoColors.systemBackground,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: CupertinoColors.systemGrey.withOpacity(0.1),
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.network(
                  item.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            item.color.resolveFrom(context),
                            item.color.resolveFrom(context).withOpacity(0.7),
                          ],
                        ),
                      ),
                      child: Icon(CupertinoIcons.photo, size: 28, color: CupertinoColors.white),
                    );
                  },
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    item.country,
                    style: TextStyle(fontSize: 14, color: CupertinoColors.secondaryLabel),
                  ),
                  Text(
                    '${item.population} • ${item.subtitle}',
                    style: TextStyle(fontSize: 12, color: CupertinoColors.tertiaryLabel),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: onFavorite,
              child: Icon(
                isFavorite ? CupertinoIcons.heart_fill : CupertinoIcons.heart,
                color: isFavorite ? CupertinoColors.systemRed : CupertinoColors.systemGrey,
                size: 22,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CityDetailScreen extends StatelessWidget {
  final GalleryItem item;

  const CityDetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Text(item.title),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Hero(
                tag: 'city-${item.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: AspectRatio(
                    aspectRatio: 1,
                    child: Image.network(
                      item.imageUrl,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                item.color.resolveFrom(context),
                                item.color.resolveFrom(context).withOpacity(0.7),
                              ],
                            ),
                          ),
                          child: Icon(CupertinoIcons.photo, size: 80, color: CupertinoColors.white),
                        );
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(height: 32),
              Text(
                item.title,
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                item.country,
                style: TextStyle(fontSize: 20, color: CupertinoColors.secondaryLabel),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              Text(
                'Resolution: ${item.population}',
                style: TextStyle(fontSize: 16, color: CupertinoColors.tertiaryLabel),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 24),
              Text(
                item.subtitle,
                style: TextStyle(fontSize: 18),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}