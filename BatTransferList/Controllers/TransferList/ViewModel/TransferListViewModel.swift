//
//  TransferListViewModel.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import Combine

class TransferListViewModel: BaseViewModel<DependencyContainer> {
    
    var container: DependencyContainer
    
    init(dependency: DependencyContainer){
        self.container = dependency
        super.init(dependency: self.container)
        getTransferList()
    }
    
    required init(dependency: Dependency) {
        fatalError("init(dependency:) has not been implemented")
    }
    
    var currentPage: Int = 1
    var transferList = CurrentValueSubject<[TransferListModel]?,Never>(nil)

}

extension TransferListViewModel {
    
    func getTransferList(){
        self.container.networkServices.transferListServices?
            .getTransferList(page: self.currentPage)
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion{
                case .failure(let error):
                    self?.error.send(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] model in
                self?.transferList.send(model)
            })
            .store(in: &self.disboseBag)
  
    }
  
}

