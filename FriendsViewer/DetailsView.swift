//
//  DetailsView.swift
//  FriendsViewer
//
//  Created by Nick on 2022-09-21.
//

import SwiftUI

struct DetailsView: View {
    var user: User
    @State private var isExpanded = false
    
    var body: some View {
        VStack(alignment: .leading) {
            Group {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        Text("Status: \(user.isActive ? "Active" : "Inactive")")
                            .font(.headline)
                            .foregroundColor(user.isActive ? .primary : .secondary)
                        Text("Age: \(user.age)")
                        Text("Date registered: \(user.registered.formatted(date: .abbreviated, time: .omitted))")
                            .font(.footnote)
                    }
                    
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(user.company)
                        Text(user.email)
                            .font(.footnote)
                        Text(user.address)
                            .font(.subheadline)
                            .multilineTextAlignment(.trailing)
                    }
                }
                if !user.about.isEmpty {
                    Group {
                        Divider()
                        Text("Description")
                            .font(.headline)
                        Text(user.about)
                            .lineLimit(isExpanded ? nil : 3)
                            .overlay(
                                GeometryReader { proxy in
                                    Button(action: {
                                        isExpanded.toggle()
                                    }) {
                                        Text(isExpanded ? "Less" : "More")
                                            .padding(.leading, 8.0)
                                            .padding(.top, 4.0)
                                            .background(Color.white)
                                    }
                                    .frame(width: proxy.size.width, height: proxy.size.height, alignment: .bottomTrailing)
                                }
                            )
                    }
                }
                Group {
                    Divider()
                    Text("Tags")
                        .font(.headline)
                    if user.tags.isEmpty {
                        Text("No tags")
                    } else {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(user.tags, id: \.self) { tag in
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 5)
                                            .foregroundColor(.mint)
                                        Text(tag)
                                            .padding(2)
                                            .padding(.horizontal, 5)
                                            .foregroundColor(.white)
                                    }
                                    .fixedSize()
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal)
            
            List {
                Section {
                    ForEach(user.friends) { friend in
                        Text(friend.name)
                    }
                } header: {
                    Text("Friends")
                }
            }
        }
        .navigationBarTitle(user.name)
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(user: User(id: UUID(), isActive: true, name: "Zhich", age: 20, company: "Company", email: "nick.zhicheng@gmail.com", address: "Address", about: "The guy that made this app", registered: Date.now, tags: ["osu!", "Genshin Impact"], friends: [Friend(id: UUID(), name: "Eric")]))
    }
}
