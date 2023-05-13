//
//  TransferListViewController.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

class TransferListViewController: BaseViewController {
    
    var viewModel: TransferListViewModel!
    
    private let refreshControl = UIRefreshControl()
    
    @IBOutlet weak var transferTableView: UITableView!{
        didSet{
            transferTableView.delegate = self
            transferTableView.dataSource = self
            transferTableView.register(UINib(nibName: TransferListTVC.identifier, bundle: nil), forCellReuseIdentifier: TransferListTVC.identifier)
            transferTableView.register(UINib(nibName: HeaderTVC.identifier, bundle: nil), forCellReuseIdentifier: HeaderTVC.identifier)
            transferTableView.refreshControl = self.refreshControl
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.getTransferList()
    }
    
    override func bind() {
        super.bind()
        self.bindTableReload()
        self.initRefreshControl()
    }

}

extension TransferListViewController {
    
    private func bindTableReload() {
        self.viewModel.shouldRealodTable
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] shoudReload in
                guard let shoudReload else {return}
                if shoudReload{
                    self?.transferTableView.reloadData()
                }
            }
            .store(in: &self.viewModel.disboseBag)

    }
    
    private func initRefreshControl(){
        self.refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    }
    
    @objc func refreshData(){
        self.refreshControl.endRefreshing()
        self.viewModel.reloadData()
    }
  
}

extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.viewModel.favorites != nil else {
            return 1
        }
        return 2
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard self.viewModel.favorites != nil else {
            guard viewModel.transferList.value != nil else {
                tableView.setEmptyState(message: "Transfer List Is Empty",image: "batman-waiting", font: .systemFont(ofSize: 16,weight: .semibold), alignment: .center)
                return 0
            }
            tableView.restore()
            return viewModel.transferList.value?.count ?? 0
        }
        switch section{
        case 0:
            return 1
        default:
            guard viewModel.transferList.value != nil else {
                tableView.setEmptyState(message: "Transfer List Is Empty",image: "batman-waiting", font: .systemFont(ofSize: 16,weight: .semibold), alignment: .center)
                return 0
            }
            tableView.restore()
            return viewModel.transferList.value?.count ?? 0
        }

    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard self.viewModel.favorites != nil else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier) as? HeaderTVC else {return .init()}
            cell.selectionStyle = .none
            cell.titleLabel.text = "All"
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier) as? HeaderTVC else {return .init()}
        switch section{
        case 0:
            cell.titleLabel.text = "Favorites"
            return cell
        default:
            cell.titleLabel.text = "All"
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.viewModel.favorites != nil else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferListTVC.identifier, for: indexPath) as? TransferListTVC else {return .init()}
            guard let model = viewModel.transferList.value?[indexPath.row] else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: model)
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            return cell
        }
        switch indexPath.section{
        case 0:
            return UITableViewCell()
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferListTVC.identifier, for: indexPath) as? TransferListTVC else {return .init()}
            guard let model = viewModel.transferList.value?[indexPath.row] else {return .init()}
            cell.selectionStyle = .none
            cell.configureCell(model: model)
            cell.layer.shouldRasterize = true
            cell.layer.rasterizationScale = UIScreen.main.scale
            return cell
        }

    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.handlePagination(index: indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let model = viewModel.transferList.value?[indexPath.row] else {return}
        coordinator?.openTransferDetail(dependency: self.viewModel.container, model: model)
    }
    
}
