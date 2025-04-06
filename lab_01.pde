import java.io.*;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.FileReader;
import java.io.FileWriter;
import java.util.Scanner;

String pythonExecutable;

void setup() {
  String playlistId = "2FvRD74Yopb6oqxLNcEZBh";
  
  BufferedWriter writer = new BufferedWriter(".\\playlist_id.txt");
  saveStrings("playlist_id.txt", new String[]{playlistId});
  println("ID guardado en playlist_id.txt.");

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

    File f = new File(sketchPath("playlist_tracks.json"));
    if (f.exists()) {
      JSONObject result = loadJSONObject(f.getAbsolutePath());
      println("Resultado del análisis JSON:");
      println(result.toString());
    } else {
      println("No se encontró el archivo playlist_tracks.json después de ejecutar el script.");
    }

  } catch (Exception e) {
    e.printStackTrace();
  }
}
