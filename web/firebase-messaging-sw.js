/* Web push service worker for BANGLA AI (Firebase Cloud Messaging).
 * The app registers it as /firebase-messaging-sw.js?<firebase web config as query params>, so no
 * project values are hard-coded here. Notifications sent with a `notification` payload are shown by
 * the Firebase SDK; clicking one opens webpush.fcm_options.link (set by the API). */
/* eslint-disable no-undef */
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-app-compat.js');
importScripts('https://www.gstatic.com/firebasejs/12.19.0/firebase-messaging-compat.js');

const params = new URL(self.location.href).searchParams;
const config = {
  apiKey: params.get('apiKey'),
  authDomain: params.get('authDomain'),
  projectId: params.get('projectId'),
  appId: params.get('appId'),
  messagingSenderId: params.get('messagingSenderId'),
};

if (config.apiKey && config.projectId && config.messagingSenderId && config.appId) {
  firebase.initializeApp(config);
  const messaging = firebase.messaging();
  // Data-only messages (no `notification` block) are not shown automatically; show them here.
  messaging.onBackgroundMessage((payload) => {
    if (payload.notification) return;
    const d = payload.data || {};
    if (!d.title) return;
    self.registration.showNotification(d.title, { body: d.body || '', icon: '/icon-192.png', badge: '/badge-72.png', lang: 'bn', data: { link: d.link || '/' } });
  });
}

self.addEventListener('notificationclick', (event) => {
  const link = event.notification && event.notification.data && event.notification.data.link;
  if (!link) return; // FCM-displayed notifications are handled by the SDK (fcm_options.link)
  event.notification.close();
  const url = new URL(link, self.location.origin).toString();
  event.waitUntil(
    self.clients.matchAll({ type: 'window', includeUncontrolled: true }).then((wins) => {
      for (const w of wins) {
        if (w.url.startsWith(self.location.origin) && 'focus' in w) {
          w.navigate(url);
          return w.focus();
        }
      }
      return self.clients.openWindow(url);
    }),
  );
});
