namespace CollectionsApiService {
    const int LIMIT = 40;

    void RequestCollections() {
        State::collections.Reset();

        string url = API::API_BASE_URL + "/collections?limit=" + LIMIT;

        auto json = API::GetAsync(url);
        if (!ApiHelpers::IsArrayResponse(json)) {
            State::collections.SetError("Bad response from server");
            return;
        }

        State::ClearCollections();

        for (uint i = 0; i < json.Length; i++) {
            auto item = json[i];
            // Skip external resources by checking the resource_id field
            if (item["resource_id"].GetType() != Json::Type::Null) continue;

            Collection@ c = Collection(item);
            State::allCollections.InsertLast(c);
            startnew(ThumbnailService::RequestThumbnailForCollection, c);
        }

        State::collections.Complete();
    }

    void RequestCollectionById(Collection@ collection) {
        if (collection is null) return;
        string url = API::API_BASE_URL + "/collections/" + collection.collectionId;
        auto json = API::GetAsync(url);
        if (ApiHelpers::IsObjectResponse(json)) {
            collection.UpdateWithFullData(json);
        }
    }

    void RequestCollectionByIdWithRef(ref@ data) {
        Collection@ c = cast<Collection>(data);
        RequestCollectionById(c);
    }
}
