// Texto de ejemplo para mostrar en ventana desplazable
String original_text = "Bienvenido, introduce un ID\npara comenzar";

// Limitamos el texto a 90 líneas
String visible_text = limitar(original_text, 90);

// Entrada de texto por teclado
String input_text = "";

// Coordenadas y dimensiones del cuadro de entrada de texto
int input_box_x = 200, input_box_y = 100, input_box_width = 290, input_box_height = 40;

// Coordenadas y tamaño de la ventana visible (área de texto desplazable)
int scroll_window_x, scroll_window_y, scroll_window_width, scroll_window_height;

// Offset del texto (scroll)
float text_offset_x = 20;
float text_offset_y = 20;

// Variables para el arrastre del mouse
float initial_mouse_x = 0;
float initial_mouse_y = 0;
boolean is_dragging = false;

// Botones
ButtonText button_art_max, button_graficas, button_mas, button_buscar; // Funcionalidades
ButtonText button_ordenar, button_ver, button_buscar_archivo, button_eliminar; // Funcionalidades mas
ButtonIcon button_quit, button_retroceder, button_quitG; //Quitar - retroceder

// Ventanas de noticia
NoticeWindow notice_buscar_error, notice_buscar_exito;

// Colores usados en la interfaz
color color_highlight = color(29, 185, 84);
color color_default = color(80, 80, 80, 255); // R, G, B, A
color color_hover = color(0, 0, 0, 255);      // Negro total con visibilidad
color color_background = color(30);

PFont fuente;
PImage Icon;

float logo_x = 10, logo_y = 10;

//Graficas
float[] popularidades;
String[] titulos;
String[] artistas;
String archivo = "tracks.txt";

boolean mostrarGraficas = false;
float panelX = -1009;
float panelDestinoX;
float panelY;
float panelW = 600;
float panelH = 450;

// Colores para barras
color colorBarra1, colorBarra2, colorBarra3, colorBarra4, colorBarra5;
// Colores para torta
color colorTorta1, colorTorta2, colorTorta3, colorTorta4, colorTorta5, colorTortaOtros;
String a1 = "", a2 = "", a3 = "", a4 = "", a5 = "";
int c1 = 0, c2 = 0, c3 = 0, c4 = 0, c5 = 0, otros = 0, total = 0;


void inicializarGUI() {
  // Definimos la zona del texto desplazable
  scroll_window_x = width / 2;
  scroll_window_y = 150;
  scroll_window_width = width / 2 - 40;
  scroll_window_height = height - (scroll_window_y + 30);

  // Creamos botones

  //Funcionalidades
  button_art_max = new ButtonText(40, 200, width / 2 - 80, 50, "Destacados", () -> obtenerDestacados());
  button_graficas = new ButtonText(40, 280, width / 2 - 80, 50, "Graficas", () -> mostrarGraficas = true);
  button_mas = new ButtonText(40, 360, width / 2 - 80, 50, "Mas", () -> {
    is_mas = true;
    aparecerMasOpciones();
  }
  );
  button_buscar = new ButtonText(input_box_x + input_box_width + 50, input_box_y, 90, input_box_height, "Buscar", () -> obtenerCrearArchivos());

  button_ordenar = new ButtonText(40, 700, width / 2 - 80, 50, "Ordenar", () -> println("en proceso"));
  button_ver = new ButtonText(40, 800, width / 2 - 80, 50, "Ver", () -> println("en proceso"));
  button_buscar_archivo = new ButtonText(40, 900, width / 2 - 80, 50, "Buscar", () -> println("en proceso"));
  button_eliminar = new ButtonText(40, 1000, width / 2 - 80, 50, "Eliminar", () -> println("en proceso"));



  //Quitar
  float w_quit =40, h_quit = 30;
  float x_quit =input_box_x +input_box_width - (w_quit+10), y_quit = input_box_y + 5;
  button_quit = new ButtonIcon(x_quit, y_quit, w_quit, h_quit, () -> input_text = "", 1);

  float w_rt =40, h_rt = 30;
  float x_rt = 30, y_rt = 510;
  button_retroceder = new ButtonIcon(x_rt, y_rt, w_rt, h_rt, () -> is_mas = false, 2);
  button_retroceder.setColorDf(color(red(button_retroceder.getColorDf()), green(button_retroceder.getColorDf()), blue(button_retroceder.getColorDf()), 1));
  button_retroceder.setColorHl(color(red(button_retroceder.getColorHl()), green(button_retroceder.getColorHl()), blue(button_retroceder.getColorHl()), 1));

  // Creamos ventanas de noticias
  notice_buscar_error = new NoticeWindow(175, -55, 350, 45, "ERROR 404: Playlist no encontrada", color(255, 36, 36, 150), () -> println("En processing"));
  notice_buscar_exito = new NoticeWindow(175, -55, 350, 45, "Playlist encontrada existosamente", color(29, 185, 84, 150), () -> println("En processing"));

  // Cargamos la fuente
  fuente = createFont(sketchPath("GOTHAM-MEDIUM.TTF"), 32);
  textFont(fuente);

  // Cargamos el log
  Icon = loadImage(sketchPath("Icon.png"));

  generarColores();
  button_quitG = new ButtonIcon(panelX, panelY, w_quit, h_quit, () -> mostrarGraficas = false, 1);
}

