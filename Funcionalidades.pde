//Metodos para los botones
void obtenerDestacados(){
  visible_text = limitar(artistaMayorCanciones() + "\n" + artistaMasPopular() + "\n" + cancionesMayorDuracionPromedio(), 90);
}

//Metodo para hallar el artista con mayor canciones en la playlist
public String artistaMayorCanciones() {
  String filePath = sketchPath("artists.txt");
  BufferedReader reader = null;
  String line[], registro, artista_mayor = "", canciones[];
  int canciones_mayor = 0;
  try {
    reader = new BufferedReader(new FileReader(filePath));
    while ((registro = reader.readLine()) != null) {
      line = registro.split(",");
      canciones = line[1].split(";");
      if (canciones_mayor < canciones.length) {
        canciones_mayor = canciones.length;
        artista_mayor = line[0];
      }
    }
  }
  catch (Exception e) {
    println(e);
  }
  finally {
    try {
      reader.close();
    }
    catch (Exception e) {
      println(e);
    }
  }
  return artista_mayor + ", "+canciones_mayor;
}

//Metodo para hallar el artista de mayor popularidad en la playlist
public String artistaMasPopular() {
  String filePath = sketchPath("artists.txt");
  BufferedReader reader = null;
  String line[], registro, artista_mayor = "", canciones[];
  int popularidad = 0;
  float promedio = 0, promedio_mayor = 0;
  try {
    reader = new BufferedReader(new FileReader(filePath));
    while ((registro = reader.readLine()) != null) {
      line = registro.split(",");
      canciones = line[1].split(";");
      promedio = 0;
      for (int i = 0; i < canciones.length; i++) {
        popularidad = Integer.parseInt(cortarDesdeLetra(canciones[i], ":"));
        promedio += popularidad;
      }
      if (promedio_mayor < promedio) {
        artista_mayor = line[0];
        promedio_mayor = promedio;
      }
    }
  }

  catch (Exception e) {
    println(e);
  }
  finally {
    try {
      reader.close();
    }
    catch (Exception e) {
      println(e);
    }
  }
  return "Artista mas popular:"+artista_mayor;
}

// Metodo para hallar la canciones con duración mayor al promedio
public String cancionesMayorDuracionPromedio() {
  String filePath = sketchPath("tracks.txt");
  BufferedReader reader = null;
  String line[], registro, artista_mayor = "", canciones[];
  int duracion = 0, tamaño = 0;
  float promedio = 0;
  try {
    // Sacamos el promedio
    reader = new BufferedReader(new FileReader(filePath));
    while ((registro = reader.readLine()) != null) {
      line = registro.split(",");
      promedio += Integer.parseInt(line[3]);
      tamaño++;
    }
    promedio = promedio / tamaño;
    reader.close();
    
    // Sacamos las canciones con mayor duración al promedio
    println("Canciones con mayor duración al promedio");
    String canciones_mayores = "";
    reader = new BufferedReader(new FileReader(filePath));
    while ((registro = reader.readLine()) != null) {
      line = registro.split(",");
      duracion = Integer.parseInt(line[3]);
      if(duracion > promedio){
        canciones_mayores += line[0]+" ("+line[3]+")"+"\n";
      }
      
    }
    return canciones_mayores;
  }

  catch (Exception e) {
    println(e);
  }
  finally {
    try {
      reader.close();
    }
    catch (Exception e) {
      println(e);
    }
  }
  return null;
}

//Funciones auxiliares
public String cortarDesdeLetra(String cadena, String lt) {
  int i = 0;
  boolean encontrado = false;
  String letra = "";
  while (i<cadena.length() && !encontrado) {
    letra =  cadena.substring(i, i+1);
    if (letra.compareTo(lt) == 0) {
      return cadena.substring(i+1, cadena.length());
    }
    i++;
  }
  return cadena;
}

//Para obtener el contenido del portapapeles
String obtener_texto_portapapeles() {
  Clipboard portapapeles = Toolkit.getDefaultToolkit().getSystemClipboard();
  try {
    return (String) portapapeles.getData(DataFlavor.stringFlavor);
  } catch (Exception e) {
    println("Error al acceder al portapapeles: " + e);
    return "";
  }
}
