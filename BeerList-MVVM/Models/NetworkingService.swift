//
//  NetworkingService.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import Moya
import RxMoya
import RxSwift

protocol NetworkingService {
    func request(_ api: BeerAPI) -> Single<[Beer]>
}

final class NetworkingAPI: NetworkingService {
    let provider: MoyaProvider<BeerAPI>
    
    init(provider: MoyaProvider<BeerAPI> = MoyaProvider<BeerAPI>()) {
        self.provider = provider
    }
    
    func request(_ api: BeerAPI) -> Single<[Beer]> {
        return provider.rx.request(api)
            .filterSuccessfulStatusCodes()
            .map([Beer].self)
    }
}
