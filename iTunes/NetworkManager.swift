//
//  NetworkManager.swift
//  iTunes
//
//  Created by 최승범 on 8/8/24.
//

import Foundation
import RxSwift

final class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData(keyword: String) -> Observable<iTunes> {
       
        let url = "https://itunes.apple.com/search?term=\(keyword)&country=kr&entity=software"
        
        return Observable<iTunes>.create { observer in
            
            let config = URLSessionConfiguration.default
            config.httpMaximumConnectionsPerHost = 5
            let session = URLSession(configuration: config)
        
            guard let url = URL(string: url) else {
                observer.onError(NetworkError.invalidURL)
                return Disposables.create()
            }
            
            session.dataTask(with: url) { data, response, error in
                
                if let error = error {
                    observer.onError(error)
                    return
                    
                }
                
                guard let response = response as? HTTPURLResponse,
                      (200...299).contains(response.statusCode) else {
                    observer.onError(NetworkError.statusError)
                    return
                }
                
                if let data = data,
                   let appData = try? JSONDecoder().decode(iTunes.self,
                                                           from: data) {
                    
                    observer.onNext(appData)
                    observer.onCompleted()
                    return
                }
                
            }.resume()
            
            return Disposables.create()
        }
    }
}

enum NetworkError: Error {
    case invalidURL
    case statusError
    case errrrrr
}

struct iTunes: Decodable {
    let resultCount: Int
    let results: [SearchResult]
}

struct SearchResult: Decodable {
    let trackName: String
    let trackId: Int
    let artworkUrl100: String
    let artworkUrl512: String
    let screenshotUrls: [String]
    let description: String
}
