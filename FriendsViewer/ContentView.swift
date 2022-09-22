//
//  ContentView.swift
//  FriendsViewer
//
//  Created by Nick on 2022-09-20.
//

import SwiftUI

struct ContentView: View {
    @State var users = [User]()
    @State var search = ""
    var filteredUsers: [User] {
        if search.isEmpty {
            return users
        }
        
        return users.filter { $0.name.contains(search) }
    }
    
    var body: some View {
        NavigationView {
            List(filteredUsers, id: \.id) { user in
                NavigationLink {
                    DetailsView(user: user)
                } label: {
                    VStack(alignment: .leading) {
                        Text(user.name)
                        Text(user.isActive ? "Active" : "Inactive")
                            .font(.caption)
                            .foregroundColor(user.isActive ? .primary : .secondary)
                    }
                }
            }
            .searchable(text: $search)
            .navigationTitle("Friends Viewer")
            .task {
                await getFriends()
            }
        }
    }
    
    func getFriends() async {
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601

            let decodedResponse = try decoder.decode([User].self, from: data)
            users = decodedResponse
            
        } catch {
            print(error)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
