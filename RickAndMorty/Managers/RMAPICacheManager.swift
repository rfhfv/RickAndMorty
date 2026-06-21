import Foundation

final class RMAPICacheManager {
    
    private var cacheDictionary: [RMEndpoint: NSCache<NSString, NSData>] = [:]
    
    init() {
        setupCache()
    }
    
    // MARK: - Public
    
    public func cacheResponse(for endpoint: RMEndpoint, url: URL?) -> Data? {
        guard let targerCache = cacheDictionary[endpoint], let url = url else {
            return nil
        }
        
        let key = url.absoluteString as NSString
        return targerCache.object(forKey: key) as? Data
    }
    
    public func setCache(for endpoint: RMEndpoint, url: URL?, data: Data) {
        guard let targerCache = cacheDictionary[endpoint], let url = url else {
            return
        }
        
        let key = url.absoluteString as NSString
        targerCache.setObject(data as NSData, forKey: key)
    }
    
    // MARK: - Private
    
    private func setupCache() {
        RMEndpoint.allCases.forEach({ endpoint in
            cacheDictionary[endpoint] = NSCache<NSString, NSData>()
        })
    }
}
