//
//  ContactModel.swift
//  DialMate
//
//  Created by Johndanial on 5/18/24.
//

import Contacts
import SwiftData

actor ContactModel {
    private let contactStore = CNContactStore()
    
    public func requestPermission() async throws -> Bool {
        return try await contactStore.requestAccess(for: .contacts)
    }
    
    
    public func loadContacts() async throws -> [Contact] {
        let keysToFetch = [
            CNContactFormatter.descriptorForRequiredKeys(for: .fullName),
            CNContactPhoneNumbersKey as CNKeyDescriptor
        ]
        let fetchRequest = CNContactFetchRequest(keysToFetch: keysToFetch)
        var cnContacts = [CNContact]()
        try self.contactStore.enumerateContacts(with: fetchRequest) { contact, stop in
            cnContacts.append(contact)
        }
        var contacts = cnContacts.map { contact in
            _ = CNContactFormatter.string(from: contact, style: .fullName) ?? ""
            let phoneNumbers = contact.phoneNumbers.map { $0.value.stringValue }
            return Contact(givenName: contact.givenName, familyName: contact.familyName, phoneNumbers: phoneNumbers)
        }
        contacts = contacts.sorted { first, second in
            first.givenName < second.givenName
        }
        return contacts
        // sort the contacts by first name
        // return them
    }
}

struct Contact: Identifiable, Codable, Hashable {
    var id = UUID()
    let givenName: String
    let familyName: String
    let phoneNumbers: [String]
    
    init(id: UUID = UUID(), givenName: String, familyName: String, phoneNumbers: [String]) {
        self.id = id
        self.givenName = givenName
        self.familyName = familyName
        self.phoneNumbers = phoneNumbers
        
   
    }
    
}
