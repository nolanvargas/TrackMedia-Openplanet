namespace CollectionsApiService {
    void RequestCollections() {
        RequestCollectionsWithParams("", 20);
    }

    void RequestCollectionsWithParams(const string &in after = "", int limit = 20) {        
        State::ResetCollectionsRequest();
        
        string url = API::API_BASE_URL + "/collections?limit=" + limit;
        if (after.Length > 0) {
            url += "&after=" + after;
        }
        
        auto json = API::GetAsync(url);
        if (json.GetType() == Json::Type::Null) {
            State::SetCollectionsError("Error");
            State::isRequestingCollections = false;
            return;
        }
        
        State::SetCollectionsSuccess();
        State::ClearCollections();
        
        for (uint i = 0; i < json.Length; i++) {
            Collection@ collection = Collection(json[i]);
            State::collections.InsertLast(collection);
            startnew(ThumbnailService::RequestThumbnailForCollection, collection);
        }
        
        State::hasRequestedCollections = true;
        
        State::isRequestingCollections = false;
    }
    
    void RequestCollectionById(Collection@ collection) {
        string url = API::API_BASE_URL + "/collections/" + collection.collectionId;
        auto json = API::GetAsync(url);
        if (json.GetType() != Json::Type::Null) {
            collection.UpdateWithFullData(json);
        }
    }
    
    void RequestCollectionByIdWithRef(ref@ data) {
        Collection@ collection = cast<Collection>(data);
        RequestCollectionById(collection);
    }
}
