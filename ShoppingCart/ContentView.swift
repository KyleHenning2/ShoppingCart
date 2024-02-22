import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            HomeView()
        }
        .navigationTitle("Home")
        .preferredColorScheme(.dark)
    }
}

struct HomeView: View {
    @State private var numberOfCarts = 2
    @State private var cartNames: [String] = ["Shopping Cart 1", "Shopping Cart 2"]

    var body: some View {
        List {
            ForEach(cartNames.indices, id: \.self) { index in
                HStack {
                    TextField("Enter Cart Name", text: self.$cartNames[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding()
                        .onChange(of: self.cartNames[index]) { _ in
                            saveCartNamesToFile()
                        }
                    
                    NavigationLink(destination: ShoppingCartView(title: self.$cartNames[index])) {
                        EmptyView()
                    }
                    
                    Button(action: {
                        deleteCart(at: index)
                    }) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                    .buttonStyle(BorderlessButtonStyle())
                }
            }
        }
        .listStyle(SidebarListStyle())
        .navigationTitle("Shopping Carts")
        .toolbar {
            ToolbarItem(placement: .principal) {
                Button(action: {
                    self.numberOfCarts += 1
                    let newCartName = "Shopping Cart \(self.numberOfCarts)"
                    self.cartNames.append(newCartName)
                    saveCartNamesToFile()
                }) {
                    Label("Add Shopping Cart", systemImage: "cart.badge.plus")
                }
            }
        }
        .onAppear {
            loadCartNamesFromFile()
        }
    }

    private func loadCartNamesFromFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cartNames.txt")
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                self.cartNames = try String(contentsOf: fileURL).components(separatedBy: "\n")
            } else {
                // Initialize with default cart names
                self.cartNames = ["Shopping Cart 1", "Shopping Cart 2"]
            }
        } catch {
            print("Error loading cart names: \(error)")
        }
    }

    private func saveCartNamesToFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cartNames.txt")
        do {
            let cartNamesString = cartNames.joined(separator: "\n")
            try cartNamesString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving cart names: \(error)")
        }
    }

    private func deleteCart(at index: Int) {
        guard index >= 0 && index < cartNames.count else {
            return
        }
        
        let cartNameToDelete = cartNames[index]
        
        // Remove the cart name from the list
        cartNames.remove(at: index)
        
        // Save the updated list
        saveCartNamesToFile()
        
        // Delete the associated data file
        let fileManager = FileManager.default
        let fileURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(cartNameToDelete).txt")
        
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print("Error deleting data file: \(error)")
        }
    }

}


struct ShoppingCartView: View {
    @State private var listText: String = ""
    @Binding var title: String

    var body: some View {
        VStack {
            Divider()

            TextEditor(text: $listText)
                .font(.headline)
                .padding()
                .background(Color.black)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()

            Spacer()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationTitle(title)
        .onAppear {
            loadTextFromFile()
        }
        .onDisappear {
            saveTextToFile()
        }
    }

    private func loadTextFromFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title).txt")
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                self.listText = try String(contentsOf: fileURL)
            } else {
                self.listText = ""
            }
        } catch {
            print("Error loading contents: \(error)")
        }
    }

    private func saveTextToFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title).txt")
        do {
            try listText.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error writing contents: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
