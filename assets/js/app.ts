import FireflyEventsCalendarClass, { FireflyEventsCalendar } from "./calendar";

declare global {
  interface Window {
    Firefly: {
      startDate: Date;
      endDate: Date;

      EventsCalendar: FireflyEventsCalendar;
    };
  }
}

import "phoenix_html";

document.addEventListener("DOMContentLoaded", () => {
  window.Firefly = {
    startDate: new Date(
      `${document.querySelector("meta[name='start-date']")!.getAttribute("content")}T00:00` // infuriatingly w/o time javascript will "helpfully" assume the date means UTC midnight
    ),

    endDate: new Date(
      `${document.querySelector("meta[name='end-date']")!.getAttribute("content")}T00:00` // infuriatingly w/o time javascript will "helpfully" assume the date means UTC midnight
    ),

    EventsCalendar: FireflyEventsCalendarClass,
  };

  const readyEvent = new Event("FireflyReady");
  document.dispatchEvent(readyEvent);
});