void mostrarGUI() {
  background(color_background);
  // Marco de ventana desplazable
  fill(color_default);
  stroke(color_highlight);
  strokeWeight(2);
  rect(scroll_window_x, scroll_window_y, scroll_window_width, scroll_window_height);

  // Mostrar texto con desplazamiento dentro de área recortada
  push();
  clip(scroll_window_x, scroll_window_y, scroll_window_width, scroll_window_height);
  fill(color_highlight);
  textLeading(24);
  textSize(12);
  fill(color_highlight);
  text(visible_text, scroll_window_x + text_offset_x, scroll_window_y + text_offset_y);
  noClip();
  pop();

  // Zonas negras encima y debajo de la ventana scroll (simulan máscara)
  fill(color_background);
  noStroke();
  rect(scroll_window_x, 0, scroll_window_width, scroll_window_y);
  rect(scroll_window_x, scroll_window_y + scroll_window_height, scroll_window_width, height - (scroll_window_y + scroll_window_height));


  // Cuadro de entrada de texto estilo consola
  textAlign(CENTER, CENTER);
  fill(color_default);
  stroke(color_highlight);
  strokeWeight(1);
  fill(color_highlight);
  textSize(20);
  text("Playlist ID:", input_box_x - 110, input_box_y + 20);
  textSize(20);
  fill(color_default);
  rect(input_box_x, input_box_y, input_box_width, input_box_height, 10);
  fill(color_highlight);


  // Mostrar botones
  button_art_max.display();
  button_graficas.display();
  button_mas.display();
  button_buscar.display();
  if (input_text != "") {
    button_quit.display();
  }
  if (activeWindow != null) {
    activeWindow.mostrar();
  }

  // Mostrar mas botones
  if (button_art_max.isHide() || is_mas) {
    aparecerMasOpciones();
    button_ordenar.display();
    button_buscar_archivo.display();
    button_ver.display();
    button_eliminar.display();
    button_retroceder.display();
  }
  textAlign(LEFT, TOP);

  String[] lines;
  if (input_text.length() > 19) {
    lines = input_text.substring(0, 19).split("\n");
    lines[0] += "...";
  } else {
    lines = input_text.split("\n");
  }
  int line_count = min(lines.length, 2);
  for (int i = 0; i < line_count; i++) {
    text(lines[i], input_box_x + 10, input_box_y + 10 + i * 24);
  }

  // Dibujar cursor
  int current_line_index = max(0, line_count - 1);
  String last_line = lines.length > 0 ? lines[lines.length - 1] : "";
  float cursor_x = input_box_x + 10 + textWidth(last_line);
  float cursor_y = input_box_y + 10 + current_line_index * 24;
  if (cursor_y < input_box_y + input_box_height) {
    stroke(color_highlight);
    line(cursor_x, cursor_y, cursor_x, cursor_y + 20);
  }
  image(Icon, logo_x, logo_y, 200, 80);
  graficas();
}

void mousePressed() {
  if (mouseX > scroll_window_x) {
    initial_mouse_y = mouseY;
    initial_mouse_x = mouseX;
    is_dragging = true;
  }

  button_art_max.click();
  button_graficas.click();
  button_mas.click();
  button_buscar.click();
  button_quit.click();
  button_quitG.click();

  button_ordenar.click();
  button_ver.click();
  button_buscar_archivo.click();
  button_eliminar.click();
  button_retroceder.click();
}

void mouseReleased() {
  is_dragging = false;
}

