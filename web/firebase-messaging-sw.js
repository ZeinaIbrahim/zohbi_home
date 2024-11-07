importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-app.js");
importScripts("https://www.gstatic.com/firebasejs/8.10.1/firebase-messaging.js");

firebase.initializeApp({
    apiKey: "AIzaSyBiymU1z-DyfOEvCnaz5sndJTXFl6nY9GM",
    authDomain: "zohbihome-f96bd.firebaseapp.com",
    projectId: "zohbihome-f96bd",
    storageBucket: "zohbihome-f96bd.appspot.com",
    messagingSenderId: "329199796442",
    appId: "1:329199796442:web:e70686a1e87426516265e3",
    measurementId: "G-GWHS64WCRH"
});

const messaging = firebase.messaging();

messaging.setBackgroundMessageHandler(function (payload) {
    const promiseChain = clients
        .matchAll({
            type: "window",
            includeUncontrolled: true
        })
        .then(windowClients => {
            for (let i = 0; i < windowClients.length; i++) {
                const windowClient = windowClients[i];
                windowClient.postMessage(payload);
            }
        })
        .then(() => {
            const title = payload.notification.title;
            const options = {
                body: payload.notification.score
              };
            return registration.showNotification(title, options);
        });
    return promiseChain;
});
self.addEventListener('notificationclick', function (event) {
    console.log('notification received: ', event)
});