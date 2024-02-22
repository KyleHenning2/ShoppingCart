import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            HomeView()
                .navigationTitle("Home")
                .preferredColorScheme(.dark)
        }
    }
}

// Home page
struct HomeView: View {
    // Starting Carts
    @State private var numberOfCarts = 2
    @State private var cartNames: [String] = ["Shopping Cart 1", "Shopping Cart 2"]

    var body: some View {
        List {
            ForEach(cartNames.indices, id: \.self) { index in
                HStack {
                    // Allows the creation of new carts
                    TextField("Enter Cart Name", text: self.$cartNames[index])
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(.vertical, 8) // Adjust vertical padding
                        .frame(maxWidth: .infinity) // Expand to maximum width
                        .onChange(of: self.cartNames[index]) { _ in
                            saveCartNamesToFile()
                        }
                        .onTapGesture {
                            // Enable clicking on the title to edit it
                            editCartName(at: index)
                        }

                    Spacer() // Add spacer to push NavigationLink to the edge

                    // Enable navigation when clicking on the name of the cart
                    NavigationLink(destination: ShoppingCartView(title: self.$cartNames[index])) {
                    }
                }
            }
            .onDelete(perform: deleteCart) // Swipe to delete functionality
        }
        // lists out each of the carts
        .listStyle(PlainListStyle()) // Use plain list style
        .navigationTitle("Shopping Carts")
        .toolbar {
            ToolbarItem(placement: .principal) {
                // allows the creation of new carts
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
        // when you open a cart it loads that cart from its file
        .onAppear {
            loadCartNamesFromFile()
        }
    }

    // handles loading of carts
    private func loadCartNamesFromFile() {
        // the file name for the cart
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

    // handles saving the cart to a file
    private func saveCartNamesToFile() {
        // the file name for the cart
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("cartNames.txt")
        do {
            let cartNamesString = cartNames.joined(separator: "\n")
            try cartNamesString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving cart names: \(error)")
        }
    }

    // handles deleting a cart's file
    private func deleteCart(at offsets: IndexSet) {
        for index in offsets {
            guard index >= 0 && index < cartNames.count else {
                continue
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

    // handles editing the name of a cart
    private func editCartName(at index: Int) {
        // To be implemented
    }
}

// Shopping Cart Page
struct ShoppingCartView: View {
    @State private var listText: String = ""
    @Binding var title: String

    var body: some View {
        VStack {
            Divider()
            // The main text editor for the shopping cart
            TextEditor(text: $listText)
                .font(.body) // Adjust font size
                .frame(minHeight: 200) // Set minimum height
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
        // loads the text to the file for cart
        .onAppear {
            loadTextFromFile()
        }
        // saves the text to the file for cart
        .onDisappear {
            saveTextToFile()
        }
    }

    // loads the text from its file
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

    // saves the text into its file
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
