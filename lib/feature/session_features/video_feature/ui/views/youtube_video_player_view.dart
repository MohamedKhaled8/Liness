import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class YoutubePlayerView extends StatefulWidget {
  final String videoId;
  final bool autoPlay;
  final bool mute;
  final Function(double currentTime, double duration)? onVideoProgress;

  const YoutubePlayerView({
    Key? key,
    required this.videoId,
    this.autoPlay = true,
    this.mute = false,
    this.onVideoProgress,
  }) : super(key: key);

  @override
  State<YoutubePlayerView> createState() => _YoutubePlayerViewState();
}

class _YoutubePlayerViewState extends State<YoutubePlayerView> {
  bool preventTap = false;
  String url = '';
  InAppWebViewController? _controller;

  @override
  void initState() {
    super.initState();
    // Build YouTube embed URL - simplified for better compatibility
    // Works with all video types: unlisted, private, and public videos
    final params = <String, String>{
      'autoplay': widget.autoPlay ? '1' : '0',
      'mute': widget.mute ? '1' : '0',
      'controls': '1',
      'rel': '0',
      'modestbranding': '1',
      'playsinline': '1',
      'enablejsapi': '1',
      'iv_load_policy': '3',
      'fs': '1',
      'cc_load_policy': '0',
      'origin': 'https://www.youtube.com',
    };

    final queryString = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    // Use youtube-nocookie.com for better compatibility, especially for unlisted videos
    url =
        'https://www.youtube-nocookie.com/embed/${widget.videoId}?$queryString';

    // Debug: print URL to verify it's correct (uncomment for debugging)
    debugPrint('YouTube Embed URL: $url');
  }

