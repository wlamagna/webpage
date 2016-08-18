import java.util.Map;
import java.util.Set;
import java.util.Iterator;
float x, y;
PImage raster;
int dias_totales = 14;
HScrollbar hs1, hs2, hs3, hs4, hs5, hs6, hs7;
HScrollbar hs[] = new HScrollbar[dias_totales];
String[] pieces;
String[] lines;
float[] elderPos = new float[dias_totales];
//float w_start = 24.827084851655627; // Longtitude start (largest longitude value)
float w_start = 24.822380337254724; // Longtitude start (largest longitude value)

//float w_end = 24.909851153642382; // Longtitude end (smallest longitude value)
float w_end = 24.910343947660746; // Longtitude end (smallest longitude value)

//float h_start = 36.09119884569536; // Latitude start (largest latitude value)
float h_start = 36.100033488124794; // Latitude start (largest latitude value)

//float h_end = 36.04759569072847; // Latitude end (smallest latitude value)
float h_end = 36.04307970158421; // Latitude end (smallest latitude value)

int mapX1, mapX2, mapY1, mapY2;
String ultima_fecha[] = new String[dias_totales];
boolean circleOver = false;
HashMap<String,Float> hm_pos_x = new HashMap<String,Float>();
HashMap<String,Float> hm_pos_y = new HashMap<String,Float>();
HashMap<String,Integer> hm = new HashMap<String,Integer>();
HashMap<String,Integer> hm_ids = new HashMap<String,Integer>();
HashMap<String,Integer> hm_checkbox = new HashMap<String,Integer>();
int[] colores = new int[42];
int tamanio_checkbox = 20;
int x_checkboxes = 970;
int y_checkboxes = 250;
// Cuanto historial (sombra) por punto
int longitud_historia = 340;
int ancho_scrollbar = 200;
int alto_scrollbar = 14;
int x_scrollbar = 970;
int[] ancho = new int[longitud_historia+1];
int width_imagen = 962;
int height_imagen = 609;
// Zoom:
int updown = 0;
int leftright = 0;
int zoom = 1;
// ------------------
boolean debo_continuar = false;

void setup() {
    // Map coordinate (start and end points)
    frameRate(25);
    background(255);
    ancho[0] = 30;
    ancho[1] = 25;
    ancho[2] = 20;
    ancho[3] = 18;
    ancho[4] = 14;
    ancho[5] = 14;
    ancho[6] = 14;
    ancho[7] = 14;
    ancho[8] = 14;
    ancho[9] = 14;
    for (int i = 10; i < (longitud_historia-1); i++) {
      ancho[i] = 10;
    }
    //size(1078, 545);
    //size(962, 609);
    size(1300, 609);
    ellipseMode(CENTER);
    smooth();
    lines = loadStrings("gps_10.reverse.csv");
    raster = loadImage("MC2_FinalMapv5.jpg");
    image(raster, 0, 0);

    for (int i = 0; i < dias_totales; i++) {
      int j = i;
      int tmp_x_scroll = x_scrollbar;
      hs[i] = new HScrollbar(tmp_x_scroll, alto_scrollbar*(j+1), ancho_scrollbar, 13, 11);
    }

    mapX1 = 0;
    mapX2 = width_imagen;
    mapY1 = 0;
    mapY2 = height;
    // Inicializo el hashmap de cada vehiculo
    int ubicacion = 0;
    for (int i = 0; i < lines.length; i++) {
      pieces = split(lines[i], ",");
      if (hm_ids.get(pieces[1]) == null) {
         hm_ids.put(pieces[1], ubicacion);
         println(pieces[1] + ", " + ubicacion);
         ubicacion = ubicacion + 1;
      }
    }
    // Son 40 asignaciones de vehiculos
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
    colores[34] = #106830;
    colores[35] = #ffffff;
    colores[36] = #ff0000;
    colores[37] = #00ff00;
    colores[38] = #0000ff;
    for (int i=39; i<42; i++) {
      colores[i] = #202000;
    }
}


