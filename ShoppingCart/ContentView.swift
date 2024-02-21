import SwiftUI

struct HomeView: View {
    @State private var carts: [Cart] = [
        Cart(title: "Cart 1", items: []),
        Cart(title: "Cart 2", items: [])
    ]
    
    var body: some View {
        VStack {
            ForEach(carts.indices, id: \.self) { index in
                Button(action: {
                    self.showCart(at: index)
                }) {
                    Text(self.carts[index].title)
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                .buttonStyle(PlainButtonStyle())
            }
        }
    }
    
    private func showCart(at index: Int) {
        let cartView = CartView(cart: carts[index])
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = UIHostingController(rootView: cartView)
    }
}

struct CartView: View {
    let cart: Cart
    @State private var listText: String = ""
    @State private var titleText: String = ""
    
    var body: some View {
        VStack {
            Text("Cart: \(cart.title)")
                .font(.headline)
                .padding()
            
            Divider()
            
            TextEditor(text: $listText)
                .font(.headline)
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.gray, lineWidth: 1)
                )
                .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct Cart {
    let title: String
    var items: [String]
}