void mouseDragged() {
  if (is_dragging && mouseX > scroll_window_x) {
    float dy = mouseY - initial_mouse_y;
    float dx = mouseX - initial_mouse_x;
    text_offset_y += dy;
    text_offset_x += dx;
    initial_mouse_y = mouseY;
    initial_mouse_x = mouseX;
    limit_scroll();
  }
}

void keyTyped() {
  if (key != BACKSPACE && key != ENTER && key != 'V' && input_text.length() < 100) {
    String[] lines = input_text.split("\n");
    String last_line = lines.length > 0 ? lines[lines.length - 1] : "";
    float line_width = textWidth(last_line + key);
    if (line_width + 20 < input_box_width && lines.length <= 2) {
      input_text += key;
    }
  } else if (key == ENTER) {
    button_buscar.execute();
  } else if (key == 'V') {
    input_text = obtener_texto_portapapeles();
  }
}

void keyPressed() {
  if (key == BACKSPACE && input_text.length() > 0) {
    input_text = input_text.substring(0, input_text.length() - 1);
  }

  float scroll_step = 20;
  if (keyCode == UP) {
    text_offset_y += scroll_step;
  } else if (keyCode == DOWN) {
    text_offset_y -= scroll_step;
  } else if (keyCode == LEFT) {
    text_offset_x += scroll_step;
  } else if (keyCode == RIGHT) {
    text_offset_x -= scroll_step;
  }

  limit_scroll();
}

// Restringe el scroll para que el texto no se desplace fuera de la ventana
void limit_scroll() {
  float max_text_width = 0;
  String[] lines = visible_text.split("\n");
  for (String line : lines) {
    float width = textWidth(line);
    if (width > max_text_width) {
      max_text_width = width;
    }
  }

  float total_text_height = lines.length * 24;

  float max_y_offset = max(0, total_text_height - scroll_window_height);

  // Aplica el límite al desplazamiento horizontal
  float vertical_padding = 20;
  text_offset_y = constrain(text_offset_y, -max_y_offset - vertical_padding, vertical_padding);

  float max_x_offset = max(0, max_text_width - scroll_window_width); // Por si el texto es más corto

  // Aplica el límite al desplazamiento horizontal
  float horizontal_padding = 20;
  text_offset_x = constrain(text_offset_x, -max_x_offset - horizontal_padding, horizontal_padding);
}

// Devuelve las primeras N líneas del texto
String limitar(String contenido, int max_lineas) {
  String[] lineas = contenido.split("\n");
  int total = min(lineas.length, max_lineas);
  String resultado = "";
  for (int i = 0; i < total; i++) {
    resultado += lineas[i] + "\n";
  }
  return resultado;
}

void graficas() {
  if (mostrarGraficas) {
    fill(0, 150);
    noStroke();
    rect(0, 0, width, height);
    panelX = lerp(panelX, panelDestinoX, 0.09);
    button_quitG.Setx(panelX+panelW);
    button_quitG.Sety(panelY+50);
    button_quitG.display();
  } else {
    panelX = lerp(panelX, -panelDestinoX - panelW - 100, 0.09);
    button_quitG.Setx(panelX+panelW);
  }
  fill(0);
  noStroke();
  rect(panelX+50, panelY+50, panelW, panelH, 15);
  println(panelX);
  if(panelX > -680){
    button_quitG.display();
  IniciarGraficas();
  }
}

void IniciarGraficas() {
  String filePath = sketchPath("tracks.txt");
  BufferedReader reader = null;
  try {
    reader = new BufferedReader(new FileReader(filePath));
    int contador = 0;
    while (reader.readLine() != null) contador++;
    reader.close();
    println(contador);
    if (contador == 1) {
      mostrarGraficas = false;
      return;
    }
    reader = new BufferedReader(new FileReader(filePath));

    popularidades = new float[contador];
    titulos = new String[contador];
    artistas = new String[contador];

    String linea;
    int i = 0;
    while ((linea = reader.readLine()) != null) {
      String[] partes = linea.split(",");
      if (partes.length >= 6) {
        titulos[i] = partes[0];
        artistas[i] = partes[1];
        popularidades[i] = float(partes[4]);

        String actual = partes[1];
        if (actual.equals(a1)) c1++;
        else if (actual.equals(a2)) c2++;
        else if (actual.equals(a3)) c3++;
        else if (actual.equals(a4)) c4++;
        else if (actual.equals(a5)) c5++;
        else if (a1.equals("")) {
          a1 = actual;
          c1 = 1;
        } else if (a2.equals("")) {
          a2 = actual;
          c2 = 1;
        } else if (a3.equals("")) {
          a3 = actual;
          c3 = 1;
        } else if (a4.equals("")) {
          a4 = actual;
          c4 = 1;
        } else if (a5.equals("")) {
          a5 = actual;
          c5 = 1;
        } else otros++;
        total++;
        i++;
      }
    }
    if (contador == 1 && linea == null) {
      mostrarGraficas = false;
      return;
    }
    graficaBarras(panelX+100, panelY+90, 250, 330);
    graficaCircularConLeyenda(panelX+380, panelY+130, 220, 220);
  }
  catch (Exception e) {
    println("Error leyendo archivo: " + e.getMessage());
    mostrarGraficas = false;
  }
  finally {
    try {
      if (reader != null) reader.close();
    }
    catch (Exception e) {
      println(e);
    }
  }
}

