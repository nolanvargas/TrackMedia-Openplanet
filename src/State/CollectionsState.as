namespace State {
    // Collections state
    bool hasRequestedCollections = false;
    bool isRequestingCollections = false;
    string collectionsRequestStatus = "Not requested";
    array<Collection@> collections;
}
