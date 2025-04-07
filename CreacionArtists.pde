// Método principal para crear el archivo artists.txt
public void crearArtistsTxt() {
  obtenerArtistas(); // Paso 1: generar archivo temporal con artistas únicos

  String tracksPath = sketchPath("tracks.txt");
  String artistsTempPath = sketchPath("artists_temp.txt");
  String finalArtistsPath = sketchPath("artists.txt");

  BufferedReader artistsReader = null;
  BufferedWriter finalWriter = null;

  try {
    artistsReader = new BufferedReader(new FileReader(artistsTempPath));
    finalWriter = new BufferedWriter(new FileWriter(finalArtistsPath));

    String artist;

    while ((artist = artistsReader.readLine()) != null) {
      BufferedReader tracksReader = new BufferedReader(new FileReader(tracksPath));

      String trackLine;
      boolean found = false;
      String lineToWrite = artist + ",";

      while ((trackLine = tracksReader.readLine()) != null) {
        String[] fields = trackLine.split(",", -1);
        if (fields.length < 5) continue;

        String song = fields[0].replace(",", "").trim();
        String artistsField = fields[1].trim();
        String popularity = fields[4].trim();

        String[] songArtists = artistsField.split(";");

        for (int i = 0; i < songArtists.length; i++) {
          String a = songArtists[i].trim();
          if (a.equalsIgnoreCase(artist.trim())) {
            if (found) {
              lineToWrite += ";";
            }
            lineToWrite += song + ":" + popularity;
            found = true;
            break; // Ya encontró en esta línea, no necesita seguir
          }
        }
      }

      tracksReader.close();

      if (found) {
        finalWriter.write(lineToWrite);
        finalWriter.newLine();
      }
    }

    println("Archivo artists.txt generado con éxito.");
  } catch (Exception e) {
    println("Error general: " + e);
  } finally {
    try {
      if (artistsReader != null) artistsReader.close();
      if (finalWriter != null) finalWriter.close();
    } catch (Exception e) {
      println("Error cerrando archivos: " + e);
    }
  }
}

// Paso previo: obtener artistas únicos a partir de tracks.txt y guardarlos en artists_temp.txt
public void obtenerArtistas() {
  String tracksPath = sketchPath("tracks.txt");
  String artistsTempPath = sketchPath("artists_temp.txt");

  BufferedReader reader = null;
  BufferedWriter writer = null;

  try {
    reader = new BufferedReader(new FileReader(tracksPath));
    writer = new BufferedWriter(new FileWriter(artistsTempPath));

    String trackLine;

    while ((trackLine = reader.readLine()) != null) {
      String[] fields = trackLine.split(",", -1);
      if (fields.length < 2) continue;

      String artistsField = fields[1];
      String[] artists = artistsField.split(";");

      for (int i = 0; i < artists.length; i++) {
        String currentArtist = artists[i].trim();

        // Verifica si ya está en artists_temp.txt
        if (!revisarExistencia(currentArtist)) {
          writer.write(currentArtist);
          writer.newLine();
          writer.flush(); // Para asegurar que esté disponible inmediatamente
        }
      }
    }

    println("Archivo artists_temp.txt generado con éxito.");
  } catch (Exception e) {
    println("Error en obtenerArtistas: " + e);
  } finally {
    try {
      if (reader != null) reader.close();
      if (writer != null) writer.close();
    } catch (Exception e) {
      println("Error cerrando archivos: " + e);
    }
  }
}

// Verifica si el artista ya existe en artists_temp.txt
public boolean revisarExistencia(String artista) {
  String artistsTempPath = sketchPath("artists_temp.txt");

  BufferedReader reader = null;
  try {
    reader = new BufferedReader(new FileReader(artistsTempPath));
    String line;
    while ((line = reader.readLine()) != null) {
      if (line.trim().equalsIgnoreCase(artista.trim())) {
        return true;
      }
    }
  } catch (Exception e) {
    // No hacer nada, probablemente el archivo aún no existe.
  } finally {
    try {
      if (reader != null) reader.close();
    } catch (Exception e) {
      println("Error cerrando archivo temporal: " + e);
    }
  }

  return false;
}
