// CLASES //
class ElementoGUI {
  protected float x, y, w, h;
  protected Behavior behavior;
  protected color color_df = color_default, color_hv = color_hover, color_hl = color_highlight;


  ElementoGUI(float x, float y, float w, float h, Behavior behavior) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
    this.behavior = behavior;
  }

  // Getters
  public float getX() {
    return this.x;
  }

  public float getY() {
    return this.y;
  }

  public float getW() {
    return this.w;
  }

  public float getH() {
    return this.h;
  }

  public color getColorDf() {
    return this.color_df;
  }

  public color getColorHv() {
    return this.color_hv;
  }

  public color getColorHl() {
    return this.color_hl;
  }

  // Setters
  public void setX(float x) {
    this.x = x;
  }

  public void setY(float y) {
    this.y = y;
  }

  public void setW(float w) {
    this.w = w;
  }

  public void setH(float h) {
    this.h = h;
  }

  public void setColorDf(color color_df) {
    this.color_df = color_df;
  }

  public void setColorHv(color color_hv) {
    this.color_hv = color_hv;
  }

  public void setColorHl(color color_hl) {
    this.color_hl = color_hl;
  }
}

// Botones

abstract class Button extends ElementoGUI {
  Button(float x, float y, float w, float h, Behavior behavior) {
    super(x, y, w, h, behavior);
  }

  boolean is_pressed(int mx, int my) {
    return mx >= this.x && mx <= this.x + this.w && my >= this.y && my <= this.y + this.h;
  }

  public boolean is_hovered(int mx, int my) {
    return is_pressed(mx, my);
  }

  abstract public void display();

  public void click() {
    if (!this.isHide()) {
      if (is_pressed(mouseX, mouseY)) {
        behavior.run();
      }
    }
  }

  public void execute() {
    behavior.run();
  }

  public boolean isHide() {
    if (alpha(this.color_hl) < 249) {
      return true;
    }
    return false;
  }
}

class ButtonText extends Button {
  private String label;

  ButtonText(float x, float y, float w, float h, String label, Behavior behavior) {
    super(x, y, w, h, behavior);
    this.label = label;
  }

  /*ButtonText(float x, float y, float w, float h, String label, Behavior behavior, color color_df, color color_hv){
   super(x, y, w, h, behavior);
   this.color_df = color_df;
   this.color_hv = color_hv;
   }*/
  @Override
    void display() {
    if (is_hovered(mouseX, mouseY)) {
      if (!this.isHide()) {
        fill(color_hv);
      } else {
        fill(color_df);
      }
    } else {
      fill(color_df);
    }

    stroke(color_hl);
    rect(x, y, w, h, 15);

    fill(color_hl);
    textAlign(CENTER, CENTER);
    text(label, x + w / 2, y + h / 2);
  }
}

class ButtonIcon extends Button {
  private int typeIcon;
  ButtonIcon(float x, float y, float w, float h, Behavior behavior, int typeIcon) {
    super(x, y, w, h, behavior);
    this.typeIcon = typeIcon;
    this.color_hv = color (0, 0, 0, 75);
    this.color_df = color (0, 0, 0, 1);
  }
  
