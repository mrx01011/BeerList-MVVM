//
//  SearchBeerViewModel.swift
//  BeerList-MVVM
//
//  Created by MacBook on 22.01.2024.
//

import RxSwift
import RxCocoa

final class SearchBeerViewModel {
    private var disposeBag = DisposeBag()
    private let networkingApi: NetworkingService!
    //MARK: ViewModelType
    struct Input {
        let searchTrigger = PublishRelay<String>()
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
        
        input.searchTrigger
            .asObservable()
            .flatMapLatest { id in
                networkingApi.request(.searchID(id: Int(id) ?? 0))
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

