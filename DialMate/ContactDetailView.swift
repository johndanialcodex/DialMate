//
//  ContactDetailView.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//
import SwiftUI
import SwiftData
struct ContactDetailView: View {
    let contact: Contact
    
    @State private var isSelected: Bool
    @Binding var friends: [Contact]
    @State var searchText = String()
    var searchResults: [Contact] {
        if searchText.isEmpty {
            return friends
        } else {
            return friends.filter {
                $0.familyName.contains(searchText)
            }
        }
    }

    
    var body: some View {
        
        
        HStack(spacing: 0) {
            Button(action: {
                            isSelected.toggle()
                            
                        }) {
                            Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(isSelected ? .blue : .gray)
                                .imageScale(.large)
                        }
                        .padding(.trailing)
                        
               
            VStack(alignment: .leading) {
                Text("\(contact.givenName) \(contact.familyName)")
                ForEach(contact.phoneNumbers, id: \.self) { phoneNumber in
                    Text(phoneNumber)
                }
            }
           
        }
        
        .onChange(of: isSelected) { _, newValue in
            if friends.contains(where: { $0.phoneNumbers == contact.phoneNumbers }) {
                friends = friends.filter { $0.phoneNumbers != contact.phoneNumbers }


            } else {
                friends.append(contact)
            }
            
        }
    }
    
    init(contact: Contact, friends: Binding<[Contact]>) {
        self.contact = contact
        if contact.givenName == "Kate" {
            print(contact.id)
        }
        if friends.wrappedValue.contains(where: { $0.phoneNumbers == contact.phoneNumbers }) {
            _isSelected = .init(initialValue: true)
        } else {
            _isSelected = .init(initialValue: false)
        }
        _friends = friends
    }
}

#Preview {
    ContactDetailView(contact: Contact(givenName: "John", familyName: "Doe", phoneNumbers: ["123-456-7890"]), friends: .constant([Contact(givenName: "Jane", familyName: "Doe", phoneNumbers: ["987-654-3210"])]))
}
