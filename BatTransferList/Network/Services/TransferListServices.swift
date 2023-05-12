//
//  TransferListServices.swift
//  BatTransferList
//
//  Created by Siamak Rostami on 5/12/23.
//

import Foundation
import Alamofire
import Combine

protocol TransferListServicesProtocols {
    func getTransferList(page: Int) -> AnyPublisher<[TransferListModel]?,AFError>
}

class TransferListServices {
    // MARK: Lifecycle

    init(apiRequest: APIRequest) {
        self.apiRequest = apiRequest
    }

    deinit {
        debugPrint("service deinited")
    }

    // MARK: Private

    private var apiRequest: APIRequest
}

extension TransferListServices {
    
    enum TransferRouter: NetworkRouter{
        case getTransferList(page: Int)
        
        var baseURLString: String{
            return PlistHelper.baseURL
        }
        
        var path: String{
            switch self{
            case .getTransferList(let page):
                return PlistHelper.path + "\(page)"
            }
        }
        
        var method: RequestMethod?{
            return .get
        }
        
        var headers: [String : String]?{
            return RequestHeaderBuilder.shared
                .addAcceptHeaders(type: .all)
                .addConnectionHeader(type: .keepAlive)
                .build()
        }
   
    }
    
}
extension TransferListServices: TransferListServicesProtocols {
    func getTransferList(page: Int) -> AnyPublisher<[TransferListModel]?, Alamofire.AFError> {
        self.apiRequest.request(TransferRouter.getTransferList(page: page))
    }
    
    
}
