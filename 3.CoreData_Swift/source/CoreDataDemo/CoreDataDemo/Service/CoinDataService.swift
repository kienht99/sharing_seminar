//
//  CoinDataService.swift
//  CoreDataDemo
//
//  Created by Bradley Hoang on 06/06/2022.
//

import Foundation

enum NetworkingError: LocalizedError {
    case badURLResponse(url: URL)
    case unknown
    
    var errorDescription: String? {
        switch self {
        case .badURLResponse(let url): return "Bad response from URL: \(url)"
        case .unknown: return "Unknown error occured"
        }
    }
}

class CoinDataService {
    static func getCoinList(completion: @escaping (Result<[CoinModel], Error>) -> Void) {
        let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h")!
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let responseData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            
            let decoder = JSONDecoder()
            
            do {
                let jsonData = try decoder.decode([CoinModel].self, from: responseData)
                completion(.success(jsonData))
            } catch let error {
                completion(.failure(error))
            }
            
        }
        .resume()
    }
    
    static func downloadCoinImage(_ urlString: String, completion: @escaping (Result<Data, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NetworkingError.unknown))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let responseData = data, error == nil else {
                completion(.failure(error!))
                return
            }
            completion(.success(responseData))
        }
        .resume()
    }
}
