//
//  MovieDetailViewModel.swift
//  SwiftMVVMTP
//
//  Created by Truc Pham on 25/09/2021.
//

import Foundation
import RxCocoa
import RxSwift
struct EpisodeModel {
    let dataPostID, dataServer, dataEpisodeSlug: String?
    let isNew: Bool
    let dataEmbed: String
    let episode: String
    let url : String
}

struct MovieDetailModel {
    let title: String
    let episodes: [EpisodeModel]
    let content: String
    let time: String
    let season: String
    let latest: String
    let categorys : String
}
protocol MovieDetailViewLogic : BaseViewLogic {
    
}
class MovieDetailViewModel : BaseViewModel<MovieDetailViewModel.Input, MovieDetailViewModel.Output> {
    @Dependency.Inject
    var service : MovieService
    
    @BehaviorRelayProperty(value: MovieDetailModel(title: "", episodes: [], content: "", time: "", season: "", latest: "", categorys: ""))
    var data : MovieDetailModel
    
    weak var viewLogic : MovieDetailViewLogic?
    
    struct Input  {
        let viewWillAppear: Observable<String>
    }
    struct Output {
        let item: Driver<MovieDetailModel>
    }
    
    override func transform(input: Input) -> Output {
        input.viewWillAppear.flatMap({[weak self] urlString -> Observable<MovieDetailModel>  in
            guard let _self = self else { return Observable.empty() }
            return _self.service.movieDetail(.init(url: urlString))
        }).trackError(self.errorTracker)
            .asDriverOnErrorJustComplete()
            .drive(self.$data).disposed(by: self.disposeBag)
        
        return Output(item: self.$data.asDriverOnErrorJustComplete())
    }
}
