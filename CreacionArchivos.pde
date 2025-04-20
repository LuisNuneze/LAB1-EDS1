int exitCodePy;
void obtenerCrearArchivos() {
  if (input_text != "") {
    String playlistId = input_text.trim();
    String filePath = sketchPath("playlist_id.txt");
    try {
      BufferedWriter writer = new BufferedWriter(new FileWriter(filePath));
      writer.write(playlistId);
      writer.close();
      println("ID guardado en playlist_id.txt.");
    }
    catch (Exception e) {
      System.out.println(e);
    }
    //Obtenemos la ruta de python, si la hay
    obtenerRutaPython();
    // Leer ruta de Python
    String[] pathLines = loadStrings("python_path.txt");
    if (pathLines != null && pathLines.length > 0) {
      pythonExecutable = pathLines[0].trim();
    } else {
      println("¡Error! Ruta de Python no configurada.");
      exit();
    }

    try {
      String scriptPath = sketchPath("spotify_playlist.py");
      String command = pythonExecutable + " \"" + scriptPath + "\"";
      println("Ejecutando comando: " + command);
      Process p = Runtime.getRuntime().exec(command);

      BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
      String line;
      while ((line = reader.readLine()) != null) {
        println("[PYTHON STDOUT] " + line);
      }

      BufferedReader errorReader = new BufferedReader(new InputStreamReader(p.getErrorStream()));
      while ((line = errorReader.readLine()) != null) {
        println("[PYTHON STDERR] " + line);
      }

      exitCodePy = p.waitFor();
      println("Proceso Python finalizado con código: " + exitCodePy);

      if (exitCodePy != 1) {
        if (activeWindow == null) {
          activeWindow = notice_buscar_exito;
        } else {
          activeWindow.cerrar(notice_buscar_exito);
          notice_buscar_exito.reset();
        }
        crearArtistsTxt();
      } else {
        if (activeWindow == null) {
          activeWindow = notice_buscar_error;
        } else {
          activeWindow.cerrar(notice_buscar_error);
          notice_buscar_error.reset();
        }
      }

      // Cargar tracks.txt
      /*
    File tracksFile = new File(sketchPath("tracks.txt"));
       if (tracksFile.exists()) {
       println("Contenido de tracks.txt:");
       String[] tracks = loadStrings(tracksFile.getAbsolutePath());
       for (String t : tracks) {
       println(t);
       }
       } else {
       println("tracks.txt no se encontró.");
       }
       
       // Cargar artists.txt
       File artistsFile = new File(sketchPath("artists.txt"));
       if (artistsFile.exists()) {
       println("Contenido de artists.txt:");
       String[] artists = loadStrings(artistsFile.getAbsolutePath());
       for (String a : artists) {
       println(a);
       }
       } else {
       println("artists.txt no se encontró.");
       }*/
    }
    catch (Exception e) {
      e.printStackTrace();
    }
  }
}

void obtenerRutaPython() {
  try {
    // Ejecuta el comando en Windows
    Process proceso = Runtime.getRuntime().exec("cmd /c where python");

    // Captura la salida del proceso
    BufferedReader reader = new BufferedReader(new InputStreamReader(proceso.getInputStream()));
    PrintWriter writer = new PrintWriter(new FileWriter(sketchPath("python_path.txt")));

    String linea;
    while ((linea = reader.readLine()) != null) {
      writer.println(linea);                // Guardar en archivo
    }

    reader.close();
    writer.close();

  } catch (IOException e) {
    println("Error: " + e.getMessage());
  }
}
