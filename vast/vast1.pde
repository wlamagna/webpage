import java.util.Map;
import java.util.Set;
import java.util.Iterator;
float x, y;
PImage raster;
HScrollbar hs1;
String[] pieces;
String[] lines;
float elderPos = 0;
float w_start = 24.827084851655627; // Longtitude start (largest longitude value)
float w_end = 24.909851153642382; // Longtitude end (smallest longitude value)
float h_start = 36.09119884569536; // Latitude start (largest latitude value)
float h_end = 36.04759569072847; // Latitude end (smallest latitude value)
int mapX1, mapX2, mapY1, mapY2;
String ultima_fecha = "";
boolean circleOver = false;
HashMap<String,Float> hm_pos_x = new HashMap<String,Float>();
HashMap<String,Float> hm_pos_y = new HashMap<String,Float>();
HashMap<String,Integer> hm = new HashMap<String,Integer>();
HashMap<String,Integer> hm_ids = new HashMap<String,Integer>();
HashMap<String,Integer> hm_checkbox = new HashMap<String,Integer>();
int[] colores = new int[42];
int tamanio_checkbox = 20;
int x_checkboxes = 660;
int y_checkboxes = 100;
int longitud_historia = 5;
int[] ancho = new int[longitud_historia];

void setup() {
    // Map coordinate (start and end points)
    frameRate(25);
    ancho[0] = 20;
    ancho[1] = 18;
    ancho[2] = 16;
    ancho[3] = 15;
    ancho[4] = 14;
    ancho[5] = 13;
    ancho[6] = 12;
    ancho[7] = 11;
    ancho[8] = 10;
    ancho[9] = 8;
    for (int i = 10; i < (longitud_historia-1); i++) {
      ancho[i] = 7;
    }
    size(1078, 545);
    ellipseMode(CENTER);
    smooth();
    lines = loadStrings("gps_20.reverse.csv");
    raster = loadImage("MC2-tourist_plus_gps_abila_track34.jpg");
    image(raster, 0, 0);
    hs1 = new HScrollbar(0, 20, width, 16, 11);
    mapX1 = 0;
    mapX2 = width;
    mapY1 = 0;
    mapY2 = height;
    // Son 40 asignaciones de vehiculos

//     x = map(24.860441834437083, w_start, w_end, mapX1, mapX2);
//     y = map(36.0898718843046356, h_start, h_end, mapY1, mapY2); 
//     ellipse(x, y, 10, 10);

    colores[0] = #8dd3c7;
    colores[1] = #ffffb3;
    colores[2] = #bebada;
    colores[3] = #fb8072;
    colores[4] = #80b1d3;
    colores[5] = #fdb462;
    colores[6] = #b3de69;
    colores[7] = #fccde5;
    colores[8] = #d9d9d9;
    colores[9] = #bc80bd;
    colores[10] = #ccebc5;
    colores[11] = #ffed6f;
    colores[12] = #a6cee3;
    colores[13] = #1f78b4;
    colores[14] = #b2df8a;
    colores[15] = #33a02c;
    colores[16] = #fb9a99;
    colores[17] = #e31a1c;
    colores[18] = #fdbf6f;
    colores[19] = #ff7f00;
    colores[20] = #cab2d6;
    colores[21] = #6a3d9a;
    colores[22] = #ffff99;
    colores[23] = #b15928;
    colores[24] = #a50026;
    colores[25] = #d73027;
    colores[26] = #f46d43;
    colores[27] = #fdae61;
    colores[28] = #fee08b;
    colores[29] = #ffffbf;
    colores[30] = #d9ef8b;
    colores[31] = #a6d96a;
    colores[32] = #66bd63;
    colores[33] = #1a9850;
    colores[34] = #006837;
    colores[35] = #ffffff;
    colores[36] = #ff0000;
    colores[37] = #00ff00;
    colores[38] = #0000ff;
    for (int i=39; i<42; i++) {
    colores[i] = #000000;
    }
}


void graficar_checkbox(int uncolor, int lugar, String clave) {
  stroke(255);
  // Grafico el checkbox para todos
  rect(x_checkboxes, y_checkboxes-30, tamanio_checkbox, tamanio_checkbox);
  color c2 = color(uncolor);
  fill(c2);
  int linea = 0;
  if (lugar > 19) {
    lugar = lugar - tamanio_checkbox;
    linea = 25;
  }
  //println("graficar_checkbox()" + lugar);
  rect(x_checkboxes + (lugar*tamanio_checkbox), y_checkboxes + linea, tamanio_checkbox, tamanio_checkbox);
  // Si esta checkeado
  if (hm_checkbox.get(clave) != null) {
    if (hm_checkbox.get(clave) == 1) {
      fill(color(0));
      ellipse((x_checkboxes+(lugar*tamanio_checkbox))+(tamanio_checkbox/2), (y_checkboxes+linea)+(tamanio_checkbox/2), 10,10);
     // println("Chequeando Automatico! " + clave );
    }
  }
}


