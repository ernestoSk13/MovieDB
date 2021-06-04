# MovieDB
Aplicación de Películas consumiendo la API de MovieDB

En esta aplicación decidí utilizar UIKit con MVVM. Para consumir los servicios utilicé los servicios de URLSession y para poder parsear las respuestas utilicé el JSONEncoder para poder casar la respuesta con mis modelos que implementan el protocolo Codable. Para las vistas utilicé UICollectionViews con Orthogonal layouts. Esto lo hice para poder tener el efecto de collectionView vertical con secciones horizontales. La lógica de negocio la manejo desde los View Models. Para descargar imágenes utilizo el método de downloadTask del URLSession y almaceno esto dentro de un NSCaché para que no se esté pidiendo constantemente. 

Para la parte de la búsqueda utilicé un search controller y un segmented control. En esta búsqueda filtro tanto por sección como por coincidencias del título con el texto que se encuentra en el barra.

No pude realizar pruebas unitarias y de UI. Pero si tuviera oportunidad de agregarlas haría pruebas con mocks de respuestas reales. Haría pruebas para las búsquedas y para ver que si se están parseando correctamente los datos y prevenir alguna falla del lado del cliente móvil.

Para el funcionamiento offline me faltó persistirlo en una base de datos local. Mi opción más fiable sería almacenarlo en Core Data ya que el sistema te provee esta herramienta y es fácil de hacer migraciones en ella. Otra alternativa podría ser sqlite o realm.

Clases:

Servicios:
  ServiceAPI: clase en donde se realizan los servicios de descarga de feeds de popular, top rated y upcoming. Además de contar con el servicio de descarga de imágenes.
Vistas: 
  HomeViewController: Vista en donde se dibujan los resultados principales en un collectionview ortogonal. La barra de navegación cuenta con una barra de búsqueda.
  MovieDetailView: Pantalla modal construida en SwiftUI que muestra a detalle una película.
Modelos:
  Movie: Modelo de una pelicula.
  SearchResult: Modelo del resultado que regresa la llamada de consulta del feed.
  Section:La sección con sus elementos a popular.
View Models:
  HomeViewModel: View model que se encarga de la lógica de negocio
  MovieDetailViewModel: view model que contiene la película a consultar
  
1. En qué consiste el principio de responsabilidad única? Cuál es su propósito?

Es el principio que indica que un módulo/clase solo debe de ser responsable de una tarea dentro de una aplicación. Es decir, una vista no debe de preocuparse por la lógica de negocio, así como un view model no debe de encargarse de tareas de UI.

3. Qué características tiene, según su opinión, un “buen” código o código limpio
 
Un buen código es aquel que contiene documentación adecuada, cumple con estándares acordados por la comunidad (LINT), y está perfectamente fragmentado en pequeñas porciones de código para que sea más fácil hacer pruebas sobre él.