  @override
  Widget build(BuildContext context) {
    return AbsorbPointer(
      absorbing: preventTap,
      child: Container(
        color: Colors.black, // Black background for video player
        child: SizedBox(
          width: double.infinity,
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: WebUri(url),
                headers: {'Referrer-Policy': 'strict-origin-when-cross-origin'},
              ),
              gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
                Factory<OneSequenceGestureRecognizer>(
                  () => EagerGestureRecognizer(),
                ),
              },
              initialSettings: InAppWebViewSettings(
                useShouldOverrideUrlLoading: true,
                mediaPlaybackRequiresUserGesture: false,
                javaScriptEnabled: true,
                allowsInlineMediaPlayback: true,
                iframeAllowFullscreen: true,
                allowsBackForwardNavigationGestures: false,
                supportZoom: false,
                userAgent:
                    "Mozilla/5.0 (Linux; Android 13; SM-G991B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Mobile Safari/537.36",
                transparentBackground:
                    false, // Fixed: false to prevent black screen
                disableHorizontalScroll: false,
                disableVerticalScroll: false,
                allowsLinkPreview: false,
                javaScriptCanOpenWindowsAutomatically: false,
                useHybridComposition: true,
                cacheEnabled: true,
                thirdPartyCookiesEnabled: true,
                mixedContentMode: MixedContentMode.MIXED_CONTENT_ALWAYS_ALLOW,
                // Add referrer policy to fix Error 153
                sharedCookiesEnabled: true,
                databaseEnabled: true,
                domStorageEnabled: true,
                // Network and performance optimizations
                networkAvailable: true,
                loadsImagesAutomatically: true,
                blockNetworkImage: false,
                blockNetworkLoads: false,
                // Reduce logging overhead
                clearSessionCache: false,
                // Hardware acceleration (already set in manifest)
                hardwareAcceleration: true,
              ),
              shouldOverrideUrlLoading: (controller, navigationAction) async {
                // Always allow all navigation for YouTube embed to work properly
                // This is critical for unlisted videos to load
                return NavigationActionPolicy.ALLOW;
              },
              onWebViewCreated: (controller) async {
                _controller = controller;

                // Add progress tracking handler
                controller.addJavaScriptHandler(
                  handlerName: 'videoProgress',
                  callback: (args) {
                    if (args.length >= 2 && widget.onVideoProgress != null) {
                      try {
                        final double currentTime = double.parse(args[0].toString());
                        final double duration = double.parse(args[1].toString());
                        widget.onVideoProgress!(currentTime, duration);
                      } catch (e) {
                        debugPrint('Error parsing video progress: $e');
                      }
                    }
                  },
                );

                // Don't inject JavaScript immediately - wait for page to load first
                // This prevents blocking YouTube's own scripts
              },
              onLoadStart: (controller, url) async {
                debugPrint('YouTube WebView loading: ${url?.toString()}');
                // Minimal intervention - let YouTube load normally
                // We'll inject cleanup scripts after page fully loads
              },
              onLoadStop: (controller, uri) async {
                try {
                  debugPrint('YouTube onLoadStop - URL: ${uri?.toString()}');

                  // Wait for YouTube player to fully initialize (critical for unlisted videos)
                  await Future.delayed(const Duration(milliseconds: 1500));

                  // CRITICAL: First check if iframe exists and force it to load
                  final iframeCheck = await controller.evaluateJavascript(
                    source: """
                  (function() {
                    console.log('=== YouTube Player Setup Started ===');
                    
                    // Log document state
                    console.log('Document ready state: ' + document.readyState);
                    console.log('Body exists: ' + (document.body !== null));
                    console.log('Document title: ' + document.title);
                    
                    // Find all iframes
                    var allIframes = document.querySelectorAll('iframe');
                    console.log('Total iframes found: ' + allIframes.length);
                    
                    // Ensure body and html are properly styled
                    if (document.body) {
                      document.body.style.backgroundColor = '#000000';
                      document.body.style.margin = '0';
                      document.body.style.padding = '0';
                      document.body.style.overflow = 'auto';
                      document.body.style.width = '100%';
                      document.body.style.height = '100%';
                    }
                    if (document.documentElement) {
                      document.documentElement.style.backgroundColor = '#000000';
                      document.documentElement.style.margin = '0';
                      document.documentElement.style.padding = '0';
                      document.documentElement.style.overflow = 'auto';
                      document.documentElement.style.width = '100%';
                      document.documentElement.style.height = '100%';
                    }
                    
                    // Function to setup iframes and player - CRITICAL for video playback
                    function setupIframes() {
                      var iframes = document.querySelectorAll('iframe');
                      var playerDiv = document.querySelector('#player, .ytp-player, .html5-video-player, [id*="player"], [class*="player"]');
                      
                      console.log('setupIframes called - found ' + iframes.length + ' iframes, player div: ' + (playerDiv ? 'yes' : 'no'));
                      
                      // Setup all iframes
                      iframes.forEach(function(iframe, index) {
                        console.log('Processing iframe ' + index + ', src: ' + iframe.src);
                        
                        if (iframe.src && (iframe.src.includes('youtube.com') || iframe.src.includes('googlevideo.com'))) {
                          console.log('Found YouTube/Google iframe!');
                          
                          // Essential attributes for video playback
                          iframe.setAttribute('allowfullscreen', 'true');
                          iframe.setAttribute('allow', 'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share');
                          iframe.setAttribute('frameborder', '0');
                          iframe.setAttribute('scrolling', 'auto');
                          
                          // Critical styling for iframe visibility - MUST be absolute positioned
                          iframe.style.cssText = 'width: 100% !important; height: 100% !important; border: none !important; display: block !important; position: absolute !important; top: 0 !important; left: 0 !important; z-index: 1 !important; pointer-events: auto !important; visibility: visible !important; opacity: 1 !important; background: transparent !important;';
                          
                          console.log('Iframe styled successfully');
                        }
                      });
                      
                      // Setup player div if exists
                      if (playerDiv) {
                        playerDiv.style.width = '100%';
                        playerDiv.style.height = '100%';
                        playerDiv.style.position = 'absolute';
                        playerDiv.style.top = '0';
                        playerDiv.style.left = '0';
                        playerDiv.style.zIndex = '1';
                        playerDiv.style.display = 'block';
                        playerDiv.style.visibility = 'visible';
                        playerDiv.style.opacity = '1';
                        console.log('Player div styled successfully');
                      }
                      
                      // Also check for embed container and make it full screen
                      var embedContainer = document.querySelector('body > iframe, body > div > iframe, #player, #player-container, .embed-container');
                      if (embedContainer) {
                        embedContainer.style.width = '100%';
                        embedContainer.style.height = '100%';
                        embedContainer.style.position = 'relative';
                        embedContainer.style.overflow = 'hidden';
                        console.log('Embed container found and styled');
                      }
                      
                      // Make sure body shows everything
                      if (document.body) {
                        document.body.style.overflow = 'auto';
                        document.body.style.position = 'relative';
                      }
                      
                      return { iframeCount: iframes.length, hasPlayerDiv: playerDiv !== null };
                    }
                    
                    // Setup immediately
                    var result = setupIframes();
                    console.log('Initial setup complete, iframes: ' + result.iframeCount + ', player div: ' + result.hasPlayerDiv);
                    
                    // Multiple retries to ensure iframe loads (important for unlisted videos)
                    setTimeout(function() {
                      console.log('Retry 1: setupIframes');
                      setupIframes();
                    }, 500);
                    setTimeout(function() {
                      console.log('Retry 2: setupIframes');
                      setupIframes();
                    }, 1000);
                    setTimeout(function() {
                      console.log('Retry 3: setupIframes');
                      setupIframes();
                    }, 2000);
                    setTimeout(function() {
                      console.log('Retry 4: setupIframes');
                      setupIframes();
                    }, 3000);
                    
                    // Continuous monitoring for dynamically added iframes
                    var observer = new MutationObserver(function(mutations) {
                      console.log('MutationObserver triggered');
                      setupIframes();
                    });
                    
                    if (document.body) {
                      observer.observe(document.body, {
                        childList: true,
                        subtree: true,
                        attributes: true,
                        attributeFilter: ['style', 'class', 'src']
                      });
                      console.log('MutationObserver attached to body');
                    }
                    if (document.documentElement) {
                      observer.observe(document.documentElement, {
                        childList: true,
                        subtree: true
                      });
                      console.log('MutationObserver attached to documentElement');
                    }
                    
                    console.log('=== YouTube Player Setup Complete ===');
                    return { success: true, iframeCount: result.iframeCount, hasPlayerDiv: result.hasPlayerDiv };
                  })();
                  """,
                  );

                  debugPrint('Iframe check result: $iframeCheck');

                  // Additional check: Try to find and click play button if video didn't start
                  await Future.delayed(const Duration(milliseconds: 2000));

                  await controller.evaluateJavascript(
                    source: """
                    (function() {
                      console.log('=== Attempting to start video playback ===');
                      
                      // Try to find and click play button
                      var playButton = document.querySelector('.ytp-large-play-button, .ytp-play-button, button[aria-label*="Play"], button[title*="Play"]');
                      if (playButton) {
                        console.log('Found play button, clicking...');
                        playButton.click();
                      } else {
                        console.log('No play button found');
                      }
                      
                      // Try to trigger play via iframe
                      var iframes = document.querySelectorAll('iframe[src*="youtube.com"]');
                      iframes.forEach(function(iframe) {
                        try {
                          // Try to send play command to iframe
                          if (iframe.contentWindow) {
                            console.log('Iframe contentWindow exists');
                          }
                        } catch(e) {
                          console.log('Cannot access iframe contentWindow (cross-origin): ' + e);
                        }
                      });
                      
                      // Force visibility one more time
                      var allIframes = document.querySelectorAll('iframe');
                      allIframes.forEach(function(iframe) {
                        if (iframe.src && iframe.src.includes('youtube.com')) {
                          iframe.style.cssText = 'width: 100% !important; height: 100% !important; border: none !important; display: block !important; position: absolute !important; top: 0 !important; left: 0 !important; z-index: 9999 !important; pointer-events: auto !important; visibility: visible !important; opacity: 1 !important; background: transparent !important;';
                        }
                      });
                      
                      console.log('=== Video playback attempt complete ===');
                    })();
              """,
                  );

                  // Wait a bit more before injecting cleanup scripts
                  await Future.delayed(const Duration(milliseconds: 1000));

                  // Inject cleanup scripts (after ensuring video loads)
                  await _injectAdvancedCSS(controller);
                  await _setupSecurityMeasures(controller);
                  await _executeEnhancedCleanup(controller);
                  await _setupContinuousMonitoring(controller);

                  // Allow user interaction
                  if (mounted) {
                    setState(() => preventTap = false);
                  }

                  debugPrint('YouTube player setup complete');
                } catch (e, stackTrace) {
                  debugPrint('Error in onLoadStop: $e');
                  debugPrint('Stack trace: $stackTrace');
                  // Always allow interaction even if scripts fail
                  if (mounted) {
                    setState(() => preventTap = false);
                  }
                }
              },
              onReceivedError: (controller, request, error) async {
                debugPrint('YouTube WebView Error: ${error.description}');
                debugPrint('Failed URL: ${request.url}');
                // Retry cleanup on error
                if (_controller != null) {
                  try {
                    await _executeEnhancedCleanup(_controller!);
                  } catch (e) {
                    debugPrint('Cleanup error: $e');
                  }
                }
              },
              onReceivedHttpError: (controller, request, response) async {
                debugPrint(
                  'YouTube HTTP Error: ${response.statusCode} - ${response.reasonPhrase}',
                );
                debugPrint('Failed URL: ${request.url}');
                // Allow the page to continue loading even with HTTP errors
              },
              onConsoleMessage: (controller, consoleMessage) {
                debugPrint(
                  'YouTube Console [${consoleMessage.messageLevel}]: ${consoleMessage.message}',
                );
              },
              onProgressChanged: (controller, progress) {
                debugPrint('YouTube Progress: $progress%');
              },
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _injectAdvancedCSS(InAppWebViewController controller) async {
    await controller.evaluateJavascript(
      source: """
      // Disable console logs for unlisted videos
      if (typeof console !== 'undefined') {
        console.log = function() {};
        console.debug = function() {};
        console.info = function() {};
        console.warn = function() {};
        console.error = function() {};
      }
      
      var advancedStyle = document.createElement('style');
      advancedStyle.id = 'youtube-cleaner-css';
      advancedStyle.textContent = `
        /* Hide YouTube branding and share buttons - works with ALL video types (unlisted, private, public) */
        .ytp-share-button,
        .ytp-copy-url-button,
        .ytp-copy-link-button,
        .ytp-copylink-button,
        .ytp-branding-logo,
        .ytp-watermark,
        .ytp-watermark-logo,
        [aria-label*="Share"],
        [aria-label*="share"],
        [title*="Share"],
        [title*="share"],
        [data-tooltip-text*="Share"],
        [data-tooltip-text*="share"],
        [aria-label*="Copy"],
        [aria-label*="copy"],
        [title*="Copy"],
        [title*="copy"],
        [data-tooltip-text*="Copy"],
        [data-tooltip-text*="copy"],
        [aria-label*="YouTube"],
        .yt-uix-button-icon.yt-uix-button-icon-share,
        button[aria-label*="Share"],
        button[title*="Share"] {
          display: none !important;
          visibility: hidden !important;
          opacity: 0 !important;
          width: 0 !important;
          height: 0 !important;
          pointer-events: none !important;
        }

        /* Ensure core controls remain visible */
        .ytp-settings-button,
        .ytp-chrome-bottom,
        .ytp-chrome-controls,
        .ytp-left-controls,
        .ytp-right-controls,
        .ytp-play-button,
        .ytp-pause-button,
        .ytp-mute-button,
        .ytp-volume-slider,
        .ytp-progress-bar-container,
        .ytp-fullscreen-button,
        .ytp-size-button {
          display: flex !important;
          visibility: visible !important;
          opacity: 1 !important;
          pointer-events: auto !important;
        }
      `;
      document.head.appendChild(advancedStyle);

      // Force settings and controls visibility
      const ensureControlsVisible = () => {
        const controls = document.querySelector('.ytp-chrome-bottom');
        const settingsBtn = document.querySelector('.ytp-settings-button');
        if (controls) {
          controls.style.display = 'flex';
          controls.style.visibility = 'visible';
          controls.style.opacity = '1';
          controls.style.pointerEvents = 'auto';
        }
        if (settingsBtn) {
          settingsBtn.style.display = 'flex';
          settingsBtn.style.visibility = 'visible';
          settingsBtn.style.opacity = '1';
          settingsBtn.style.pointerEvents = 'auto';
        }
      };
      ensureControlsVisible();
      setTimeout(ensureControlsVisible, 200);
      setTimeout(ensureControlsVisible, 800);
      """,
    );
  }

  Future<void> _setupSecurityMeasures(InAppWebViewController controller) async {
    await controller.evaluateJavascript(
      source: """
      // Block external navigation attempts
      window.addEventListener('beforeunload', function(e) {
        e.preventDefault();
        return false;
      });
      
      // Override window.open to prevent popups
      window.open = function() { return null; };
      
      // Block context menu
      document.addEventListener('contextmenu', function(e) {
        e.preventDefault();
        return false;
      });
      
      // Block right-click
      document.addEventListener('mousedown', function(e) {
        if (e.button === 2) {
          e.preventDefault();
          return false;
        }
      });
      
      // Block keyboard shortcuts
      document.addEventListener('keydown', function(e) {
        // Block Ctrl+S, Ctrl+A, F12, etc.
        if ((e.ctrlKey && (e.key === 's' || e.key === 'a' || e.key === 'u')) || 
            e.key === 'F12' || 
            (e.ctrlKey && e.shiftKey && e.key === 'I')) {
          e.preventDefault();
          return false;
        }
      });
      """,
    );
  }

  Future<void> _executeEnhancedCleanup(
    InAppWebViewController controller,
  ) async {
    await controller.evaluateJavascript(
      source: """
      // ENHANCED CLEANUP SYSTEM - Works with ALL video types (unlisted, private, public)
      // Disable console logs for cleaner experience
      if (typeof console !== 'undefined') {
        console.log = function() {};
        console.debug = function() {};
        console.info = function() {};
        console.warn = function() {};
        console.error = function() {};
      }
      
      function executeAdvancedCleanup() {
        const startTime = performance.now();
        
        // AGGRESSIVE SELECTOR ARRAY - Hides YouTube branding (works with all video types)
        const ELIMINATION_SELECTORS = [
          '.ytp-share-button',
          '.ytp-copy-url-button',
          '.ytp-copy-link-button',
          '.ytp-copylink-button',
          '.ytp-branding-logo',
          '.ytp-watermark',
          '.ytp-watermark-logo',
          '[aria-label*="Share"]', '[aria-label*="share"]', '[title*="Share"]', '[title*="share"]',
          '[data-tooltip-text*="Share"]', '[data-tooltip-text*="share"]',
          '[aria-label*="Copy"]', '[aria-label*="copy"]', '[title*="Copy"]', '[title*="copy"]',
          '[data-tooltip-text*="Copy"]', '[data-tooltip-text*="copy"]',
          '[aria-label*="YouTube"]',
          '.yt-uix-button-icon.yt-uix-button-icon-share',
          'button[aria-label*="Share"]',
          'button[title*="Share"]'
        ];
        
        // Execute removal with multiple strategies
        let removedCount = 0;
        
        ELIMINATION_SELECTORS.forEach(selector => {
          try {
            const elements = document.querySelectorAll(selector);
            elements.forEach(el => {
              if (el && el.parentNode) {
                // Multi-method removal
                el.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important; width: 0 !important; height: 0 !important; position: absolute !important; left: -9999px !important; top: -9999px !important; z-index: -1 !important; pointer-events: none !important;';
                el.remove();
                removedCount++;
              }
            });
          } catch (e) {
            
          }
        });
        
        // TEXT-BASED CLEANUP
        const textPatterns = [/share/i, /مشاركة/i, /copy/i, /نسخ/i];
        
        document.querySelectorAll('.ytp-button, .ytp-menuitem, button, a').forEach(element => {
          const text = (element.textContent || '').trim();
          const ariaLabel = element.getAttribute('aria-label') || '';
          const title = element.getAttribute('title') || '';
          const tooltip = element.getAttribute('data-tooltip-text') || '';
          
          const allText = (text + ' ' + ariaLabel + ' ' + title + ' ' + tooltip).toLowerCase();
          
          if (textPatterns.some(pattern => pattern.test(allText))) {
            // Verified unwanted element - eliminate
            element.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important; width: 0 !important; height: 0 !important; position: absolute !important; left: -9999px !important; pointer-events: none !important;';
            if (element.parentNode) {
              element.remove();
              removedCount++;
            }
          }
        });
        
        // SVG-BASED CLEANUP (for icon-only buttons)
        document.querySelectorAll('.ytp-button').forEach(button => {
          const svg = button.querySelector('svg');
          if (svg && svg.getAttribute('viewBox') === '0 0 24 24') {
            // Check if it's NOT a control we want to keep
            const allowedControls = [
              'play', 'pause', 'volume', 'mute', 'unmute', 
              'fullscreen', 'settings', 'speed', 'quality'
            ];
            
            const isAllowed = allowedControls.some(control => 
              button.getAttribute('aria-label')?.toLowerCase().includes(control) ||
              button.className.includes(control)
            );
            
            if (!isAllowed) {
              button.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important;';
              button.remove();
              removedCount++;
            }
          }
        });
        
        // Do not remove watermark or chrome bars to avoid impacting settings UI
        
        // Dynamic endscreen/suggestion/upnext/replay removal
        document.querySelectorAll('[id*="endscreen"], [class*="endscreen"], [id*="suggestion"], [class*="suggestion"], [id*="upnext"], [class*="upnext"], [id*="replay"], [class*="replay"]').forEach(el => {
          el.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important; width: 0 !important; height: 0 !important; position: absolute !important; left: -9999px !important; top: -9999px !important; z-index: -1 !important; pointer-events: none !important;';
          if (el.parentNode) el.remove();
        });

        // Remove by text content
        document.querySelectorAll('div, span, button, a').forEach(el => {
          const txt = (el.textContent || '').toLowerCase();
          if (txt.includes('up next') || txt.includes('suggested') || txt.includes('replay') || txt.includes('تشغيل التالي') || txt.includes('اقتراحات') || txt.includes('إعادة')) {
            el.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important; width: 0 !important; height: 0 !important; position: absolute !important; left: -9999px !important; top: -9999px !important; z-index: -1 !important; pointer-events: none !important;';
            if (el.parentNode) el.remove();
          }
        });

        // Target only Debug log inside settings
        document.querySelectorAll('.ytp-settings-menu .ytp-menuitem, .ytp-popup.ytp-settings-menu .ytp-menuitem').forEach(item => {
          const label = (item.getAttribute('aria-label') || '').toLowerCase();
          const text = (item.textContent || '').toLowerCase();
          if (label.includes('debug') || text.includes('debug')) {
            item.style.cssText = 'display: none !important; visibility: hidden !important; opacity: 0 !important; width: 0 !important; height: 0 !important; position: absolute !important; left: -9999px !important; top: -9999px !important; z-index: -1 !important; pointer-events: none !important;';
            if (item.parentNode) item.remove();
          }
        });
        
        const endTime = performance.now();
        
        return removedCount;
      }
      
      // Initial cleanup
      executeAdvancedCleanup();
      
      """,
    );
  }

  Future<void> _setupContinuousMonitoring(
    InAppWebViewController controller,
  ) async {
    await controller.evaluateJavascript(
      source: """
      // CONTINUOUS MONITORING SYSTEM
      let cleanupCount = 0;
      let lastCleanupTime = Date.now();
      
      // High-frequency mutation observer
      const aggressiveObserver = new MutationObserver((mutations) => {
        let needsCleanup = false;
        
        mutations.forEach((mutation) => {
          if (mutation.type === 'childList') {
            mutation.addedNodes.forEach(node => {
              if (node.nodeType === 1) { // Element node
                const element = node;
                
                // Check if new element matches unwanted patterns
                const classList = element.className || '';
                const ariaLabel = element.getAttribute('aria-label') || '';
                
                if (classList.includes('ytp-share') || 
                    ariaLabel.toLowerCase().includes('share') ||
                    ariaLabel.toLowerCase().includes('copy')) {
                  needsCleanup = true;
                }
              }
            });
          }
          
          if (mutation.type === 'attributes') {
            const element = mutation.target;
            if (element.getAttribute('aria-label')?.toLowerCase().includes('share') ||
                element.getAttribute('aria-label')?.toLowerCase().includes('copy')) {
              needsCleanup = true;
            }
          }
        });
        
        if (needsCleanup) {
          executeAdvancedCleanup();
        }
      });
      
      // Observer configuration
      const observerConfig = {
        childList: true,
        subtree: true,
        attributes: true,
        attributeFilter: ['aria-label', 'title', 'data-tooltip-text', 'class']
      };
      
      // Start observing
      aggressiveObserver.observe(document.body, observerConfig);
      
      // Interval-based cleanup (backup system)
      setInterval(() => {
        const now = Date.now();
        if (now - lastCleanupTime > 2000) { // Every 2 seconds
          const removed = executeAdvancedCleanup();
          
          lastCleanupTime = now;
        }
      }, 2000);
      
      // Event-based cleanup triggers
      ['click', 'mouseover', 'focus', 'keydown'].forEach(eventType => {
        document.addEventListener(eventType, () => {
          setTimeout(() => {
            executeAdvancedCleanup();
          }, 100);
        }, true);
      });

      // Video Progress tracking
      setInterval(() => {
        try {
          const video = document.querySelector('video.html5-main-video') || document.querySelector('video');
          if (video && !video.paused && window.flutter_inappwebview) {
             const currentTime = video.currentTime;
             const duration = video.duration;
             if (duration > 0) {
               window.flutter_inappwebview.callHandler('videoProgress', currentTime, duration);
             }
          }
        } catch (e) {
           console.log('Error reporting progress: ' + e);
        }
      }, 5000);
      
      // 🔥 ENHANCED SETTINGS MENU MONITORING - MORE OPTIONS REMOVAL
      const settingsMenuObserver = new MutationObserver(() => {
        // keep settings menu intact; do nothing
      });
      
      // Watch for settings button clicks
      const settingsButton = document.querySelector('.ytp-settings-button');
      if (settingsButton) {
        settingsButton.addEventListener('click', () => {
          setTimeout(() => {
            const settingsMenu = document.querySelector('.ytp-settings-menu, .ytp-popup.ytp-settings-menu');
            if (settingsMenu) {
              settingsMenuObserver.observe(settingsMenu, {
                childList: true,
                subtree: true,
                attributes: true,
                attributeFilter: ['aria-label', 'title', 'data-tooltip-text']
              });
              
              // keep settings items visible
            }
          }, 50);
        });
      }
      
      // Document-wide observer for settings menu appearance
      const documentObserver = new MutationObserver(() => { /* keep settings intact */ });
      
      documentObserver.observe(document.body, {
        childList: true,
        subtree: true
      });
      
      // Final cleanup executions
      setTimeout(() => executeAdvancedCleanup(), 500);
      setTimeout(() => executeAdvancedCleanup(), 1000);
      setTimeout(() => executeAdvancedCleanup(), 2000);
      setTimeout(() => executeAdvancedCleanup(), 5000);
      
      """,
    );
  }

  @override
  void dispose() {
    _controller?.clearCache();
    super.dispose();
  }
}
