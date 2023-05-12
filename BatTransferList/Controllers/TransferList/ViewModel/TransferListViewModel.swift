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
        getTransferList()
    }
    
    required init(dependency: Dependency) {
        fatalError("init(dependency:) has not been implemented")
    }

    // MARK: Internal

    var container: DependencyContainer
    
    var currentPage: Int = 1
    var transferList = CurrentValueSubject<[TransferListModel]?, Never>(nil)
}

extension TransferListViewModel {
    func getTransferList() {
        if self.currentPage == 1 {
            self.transferList.send(nil)
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
                self?.createTransferArrayFromModel(model: model)

            })
            .store(in: &self.disboseBag)
    }
    
    private func createTransferArrayFromModel(model: [TransferListModel]?) {
        guard let model = model else {
            self.transferList.send(nil)
            return
        }
        if self.transferList.value == nil {
            self.transferList.send(.init())
        }
        model.forEach {
            self.transferList.value?.append($0)
        }
    }
}