void graficaBarras(float x, float y, float w, float h) {
  float maxValor = 0;
  int cantidad = min(5, popularidades.length);

  for (int i = 0; i < cantidad; i++) {
    if (popularidades[i] > maxValor) maxValor = popularidades[i];
  }

  float espacio = 5;
  float anchoBarra = (w - espacio * (cantidad + 1)) / cantidad;

  int divisionesY = 5;
  textAlign(RIGHT, CENTER);
  fill(255);
  for (int i = 0; i <= divisionesY; i++) {
    float v = map(i, 0, divisionesY, 0, maxValor);
    float yPos = y + h - map(v, 0, maxValor, 0, h);
    stroke(40);
    line(x, yPos, x + w, yPos);
    noStroke();
    textSize(8);
    text(nf(v, 0, 0), x - 5, yPos);
  }

  textAlign(CENTER, TOP);
  for (int i = 0; i < cantidad; i++) {
    float altura = map(popularidades[i], 0, maxValor, 0, h);
    float posX = x + espacio + i * (anchoBarra + espacio);
    float posY = y + (h - altura);

    if (i == 0) fill(colorBarra1);
    else if (i == 1) fill(colorBarra2);
    else if (i == 2) fill(colorBarra3);
    else if (i == 3) fill(colorBarra4);
    else if (i == 4) fill(colorBarra5);
    stroke(255);
    rect(posX, posY, anchoBarra, altura);

    fill(255);
    noStroke();
    String texto = titulos[i];
    if (textWidth(texto) > anchoBarra) {
      while (textWidth(texto + "...") > anchoBarra && texto.length() > 0) {
        texto = texto.substring(0, texto.length() - 1);
      }
      texto += "...";
    }
    text(texto, posX + anchoBarra / 2, y + h + 5);
  }

  stroke(255);
  line(x, y, x, y + h);
  line(x, y + h, x + w, y + h);
}

void graficaCircularConLeyenda(float x, float y, float w, float h) {
  float centroX = x + w / 2;
  float centroY = y + h / 2;
  float radio = min(w, h) / 2;
  float anguloInicio = 0;

  float[] angulos = {c1, c2, c3, c4, c5, otros};
  color[] colores = {colorTorta1, colorTorta2, colorTorta3, colorTorta4, colorTorta5, colorTortaOtros};
  String[] etiquetas = {a1, a2, a3, a4, a5, "Otros"};

  for (int i = 0; i < angulos.length; i++) {
    if (angulos[i] > 0) {
      float angulo = map(angulos[i], 0, total, 0, TWO_PI);
      fill(colores[i]);
      stroke(15);
      strokeWeight(2);
      arc(centroX, centroY, radio * 2, radio * 2, anguloInicio, anguloInicio + angulo, PIE);
      anguloInicio += angulo;
    }
  }

  float leyendaX = x;
  float leyendaY = y + h + 10;
  textAlign(LEFT, CENTER);
  textSize(8);
  fill(255);

  int leyendaContador = 0;
  for (int i = 0; i < angulos.length; i++) {
    if (angulos[i] > 0) {
      fill(colores[i]);
      rect(leyendaX, leyendaY + leyendaContador * 20, 12, 12);
      fill(255);
      text(etiquetas[i], leyendaX + 18, leyendaY + leyendaContador * 20 + 6);
      leyendaContador++;
    }
  }
}

void generarColores() {
  colorBarra1 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorBarra2 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorBarra3 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorBarra4 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorBarra5 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));

  colorTorta1 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorTorta2 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorTorta3 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorTorta4 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorTorta5 = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
  colorTortaOtros = color(int(random(10, 50)), int(random(120, 255)), int(random(10, 50)));
}
