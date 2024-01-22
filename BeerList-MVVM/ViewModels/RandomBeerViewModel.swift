//
//  RandomBeerViewModel.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import RxSwift
import RxCocoa

final class RandomBeerViewModel {
    private let disposeBag = DisposeBag()
    private let networkingApi: NetworkingService!
    //MARK: ViewModelType
    struct Input {
        let buttonTrigger = PublishRelay<Void>()
    }
    
    struct Output {
        let beer = BehaviorRelay<[Beer]>(value: [])
        let isLoading = BehaviorRelay<Bool>(value: false)
        let errorRelay = PublishRelay<Error>()
    }
    
    let input = Input()
    let output = Output()
    
    init(networkingApi: NetworkingService = NetworkingAPI()) {
        self.networkingApi = networkingApi
        let activityIndicator = ActivityIndicator()
        
        input.buttonTrigger
            .asObservable()
            .flatMapLatest {
                networkingApi.request(.random)
                    .trackActivity(activityIndicator)
                    .do(onError: { [weak self] error in
                            self?.output.errorRelay.accept(error)
                    })
            }
            .bind(to: output.beer)
            .disposed(by: disposeBag)
        
        activityIndicator
            .asObservable()
            .bind(to: output.isLoading)
            .disposed(by: disposeBag)
    }
}
