import "fullcalendar/main.css";
import { Calendar, CalendarOptions, ViewOptionsRefined } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";


class FireflyEventCalendar {
  public fc: Calendar;

  constructor() {
    this.fc = new Calendar(this.mountPoint(), {
      ...this.viewOptions(),
      firstDay: window.Firefly.startDate.getDay(), // start on the correct day of the week
      initialDate: window.Firefly.startDate,
      events: "/api/events"
    } )
  }

  render() {
    this.fc.render();
  }

  mountPoint() {
    return document.getElementById("calendar")!;
  }

  viewOptions(): CalendarOptions {
    return {
      plugins: [dayGridPlugin, timeGridPlugin, listPlugin],
      views: {
        listByDay: {
          type: "dayGrid",
          duration: { days: 5 },
          buttonText: "Overview",
        },
        gridByDay: {
          type: "timeGrid",
          dayCount: 6,
          buttonText: "Grid"
        },
        agenda: {
         type: "list",
          dayCount: 5,
          buttonText: "Agenda",
        }
      },
      initialView: "listByDay",
      headerToolbar: {
        start: '',
        center: 'listByDay,gridByDay,listWeek',
        end: ''
      }

    };
  }
};

export default FireflyEventCalendar;

document.addEventListener('DOMContentLoaded', () => {
  window.Firefly.EventsCalendar = new FireflyEventCalendar();
  window.Firefly.EventsCalendar.render();
});
