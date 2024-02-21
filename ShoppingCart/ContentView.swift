import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            CartListView()
                .tabItem {
                    Label("Carts", systemImage: "cart")
                }
        }
    }
}

struct HomeView: View {
    var body: some View {
        Text("Welcome to your Home")
            .font(.title)
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
            Text("Details of Cart \(cartNumber)")
            Spacer()
        }
        .navigationTitle("Cart \(cartNumber)")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
