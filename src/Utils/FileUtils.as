namespace FileUtils {
    bool IsFileType(const string &in url, const string &in fileType) {
        if (url.Length == 0 || fileType.Length == 0) throw("FileUtils::IsFileType: empty argument");;
        string lowerUrl = url.ToLower();
        string lowerType = fileType.ToLower();
        int urlLen = lowerUrl.Length;
        int typeLen = lowerType.Length;
        if (urlLen >= typeLen + 1 && lowerUrl.SubStr(urlLen - typeLen - 1) == "." + lowerType) {
            return true;
        }
        return false;
    }
}
