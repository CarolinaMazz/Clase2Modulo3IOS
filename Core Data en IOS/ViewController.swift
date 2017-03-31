//
//  ViewController.swift
//  Core Data en IOS
//
//  Created by Alumno on 30/03/17.
//  Copyright © 2017 Jorge Luis Limo. All rights reserved.
//

import UIKit
import MBProgressHUD
import CoreData

class ViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    @IBOutlet weak var tvpublicaciones: UITableView!
    
    
    var publicaciones = Array<Publicaciones>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        listarDeCoreData()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func listarDeCoreData(){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Publicacion")
        
        do {
            let resultado = try context.fetch(fetchRequest)
            for item in resultado {
                //convertir NSmanagedObject a publicacion
                let publicacion = Publicaciones()
                
                publicacion.titulo = item.value(forKey: "titulo") as! String!
                publicacion.contenido = item.value(forKey: "contenido") as! String!
                
                self.publicaciones.append(publicacion)
                
            }
        } catch let error as NSError {
            print(error.userInfo)
        }
        
    }
    
    func eliminarDeCoreData() {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName:"Publicacion")
        
        do {
            let result = try context.fetch(fetchRequest)
            
            for item in result {
                context.delete(item)
            }
            
            try context.save()
            
        } catch let error as NSError{
            print(error.userInfo)
        }
        
    }
    
    func registrarEnCoreData (listado: Array<Publicaciones>) {
        for item in listado {
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Publicacion", in: context)
            let publicacion = NSManagedObject(entity: entity!, insertInto: context)
            
            //asignamos
            publicacion.setValue(item.titulo, forKey: "titulo")
            publicacion.setValue(item.contenido, forKey: "contenido")
            //registramos el dato manejando errores
            //context.save()
            do {
                try context.save()
                self.publicaciones.append(item)
                print(item.titulo + "se registro correctamnte")
            } catch let error as NSError {
                print("no se registro: \(error.userInfo)")
            }
            
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return publicaciones.count
    }
    
    func obtenerPublicaciones(){
        
        publicaciones.removeAll()
        
        let hud = MBProgressHUD(view: self.view)
        hud.show(animated: true)
        hud.label.text = "Cargando"
        
        self.view.addSubview(hud)
        
        PublicacionesWebservice.ListarTodos { (resultado) in
            //eliminar
            self.eliminarDeCoreData()
            //registrar actualizados
            self.registrarEnCoreData(listado: resultado)
            //mostrar en el table view
            //self.publicaciones = resultado
            self.tableView.reloadData()
            
            hud.hide(animated: true)
        }
        
        /*for i in 1...8{
            
            let publi =  Publicaciones()
            publi.titulo = "publicacion \(i)"
            publi.contenido = "contenido \(i)"
            publicaciones.append(publi)
        }*/
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let publi = publicaciones[indexPath.row]
        
        self.performSegue(withIdentifier: "detalle", sender: publi)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if  segue.identifier == "detalle"{
            
            //let detallecontroler = segue.destination as! DetalleViewController
            
            //detallecontroler.publi = sender as! publicacion
            
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! PublicacionCelda
        
        let indice = indexPath.row
        
        let publi = publicaciones[indice]
        
        cell.lbltitulo.text = publi.titulo
        cell.txtcontenido.text = publi.contenido
        
        return cell
    }
    
    @IBAction func cargarpublicaciones(_ sender: UIBarButtonItem) {
        self.obtenerPublicaciones()
        tvpublicaciones.reloadData()
    }
    
    
    
}

