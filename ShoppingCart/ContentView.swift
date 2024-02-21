import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            CartListView()
                .tabItem {
                    Label("Carts", systemImage: "cart")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gearshape")
                }
        }
    }
}

struct CartListView: View {
    var body: some View {
        NavigationView {
            List {
                ForEach(1..<4) { index in
                    NavigationLink(destination: CartView(cartNumber: index)) {
                        Text("Cart \(index)")
                    }
                }
            }
            .navigationTitle("Carts")
        }
    }
}

struct CartView: View {
    let cartNumber: Int

    var body: some View {
        VStack {
            Text("Cart \(cartNumber)")
                .font(.title)

            Spacer()

            TextEditor(text: .constant(""))
                .frame(minHeight: 200)
                .padding()
        }
        .navigationTitle("Cart \(cartNumber)")
    }
}

struct SettingsView: View {
    var body: some View {
        Text("Settings Page")
            .navigationTitle("Settings")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
