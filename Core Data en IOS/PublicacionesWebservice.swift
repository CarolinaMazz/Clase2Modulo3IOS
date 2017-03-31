//
//  PublicacionesWebservice.swift
//  Servicios Web IOS Modulo3
//
//  Created by Admin on 28/03/17.
//  Copyright © 2017 alumno. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PublicacionesWebservice: NSObject {
    
    static func ListarTodos(completion: @escaping (_ result: Array<Publicaciones>) -> Void) {
        
        var resultado = Array<Publicaciones>()
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/posts")
        
        Alamofire.request(url!, method:.get, parameters:nil, encoding: URLEncoding.httpBody).responseJSON { (response) in
            
            //print(response.result.value)
            
            let json = JSON(response.result.value)
            //print(json)
            //print(json[0]["id"])
            
            for i in 0..<json.count{
                let publicaciones = Publicaciones()
                
                publicaciones.titulo = json[i]["title"].string
                publicaciones.contenido = json[i]["body"].string
                
                resultado.append(publicaciones)
            }
            //TERMINO
            completion(resultado)
        }
        
    }

}
