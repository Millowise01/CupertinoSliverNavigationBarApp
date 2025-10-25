# Photo Gallery - CupertinoSliverNavigationBar Demo

A beautiful iOS-style photo gallery app showcasing the CupertinoSliverNavigationBar widget with smooth scrolling animations and responsive design.

## Features

### CupertinoSliverNavigationBar Properties

- **largeTitle**: "Photo Gallery" - Displays large title that smoothly collapses when scrolling
- **backgroundColor**: Clean system background with subtle border
- **trailing**: Grid/List view toggle button for different viewing modes

### Enhanced Features

- **10 Curated Photos**: High-quality images with accurate descriptions
- **Responsive Grid**: Adapts from 2-5 columns based on screen width
- **Grid/List Toggle**: Switch between grid and list viewing modes
- **Search Functionality**: Search photos by title or category
- **Favorites System**: Heart icon to save favorite photos
- **Smooth Animations**: Fade and slide transitions for cards
- **Hero Transitions**: Seamless image transitions between screens
- **Haptic Feedback**: Touch responses for better user experience
- **No Debug Banner**: Clean production appearance

### Photo Collection

1. **Mountain Vista** - Breathtaking mountain landscape (Nature, 4K)
2. **City Lights** - Urban night photography (Urban, 8K)
3. **Ocean Waves** - Powerful ocean waves (Seascape, HD)
4. **Forest Path** - Peaceful forest trail (Forest, 2K)
5. **Desert Sunset** - Golden desert sunset (Desert, 5K)
6. **Urban Street** - Vibrant street scene (Street, Ultra HD)
7. **Flower Garden** - Colorful garden blooms (Macro, Full HD)
8. **Snowy Peak** - Majestic snowy peak (Winter, 6K)
9. **Beach Paradise** - Pristine tropical beach (Beach, 3K)
10. **Autumn Leaves** - Beautiful autumn foliage (Seasonal, QHD)

## Run Instructions

1. Ensure Flutter is installed on your system
2. Navigate to the project directory
3. Run `flutter pub get` to install dependencies
4. Run `flutter run -d chrome` to start the web app
5. Or run `flutter run -d windows` for desktop app

## Technical Implementation

- **Framework**: Flutter with Cupertino design system
- **Responsive Design**: MediaQuery-based adaptive layouts
- **Image Source**: Curated Unsplash photos with specific IDs
- **Animations**: Custom AnimationController with staggered effects
- **State Management**: StatefulWidget with local state
- **Navigation**: CupertinoPageRoute with hero animations

## Project Structure

lib/
├── main.dart              # Main app with gallery implementation
test/
├── widget_test.dart       # Widget tests
web/
├── index.html            # Web entry point
├── manifest.json         # Web app manifest
└── icons/                # App icons

## Screenshots

The app features a clean, iOS-style interface with:

- Collapsible navigation bar with large title
- Responsive photo grid that adapts to screen size
- Smooth animations and transitions
- Beautiful photo cards with favorites functionality
- Detailed photo view with hero animations

![Alt Text](Image URL )

## Development

This project demonstrates advanced Flutter concepts including:

- Custom scroll views with slivers
- Responsive design patterns
- Animation controllers and transitions
- Hero animations
- Cupertino design system
- State management
- Image handling and error states
