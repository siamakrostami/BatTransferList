//
//  TransferDetailViewController.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

class TransferDetailViewController: BaseViewController {
    
    @IBOutlet weak var fullNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var detailTableView: UITableView!{
        didSet{
            detailTableView.delegate = self
            detailTableView.dataSource = self
            detailTableView.register(UINib(nibName: PersonalTVC.identifier, bundle: nil), forCellReuseIdentifier: PersonalTVC.identifier)
            detailTableView.register(UINib(nibName: CardTVC.identifier, bundle: nil), forCellReuseIdentifier: CardTVC.identifier)
            detailTableView.register(UINib(nibName: TransferTVC.identifier, bundle: nil), forCellReuseIdentifier: TransferTVC.identifier)
            detailTableView.register(UINib(nibName: NoteTVC.identifier, bundle: nil), forCellReuseIdentifier: NoteTVC.identifier)
            detailTableView.register(UINib(nibName: HeaderTVC.identifier, bundle: nil), forCellReuseIdentifier: HeaderTVC.identifier)
        }
    }
    
    var viewModel: TransferDetailViewModel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setFullName()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        self.coordinator?.handleNavigation(style: .pop)
    }
    
    @IBAction func toggleFavorite(_ sender: Any) {
        if self.viewModel.currentModel.isFavorited{
            self.viewModel.currentModel.isFavorited = false
            UserDefaultsHelper.shared.removeModel(model: self.viewModel.currentModel)
            self.favoriteButton.setTitle("Add To Favorites", for: .normal)
        }else{
            self.viewModel.currentModel.isFavorited = true
            UserDefaultsHelper.shared.insertModel(model: self.viewModel.currentModel)
            self.favoriteButton.setTitle("Remove From Favorites", for: .normal)
        }
    }
    
    
    
    

}

extension TransferDetailViewController{
    
    private func setFullName() {
        DispatchQueue.main.async {
            self.fullNameLabel.text = self.viewModel.currentModel.transferModel.person?.fullName
            if self.viewModel.currentModel.isFavorited {
                self.favoriteButton.setTitle("Remove From Favorites", for: .normal)
            }else{
                self.favoriteButton.setTitle("Add To Favorites", for: .normal)
            }
        }
    }
    
    
    
    
}

extension TransferDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.sections.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: PersonalTVC.identifier, for: indexPath) as? PersonalTVC else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: self.viewModel.currentModel)
            return cell
        case 1:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: CardTVC.identifier, for: indexPath) as? CardTVC else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: self.viewModel.currentModel)
            return cell
        case 2:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferTVC.identifier, for: indexPath) as? TransferTVC else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: self.viewModel.currentModel)
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: NoteTVC.identifier, for: indexPath) as? NoteTVC else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: self.viewModel.currentModel)
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 80
        case 1:
            return 100
        case 2:
            return 147
        default:
            let size = viewModel.currentModel.transferModel.note?.height(withConstrainedWidth: tableView.frame.width, .systemFont(ofSize: 20))
            return (size ?? 0) + 21
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier) as? HeaderTVC else {return .init()}
        cell.selectionStyle = .none
        cell.titleLabel.text = self.viewModel.sections[section].rawValue
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    
    
    
    
}
