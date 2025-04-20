//Metodos para los botones
void obtenerDestacados() {
  new_text = limitar(artistaMayorCanciones() + "\n" + artistaMasPopular() + "\n" + cancionesMayorDuracionPromedio(), 90);
  fade_out_text = true;
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
  return "Artista con mayor aparición: "+artista_mayor + ", "+canciones_mayor;
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
      if (duracion > promedio) {
        canciones_mayores += line[0]+" ("+line[3]+")"+"\n";
      }
    }
    return "Canciones con mayor duración al promedio:\n"+canciones_mayores;
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

//Metodos para el boton mas
boolean is_mas = false;
public void aparecerMasOpciones() {
  if (is_mas) {
    if (alpha(button_art_max.getColorDf()) > 0.1) {
      float alpha_transicion = lerp(alpha(button_art_max.getColorDf()), 0, 0.15);
      // Boton destacados
      button_art_max.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
      button_art_max.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));

      //Boton graficas
      button_graficas.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
      button_graficas.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));

      //Boton mas
      button_mas.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
      button_mas.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));
      //println(alpha_transicion);
    } else {
      float target_y = 180;
      if (button_ordenar.getY() >= target_y-1) {
        //Hacemos aparecer los botones de mas
        button_ordenar.setY(lerp(button_ordenar.getY(), target_y, 0.1));
        button_ver.setY(lerp(button_ver.getY(), target_y + 80, 0.1));
        button_buscar_archivo.setY(lerp(button_buscar_archivo.getY(), target_y + 160, 0.1));
        button_eliminar.setY(lerp(button_eliminar.getY(), target_y + 240, 0.1));
        
        if(alpha(button_retroceder.getColorHl()) < 240){
          button_retroceder.setColorHl(color(red(button_retroceder.getColorHl()), green(button_retroceder.getColorHl()), blue(button_retroceder.getColorHl()), lerp(alpha(button_retroceder.getColorHl()), 255, 0.1)));
        } else{
          button_retroceder.setColorHl(color(red(button_retroceder.getColorHl()), green(button_retroceder.getColorHl()), blue(button_retroceder.getColorHl()), 255));
        }
        
      }
    }
  } else {
    float target_y = 700;
    if (button_eliminar.getY() <= target_y + 299) {
      //Hacemos aparecer los botones de mas
      button_ordenar.setY(lerp(button_ordenar.getY(), target_y, 0.1));
      button_ver.setY(lerp(button_ver.getY(), target_y + 100, 0.1));
      button_buscar_archivo.setY(lerp(button_buscar_archivo.getY(), target_y + 200, 0.1));
      button_eliminar.setY(lerp(button_eliminar.getY(), target_y + 300, 0.1));

      //Hacemos desaparecer la felcha de volver
      button_retroceder.setColorHl(color(red(button_retroceder.getColorHl()), green(button_retroceder.getColorHl()), blue(button_retroceder.getColorHl()), lerp(alpha(button_retroceder.getColorHl()), 0, 0.1)));
    } else {
      if (alpha(button_art_max.getColorDf()) < 249) {
        float alpha_transicion = lerp(alpha(button_art_max.getColorDf()), 255, 0.15);
        // Boton destacados
        button_art_max.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
        button_art_max.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));

        //Boton graficas
        button_graficas.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
        button_graficas.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));

        //Boton mas
        button_mas.setColorDf(color(red(button_art_max.getColorDf()), green(button_art_max.getColorDf()), blue(button_art_max.getColorDf()), alpha_transicion));
        button_mas.setColorHl(color(red(button_art_max.getColorHl()), green(button_art_max.getColorHl()), blue(button_art_max.getColorHl()), alpha_transicion));
        //println(alpha_transicion);
      }
    }
  }
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
  }
  catch (Exception e) {
    println("Error al acceder al portapapeles: " + e);
    return "";
  }
}

public String buscarArtista(String input_text) {
  String resultado_busqueda = "No encontrado.", ruta_artists = sketchPath("artists.txt");
  try {
    BufferedReader archivo = new BufferedReader(new FileReader(ruta_artists));
    String linea;

    while ((linea = archivo.readLine()) != null) {
      String[] campos = linea.split(",");
      
      if (campos.length > 0 && campos[0].equalsIgnoreCase(input_text)) {
        // Reemplazar punto y coma por salto de línea al igual que coma
        resultado_busqueda = linea.replace(",", "\n").replace(";", "\n");
        break;
      }
    }

    archivo.close();
  } catch (IOException e) {
    e.printStackTrace();
    return "Error al leer el archivo.";
  }

  return resultado_busqueda;
}

