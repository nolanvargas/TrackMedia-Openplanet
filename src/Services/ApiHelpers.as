// Common API response type checking functions

namespace ApiHelpers {
    bool IsJsonResponse(Json::Value@ json) {
        if (json is null) return false;
        auto type = json.GetType();
        return type == Json::Type::Array || type == Json::Type::Object;
    }

    bool IsArrayResponse(Json::Value@ json) {
        return json !is null && json.GetType() == Json::Type::Array;
    }

    bool IsObjectResponse(Json::Value@ json) {
        return json !is null && json.GetType() == Json::Type::Object;
    }
}
