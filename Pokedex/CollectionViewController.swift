//
//  ViewController.swift
//  Pokedex
//
//  Created by marco rodriguez on 22/08/22.
//

import UIKit
import Kingfisher
import Alamofire

class CollectionViewController: UIViewController {
    
    @IBOutlet weak var collectionViewPokemon: UICollectionView!
    
    var pokemons: [Pokemon] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionViewPokemon.delegate = self
        collectionViewPokemon.dataSource = self
        
        buscarPokemon()
        
    }
    
    
    func buscarPokemon(){
        guard let url = URL(string: "https://pokedex-bb36f.firebaseio.com/pokemon.json") else { return }
        let tarea = URLSession.shared.dataTask(with: url) { data, respuesta, error in
            guard let datosSeguros = data, error == nil else { return }
            
            if let dataSinNull = datosSeguros.parseData(quitarString: "null,") {
                do {
                   
                    let pokemon = try JSONDecoder().decode([Pokemon].self, from: dataSinNull)
                    print(pokemon.count)
                    self.pokemons = pokemon
                    
                    DispatchQueue.main.async {
                        self.collectionViewPokemon.reloadData()
                    }
                    
                } catch  {
                    print(error.localizedDescription)
                }
            }
        }
        tarea.resume()
    }

}

extension Data {
    func parseData(quitarString palabra: String) -> Data? {
        let dataAsString = String(data: self, encoding: .utf8)
        let parseDataString = dataAsString?.replacingOccurrences(of: palabra, with: "")
        
        guard let data = parseDataString?.data(using: .utf8) else { return nil }
        return data
    }
}

extension CollectionViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pokemons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let celda = collectionView.dequeueReusableCell(withReuseIdentifier: "PokemonCell", for: indexPath) as! PokemonCell
        
        if let url = URL(string: pokemons[indexPath.row].imageUrl) {
            celda.imagenPokemon.kf.setImage(with: url)
        }
        
        celda.nombrePokemon.text = pokemons[indexPath.row].name
        
        return celda
    }
}

extension CollectionViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 120, height: 120)
    }
}


