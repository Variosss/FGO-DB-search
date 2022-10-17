//
//  ContentView.swift
//  FGO DB search
//
//  Created by Jakub Grąbka on 16/10/2022.
//

import SwiftUI
final class Params: ObservableObject {
  static let global = Params()

        var nazwa = "Altria"
}
extension String
{
    func load() -> UIImage
    {
        do
        {
            guard let url = URL(string:self) else
            {
                return UIImage()
            }
            let data: Data = try Data(contentsOf: url)
            return UIImage(data: data) ?? UIImage()
        }
        catch
        {
            
        }
        return UIImage()
    }
}

struct Character: Codable{
    var id: Int
    var face: String
    var name: String
    var className: String
    var rarity: Int
}

struct SecondView: View
{
    @ObservedObject var global = Params.global
    @State private var characters = [Character]()
    @State private var charactername: String = ""
    var body: some View {
        NavigationView {
            List(characters, id:\.id)
            {
                character in VStack(alignment: .leading)
                {
                    Text(character.name).font(.headline)
                    Text(String(character.rarity)+" Stars").font(.body)
                    Text(character.className).font(.body)
                    Image(uiImage: character.face.load())
                }
            }.navigationTitle("Characters")
                .task {
                    await fetchData()
                }
            
        }
    }
    func fetchData() async
    {
        guard let url = URL(string: "https://api.atlasacademy.io/basic/NA/servant/search?name=" + global.nazwa)
                else
        {
            print("URL not working")
            return
        }
        do
        {
            let (data, _) = try await URLSession.shared.data(from: url)
            
            if let decodedResponse = try? JSONDecoder().decode([Character].self,from: data)
            {
                characters = decodedResponse
            }
            
        }catch
        {
            print("Invalid data")
        }
    }
    
}

struct ContentView: View {
    @ObservedObject var global = Params.global
    var body: some View {
            NavigationView {
                VStack {
                    TextField("Test", text: $global.nazwa).multilineTextAlignment(.center)
                    NavigationLink(destination: SecondView()) {
                        Text("Wyszukaj").font(.system(size:34))
                    }
                    .navigationTitle("FGO Database searcher")
                }
            }
        }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