void draw () {
  //float topPos = hs1.getPos();
  float topPos = hs1.getPos();

  // valor minimo: 1389000511
  // valor maximo: 1390175797
  int intervalo = 1390175797 - 1389000481;
  //println(topPos);
  long slot = ((int(topPos) * intervalo) / 1077) + 1389000511;

  //println(int(topPos) + ", " + slot);
  if (topPos != elderPos) {
    elderPos = topPos;
    image(raster, 0, 0);
    hm.clear();
    hm_pos_x.clear();
    hm_pos_y.clear();
    int ubicacion = 0;
    for (int i = 0; i < lines.length; i++) {
      pieces = split(lines[i], ",");
      if (hm_ids.get(pieces[1]) == null) {
         hm_ids.put(pieces[1], ubicacion);
         ubicacion = ubicacion + 1;
      }
    }
    // Los datos estan ordenados al revez, por eso se comienza de lo mas nuevo a lo mas
    // viejo, y asi me aseguro que cuando grafica es de mas nuevo a mas viejo.
    for (int i = 0; i < lines.length; i++) {
      pieces = split(lines[i], ",");
      // Validar si grafico este id o no
      //
      if (hm_checkbox.get(pieces[1]) != null) {
       if (hm_checkbox.get(pieces[1]) == 1) {
          continue;
        }
      }
      // Graficar IDs:
      if (pieces[4] < slot) {
        if (ultima_fecha == "") {
          ultima_fecha = pieces[0];
        }
        float mapX = float(pieces[2]);
        float mapY = float(pieces[3]);
        x = map(mapY, w_start, w_end, mapX1, mapX2);
        y = map(mapX,  h_start, h_end, mapY1, mapY2); 
        if (hm.get(pieces[1]) != null) {
          int cuantos = hm.get(pieces[1]);
          if (cuantos > longitud_historia) {
            continue;
          }
          // cuantos puntos he graficado de este id ?
          hm.put(pieces[1], (cuantos+1));
          strokeWeight(ancho[cuantos-1]);
          color c2 = color(colores[hm_ids.get(pieces[1])], 120);
          line(hm_pos_x.get(pieces[1]), hm_pos_y.get(pieces[1]), x, y);
          stroke(c2);
          hm_pos_x.put(pieces[1], x);
          hm_pos_y.put(pieces[1], y);
        } else {
          hm.put(pieces[1], 1);
          hm_pos_x.put(pieces[1], x);
          hm_pos_y.put(pieces[1], y);
        }
        //println(hm.get(pieces[1]));
        //println(pieces[0]);
        //if (float(pieces[1]) == 31) {
        color c2 = color(25,10,10);
        //println(mapX + " " + mapY + " " + width);
        ellipse(x, y, 4, 4);
        fill(c2);
      }
    }
    //println(slot);
    text(ultima_fecha,900,90);
    ultima_fecha = "";

    int linea = 0;
    Set set = hm_ids.entrySet();
    Iterator i = set.iterator();
    while(i.hasNext()) {
      Map.Entry me = (Map.Entry)i.next();
      graficar_checkbox(colores[int(me.getValue().toString())], int(me.getValue().toString()), me.getKey().toString());
    }
  }
  update(10, hm_pos_x, hm_pos_y, hm);
  //println(slot);
  hs1.update();
  hs1.display();
}


