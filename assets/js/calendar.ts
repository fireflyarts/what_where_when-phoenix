import "fullcalendar/main.css";
import { Calendar, CalendarOptions, EventInput } from "@fullcalendar/core";
import dayGridPlugin from "@fullcalendar/daygrid";
import timeGridPlugin from "@fullcalendar/timegrid";
import listPlugin from "@fullcalendar/list";

export { EventInput };
export interface FireflyEventsCalendar {
  withEvents(events: EventInput[]): FireflyEventCalendar;
  async(): FireflyEventCalendar;
}

class FireflyEventCalendar implements FireflyEventsCalendar {
  private fc: Calendar;

  static async() {
    return (window.Firefly.EventsCalendar = new FireflyEventCalendar({
      events: "/api/events",
    }));
  }

  public async() {
    this.fc.addEventSource("/api/events");
    return this;
  }

  static withEvents(initialEvents: EventInput[]) {
    return (window.Firefly.EventsCalendar = new FireflyEventCalendar({
      initialEvents,
    }));
  }

  public withEvents(eventsToAdd: EventInput[]) {
    this.fc.addEvent(eventsToAdd);
    return this;
  }

  public render() {
    this.fc.render();
  }

  private constructor(inputOpts: CalendarOptions) {
    this.fc = new Calendar(this.mountPoint(), {
      ...this.viewOptions(),
      firstDay: window.Firefly.startDate.getDay(), // start on the correct day of the week
      initialDate: window.Firefly.startDate,
      ...inputOpts,
    });
  }

  private mountPoint() {
    return document.getElementById("calendar")!;
  }

  private viewOptions(): CalendarOptions {
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
          buttonText: "Grid",
        },
        agenda: {
          type: "list",
          dayCount: 5,
          buttonText: "Agenda",
        },
      },
      initialView:
        window.visualViewport && window.visualViewport.width > 500
          ? "listByDay"
          : "agenda",
      headerToolbar: {
        start: "",
        center: "agenda,listByDay,gridByDay",
        end: "",
      },
    };
  }
}

export default FireflyEventCalendar;
