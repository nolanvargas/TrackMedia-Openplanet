namespace API {
    const string API_BASE_URL = "https://api.trackmedia.io";

    Net::HttpRequest@ Get(const string &in url) {
        if (url.Length == 0) throw("API::Get: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Get;
        ret.Url = url;
        ret.Start();
        return ret;
    }

    Net::HttpRequest@ Post(const string &in url, const string &in body = "") {
        if (url.Length == 0) throw("API::Post: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Post;
        ret.Url = url;
        if (body.Length > 0) {
            ret.Body = body;
        }
        ret.Headers["Content-Type"] = "application/json";
        ret.Start();
        return ret;
    }

    Net::HttpRequest@ Patch(const string &in url, const string &in body = "") {
        if (url.Length == 0) throw("API::Patch: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Patch;
        ret.Url = url;
        if (body.Length > 0) {
            ret.Body = body;
        }
        ret.Headers["Content-Type"] = "application/json";
        ret.Start();
        return ret;
    }

    Net::HttpRequest@ Delete(const string &in url) {
        if (url.Length == 0) throw("API::Delete: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Delete;
        ret.Url = url;
        ret.Start();
        return ret;
    }

    Net::HttpRequest@ Put(const string &in url, const string &in body = "") {
        if (url.Length == 0) throw("API::Put: url argument cannot be empty");
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Put;
        ret.Url = url;
        if (body.Length > 0) {
            ret.Body = body;
        }
        ret.Headers["Content-Type"] = "application/json";
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

    Json::Value PatchAsync(const string &in url, const string &in body = "") {
        auto req = Patch(url, body);
        if (req is null) return Json::Value();
        while (!req.Finished()) yield();
        int responseCode = req.ResponseCode();
        if (responseCode < 200 || responseCode >= 300) {
            Logging::Error("HTTP PATCH request failed: " + url + " (code: " + responseCode + ")");
            return Json::Value();
        }
        try {
            return req.Json();
        } catch {
            Logging::Error("Failed to parse JSON response from: " + url + " - " + getExceptionInfo());
            return Json::Value();
        }
    }

    bool DeleteAsync(const string &in url) {
        auto req = Delete(url);
        if (req is null) return false;
        while (!req.Finished()) yield();
        int responseCode = req.ResponseCode();
        if (responseCode < 200 || responseCode >= 300) {
            Logging::Error("HTTP DELETE request failed: " + url + " (code: " + responseCode + ")");
            return false;
        }
        return true;
    }

    Json::Value PutAsync(const string &in url, const string &in body = "") {
        auto req = Put(url, body);
        if (req is null) return Json::Value();
        while (!req.Finished()) yield();
        int responseCode = req.ResponseCode();
        if (responseCode < 200 || responseCode >= 300) {
            Logging::Error("HTTP PUT request failed: " + url + " (code: " + responseCode + ")");
            return Json::Value();
        }
        try {
            return req.Json();
        } catch {
            Logging::Error("Failed to parse JSON response from: " + url + " - " + getExceptionInfo());
            return Json::Value();
        }
    }

    string GenerateUUIDv4() {
        string hexChars = "0123456789abcdef";
        string uuid = "";
        for (int i = 0; i < 32; i++) {
            uuid += hexChars.SubStr(Math::Rand(0, hexChars.Length), 1);
        }
        string variantChars = "89ab";
        return uuid.SubStr(0, 8) + "-" + uuid.SubStr(8, 4) + "-4" + uuid.SubStr(9, 3) + "-" +
               variantChars.SubStr(Math::Rand(0, variantChars.Length), 1) + uuid.SubStr(13, 3) + "-" +
               uuid.SubStr(16, 12);
    }
}