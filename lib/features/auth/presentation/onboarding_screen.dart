import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: 'Real-time Monitoring',
      description: 'Track your network base stations and infrastructure in real-time with high precision.',
      lottieUrl: 'https://lottie.host/5c8c5c7d-3d44-4f81-a3f1-7c0937583683/FvUqN4y3l1.json',
      imageUrl: 'assets/images/christopher-1sT46mkjAo0-unsplash.jpg',
      fallbackIcon: Icons.settings_remote,
    ),
    OnboardingData(
      title: 'AI Predictions',
      description: 'Leverage machine learning to predict potential faults before they occur.',
      lottieUrl: 'https://lottie.host/9e4d0b13-0931-424a-8d3f-5d0b49f99e32/7wD6C6YyXv.json',
      imageUrl: 'assets/images/denny-muller-JyRTi3LoQnc-unsplash.jpg',
      fallbackIcon: Icons.psychology,
    ),
    OnboardingData(
      title: 'Seamless Maintenance',
      description: 'Automatically generate maintenance tickets and track technician progress.',
      lottieUrl: 'https://lottie.host/0a1a5472-3532-4d2a-a9a3-5c0245a44302/O2hGq4R9jW.json',
      imageUrl: 'assets/images/kabiur-rahman-riyad-j8B2SuM4UlE-unsplash.jpg',
      fallbackIcon: Icons.build_circle,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (int page) {
              setState(() {
                _currentPage = page;
              });
            },
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Stack(
                children: [
                  // High-quality background image with gradient overlay
                  Positioned.fill(
                    child: Image.asset(
                      page.imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: 0.1),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(40.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Spacer(),
                        Lottie.network(
                          page.lottieUrl,
                          height: 200,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(
                              page.fallbackIcon,
                              size: 100,
                              color: Colors.white.withValues(alpha: 0.5),
                            );
                          },
                        ),
                        const SizedBox(height: 40),
                        Text(
                          page.title,
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          page.description,
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withValues(alpha: 0.8),
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 120), // Space for button
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => _buildDot(index),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_currentPage == _pages.length - 1) {
                          context.go('/login');
                        } else {
                          _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        }
                      },
                      child: Text(
                        _currentPage == _pages.length - 1 ? 'Get Started' : 'Next',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDot(int index) {
    return Container(
      height: 10,
      width: _currentPage == index ? 25 : 10,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: _currentPage == index ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String lottieUrl;
  final String imageUrl;
  final IconData fallbackIcon;

  OnboardingData({
    required this.title,
    required this.description,
    required this.lottieUrl,
    required this.imageUrl,
    required this.fallbackIcon,
  });
}
