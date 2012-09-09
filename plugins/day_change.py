from gettext import gettext as _
from plugin import BasePlugin
import datetime
import tabs
import timed_events

class Plugin(BasePlugin):
    def init(self):
        self.schedule_event()

    def cleanup(self):
        self.core.remove_timed_event(self.next_event)

    def schedule_event(self):
        day_change = datetime.datetime.combine(datetime.date.today(), datetime.time())
        day_change += datetime.timedelta(1)
        self.next_event = timed_events.TimedEvent(day_change, self.day_change)
        self.core.add_timed_event(self.next_event)

    def day_change(self):
        msg = datetime.date.today().strftime(_("Day changed to %x"))

        for tab in self.core.tabs:
            if (isinstance(tab, tabs.MucTab) or
                isinstance(tab, tabs.PrivateTab) or
                isinstance(tab, tabs.ConversationTab)):
                tab.add_message(msg)

        self.core.refresh_window()
        self.schedule_event()
