//
//  CoinModel.swift
//  CoreDataDemo
//
//  Created by Bradley Hoang on 06/06/2022.
//

import Foundation

// CoinGecko API info
/*
 
 URL: https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=100&page=1&sparkline=true&price_change_percentage=24h
 
 Response:
 {
     "id": "bitcoin",
     "symbol": "btc",
     "name": "Bitcoin",
     "image": "https://assets.coingecko.com/coins/images/1/large/bitcoin.png?1547033579",
     "current_price": 38481,
     "market_cap": 732622892530,
     "market_cap_rank": 1,
     "fully_diluted_valuation": 808489295003,
     "total_volume": 27063185961,
     "high_24h": 39097,
     "low_24h": 38191,
     "price_change_24h": -374.805484905141,
     "price_change_percentage_24h": -0.9646,
     "market_cap_change_24h": -7176431716.637695,
     "market_cap_change_percentage_24h": -0.97005,
     "circulating_supply": 19029418,
     "total_supply": 21000000,
     "max_supply": 21000000,
     "ath": 69045,
     "ath_change_percentage": -44.24244,
     "ath_date": "2021-11-10T14:24:11.849Z",
     "atl": 67.81,
     "atl_change_percentage": 56673.69743,
     "atl_date": "2013-07-06T00:00:00.000Z",
     "roi": null,
     "last_updated": "2022-05-03T10:15:01.642Z",
     "sparkline_in_7d": {
       "price": [
         57812.96915967891,
         57504.33531773738,
       ]
     },
     "price_change_percentage_24h_in_currency": -0.9645990191152488
   }
 
 */

class CoinModel: Codable {
    var id: String = ""
    var symbol: String = ""
    var name: String = ""
    var image: String = ""
    var currentPrice: Double = 0
    var marketCapRank: Double? = nil
    var priceChangePercentage24H: Double? = nil
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCapRank = "market_cap_rank"
        case priceChangePercentage24H = "price_change_percentage_24h"
    }
    
    init() {
        
    }
    
    var rank: Int {
        return Int(marketCapRank ?? 0)
    }
}
