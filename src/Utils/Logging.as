enum LogLevel {
    Error,
    Warn,
    Info,
    Debug,
    Trace
}

namespace Logging {
    [Setting name="Log Level" category="TrackMedia" description="Controls the verbosity of plugin logging. Higher levels include lower levels (Info includes Warn and Error)."]
    LogLevel Setting_LogLevel = LogLevel::Info;

    const string PLUGIN_NAME = "TrackMedia";

    void Error(const string &in msg, bool showNotification = false) {
        if (Setting_LogLevel < LogLevel::Error) return;
        if (showNotification) {
            UI::ShowNotification(Icons::Kenney::ButtonTimes + " " + PLUGIN_NAME + " - Error", msg, UI::HSV(1.0, 1.0, 1.0), 8000);
        }
        error("[TrackMedia] " + msg);
    }

    void Warn(const string &in msg, bool showNotification = false) {
        if (Setting_LogLevel < LogLevel::Warn) return;
        if (showNotification) {
            UI::ShowNotification(Icons::Kenney::ButtonTimes + " " + PLUGIN_NAME + " - Warning", msg, UI::HSV(0.11, 1.0, 1.0), 5000);
        }
        warn("[TrackMedia] " + msg);
    }

    void Info(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Info) {
            print("[TrackMedia] " + msg);
        }
    }

    void Debug(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Debug) {
            print("[TrackMedia] " + msg);
        }
    }

    void Trace(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Trace) {
            trace("[TrackMedia] " + msg);
        }
    }
}