public String verContenido() {
  String resultado = "", ruta_artists = sketchPath("artists.txt");

  try {
    BufferedReader br = new BufferedReader(new FileReader(ruta_artists));
    String linea;

    while ((linea = br.readLine()) != null) {
      resultado += linea.replace(",", " | ").replace(";", " | ") + "\n";
    }

    br.close();
  } catch (IOException e) {
    e.printStackTrace();
    return "Error al leer el archivo.";
  }

  return resultado;
}

public String eliminarArchivos() {
  try {
    PrintWriter pw1 = new PrintWriter(new FileWriter(sketchPath("artists.txt")));
    pw1.close();

    PrintWriter pw2 = new PrintWriter(new FileWriter(sketchPath("artists_temp.txt")));
    pw2.close();

    PrintWriter pw3 = new PrintWriter(new FileWriter(sketchPath("tracks.txt")));
    pw3.close();

    PrintWriter pw4 = new PrintWriter(new FileWriter(sketchPath("playlist_id.txt")));
    pw4.close();

    return "Archivos eliminados.";

  } catch (IOException e) {
    println("Error al eliminar archivos: " + e.getMessage());
    return "Error al eliminar archivos";
  }
}

// Metodo para el boton ordenar
String ordenarPorPopularidad() {
  String filePath = sketchPath("artists.txt");
  String tempPath = sketchPath("artists_temp_ordenamiento.txt");
  
  // 1) Cargo todas las líneas
  String[] lines = loadStrings(filePath);
  int n = lines.length;
  
  // 2) Calculo la "popularidad total" de cada línea
  int[] pops = new int[n];
  for (int i = 0; i < n; i++) {
    pops[i] = calcularPopularidad(lines[i]);
  }

  // 3) Selection sort paralelo sobre lines[] y pops[]
  for (int i = 0; i < n - 1; i++) {
    int maxIdx = i;
    for (int j = i + 1; j < n; j++) {
      if (pops[j] > pops[maxIdx]) {
        maxIdx = j;
      }
    }
    if (maxIdx != i) {
      // intercambio en pops[]
      int tmpPop = pops[i];
      pops[i]    = pops[maxIdx];
      pops[maxIdx] = tmpPop;
      // intercambio en lines[]
      String tmpLine = lines[i];
      lines[i]       = lines[maxIdx];
      lines[maxIdx]  = tmpLine;
    }
  }

  // 4) Escribo el arreglo ordenado en el temporal
  try {
    BufferedWriter bw = new BufferedWriter(new FileWriter(tempPath));
    for (String l : lines) {
      bw.write(l);
      bw.newLine();
    }
    bw.close();

    // 5) Reemplazo el original por el temporal
    File orig = new File(filePath);
    File temp = new File(tempPath);
    if (orig.delete()) {
      temp.renameTo(orig);
      println("Archivo ordenado y reemplazado en artists.txt");
      return "Archivo ordenado y reemplazado en artists.txt";
    } else {
      println("No se pudo borrar el archivo original.");
      return "No se pudo borrar el archivo original.";
    }
  } catch (Exception e) {
    println("Error al escribir archivos: " + e.getMessage());
    return "Error al ordenar el archivo";
  }
}

// Auxiliar: suma todas las populares de una línea estilo:
//     "Bradley Cooper,Shallow:73;Music To My Eyes:56;..."
int calcularPopularidad(String line) {
  // uso Java String.split(regex, limit) para partir SOLO en la primer coma
  String[] parts = line.split(",", 2);
  if (parts.length < 2) return 0;
  
  // parts[1] = "Shallow:73;Music To My Eyes:56;..."
  String canciones = parts[1];
  // aquí uso split de Processing con char delimitador
  String[] items = split(canciones, ';');
  
  int suma = 0;
  for (String it : items) {
    int idx = it.lastIndexOf(':');
    if (idx != -1 && idx + 1 < it.length()) {
      try {
        suma += Integer.parseInt(it.substring(idx + 1).trim());
      } catch (NumberFormatException ex) {
        // ignorar si no es un número válido
      }
    }
  }
  return suma;
}
