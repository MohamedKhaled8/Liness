import 'dart:collection';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class VimeoPlayerView extends StatefulWidget {
  final String vimeoId;
  final bool autoPlay;
  final bool mute;

  const VimeoPlayerView({
    super.key,
    required this.vimeoId,
    this.autoPlay = false,
    this.mute = false,
  });

  @override
  State<VimeoPlayerView> createState() => _VimeoPlayerViewState();
}

class _VimeoPlayerViewState extends State<VimeoPlayerView> {
  String url = '';

  @override
  void initState() {
    url =
        "https://player.vimeo.com/video/${widget.vimeoId}?autoplay=${widget.autoPlay ? 1 : 0}&loop=0&dnt=1&controls=1&title=0&byline=0&portrait=0";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: InAppWebView(
        initialUrlRequest: URLRequest(
          url: WebUri(url),
          headers: {
            'User-Agent':
                'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/131.0.0.0 Safari/537.36',
          },
        ),
        initialUserScripts: UnmodifiableListView<UserScript>([
          UserScript(
            source: """
                (function() {
                  const css = `
                    .vp-share, .vp-like, .vp-watch-later, .vp-sidebar, 
                    .vp-action-buttons, .vp-video-header,
                    .vp-portrait, .avatar, .vp-byline, .vp-title, .vp-header,
                    .vp-side-buttons, .vp-actions,
                    [aria-label*="Share" i], [aria-label*="Like" i], [aria-label*="Watch later" i],
                    [aria-label*="Vimeo" i], .vp-logo, .vimeo-logo, .vp-watermark,
                    [aria-label*="more" i], [aria-label*="overflow" i], [data-testid*="more" i], [data-testid*="overflow" i] { 
                      display: none !important; 
                      visibility: hidden !important; 
                      opacity: 0 !important; 
                      pointer-events: none !important; 
                    }
                  `;
                  const style = document.createElement('style');
                  style.textContent = css;
                  document.head.appendChild(style);
                  
                  const hardHideInsecure = () => {
                    const selectors = [
                      '.vp-share', '.vp-like', '.vp-watch-later', '.vp-sidebar',
                      '.vp-side-buttons', '.vp-actions', '.vp-contextmenu',
                      '[aria-label*="Share" i]',
                      '[aria-label*="Like" i]', '[aria-label*="Watch later" i]',
                      '[data-testid*="share" i]', '[data-testid*="like" i]',
                      '[data-testid*="watch-later" i]',
                      '[aria-label*="more" i]', '[aria-label*="overflow" i]',
                      '[data-testid*="more" i]', '[data-testid*="overflow" i]'
                    ];
                    selectors.forEach(s => {
                      document.querySelectorAll(s).forEach(el => {
                        el.style.setProperty('display', 'none', 'important');
                        el.style.setProperty('pointer-events', 'none', 'important');
                        el.style.setProperty('visibility', 'hidden', 'important');
                      });
                    });

                    // Hide context menu items that can leak information
                    const sensitiveTexts = [
                      'copy link',
                      'copy embed code',
                      'screenshot',
                      'view in vimeo',
                      'open debug panel',
                      'copy debug info',
                      'view keyboard shortcuts',
                      'debug log'
                    ];

                    const allMenuItems = document.querySelectorAll(
                      '.vp-menu__item, .vp-settings__row, li, button, [role="menuitem"], .vp-contextmenu__item'
                    );
                    allMenuItems.forEach(el => {
                      const txt = (el.textContent || '').toLowerCase();
                      if (sensitiveTexts.some(t => txt.includes(t))) {
                        el.style.setProperty('display', 'none', 'important');
                        el.style.setProperty('pointer-events', 'none', 'important');
                        el.style.setProperty('visibility', 'hidden', 'important');
                      }
                    });
                  };
                  
                  // Block right-click / long-press context menu completely
                  document.addEventListener('contextmenu', function(e) {
                    e.preventDefault();
                    e.stopPropagation();
                  }, { capture: true });

                  // Block common keyboard shortcuts that can open debug / shortcuts panels
                  document.addEventListener('keydown', function(e) {
                    const key = (e.key || '').toLowerCase();
                    if (
                      key === 'f12' ||
                      key === 'f8' ||
                      (key === 'i' && (e.ctrlKey || e.metaKey) && e.shiftKey) ||
                      (key === 'j' && (e.ctrlKey || e.metaKey) && e.shiftKey) ||
                      ((key === '?' || key === '/') && e.shiftKey)
                    ) {
                      e.preventDefault();
                      e.stopPropagation();
                    }
                  }, { capture: true });

                  hardHideInsecure();
                  setInterval(hardHideInsecure, 300);
                  
                  const observer = new MutationObserver(hardHideInsecure);
                  observer.observe(document.body, { childList: true, subtree: true });
                })();
              """,
            injectionTime: UserScriptInjectionTime.AT_DOCUMENT_START,
          ),
        ]),
        gestureRecognizers: <Factory<OneSequenceGestureRecognizer>>{
          Factory<OneSequenceGestureRecognizer>(
            () => EagerGestureRecognizer(),
          ),
        },
        initialSettings: InAppWebViewSettings(
          useShouldOverrideUrlLoading: true,
          mediaPlaybackRequiresUserGesture: false,
          useHybridComposition: true,
          javaScriptEnabled: true,
          allowsInlineMediaPlayback: true,
          iframeAllowFullscreen: true,
          allowsBackForwardNavigationGestures: false,
          supportZoom: false,
          transparentBackground: false,
          disableVerticalScroll: false,
          disableHorizontalScroll: false,
        ),
        shouldOverrideUrlLoading: (controller, navigationAction) async {
          final uri = navigationAction.request.url;
          if (uri == null) return NavigationActionPolicy.ALLOW;

          final host = uri.host.toLowerCase();
          final scheme = uri.scheme.toLowerCase();

          // Allow Vimeo domains and common asset schemes
          const allowedHosts = [
            'player.vimeo.com',
            'vimeo.com',
            'i.vimeocdn.com',
            'f.vimeocdn.com',
            'vod-progressive.akamaized.net',
          ];

          if (scheme == 'blob' || scheme == 'data' || scheme == 'about') {
            return NavigationActionPolicy.ALLOW;
          }

          if (allowedHosts.any((h) => host == h || host.endsWith('.' + h))) {
            return NavigationActionPolicy.ALLOW;
          }

          // Cancel external navigations
          return NavigationActionPolicy.CANCEL;
        },
        onWebViewCreated: (controller) {},
        onLoadStop: (controller, uri) async {
          await controller.evaluateJavascript(
            source: """
      function hideVimeoElements() {
        const selectors = [
          '.vp-share', '.vp-like', '.vp-watch-later', '.vp-sidebar', 
          '.vp-action-buttons', '.vp-video-header',
          '.vp-portrait', '.avatar', '.vp-byline', '.vp-title', '.vp-header',
          '.vp-side-buttons', '.vp-actions', '.vp-controls-video',
          '.vp-logo', '.vimeo-logo', '.vp-watermark', '.vp-logoContainer',
          '[aria-label*="Share" i]', '[aria-label*="Like" i]', '[aria-label*="Watch later" i]',
          '[aria-label*="Vimeo" i]', '[data-testid*="share" i]', '[data-testid*="like" i]',
          '[data-testid*="watch-later" i]', '.vp-preview-vimeo-logo',
          '[aria-label*="more" i]', '[aria-label*="overflow" i]',
          '.vp-contextmenu'
        ];

        selectors.forEach(selector => {
          document.querySelectorAll(selector).forEach(el => {
            el.style.setProperty('display', 'none', 'important');
            el.style.setProperty('visibility', 'hidden', 'important');
            el.style.setProperty('opacity', '0', 'important');
            el.style.setProperty('pointer-events', 'none', 'important');
          });
        });

        // Hide words containing 'debug log'
        const allElements = document.querySelectorAll('*');
        for (let el of allElements) {
          if (el.children.length === 0 && el.textContent.toLowerCase().includes('debug log')) {
            const row = el.closest('.vp-menu__item, .vp-settings__row, li, button, [role="menuitem"], .vp-contextmenu__item');
            if (row) {
              row.style.setProperty('display', 'none', 'important');
              row.style.setProperty('pointer-events', 'none', 'important');
              row.style.setProperty('visibility', 'hidden', 'important');
            }
          }
        }

        // Block context menus entirely so the user can't see Vimeo debug/share options
        document.addEventListener('contextmenu', function(e) {
          e.preventDefault();
          e.stopPropagation();
        }, { capture: true });

        // Also hide any remaining context menu container that may have been created
        document.querySelectorAll('.vp-contextmenu, [role="menu"][data-contextmenu], .context-menu').forEach(el => {
          el.style.setProperty('display', 'none', 'important');
          el.style.setProperty('pointer-events', 'none', 'important');
          el.style.setProperty('visibility', 'hidden', 'important');
        });
      }

      const observer = new MutationObserver(hideVimeoElements);
      observer.observe(document.body, { childList: true, subtree: true, attributes: true });
      
      hideVimeoElements();
      setInterval(hideVimeoElements, 200);

      const style = document.createElement('style');
      style.textContent = `
        .vp-share, .vp-like, .vp-watch-later, .vp-sidebar, 
        .vp-action-buttons, .vp-video-header,
        .vp-portrait, .avatar, .vp-byline, .vp-title, .vp-header,
        .vp-side-buttons, .vp-actions,
        [aria-label*="Share" i], [aria-label*="Like" i], [aria-label*="Watch later" i],
        [aria-label*="Vimeo" i], .vp-logo, .vimeo-logo, .vp-watermark,
        [aria-label*="more" i], [aria-label*="overflow" i], [data-testid*="more" i], [data-testid*="overflow" i],
        .vp-controls__more, .vp-controls__overflow,
        .vp-contextmenu { 
          display: none !important; 
          visibility: hidden !important; 
          opacity: 0 !important; 
          pointer-events: none !important; 
        }

        .vp-player-ui .vp-side-buttons, .vp-player-ui .vp-actions {
          display: none !important;
        }

        /* Responsive/Mobile specific selectors recorded from recent Vimeo updates */
        .vp-controls--mobile .vp-controls__more,
        .vp-controls--mobile .vp-controls__overflow {
          display: none !important;
          visibility: hidden !important;
        }
      `;
      document.head.appendChild(style);
    """,
          );
        },
      ),
    );
  }
}
