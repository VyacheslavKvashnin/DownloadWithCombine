//
//  DownloadViewModel.swift
//  DownloadWithCombine
//
//  Created by Вячеслав Квашнин on 11.05.2022.
//

import Foundation
import Combine

class DownloadViewModel: ObservableObject {
    @Published var posts: [Posts] = []
    var cancelable = Set<AnyCancellable>()
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { (data, response) -> Data in
                guard
                    let response = response as? HTTPURLResponse,
                    response.statusCode >= 200 && response.statusCode < 300 else {
                        throw URLError(.badServerResponse)
                    }
                return data
            }
            .decode(type: [Posts].self, decoder: JSONDecoder())
            .sink { completion in
                print("\(completion)")
            } receiveValue: { [weak self] posts in
                self?.posts = posts
            }
            .store(in: &cancelable)
    }
}
