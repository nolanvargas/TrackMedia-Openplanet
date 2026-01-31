// Base class for all entity models with common fields

class BaseEntity {
    string accountId;
    string userName;
    int64 createdAt;
    bool isUnlisted;

    void ParseBaseFields(Json::Value@ json) {
        if (json is null || json.GetType() != Json::Type::Object) return;
        accountId = JsonHelpers::GetString(json, "account_id");
        userName = JsonHelpers::GetString(json, "user_name");
        createdAt = JsonHelpers::GetInt64(json, "created_at");
        isUnlisted = JsonHelpers::GetBool(json, "is_unlisted");
    }

    // Abstract methods that subclasses should implement
    string GetId() { return ""; }
    string GetDisplayName() { return ""; }
}
