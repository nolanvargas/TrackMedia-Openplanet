namespace UbisoftIdService {
    void FetchUbisoftId() {
        while (!NadeoServices::IsAuthenticated("NadeoServices")) yield();

        string accountId = NadeoServices::GetAccountID();
        if (accountId.Length == 0) { Logging::Warn("Account ID not available"); return; }

        auto req = NadeoServices::Get(
            "NadeoServices",
            NadeoServices::BaseURLCore() + "/webidentities/by-account/?accountIdList=" + accountId
        );
        req.Start();
        while (!req.Finished()) yield();

        if (req.ResponseCode() != 200) {
            Logging::Error("Failed to fetch web identities. Response code: " + req.ResponseCode());
            return;
        }

        Json::Value ids = Json::Parse(req.String());
        if (ids.GetType() != Json::Type::Array) {
            Logging::Error("Unexpected response format for web identities");
            return;
        }

        for (uint i = 0; i < ids.Length; i++) {
            auto ident = ids[i];
            if (ident.GetType() != Json::Type::Object) continue;
            if (ident.HasKey("provider") && string(ident["provider"]) == "ubiServices"
                && ident.HasKey("uid")) {
                State::ubisoftAccountId = string(ident["uid"]);
                State::hasUbisoftId = true;
                return;
            }
        }

        Logging::Warn("No ubiServices provider found in web identities response");
    }
}