void graficar_checkbox(int uncolor, int lugar, String clave) {
  // Grafico el checkbox para todos
  //stroke(255);
  fill(color(#ffffff));
  rect(x_checkboxes, y_checkboxes-30, tamanio_checkbox, tamanio_checkbox);
  color c2 = color(uncolor);
  fill(c2);
  int linea = 0;
  int ubica_texto = 0;
  if ((lugar > 15) && (lugar < 32)) {
    lugar = lugar - 16;
    linea = 32;
    ubica_texto = 28;
  }
  if (lugar >= 32) {
    lugar = lugar - 32;
    linea = 60;
    ubica_texto = 58;
  }
  noStroke();
  //rect(x_checkboxes + (lugar*tamanio_checkbox), y_checkboxes + linea, tamanio_checkbox, tamanio_checkbox);
  rect(x_checkboxes + (lugar*tamanio_checkbox), y_checkboxes + linea, tamanio_checkbox, tamanio_checkbox);
  fill(color(#000000));
  textSize(10);
  text(clave, x_checkboxes+(lugar*tamanio_checkbox), y_checkboxes + ubica_texto);
  // Si esta checkeado
  if (hm_checkbox.get(clave) != null) {
    if (hm_checkbox.get(clave) == 1) {
      fill(color(0));
      ellipse((x_checkboxes+(lugar*tamanio_checkbox))+(tamanio_checkbox/2), (y_checkboxes+linea)+(tamanio_checkbox/2), 10,10);
      //println("Chequeando Automatico! " + clave );
    }
  }
}


void draw () {
  //float topPos = hs1.getPos();
  float topPos[] = new float[dias_totales];
  long slot[] = new long[dias_totales];
  long initial_slot_position[] = new long[dias_totales];
  // valor minimo: 1389000511
  // valor maximo: 1390175797
  // 1401591600 = 0:0:0 1/6/2014
  // 86400 son los segundos en un dia
  int intervalo = 86400;
  float restar = 1037.4331; 
  for (int i =0 ; i<dias_totales; i++) {
    topPos[i] = hs[i].getPos() - restar;
    initial_slot_position[i] = (1388977200+(intervalo*i));
    slot[i] = (int(topPos[i]) * (intervalo) / ancho_scrollbar) + initial_slot_position[i];
    //println("Slot " + i + ", value: " + slot[i] + " selected:" + topPos[i] + ". Position: " + hs[i].getPos());
  }
  for (int i=0; i<dias_totales; i++) {
    if (topPos[i] != elderPos[i]) {
      elderPos[i] = topPos[i];
      debo_continuar = true;
    }
  }
  if (debo_continuar) {
    debo_continuar = false;
    // Zoom
    background(255);
    scale(zoom);
    translate (leftright,updown);
    image(raster, 0, 0);
    //
    //println("======" + j + "====");
    // Los datos estan ordenados al revez, por eso se comienza de lo mas nuevo a lo mas
    // viejo, y asi me aseguro que cuando grafica es de mas nuevo a mas viejo.
    hm.clear();
    hm_pos_x.clear();
    hm_pos_y.clear();
    for (int i = 0; i < lines.length; i++) {
      pieces = split(lines[i], ",");
      // Validar si grafico este id o no
      if (hm_checkbox.get(pieces[1]) != null) {
        if (hm_checkbox.get(pieces[1]) == 1) {
          continue;
        }
      }
      // Graficar IDs, recorro los dias
      textSize(10);
      for (int j = 0; j<dias_totales; j++) {
          // Por cada dia (scroller), chequeo si hubo algun cambio
          if ((pieces[4] > initial_slot_position[j]) && (pieces[4] < slot[j])) {
            if (ultima_fecha[j] == null) {
              ultima_fecha[j] = pieces[0];
              //println(j + ":" + ultima_fecha[j] + ", From:" + initial_slot_position[j] + ", to: " + slot[j] + ". now: " + pieces[4]);
            }
            float mapX = float(pieces[2]);
            float mapY = float(pieces[3]);
            x = map(mapY, w_start, w_end, mapX1, mapX2);
            y = map(mapX,  h_start, h_end, mapY1, mapY2);
            // hm lleva control de cuantos puntos se graficaron por ID.
            // pieces[1] tiene el ID del vehiculo.  j es el dia. 
            if (hm.get(pieces[1] + "," + j) == null) {
              hm.put(pieces[1] + "," + j, 0);
            }
            //println("poniendo: " + pieces[1] + "," + j);
            // cuantos puntos he graficado de este id ?
            int cuantos = hm.get(pieces[1] + "," + j);
            cuantos = cuantos + 1;
            // Sumo uno al contador de cuantos puntos grafique para este ID, este dia.
            hm.put(pieces[1] + "," + j, cuantos);
            hm_pos_x.put(pieces[1] + "," + j + "," + cuantos, x);
            hm_pos_y.put(pieces[1] + "," + j + "," + cuantos, y);
            fill(255);
            rect(x_scrollbar+210, 8+alto_scrollbar+((j-1)*alto_scrollbar), 200, alto_scrollbar);
            fill(0);
            text(ultima_fecha[j],x_scrollbar+210,6+alto_scrollbar+(j*alto_scrollbar));
            //println(alto_scrollbar + ", " + i + ". En:" + x_scrollbar);
            ultima_fecha[j] = null;
          }
      }
    }
    //hm_ids.put(pieces[1], ubicacion);
    Set set = hm_ids.entrySet();
    Iterator s = set.iterator();
    while(s.hasNext()) {
      Map.Entry me = (Map.Entry)s.next();
      String porid = me.getValue().toString();
      porid = me.getKey().toString();
      // Validar si grafico este id o no
      if (hm_checkbox.get(porid) != null) {
        if (hm_checkbox.get(porid) == 1) {
          continue;
        }
        //porid = "106";
      }
      //porid = me.getKey().toString();
      for (int j = 0; j<dias_totales; j++) {
          // cuantos puntos he graficado de este id ?
          if (hm.get(porid + "," + j) == null) {
             //println("no grafico! " + porid + "," + j );
             continue;
          }
          int cuantos = hm.get(porid + "," + j);
          // Una vez leidos los puntos a graficar, los grafico    
          int contadorcito = 0;
          for (int m=cuantos; m>0; m--) {
            if (contadorcito >= longitud_historia) {
               continue;
            }
            //println("grafico! [" + m + "/" + cuantos + "]" + contadorcito);
            contadorcito = contadorcito + 1;
            strokeWeight(ancho[contadorcito]);
            color c2 = color(colores[hm_ids.get(porid)], 80);
            stroke(c2);
            x = hm_pos_x.get(porid + "," + j + "," + m);
            y = hm_pos_y.get(porid + "," + j + "," + m);
            if (m < cuantos) {
              line(hm_pos_x.get(porid + "," + j + "," + (m+1)), hm_pos_y.get(porid + "," + j + "," + (m+1)), x, y);
            }
            ellipse(x, y, 2, 2);
            noStroke();
          }
      }
    }

    scale(1);
    textSize(10);
    for (int i = 0; i<dias_totales; i++) {
      //println(slot);
      int k = i;
      int tmp_x_scroll = x_scrollbar;
      if (ultima_fecha[i] != null) {
        text(ultima_fecha[i],tmp_x_scroll+210,6+alto_scrollbar+(k*alto_scrollbar));
        //println(alto_scrollbar + ", " + i + ". En:" + x_scrollbar);
        ultima_fecha[i] = null;
      }
    }
  }
  /*scale(1);
  translate(0,0);
  fill(209);
  noStroke();  
  rect(900, 0, 510, 1020);*/
  Set set = hm_ids.entrySet();
  Iterator i = set.iterator();
  while(i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    graficar_checkbox(colores[int(me.getValue().toString())], int(me.getValue().toString()), me.getKey().toString());
    //println("grafico checkbox:" +  me.getKey().toString());
  }
  for (int j = 0; j< dias_totales; j++) {
    hs[j].update();
    hs[j].display();
  }

}




void mousePressed() {
  Set set = hm_ids.entrySet();
  Iterator i = set.iterator();
  int marcar_todos = 0;
  //Si quiere marcar todos:
  if (overCheckbox(x_checkboxes, y_checkboxes-30, tamanio_checkbox)) {
//    println("mark all");
    marcar_todos = 1;  
  }
  while(i.hasNext()) {
    Map.Entry me = (Map.Entry)i.next();
    int linea = 0;
    int lugar = int(me.getValue().toString());
    if ((lugar > 15) && (lugar < 32)) {
      lugar = lugar - 16;
      linea = 32;
    }
    if (lugar >= 32) {
      lugar = lugar - 32;
      linea = 60;
    }
    if (marcar_todos == 1) {
      hm_checkbox.put(me.getKey().toString(), 1);
    } else {
      if (overCheckbox(x_checkboxes + (lugar * tamanio_checkbox), (y_checkboxes + linea), tamanio_checkbox)) {
        if ((hm_checkbox.get(me.getKey()) == null) || (hm_checkbox.get(me.getKey().toString()) == 0)) {
          hm_checkbox.put(me.getKey().toString(), 1);
          fill(color(0));
          ellipse((x_checkboxes+(lugar*tamanio_checkbox))+(tamanio_checkbox/2), (y_checkboxes+linea)+(tamanio_checkbox/2), 10,10);
          //println("Chequeando! " + me.getKey().toString());
        } else {
          hm_checkbox.put(me.getKey().toString(), 0);
          graficar_checkbox(colores[int(me.getValue().toString())], int(me.getValue().toString()),me.getKey().toString() );
          //println("Des Chequeando! " + me.getValue().toString());
        }
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
    // fuerzo a que el slider este al principio
    spos = xpos;
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
        Float lax = Float.parseFloat(circleX.get(me.getKey().toString()).toString());
        Float lay = Float.parseFloat(circleY.get(me.getKey().toString()).toString());
        if (overCircle(lax, lay, circleSize)) {
          text("Id:" + me.getKey().toString(),900,130);
          color c2 = color(0,0,250);
          ellipse(lax, lay, 10, 10);
          stroke(c2);
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
    
    
void keyPressed() {
     if (key == CODED) {
       if (keyCode == UP) {
       updown = updown-50;
       debo_continuar = true;
   } else
       if (keyCode == DOWN) {
       updown = updown+50;
       debo_continuar = true;
   } else
       if (keyCode == LEFT) {
       leftright = leftright-50;
       debo_continuar = true;
  }  else
       if (keyCode == RIGHT) {
       leftright = leftright+50;
       debo_continuar = true;
     }  
  }

   if(key == '+') {
   zoom = 2;
   println(zoom);
 } else if (key == '-') {
   leftright =0;
   updown = 0;
   zoom = 1;
   println(zoom);
 }
}
