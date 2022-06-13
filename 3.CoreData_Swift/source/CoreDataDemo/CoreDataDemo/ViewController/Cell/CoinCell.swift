//
//  CoinCell.swift
//  CoreDataDemo
//
//  Created by Bradley Hoang on 11/06/2022.
//

import UIKit

class CoinCell: UITableViewCell {
    static let identifier = "CoinCell"
    
    @IBOutlet weak var rankLabel: UILabel!
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var currentPriceLabel: UILabel!
    @IBOutlet weak var priceChangePercentLabel: UILabel!

    func setupCell(withCoin coin: CoinEntity) {
        rankLabel.text = "\(coin.rank)"
        
        logoImageView.image = nil
        CoinDataService.downloadCoinImage(coin.imageUrl ?? "") { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                DispatchQueue.main.async {
                    self.logoImageView.image = UIImage(data: data)
                }
            default:
                break
            }
        }
        
        nameLabel.text = coin.name?.uppercased() ?? ""
        currentPriceLabel.text = coin.currentPrice.asCurrencyWith6Decimals()
        priceChangePercentLabel.text = coin.currentPrice.asPercentString()
        priceChangePercentLabel.textColor = coin.priceChangePercent >= 0 ? .green : .red
    }
}
