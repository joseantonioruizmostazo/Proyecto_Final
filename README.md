# Weddings & WeddingsBI
Proyecto final 2ºDAM_ 2019 que consta de dos aplicaciones, una móvil(IOS) y otra web(Angular)

   # Weddings
<img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/logo.png" width="150px">

## Desarrollo y tecnologías
Aplicación móvil dessarrollada en IOS:

  - Base de datos: Cloud Firestore (Auth & Storage)
  - Herramienta de desarrollo: Xcode 10
  - Lenguaje: Swift 4
  
## Introducción
La aplicación trata sobre la creación de bodas, donde los novios pueden indicar cierta información sobre ésta. Una vez creada podrán editarla o modificarla si lo desean, además se les proporcionará un pin para distribuirlo con todos sus invitados, los cuáles con ese pin podrán acceder a toda la información de la boda que han colgado los novios. Aparte de la información de la boda tanto los invitados como los novios podrán subir fotos desde su móvil a una galería y también descargarlas a su móvil si ya se encuentran en la galería de la aplicación.

## Funcionamiento

  ### Splash Screen y Main
  Al iniciar la aplicación se muestra una pantalla a modo de splash que redirigirá a la pantalla Main.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/SplashScreen.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/LoginViewController.png" width="250px">
</div>

   ### Crear boda
  En el Main nos encontramos con 3 opciones, en principio vamos a crear una nueva boda rellenando los 4 pasos obligatorios para ello, obteniendo al final el pin de nuestra boda.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/CreateStep1.png" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/CreateStep2.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/CreateStep3.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/CreateStep4.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/CreateComplete.gif" width="250px">
</div>

   ### Modificar boda
  Una vez creada una boda podemos modificarla, optando por la tercera opción de la pantalla Main. Para poder modificar una boda los novios deberán hacer login previamente con el correo y contraseña que usaron para crear la boda, de esa forma accederán a otro formulario que obtendrá todos los datos de su boda para no tener que modificar todos los campos sino solamente los que los novios quieran. Una vez finalizada la modificación de la boda se le recordará a los novios el pin de su boda que será el mismo que cuando la crearon.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/ModifyStep1.png" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/ModifyStep2.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/ModifyStep3.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/ModifyStep4.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/ModifyComplete.gif" width="250px">
</div>

   ### Borrar boda
  Una vez creada una boda, aparte de modificarla, también podemos borrarla, optando por la tercera opción de la pantalla Main. Para poder modificar una boda los novios deberán introducir su correo y contraseña que usaron para crear la boda, pulsar postoriormente el botón "ELIMINAR BODA" y posteriormente confirmar el popUp.

  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/BorrarBoda.gif" width="250px">
  
  ### Pantalla principal invitados boda
  Proporcionado el pin a todos nuestros invitados, éstos podrán introducirlo en la pantalla Main, una vez introducido llegarán a la pantalla principal de invitados con la información de la boda, donde podrán acceder a los distintos puntos de información.

  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/PinView.png" width="250px">

### Información de la boda
  Habiendo accedido correctamente a la pantalla principal de invitados con el pin de la boda, podremos navegar hacia los distintos puntos de información como son: datos del enlace, datos del convite y datos de contacto de los novios.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/Enlace.png" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/Convite.gif" width="250px">
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/Contacto.png" width="250px">
</div>

### Fotos
  Desde la pantalla principal de invitados también podemos acceder al apartado de fotos, donde se le explica al usuario que tipo de acciones pueden realizar ahí, que serán: ver, subir y descargar fotos.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/Fotos.png" width="250px">
</div>

### Subir Foto
  En la pantalla de fotos tenemos dos opciones, ir a la galería o subir una foto. En este caso subamos una foto.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/SubirFoto.gif" width="250px">
</div>

### Galería
  De nuevo en la pantalla de fotos, para comprobar que nuestras fotos se han subido correctamente debemos acceder a la galería.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/Galeria.gif" width="250px">
</div>

### Detalle foto
  Si nos encontramos en la galería de fotos y hacemos click en una foto, navegaremos a otra pantalla donde veremos la foto ampliada y dos opciones: borrar la foto y guardar la foto.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/DetalleFoto.png" width="250px">
</div>

### Borrar foto
  En la pantalla del detalle de la foto, podemos hacer click en el icono de papelera en la esquina superior derecha para borrar la foto. Esta acción solo podrá llevarse a cabo por los novios introduciendo el correo y contraseña de la boda como una alerta indicará. La foto se borrará tanto de la base de datos como del storage de firebase.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/BorrarFoto.gif" width="250px">
</div>

### Guardar foto
  La otra opción disponible en la pantalla de detalle de la foto es la de guardar la foto, si hacemos click en el botón "GUARDAR", la foto se guardará en la galería del dispositivo automáticamente.
  
<div>
  <img src="https://github.com/joseantonioruizmostazo/Proyecto_Final/blob/master/img/GuardarFoto.gif" width="250px">
</div>
