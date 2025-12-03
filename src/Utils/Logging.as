enum LogLevel {
    Error,
    Warn,
    Info,
    Debug,
    Trace
}
LogLevel Setting_LogLevel = LogLevel::Trace;

namespace Logging {
    const string pluginName = "TrackMedia";

    void Error(const string &in msg, bool showNotification = false) {
        if (Setting_LogLevel >= LogLevel::Error) {
            if (showNotification) {
                UI::ShowNotification(Icons::Kenney::ButtonTimes + " " + pluginName + " - Error", msg, UI::HSV(1.0, 1.0, 1.0), 8000);
            }
            error("[ERROR] " + msg);
        }
    }

    void Warn(const string &in msg, bool showNotification = false) {
        if (Setting_LogLevel >= LogLevel::Warn) {
            if (showNotification) {
                UI::ShowNotification(Icons::Kenney::ButtonTimes + " " + pluginName + " - Warning", msg, UI::HSV(0.11, 1.0, 1.0), 5000);
            }
            warn("[WARN] " + msg);
        }
    }

    void Info(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Info) {
            print("[INFO] " + msg);
        }
    }

    void Debug(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Debug) {
            print("[DEBUG] " + msg);
        }
    }

    void Trace(const string &in msg) {
        if (Setting_LogLevel >= LogLevel::Trace) {
            trace("[TRACE] " + msg);
        }
    }
}