//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by Bradley Hoang on 06/06/2022.
//

import UIKit

enum StatusType {
    case NoData
    case LoadingDataFromAPI
    case LoadingDataFromLocal
    case GetDataFromAPI
    case GetDataFromLocal(Int)
    case SaveDataToLocal
    case DeletedLocalData
    case Error
    
    func getRawValue() -> String {
        switch self {
        case .NoData:
            return "No data"
        case .LoadingDataFromAPI:
            return "Loading data from API"
        case .LoadingDataFromLocal:
            return "Loading data from local by Core Data"
        case .GetDataFromAPI:
            return "Get data from API success"
        case .GetDataFromLocal(let result):
            return "Get \(result) records from local success"
        case .SaveDataToLocal:
            return "Save data to local"
        case .DeletedLocalData:
            return "Deleted local data"
        case .Error:
            return "Unknown error"
        }
    }
}

class ViewController: UIViewController {

    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private var coins: [CoinEntity] = []
    private var status: StatusType = .NoData {
        didSet {
            statusLabel.text = status.getRawValue()
        }
    }
    private var isDisplayLocalData = false
    
    // MARK: - Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        status = .NoData
        configureTableView()
    }

    // MARK: - IBAction
    @IBAction func resetTableView(_ sender: Any) {
        coins.removeAll()
        tableView.reloadData()
        status = .NoData
        isDisplayLocalData = false
    }
    
    @IBAction func resetDataAction(_ sender: Any) {
        CoreDataManager.shared.deleteAllCoins()
        status = .DeletedLocalData
        isDisplayLocalData = false
    }
    
    @IBAction func callAPIAction(_ sender: UIButton) {
        getDataFromAPI()
        isDisplayLocalData = false
    }
    
    @IBAction func getLocalDataAction(_ sender: Any) {
        getDataFromLocal()
        isDisplayLocalData = true
    }
}

// MARK: - Core Data
extension ViewController {
    private func getDataFromLocal() {
        let localCoins = CoreDataManager.shared.getCoins()
        status = .GetDataFromLocal(localCoins.count)
        coins = localCoins
        tableView.reloadData()
    }
    
    private func showEditAlert(_ coin: CoinEntity) {
        guard let name = coin.name else { return }
        //1. Create the alert controller.
        let alert = UIAlertController(title: "Edit name", message: "Current name is \(name)", preferredStyle: .alert)

        //2. Add the text field. You can configure it however you need.
        alert.addTextField { (textField) in
            textField.text = "\(name)"
        }

        // 3. Grab the value from the text field, and print it when the user clicks OK.
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { [unowned self] _ in
            let nameTextField = alert.textFields![0]
            
            // MARK: Option 1: Edit directly
            coin.name = nameTextField.text
            CoreDataManager.shared.saveContext()
            
            // MARK: Option 2: Get record to memory and edit then
            CoreDataManager.shared.editNameCoin(coin, newName: nameTextField.text ?? "")
            
            
            // FIXME: Only for demo, not recomment on real project
            self.getLocalDataAction(UIButton())
        }))

        // 4. Present the alert.
        present(alert, animated: true, completion: nil)
    }
    
    private func deleteCoin(_ indexPath: IndexPath) {
        
        // MARK: Option 1: Delete directly
//        CoreDataManager.shared.deleteOneCoin(coins[indexPath.row])
        
        // MARK: Option 2: Batch delete (no need load record to memory)
        CoreDataManager.shared.batchDeleteOneCoin(coins[indexPath.row])
        
        coins.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }
}

// MARK: - Helper
extension ViewController {
    private func configureTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: CoinCell.identifier, bundle: nil), forCellReuseIdentifier: CoinCell.identifier)
    }
    
    private func getDataFromAPI() {
        status = .LoadingDataFromAPI
        CoinDataService.getCoinList { [weak self] result in
            switch result {
            case .success(let coins):
                self?.coins = CoreDataManager.shared.saveCoins(coins)
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                    self?.status = .GetDataFromAPI
                }
                
            case .failure(let error):
                print("DEBUG: error. \(error)")
                DispatchQueue.main.async {
                    self?.status = .Error
                }
            }
        }
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return coins.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CoinCell.identifier, for: indexPath) as! CoinCell
        cell.setupCell(withCoin: coins[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        // delete
        let delete = UIContextualAction(style: .destructive, title: "Delete") { (action, view, completionHandler) in
            
            self.deleteCoin(indexPath)
            
            completionHandler(true)
        }
        // edit
        let edit = UIContextualAction(style: .normal, title: "Edit") { action, view, completionHandler in
            self.showEditAlert(self.coins[indexPath.row])
            completionHandler(true)
        }
        
        // swipe
        let swipe = UISwipeActionsConfiguration(actions: [delete, edit])
        
        return isDisplayLocalData ? swipe : nil
    }
}

// MARK: - UITableViewDelegate
extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 55
    }
}