void mousePressed() {
  Set set = hm_ids.entrySet();
  Iterator i = set.iterator();
  int marcar_todos = 0; 
  if (overCheckbox(x_checkboxes, y_checkboxes-30, tamanio_checkbox)) {
    println("mark all");
    marcar_todos = 1;  
  }
  while(i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    int linea = 0;
    int lugar = int(me.getValue().toString());
    if (lugar > 19) {
      lugar = lugar - tamanio_checkbox;
      linea = 25;
    }
    if (marcar_todos == 1 ) {
      hm_checkbox.put(me.getKey().toString(), 1);
      fill(color(0));
      ellipse((x_checkboxes+(lugar*tamanio_checkbox))+(tamanio_checkbox/2), (y_checkboxes+linea)+(tamanio_checkbox/2), 10,10);
    }
    if (overCheckbox(x_checkboxes + (lugar * tamanio_checkbox), (y_checkboxes + linea), tamanio_checkbox)) {
      if ((hm_checkbox.get(me.getKey()) == null) || (hm_checkbox.get(me.getKey().toString()) == 0)) {
        hm_checkbox.put(me.getKey().toString(), 1);
        fill(color(0));
        ellipse((x_checkboxes+(lugar*tamanio_checkbox))+(tamanio_checkbox/2), (y_checkboxes+linea)+(tamanio_checkbox/2), 10,10);
        println("Chequeando! " + me.getKey().toString());
      } else {
        hm_checkbox.put(me.getKey().toString(), 0);
        graficar_checkbox(colores[int(me.getValue().toString())], int(me.getValue().toString()),me.getKey().toString() );
        //println("Des Chequeando! " + me.getValue().toString());
      }
    }
  }
}

class HScrollbar {
  int swidth, sheight;    // width and height of bar
  float xpos, ypos;       // x and y position of bar
  float spos, newspos;    // x position of slider
  float sposMin, sposMax; // max and min values of slider
  int loose;              // how loose/heavy
  boolean over;           // is the mouse over the slider?
  boolean locked;
  float ratio;

  HScrollbar (float xp, float yp, int sw, int sh, int l) {
    swidth = sw;
    sheight = sh;
    int widthtoheight = sw - sh;
    ratio = (float)sw / (float)widthtoheight;
    xpos = xp;
    ypos = yp-sheight/2;
    spos = xpos + swidth/2 - sheight/2;
    newspos = spos;
    sposMin = xpos;
    sposMax = xpos + swidth - sheight;
    loose = l;
  }

  void update() {
    if (overEvent()) {
      over = true;
    } else {
      over = false;
    }
    if (mousePressed && over) {
      locked = true;
    }
    if (!mousePressed) {
      locked = false;
    }
    if (locked) {
      newspos = constrain(mouseX-sheight/2, sposMin, sposMax);
    }
    if (abs(newspos - spos) > 1) {
      spos = spos + (newspos-spos)/loose;
    }
  }

  float constrain(float val, float minv, float maxv) {
    return min(max(val, minv), maxv);
  }

  boolean overEvent() {
    if (mouseX > xpos && mouseX < xpos+swidth &&
       mouseY > ypos && mouseY < ypos+sheight) {
      return true;
    } else {
      return false;
    }
  }

  void display() {
    noStroke();
    fill(204);
    rect(xpos, ypos, swidth, sheight);
    if (over || locked) {
      fill(0, 0, 0);
    } else {
      fill(102, 102, 102);
    }
    rect(spos, ypos, sheight, sheight);
  }

  float getPos() {
    // Convert spos to be values between
    // 0 and the total width of the scrollbar
    return spos * ratio;
  }
}

    void update(int circleSize, HashMap circleX, HashMap circleY, HashMap hm) {
      Set set = hm.entrySet();
      Iterator i = set.iterator(); 
      while(i.hasNext()) {
        Map.Entry me = (Map.Entry)i.next();
        //System.out.print(me.getKey() + ": ");
        //String clave = me.getKey().toString();
        //println( me.getKey());
        //println(Float.parseFloat(circleX.get(me.getKey().toString()).toString()), ": " + Float.parseFloat(circleY.get(me.getKey().toString()).toString()));
        float lax = (circleX.get(me.getKey().toString()).toString());
        float lay = (circleY.get(me.getKey().toString()).toString());
        if (overCircle(lax, lay, circleSize)) {
          text("Id:" + me.getKey().toString(),900,130);
          color c2 = color(0,0,250);
          ellipse(lax, lay, 10, 10);
          stroke(c2);
        } else {
        //System.out.println(me.getValue());

        }
      }
    }

    boolean overCircle(float x_o, float y_o, int diameter) {
      float disX = x_o - mouseX;
      float disY = y_o - mouseY;
      if(sqrt(sq(disX) + sq(disY)) < diameter/2 ) {
        return true;
      } else {
        return false;
      }
    }

    // Check if the mouse is over the checkbox
    boolean overCheckbox(int x_o, int y_o, int size) {
      float disX = x_o - mouseX;
      float disY = y_o - mouseY;
      if ((mouseX > (x_o)) & (mouseX < (x_o + size)) & (mouseY > y_o) & (mouseY < (y_o + size))) { 
        return true;
      } else {
        return false;
      }
    }
