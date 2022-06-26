import FireflyEventsCalender from "./calendar";

declare global {
  interface Window {
    Firefly: {
      startDate: Date,
      endDate: Date,

      EventsCalendar: FireflyEventsCalender | null,
    }
  }
}


import "phoenix_html";


window.Firefly = {
  startDate: new Date(
  `${document
    .querySelector("meta[name='start-date']")!
    .getAttribute("content")}T00:00` // infuriatingly w/o time javascript will "helpfully" assume the date means UTC midnight
),

  endDate: new Date(
  `${document
    .querySelector("meta[name='end-date']")!
    .getAttribute("content")}T00:00` // infuriatingly w/o time javascript will "helpfully" assume the date means UTC midnight
)
  };
