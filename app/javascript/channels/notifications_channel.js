// app/javascript/channels/notifications_channel.js
import consumer from "./consumer"
import { application } from "../controllers/application";

consumer.subscriptions.create("NotificationsChannel", {
  received(data) {
    const notificationsDiv = document.getElementById("notifications");
    notificationsDiv.innerHTML += `<p>${data.message}</p>`;
  }
});
