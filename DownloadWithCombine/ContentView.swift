//
//  ContentView.swift
//  DownloadWithCombine
//
//  Created by Вячеслав Квашнин on 10.05.2022.
//

import SwiftUI
import Combine

struct Posts: Identifiable, Codable {
    let id: Int
    let title: String
    let body: String
}

class DownloadWithCombine: ObservableObject {
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

struct ContentView: View {
    @StateObject var viewModel = DownloadWithCombine()
    var body: some View {
        List {
            ForEach(viewModel.posts) { post in
                VStack {
                    Text(post.title)
                        .font(.title)
                    Text(post.body)
                        .font(.body)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
