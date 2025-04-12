// Texto de ejemplo para mostrar en ventana desplazable
String original_text = "Bienvenido, introduce un ID\npara comenzar";

// Limitamos el texto a 90 líneas
String visible_text = limitar(original_text, 90);

// Entrada de texto por teclado
String input_text = "";

// Coordenadas y dimensiones del cuadro de entrada de texto
int input_box_x = 220, input_box_y = 80, input_box_width = 270, input_box_height = 40;

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
ButtonIcon button_quit; //Quitar - retroceder

// Colores usados en la interfaz
color color_highlight = color(29, 185, 84);
color color_default = color(80);
color color_hover = color(0);
color color_background = color(30);

void inicializarGUI() {
  // Definimos la zona del texto desplazable
  scroll_window_x = width / 2;
  scroll_window_y = 150;
  scroll_window_width = width / 2 - 40;
  scroll_window_height = height - (scroll_window_y + 30);

  // Creamos botones

  //Funcionalidades
  button_art_max = new ButtonText(40, 200, width / 2 - 80, 50, "Destacados", () -> obtenerDestacados());
  button_graficas = new ButtonText(40, 280, width / 2 - 80, 50, "Graficas", () -> println("en proceso"));
  button_mas = new ButtonText(40, 360, width / 2 - 80, 50, "Mas", () -> println("en proceso"));
  button_buscar = new ButtonText(input_box_x + input_box_width + 50, input_box_y, 90, input_box_height, "Buscar", () -> obtenerCrearArchivos());

  //Quitar
  float w_quit =40, h_quit = 30;
  float x_quit =input_box_x +input_box_width - (w_quit+10), y_quit = input_box_y + 5;
  button_quit = new ButtonIcon(x_quit, y_quit, w_quit, h_quit, () -> input_text = "", 1);
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
  fill(255);
  textSize(35);
  text("Playlist ID:", input_box_x - 110, input_box_y + 15);
  textSize(20);
  fill(color_default);
  rect(input_box_x, input_box_y, input_box_width, input_box_height, 10);
  fill(color_highlight);
  

  // Mostrar botones
  button_art_max.display();
  button_graficas.display();
  button_mas.display();
  button_buscar.display();
  if(input_text != ""){
      button_quit.display();
  }
  textAlign(LEFT, TOP);




  String[] lines = input_text.split("\n");
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
