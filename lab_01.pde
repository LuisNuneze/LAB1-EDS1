import java.io.*;

void setup() {
  // Escribir la ID
  String playlistId = "2FvRD74Yopb6oqxLNcEZBh";
  saveStrings("playlist_id.txt", new String[]{playlistId});
  println("ID guardado.");

  // Ejecutar el análisis automático
  try {
    Process p = Runtime.getRuntime().exec("python spotify_playlist.py");
    p.waitFor();

    // Leer la salida del proceso (opcional, por si querés ver qué pasó)
    BufferedReader reader = new BufferedReader(new InputStreamReader(p.getInputStream()));
    String line = null;
    while ((line = reader.readLine()) != null) {
      println(line);
    }

    // Leer el JSON generado
    JSONObject result = loadJSONObject("salida.json");
    println("Resultado del análisis:");
    println(result.toString());

  } catch (Exception e) {
    e.printStackTrace();
  }
}

void draw(){
}
