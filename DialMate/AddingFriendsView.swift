//
//  AddingFriendsView.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//

import SwiftUI
import SwiftData


struct AddingFriendsView: View {
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var contactPermission: ContactPermission
    @Environment(\.dismiss) var dismiss
    @Binding var friends: [Contact]
    @State private var searchText = ""
    
    var filteredContacts: [Contact] {
        if searchText.isEmpty {
            return contactPermission.contacts
        } else {
            return contactPermission.contacts.filter {
                $0.givenName.localizedCaseInsensitiveContains(searchText) ||
                            $0.familyName.localizedCaseInsensitiveContains(searchText)
                       
            }
        }
    }
    

    
    var body: some View {
        NavigationStack {
            
            VStack {
                Button("Rest"){
                    friends.removeAll()
                }
                
                Text(" Total Contacts: \(contactPermission.contacts.count)")
                Text(" Close Friends added: \(friends.count)")
                SearchBar(text: $searchText)
                
                List {
                    ForEach(filteredContacts) { contact in
                        ContactDetailView(contact: contact, friends: $friends)
                    }
                }
                

                .navigationTitle("Add Friends")
                .toolbar {
                    Button("Done") {
                        dismiss()
                        
                    }
                }
            }
        }
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 10)
        }
        .padding(.vertical, 8)
        .background(Color(.systemGray6))
        .cornerRadius(8)
        .padding(.horizontal)
    }
}
