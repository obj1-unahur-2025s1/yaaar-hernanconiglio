class BarcoPirata {
  const property tripulantes = []
  var mision
  const capacidad

  method agregarPirata(unPirata) {
    if(mision.cumpleRequisitos(unPirata) && capacidad > tripulantes.size()) {tripulantes.add(unPirata)}
  }
  method cantTripulantes() = tripulantes.size()
  method tieneSuficienteTripulacion() = capacidad * 0.9 <= tripulantes.size()
  method hayTripulanteQueTiene(unItem) = tripulantes.any{t=>t.tiene(unItem)}
  method puedeSerSaqueadoPor(unPirata) = unPirata.estaPasadoDeGrog()
  method esVulnerable(otroBarco) {
    return
    otroBarco.cantidadTripulantes() / 2 >= self.cantTripulantes()
  } 
  method estanTodosPasadosDeGrog() = tripulantes.all({t=>t.estaPasadoDeGrog()})
  method tripulacionNoCalifica(unaMision) = tripulantes.filter({t=>!unaMision.esUtil(t)})
  method cambiarMision(nuevaMision) {
    mision = nuevaMision
    tripulantes.removeAll(self.tripulacionNoCalifica(nuevaMision))
  }
  method anclarEnCiudad(unaCiudad)  {
    self.todosSeTomanGrog(5) 
    self.todosGastan(1)
    self.removerAlMasBorracho()
    unaCiudad.sumarUnHabitante()
  }
  method todosSeTomanGrog(cantidad) {tripulantes.forEach({t=>t.tomarGrog(cantidad)})}
  method todosGastan(cantidad) {tripulantes.forEach({t=>t.gastar(cantidad)})}
  method elMasBoracho() = tripulantes.max({t=>t.nivelDeEbriedad()})
  method removerAlMasBorracho() {tripulantes.remove(self.elMasBoracho())}
  method esTemible() = mision.puedeCompletarMision(self)

}

class Ciudad {
  var habitantes
  method puedeSerSaqueadoPor(unPirata) = unPirata.nivelDeEbriedadMayorA(50)
  method esVulnerable(otroBarco) {
    return otroBarco.cantTripulantes() >= habitantes * 0.4 || 
    otroBarco.estanTodosPasadosDeGrog()
  }
  method sumarUnHabitante() {habitantes += 1}
}


class Pirata {
  var nivelEbriedad
  var monedas
  method tieneMenosDe(cantidad) = monedas <= cantidad
  const property items = []
  method agregarItem(unItem) {items.add(unItem)}
  method tiene(unItem) = items.contains(unItem)
  method tieneAlMenosItems(cantidad) = items.size() >= cantidad
  method estaPasadoDeGrog() = nivelEbriedad >= 90
  method seAnimaA(unObjetivo) = unObjetivo.puedeSerSaqueadoPor(self)
  method nivelDeEbriedadMayorA(unValor) = nivelEbriedad > unValor
  method esUtil(unaMision) = unaMision.esUtil(self)
  method nivelDeEbriedad() = nivelEbriedad
  method tomarGrog(unaCantidad) {nivelEbriedad += unaCantidad} 
  method gastar(unaCantidad) {monedas = (monedas - unaCantidad).max(0)}
}

class Espia inherits Pirata {
  
}

class Mision {
  method puedeCompletarMision(unBarco) = unBarco.tieneSuficienteTripulacion()
  
}

class BusquedaDelTesoro inherits Mision {
  const itemsRequeridos = #{"brujula","mapa","grog"}
  method requisitoAdicional(unBarco) = unBarco.hayTripulanteQueTiene("llave")
  override method puedeCompletarMision(unBarco) {
    return super(unBarco) && self.requisitoAdicional(unBarco)
  }
  method esUtil(unPirata) = 
    not unPirata.items().asSet().intersection(itemsRequeridos).isEmpty() 
    && unPirata.tieneMenosDe(5)
  method esUtilBis(unPirata) {
    return itemsRequeridos.any({i=>unPirata.tiene(i)}) && unPirata.tieneMenosDe(5)
  }
}

class Leyenda inherits Mision {
  const itemObligatorio
  method esUtil(unPirata) = unPirata.tieneAlMenosItems(10) && unPirata.tiene(itemObligatorio)
}

class Saqueo inherits Mision {
  const objetivo
  method esUtil(unPirata) {
    return unPirata.tieneMenosDe(monedasDeterminadas.valor()) 
    && unPirata.seAnimaA(objetivo)
  } 
}

object monedasDeterminadas {
  var property valor = 0
}