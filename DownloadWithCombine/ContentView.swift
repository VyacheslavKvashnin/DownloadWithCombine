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
    
    init() {
        getPosts()
    }
    
    func getPosts() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/posts") else { return }
        
                
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
