namespace API {
    Net::HttpRequest@ Get(const string &in url) {
        auto ret = Net::HttpRequest();
        ret.Method = Net::HttpMethod::Get;
        ret.Url = url;
        ret.Start();
        return ret;
    }

    Json::Value GetAsync(const string &in url) {
        auto req = Get(url);
        while (!req.Finished()) {
            yield();
        }
        if (req.ResponseCode() != 200) {
            Logging::Error("API::GetAsync failed for URL: " + url + " with code: " + req.ResponseCode());
            return Json::Value();
        }
        try {
            return req.Json();
        } catch {
            Logging::Error("API::GetAsync failed to parse JSON for URL: " + url);
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