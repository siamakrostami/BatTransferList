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
            transferTableView.refreshControl = self.refreshControl
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func bind() {
        super.bind()
        self.bindTableReload()
        self.initRefreshControl()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

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
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.transferList.value?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferListTVC.identifier, for: indexPath) as? TransferListTVC else {return .init()}
        guard let model = viewModel.transferList.value?[indexPath.row] else {return .init()}
        cell.selectionStyle = .none
        cell.configureCell(model: model)
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.handlePagination(index: indexPath.row)
    }
    
}
