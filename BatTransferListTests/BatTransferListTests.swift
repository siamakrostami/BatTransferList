//
//  BatTransferListTests.swift
//  BatTransferListTests
//
//  Created by Siamak on 5/13/23.
//

@testable import BatTransferList
import Combine
import XCTest

final class BatTransferListTests: XCTestCase {
    var viewModel: TransferListViewModel?
    var disposeBag = Set<AnyCancellable>()

    override func setUpWithError() throws {
        let container = DependencyContainer(networkServices: .init(apiRrequest: .init()), applicationDataContainer: .init())
        self.viewModel = TransferListViewModel(dependency: container)
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        self.viewModel = nil
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testApiCall() throws {
        let expect = expectation(description: "get transfer list")
        expect.fulfill()
        self.viewModel?.container.networkServices.transferListServices?.getTransferList(page: 1)
            .subscribe(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let _ = self else {
                    return
                }
                switch completion {
                case .failure(let error):
                    XCTAssertThrowsError(error)
                default:
                    break
                }
            }, receiveValue: { [weak self] model in
                guard let _ = self else {
                    return
                }
                XCTAssertNotNil(model)
            })
            .store(in: &self.disposeBag)
        wait(for: [expect], timeout: 5)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            try? testApiCall()
            // Put the code you want to measure the time of here.
        }
    }
}
