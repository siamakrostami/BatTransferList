//
//  TransferListViewModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Combine
import Foundation

// MARK: - TransferListViewModel

class TransferListViewModel: BaseViewModel<DependencyContainer> {
    // MARK: Lifecycle

    init(dependency: DependencyContainer) {
        self.container = dependency
        super.init(dependency: self.container)
        self.bindSearchText()
    }
    
    required init(dependency: Dependency) {
        fatalError("init(dependency:) has not been implemented")
    }

    // MARK: Internal

    var container: DependencyContainer
    
    var currentPage: Int = 1
    var transferList = CurrentValueSubject<[TransferListDomainModel]?, Never>(nil)
    var shouldRealodTable = CurrentValueSubject<Bool?,Never>(nil)
    var favorites: [TransferListDomainModel]?
    var searchText = CurrentValueSubject<String?,Never>(nil)
    var filteredArray: [TransferListDomainModel]?
    var isSearching: Bool = false
}

extension TransferListViewModel {
    
    func reloadData(){
        self.currentPage = 1
        self.getTransferList()
    }
    
    func handlePagination(index: Int){
        guard let model = self.transferList.value else {return}
        if index == model.count - 1 {
            if self.currentPage <= 3 {
                self.currentPage += 1
                self.getTransferList()
            }
        }
    }
 
    func getTransferList() {
        if self.currentPage == 1 {
            self.transferList.send(nil)
            self.favorites = nil
            self.shouldRealodTable.send(true)
        }
        self.container.networkServices.transferListServices?
            .getTransferList(page: self.currentPage)
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.error.send(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] model in
                debugPrint(model)
                self?.createTransferArrayFromModel(model: model)
                self?.shouldRealodTable.send(true)

            })
            .store(in: &self.disboseBag)
    }
    
    private func createTransferArrayFromModel(model: [TransferListModel]?) {
        guard let model = model else {
            self.transferList.send(nil)
            self.shouldRealodTable.send(true)
            return
        }

        if self.transferList.value == nil {
            self.transferList.send(.init())
        }
        var isFavorited = false

        model.forEach {
            if let numbers = UserDefaultsHelper.shared.getStoredCardNumbers(){
                if numbers.contains($0.card?.cardNumber ?? ""){
                    isFavorited = true
                }else{
                    isFavorited = false
                }
            }
            let domain = TransferListDomainModel(transferModel: $0, isFavorited: isFavorited)
            self.transferList.value?.append(domain)
        }
        self.favorites = UserDefaultsHelper.shared.getFavoriteModels()
        
    }
    
    private func bindSearchText(){
        self.searchText.subscribe(on: DispatchQueue.main)
            .sink { [weak self] search in
                self?.filterArray(searchText: search)
            }
            .store(in: &self.disboseBag)
    }
    
    private func filterArray(searchText: String?) {
        guard let searchText = searchText else {
            self.filteredArray = nil
            self.shouldRealodTable.send(true)
            return
        }
        guard let transferList = transferList.value else {
            self.filteredArray = nil
            self.shouldRealodTable.send(true)
            return
        }
        var tempArray = [TransferListDomainModel]()
        transferList.forEach{
            guard let fullname = $0.transferModel.person?.fullName else {
                self.filteredArray = nil
                self.shouldRealodTable.send(true)
                return
            }
            if fullname.contains(searchText){
                tempArray.append($0)
            }
        }
        self.filteredArray = tempArray
        self.isSearching = true
        self.shouldRealodTable.send(true)
    }
}
