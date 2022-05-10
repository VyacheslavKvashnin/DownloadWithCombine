//
//  ContentView.swift
//  DownloadWithCombine
//
//  Created by Вячеслав Квашнин on 10.05.2022.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = DownloadViewModel()
    
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
