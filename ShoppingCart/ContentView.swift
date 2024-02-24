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

struct GroceryItem {
    var name: String
    var aisle: String
}

struct ShoppingCartItem: Identifiable, Equatable {
    let id = UUID()
    var item: String
    
    static func == (lhs: ShoppingCartItem, rhs: ShoppingCartItem) -> Bool {
        return lhs.item == rhs.item
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
}

// Shopping Cart Page
struct ShoppingCartView: View {
    @Binding var title: String
    @State private var items: [ShoppingCartItem] = []
    @State private var newItem: String = ""
    @State private var isToggled: [Bool] = [] // Track toggled state for each item

    var body: some View {
        VStack {
            Divider()

            // List of items
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(items.indices.sorted { (firstIndex, secondIndex) -> Bool in
                        if !isToggled[firstIndex] && isToggled[secondIndex] {
                            return false // Move toggled off items down
                        } else if isToggled[firstIndex] && !isToggled[secondIndex] {
                            return true // Keep toggled on items at the current position
                        } else {
                            return firstIndex < secondIndex // Maintain the relative order of toggled on items
                        }
                    }, id: \.self) { index in
                        HStack {
                            if index != items.indices.last && !items.isEmpty {
                                Toggle("", isOn: $isToggled[index])
                                    .labelsHidden()
                            }
                            
                            if index != items.indices.last && !items.isEmpty {
                                Button(action: {
                                    items.remove(at: index)
                                    isToggled.remove(at: index)
                                }) {
                                    Image(systemName: "minus.circle.fill")
                                        .foregroundColor(.red)
                                }
                                .padding(.trailing, 8)
                            }
                            
                            TextField("Add Item", text: $items[index].item, onCommit: {
                                if index == items.count - 1 {
                                    let newItem = ShoppingCartItem(item: "")
                                    items.append(newItem)
                                    isToggled.append(true)
                                }
                            })
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            if index != items.indices.last && !items.isEmpty && isToggled[index] {
                                Button(action: {
                                    let newItem = ShoppingCartItem(item: "")
                                    items.insert(newItem, at: index + 1)
                                    isToggled.insert(true, at: index + 1)
                                }) {
                                    Image(systemName: "plus.circle.fill")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .navigationTitle(title)
        // Load items from file
        .onAppear {
            loadItemsFromFile()
        }
        // Save items to file
        .onDisappear {
            saveItemsToFile()
        }
        // Ensure there is always an empty item at the end of the list
        .onChange(of: items, perform: { _ in
            if let lastItem = items.last, !lastItem.item.isEmpty {
                let newItem = ShoppingCartItem(item: "")
                items.append(newItem)
                isToggled.append(true) // Add new toggle state for the new item
            }
        })
    }

    // Load items from file
    private func loadItemsFromFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title)_items.txt")
        do {
            if FileManager.default.fileExists(atPath: fileURL.path) {
                let savedItems = try String(contentsOf: fileURL).components(separatedBy: "\n").filter { !$0.isEmpty }
                if savedItems.isEmpty {
                    // If there are no items in the file, initialize with one empty item
                    self.items = [ShoppingCartItem(item: "")]
                    self.isToggled = [true] // Initialize toggle state for the single item
                } else {
                    // Otherwise, load the saved items from the file
                    self.items = savedItems.map { ShoppingCartItem(item: $0) }
                    self.isToggled = Array(repeating: true, count: savedItems.count) // Initialize toggle states for loaded items
                }
            } else {
                // If the file does not exist, initialize with one empty item
                self.items = [ShoppingCartItem(item: "")]
                self.isToggled = [true] // Initialize toggle state for the single item
            }
        } catch {
            print("Error loading items: \(error)")
        }
    }

    // Save items to file
    private func saveItemsToFile() {
        let fileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent("\(title)_items.txt")
        do {
            let itemsString = items.map { $0.item }.joined(separator: "\n")
            try itemsString.write(to: fileURL, atomically: true, encoding: .utf8)
        } catch {
            print("Error saving items: \(error)")
        }
    }
}

#Preview {
    ContentView()
}
