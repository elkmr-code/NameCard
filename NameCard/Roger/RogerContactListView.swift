//
//  RogerContactListView.swift
//  NameCard
//
//  Created by Roger on 12/30/24.
//

import SwiftUI
import SwiftData

struct RogerContactListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var contacts: [StoredContact]
    @Query private var categories: [ContactCategory]
    
    @State private var showingAddContact = false
    @State private var selectedContact: StoredContact?
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(contacts) { contact in
                    ContactRowView(contact: contact)
                        .onTapGesture {
                            selectedContact = contact
                        }
                }
                .onDelete(perform: deleteContacts)
            }
            .navigationTitle("My Contacts")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Add") {
                        showingAddContact = true
                    }
                }
            }
            .sheet(isPresented: $showingAddContact) {
                AddContactView()
            }
            .sheet(item: $selectedContact) { contact in
                RogerView(storedContact: contact)
            }
        }
    }
    
    private func deleteContacts(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(contacts[index])
            }
        }
    }
}

struct ContactRowView: View {
    let contact: StoredContact
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(contact.name)
                    .font(.headline)
                Text(contact.title)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                if let category = contact.category {
                    Text(category.name)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(.blue.opacity(0.1))
                        .foregroundStyle(.blue)
                        .clipShape(Capsule())
                }
            }
            Spacer()
            Image(systemName: "person.crop.rectangle")
                .foregroundStyle(.blue)
        }
        .padding(.vertical, 2)
    }
}

struct AddContactView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Query private var categories: [ContactCategory]
    
    @State private var name = ""
    @State private var title = ""
    @State private var email = ""
    @State private var selectedCategory: ContactCategory?
    @State private var showingAddCategory = false
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Contact Information") {
                    TextField("Name", text: $name)
                    TextField("Title", text: $title)
                    TextField("Email", text: $email)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                }
                
                Section("Category") {
                    Picker("Category", selection: $selectedCategory) {
                        Text("None").tag(nil as ContactCategory?)
                        ForEach(categories) { category in
                            Text(category.name).tag(category as ContactCategory?)
                        }
                    }
                    
                    Button("Add New Category") {
                        showingAddCategory = true
                    }
                }
            }
            .navigationTitle("Add Contact")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveContact()
                    }
                    .disabled(name.isEmpty || title.isEmpty || email.isEmpty)
                }
            }
            .sheet(isPresented: $showingAddCategory) {
                AddCategoryView()
            }
        }
    }
    
    private func saveContact() {
        let newContact = StoredContact(
            id: UUID(),
            name: name,
            title: title,
            email: email
        )
        newContact.category = selectedCategory
        
        modelContext.insert(newContact)
        dismiss()
    }
}

struct AddCategoryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @State private var categoryName = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Category Information") {
                    TextField("Category Name", text: $categoryName)
                }
            }
            .navigationTitle("Add Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveCategory()
                    }
                    .disabled(categoryName.isEmpty)
                }
            }
        }
    }
    
    private func saveCategory() {
        let newCategory = ContactCategory(
            id: UUID(),
            name: categoryName
        )
        
        modelContext.insert(newCategory)
        dismiss()
    }
}

#Preview {
    RogerContactListView()
        .modelContainer(for: [StoredContact.self, ContactCategory.self], inMemory: true)
}
