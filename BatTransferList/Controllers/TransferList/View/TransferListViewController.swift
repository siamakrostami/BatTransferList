//
//  TransferListViewController.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import UIKit

// MARK: - TransferListViewController

class TransferListViewController: BaseViewController {
    // MARK: Internal

    var viewModel: TransferListViewModel!

    @IBOutlet var transferTableView: UITableView! {
        didSet {
            self.transferTableView.delegate = self
            self.transferTableView.dataSource = self
            self.transferTableView.register(UINib(nibName: TransferListTVC.identifier, bundle: nil), forCellReuseIdentifier: TransferListTVC.identifier)
            self.transferTableView.register(UINib(nibName: FavoriteContainerTVC.identifier, bundle: nil), forCellReuseIdentifier: FavoriteContainerTVC.identifier)
            self.transferTableView.register(UINib(nibName: HeaderTVC.identifier, bundle: nil), forCellReuseIdentifier: HeaderTVC.identifier)
            self.transferTableView.refreshControl = self.refreshControl
        }
    }

    @IBOutlet var searchTextfield: UITextField! {
        didSet {
            searchTextfield.delegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initRefreshControl()

        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.viewModel.reloadData()
    }

    override func bind() {
        super.bind()
        self.bindTableReload()
        self.bindError()
    }

    // MARK: Private

    private let refreshControl = UIRefreshControl()
}

extension TransferListViewController {
    //MARK: - Bind reloadTable
    private func bindTableReload() {
        self.viewModel.shouldRealodTable
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] shoudReload in
                guard let shoudReload else {
                    return
                }
                if shoudReload {
                    UIView.performWithoutAnimation {
                        self?.transferTableView.reloadData()
                    }
                    
                }
            }
            .store(in: &self.viewModel.disboseBag)
    }

    private func initRefreshControl() {
        self.refreshControl.addTarget(self, action: #selector(self.refreshData), for: .valueChanged)
    }

    @objc func refreshData() {
        self.refreshControl.endRefreshing()
        self.viewModel.reloadData()
    }

    private func bindError() {
        self.viewModel.error
            .subscribe(on: DispatchQueue.main)
            .sink { [weak self] error in
                guard let error = error else {
                    return
                }
                self?.showAlert(message: error.localizedDescription)
            }
            .store(in: &self.viewModel.disboseBag)
    }
}

// MARK: UITextFieldDelegate

extension TransferListViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let text = (textField.text ?? "") + string
        self.viewModel.searchText.send(text)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        self.viewModel.searchText.send(textField.text)
        if textField.text == nil || textField.text!.isEmpty {
            self.viewModel.isSearching = false
        }
        self.viewModel.shouldRealodTable.send(true)
    }
}

// MARK: UITableViewDataSource, UITableViewDelegate

extension TransferListViewController: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            return 1
        }
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //- Handle logic for creating number of rows in each section
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            if self.viewModel.isSearching {
                guard self.viewModel.filteredArray != nil, !self.viewModel.filteredArray!.isEmpty else {
                    tableView.setEmptyState(message: "Transfer List Is Empty", image: "batman-waiting",
                                            font: .systemFont(ofSize: 16, weight: .semibold),
                                            alignment: .center)
                    return 0
                }
                tableView.restore()
                return self.viewModel.filteredArray?.count ?? 0
            } else {
                guard self.viewModel.transferList.value != nil else {
                    tableView.setEmptyState(message: "Transfer List Is Empty", image: "batman-waiting",
                                            font: .systemFont(ofSize: 16, weight: .semibold),
                                            alignment: .center)
                    return 0
                }
                tableView.restore()
                return self.viewModel.transferList.value?.count ?? 0
            }
        }
        switch section {
        case 0:
            return 1
        default:
            if self.viewModel.isSearching {
                guard self.viewModel.filteredArray != nil, !self.viewModel.filteredArray!.isEmpty else {
                    tableView.setEmptyState(message: "Transfer List Is Empty", image: "batman-waiting",
                                            font: .systemFont(ofSize: 16, weight: .semibold),
                                            alignment: .center)
                    return 0
                }
                tableView.restore()
                return self.viewModel.filteredArray?.count ?? 0
            } else {
                guard self.viewModel.transferList.value != nil else {
                    tableView.setEmptyState(message: "Transfer List Is Empty", image: "batman-waiting",
                                            font: .systemFont(ofSize: 16, weight: .semibold),
                                            alignment: .center)
                    return 0
                }
                tableView.restore()
                return self.viewModel.transferList.value?.count ?? 0
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard tableView.numberOfSections > 1 else {
            return nil
        }
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier) as? HeaderTVC else {
                return .init()
            }
            cell.selectionStyle = .none
            cell.titleLabel.text = "All"
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: HeaderTVC.identifier) as? HeaderTVC else {
            return .init()
        }
        switch section {
        case 0:
            cell.titleLabel.text = "Favorites"
            return cell
        default:
            cell.titleLabel.text = "All"
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard tableView.numberOfSections > 1 else {
            return .leastNormalMagnitude
        }
        return 50
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferListTVC.identifier,
                                                           for: indexPath) as? TransferListTVC
            else {
                return .init()
            }
            if self.viewModel.isSearching {
                guard let model = viewModel.filteredArray, !model.isEmpty else {
                    return .init()
                }
                cell.selectionStyle = .none
                cell.configureCell(model: model[indexPath.row])
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                return cell
            } else {
                guard let model = viewModel.transferList.value?[indexPath.row] else {
                    return .init()
                }
                cell.selectionStyle = .none
                cell.configureCell(model: model)
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                return cell
            }
        }
        switch indexPath.section {
        case 0:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: FavoriteContainerTVC.identifier,
                                                           for: indexPath) as? FavoriteContainerTVC
            else {
                return .init()
            }
            cell.selectionStyle = .none
            guard let favorites = self.viewModel.favorites else {
                return .init()
            }
            cell.configureCell(models: favorites)
            cell.selectedItemHandler = { [weak self] model in
                guard let `self` = self else {
                    return
                }
                self.coordinator?.openTransferDetail(dependency: self.viewModel.container, model: model)
            }
            return cell
        default:
            guard let cell = tableView.dequeueReusableCell(withIdentifier: TransferListTVC.identifier,
                                                           for: indexPath) as? TransferListTVC
            else {
                return .init()
            }
            if self.viewModel.isSearching {
                guard let model = viewModel.filteredArray, !model.isEmpty else {
                    return .init()
                }
                cell.selectionStyle = .none
                cell.configureCell(model: model[indexPath.row])
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                return cell
            } else {
                guard let model = viewModel.transferList.value?[indexPath.row] else {
                    return .init()
                }
                cell.selectionStyle = .none
                cell.configureCell(model: model)
                cell.layer.shouldRasterize = true
                cell.layer.rasterizationScale = UIScreen.main.scale
                return cell
            }
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            return 80
        }
        switch indexPath.section {
        case 0:
            return 100
        default:
            return 80
        }
    }

    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        self.viewModel.handlePagination(index: indexPath.row)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard self.viewModel.favorites != nil, !self.viewModel.favorites!.isEmpty else {
            guard let model = viewModel.transferList.value?[indexPath.row] else {
                return
            }
            coordinator?.openTransferDetail(dependency: self.viewModel.container, model: model)
            return
        }
        switch indexPath.section {
        case 1:
            guard let model = viewModel.transferList.value?[indexPath.row] else {
                return
            }
            coordinator?.openTransferDetail(dependency: self.viewModel.container, model: model)
        default:
            break
        }
    }
}
