namespace API {
    const string API_BASE_URL = "https://api.trackmedia.io";

    void AddSessionHeader(Net::HttpRequest@ req) {
        string sessionId = SessionStorage::GetSessionId();
        if (sessionId.Length > 0) {
            req.Headers["cookie"] = "sid=" + sessionId;
        }
    }

    Net::HttpRequest@ Get(const string &in url) {
        if (url.Length == 0) throw("API::Get: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Get;
        ret.Url = url;
        ret.Headers["Accept"] = "application/json";
        ret.Headers["Content-Type"] = "application/json";
        AddSessionHeader(ret);
        ret.Start();
        return ret;
    }

    Json::Value GetAsync(const string &in url) {
        auto req = Get(url);
        if (req is null) return Json::Value();
        while (!req.Finished()) yield();
        int responseCode = req.ResponseCode();
        if (responseCode != 200) {
            Logging::Error("HTTP request failed: " + url + " (code: " + responseCode + ")");
            return Json::Value();
        }
        try {
            return req.Json();
        } catch {
            Logging::Error("Failed to parse JSON response from: " + url + " - " + getExceptionInfo());
            return Json::Value();
        }
    }

    Net::HttpRequest@ Post(const string &in url, const string &in body = "") {
        if (url.Length == 0) throw("API::Post: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Post;
        ret.Url = url;
        ret.Headers["Accept"] = "application/json";
        ret.Headers["Content-Type"] = "application/json";
        AddSessionHeader(ret);
        ret.Body = body;
        ret.Start();
        return ret;
    }

    Json::Value PostAsync(const string &in url, const string &in body = "") {
        auto req = Post(url, body);
        if (req is null) return Json::Value();
        while (!req.Finished()) yield();
        int responseCode = req.ResponseCode();
        if (responseCode < 200 || responseCode >= 300) {
            Logging::Error("HTTP POST request failed: " + url + " (code: " + responseCode + ")");
            return Json::Value();
        }
        try {
            return req.Json();
        } catch {
            Logging::Error("Failed to parse JSON response from: " + url + " - " + getExceptionInfo());
            return Json::Value();
        }
    }
}