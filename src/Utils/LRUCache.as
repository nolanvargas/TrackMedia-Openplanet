// LRU (Least Recently Used) Cache implementation
// Provides bounded caching with automatic eviction of least recently used entries

class LRUCacheEntry {
    string key;
    int64 lastAccessTime;
    ref@ value;

    LRUCacheEntry() {}
    LRUCacheEntry(const string &in k, ref@ v) {
        key = k;
        @value = v;
        lastAccessTime = Time::Now;
    }

    void Touch() {
        lastAccessTime = Time::Now;
    }
}

class LRUCache {
    private dictionary m_entries;
    private array<string> m_keys;
    private uint m_maxSize;
    private uint m_evictCount;

    LRUCache(uint maxSize = 200, uint evictCount = 20) {
        m_maxSize = maxSize;
        m_evictCount = evictCount;
    }

    uint GetSize() { return m_keys.Length; }

    ref@ Get(const string &in key) {
        if (!m_entries.Exists(key)) return null;

        LRUCacheEntry@ entry;
        m_entries.Get(key, @entry);
        if (entry !is null) {
            entry.Touch();
            return entry.value;
        }
        return null;
    }

    void Set(const string &in key, ref@ value) {
        if (m_entries.Exists(key)) {
            LRUCacheEntry@ existing;
            m_entries.Get(key, @existing);
            if (existing !is null) {
                @existing.value = value;
                existing.Touch();
            }
            return;
        }

        // Evict if at capacity
        if (m_keys.Length >= m_maxSize) {
            EvictLeastRecentlyUsed();
        }

        auto entry = LRUCacheEntry(key, value);
        m_entries.Set(key, @entry);
        m_keys.InsertLast(key);
    }

    void Remove(const string &in key) {
        if (!m_entries.Exists(key)) return;

        m_entries.Delete(key);
        int idx = m_keys.Find(key);
        if (idx >= 0) {
            m_keys.RemoveAt(idx);
        }
    }

    void Clear() {
        m_entries.DeleteAll();
        m_keys.Resize(0);
    }

    private void EvictLeastRecentlyUsed() {
        if (m_keys.Length == 0) return;

        // Find entries sorted by last access time (oldest first)
        array<LRUCacheEntry@> entries;
        for (uint i = 0; i < m_keys.Length; i++) {
            LRUCacheEntry@ entry;
            m_entries.Get(m_keys[i], @entry);
            if (entry !is null) {
                entries.InsertLast(entry);
            }
        }

        // Sort by lastAccessTime (oldest first)
        for (uint i = 0; i < entries.Length; i++) {
            for (uint j = i + 1; j < entries.Length; j++) {
                if (entries[i].lastAccessTime > entries[j].lastAccessTime) {
                    auto temp = entries[i];
                    @entries[i] = entries[j];
                    @entries[j] = temp;
                }
            }
        }

        // Evict oldest entries
        uint toEvict = Math::Min(m_evictCount, entries.Length);
        for (uint i = 0; i < toEvict; i++) {
            Remove(entries[i].key);
        }
    }

    array<string> GetKeys() {
        return m_keys;
    }
}
