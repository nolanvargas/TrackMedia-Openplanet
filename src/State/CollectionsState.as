namespace State {
    // Collections state
    bool hasRequestedCollections = false;
    bool isRequestingCollections = false;
    string collectionsRequestStatus = "Not requested";
    array<Collection@> collections;
    
    void ResetCollectionsRequest() {
        isRequestingCollections = true;
        collectionsRequestStatus = "Requesting...";
    }
    
    void SetCollectionsError(const string &in status) {
        collectionsRequestStatus = status;
        isRequestingCollections = false;
    }
    
    void SetCollectionsSuccess() {
        collectionsRequestStatus = "Success";
    }
    
    void SetCollectionsRequestComplete() {
        hasRequestedCollections = true;
        isRequestingCollections = false;
    }

    void ClearCollections() {
        collections.RemoveRange(0, collections.Length);
    }
}
