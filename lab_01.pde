import java.io.*;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Scanner;


String pythonExecutable;

void setup() {
  String playlistId = "2FvRD74Yopb6oqxLNcEZBh";
  String filePath = sketchPath("playlist_id.txt");

  try {
    BufferedWriter writer = new BufferedWriter(new FileWriter(filePath));
    writer.write(playlistId);
    writer.close();
    println("ID guardado en playlist_id.txt.");
  } catch (Exception e) {
    System.out.println(e);
  }

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

    int exitCode = p.waitFor();
    println("Proceso Python finalizado con código: " + exitCode);

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
    
    artistaMayorCanciones();
    artistaMasPopular();
    cancionesMayorDuracionPromedio();

  } catch (Exception e) {
    e.printStackTrace();
  }
}
