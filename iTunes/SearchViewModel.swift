//
//  SearchViewModel.swift
//  iTunes
//
//  Created by 최승범 on 8/8/24.
//

import Foundation
import RxSwift
import RxCocoa

final class SearchViewModel {
    
    struct Input {
        let searchText: ControlProperty<String>
        let searchButtonClicked: ControlEvent<Void>
    }
    
    struct Output {
        let list: BehaviorSubject<[SearchResult]>
    }
    
    private let disposeBag = DisposeBag()
    
    func transform(input: Input) -> Output {
        
        let searchedList = BehaviorSubject<[SearchResult]>(value: [])
        
        input.searchButtonClicked
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .withLatestFrom(input.searchText)
            .flatMap { value in
                NetworkManager.shared.fetchData(keyword: value)
            }.subscribe(with: self) { owner, value in
                searchedList.onNext(value.results)
            } onError: { _, error in
                print(error)
            } onCompleted: { _ in
                print("complete")
            } onDisposed: { _ in
                print("dispose")
            }.disposed(by: disposeBag)
        
        return Output(list: searchedList)
    }
    
}