  public void Setx(float nx){
    x = nx;
  }
  public void Sety(float ny){
    y = ny;
  }
  @Override
    public void display() {

    // Cambia el color de fondo si el mouse está encima
    if (is_hovered(mouseX, mouseY)) {
      fill(color_hv);
    } else {
      fill(color_df);
    }

    // Dibuja el fondo del botón con bordes redondeados
    noStroke();
    rect(x, y, w, h, 5);


    // Dibujo del ícono según this.typeIcon
    float padding = w * 0.225;
    float x1 = x + padding;
    float y1 = y + padding;
    float x2 = x + w - padding;
    float y2 = y + h - padding;

    stroke(color_hl);
    strokeWeight(3);

    switch(this.typeIcon) {
    case 1: // "quit" - X
      line(x1, y1, x2, y2); // Diagonal \
      line(x1, y2, x2, y1); // Diagonal /
      break;

    case 2: // "back" - flecha a la izquierda
      float centerY = y + h / 2;
      float arrowHead = w * 0.15;
      float arrowTail = w * 0.6;

      line(x + arrowTail + 8, centerY, x + padding, centerY); // línea horizontal
      line(x + padding, centerY, x + padding + arrowHead, centerY - arrowHead); // cabeza arriba
      line(x + padding, centerY, x + padding + arrowHead, centerY + arrowHead); // cabeza abajo
      break;

    case 3: // "recovert" - ícono de doble flecha curva

      noFill();
      stroke(color_highlight);
      strokeWeight(2);

      // Flecha curva superior (de izquierda a derecha)
      arc(x + w/2, y + h/2, w * 0.8, h * 0.8, PI + QUARTER_PI, TWO_PI - QUARTER_PI);

      // Punta de flecha derecha
      float arrow1X = x + w/2 + cos(TWO_PI - QUARTER_PI) * (w * 0.4);
      float arrow1Y = y + h/2 + sin(TWO_PI - QUARTER_PI) * (h * 0.4);
      line(arrow1X, arrow1Y, arrow1X - 6, arrow1Y - 6);
      line(arrow1X, arrow1Y, arrow1X - 6, arrow1Y + 6);

      // Flecha curva inferior (de derecha a izquierda)
      arc(x + w/2, y + h/2, w * 0.8, h * 0.8, QUARTER_PI, PI - QUARTER_PI);

      // Punta de flecha izquierda
      float arrow2X = x + w/2 + cos(QUARTER_PI) * (w * 0.4) * -1;
      float arrow2Y = y + h/2 + sin(QUARTER_PI) * (h * 0.45);
      line(arrow2X, arrow2Y, arrow2X + 6, arrow2Y - 6);
      line(arrow2X, arrow2Y, arrow2X + 6, arrow2Y + 6);

      break;
    }
    fill(color_highlight);
    strokeWeight(1);
  }
}

//Proccesing no permite crear variables estaticas en las clases internas, por se tuvo que hacer esta fealdad tecnica
NoticeWindow activeWindow = null;

// Ventanas emergentes
public class NoticeWindow extends ElementoGUI {
  private String label;
  private float target_y;
  private float original_y;
  private int time_start;
  private boolean is_start = false, is_cerrar = false;
  private NoticeWindow newNoticeWindow;
  NoticeWindow(float x, float y, float w, float h, String label, color color_df, Behavior behavior) {
    super(x, y, w, h, behavior);
    this.label = label;
    this.target_y = this.y + 70;
    this.original_y = this.y;
    this.color_df = color_df;
  }

  // Para mostrar la ventana
  public void mostrar() {
    if (!this.is_cerrar) {
      if (!this.is_start) {
        this.time_start = millis();
        is_start = true;
      }
      noStroke();
      fill(this.color_df);
      rect(this.x, this.y, this.w, this.h, 10);
      textAlign(LEFT, TOP);
      text(this.label, this.x + 15, this.y + 10);
      textAlign(CENTER, CENTER);
      fill(0);
      stroke(color_highlight);
      if (millis() - time_start < 5000) {
        this.y = lerp(this.y, target_y, 0.1);
      } else {
        this.y = lerp(this.y, original_y, 0.1);
      }
    } else {
      cerrar(newNoticeWindow);
    }
  }

  public void cerrar(NoticeWindow newNoticeActive) {
    if (!this.is_cerrar) {
      this.is_cerrar = true;
      this.newNoticeWindow = newNoticeActive;
    }
    fill(color_df);
    rect(this.x, this.y, this.w, this.h, 10);
    textAlign(LEFT, TOP);
    text(label, x + 15, y + 10);
    textAlign(CENTER, CENTER);
    fill(0);
    this.y = lerp(this.y, original_y, 0.1);

    if (abs(this.y - original_y) <= 0.1) {
      activeWindow = newNoticeActive;
    }
  }

  public void reset() {
    this.is_cerrar = false;
    this.is_start = false;
    this.newNoticeWindow = null;
  }
}

// Interfaces
@FunctionalInterface
  interface Behavior {
  void run();
}
