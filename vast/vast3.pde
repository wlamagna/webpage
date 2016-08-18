import java.util.Map;
import java.util.Set;
import java.util.Iterator;

HScrollbar hs1, hs2;
float x, y;
PImage raster;
float tmp_pos_destino;
float tmp_pos_origen;
long min_epoch = 0;
long max_epoch = 0;
long epoch_limite_inferior;
long epoch_limite_superior;
String[] pieces;
String[] lines;
//float w_start = 24.827084851655627; // Longtitude start (largest longitude value)
float w_start = 24.82321911871689; // Longtitude start (largest longitude value)

//float w_end = 24.909851153642382; // Longtitude end (smallest longitude value)
float w_end = 24.91072532181327; // Longtitude end (smallest longitude value)

//float h_start = 36.09119884569536; // Latitude start (largest latitude value)
float h_start = 36.09572205560992; // Latitude start (largest latitude value)

//float h_end = 36.04759569072847; // Latitude end (smallest latitude value)
float h_end = 36.044261454053895; // Latitude end (smallest latitude value)
//String lugargps;
//int catsClicked;
int mapX1, mapX2, mapY1, mapY2;
HashMap<String,Integer> hm_events = new HashMap<String,Integer>();
boolean circleOver = false;
int width_imagen = 780;
int height_imagen = 545;
// Zoom:
int updown = 0;
int leftright = 0;
int zoom = 1;
// ------------------
boolean debo_continuar = false;
boolean epoch_setup = true;
int ancho_scrollbar = 200;
int alto_scrollbar = 14;
boolean update_scroller = false;
boolean locked = false;
float xOffset = 0.0; 
float yOffset = 0.0;
float bx;
float by;

void setup() {
    background(255);

    size(width_imagen, height_imagen);
    ellipseMode(CENTER);
    smooth();
    raster = loadImage("MC2_Finalmap5.jpg");
    image(raster, 0, 0, width_imagen, height_imagen);
    mapX1 = 0;
    mapX2 = width_imagen;
    mapY1 = 0;
    mapY2 = height;
	bx = width/2.0;
	by = height/2.0;
	hs1 = new HScrollbar(width_imagen-(ancho_scrollbar+30), 20, ancho_scrollbar, 13, 11);
	hs2 = new HScrollbar(width_imagen-(ancho_scrollbar+30), 40, ancho_scrollbar, 13, 11);
}

    // Check if the mouse is over the checkbox
    boolean overCheckbox(int x_o, int y_o, int x_d, int y_d) {
      float disX = x_o - mouseX;
      float disY = y_o - mouseY;
      if ((mouseX > (x_o)) & (mouseX < (x_d)) & (mouseY > y_o) & (mouseY < (y_d))) {
        return true;
      } else {
        return false;
      }
    }


void mousePressed() {
	if (overCheckbox(width_imagen-(ancho_scrollbar+40), 10, (width_imagen), 80)) {
		update_scroller = true;
	} else {
		update_scroller = false;
		fill (random(0,255), random(0,255), random(0,255), 50);
		locked = true;
		xOffset = mouseX;
		yOffset = mouseY;
	}
}

void mouseReleased() {
	if (locked) {
		locked = false;
	float min_x = map(xOffset, mapX1, mapX2, w_start, w_end);
	float min_y = map(yOffset, mapY1, mapY2, h_start, h_end);
	float max_x = map(mouseX, mapX1, mapX2, w_start, w_end);
	float max_y = map(mouseY, mapY1, mapY2, h_start, h_end);
	top.frames['texto'].cargar_seleccionados(min_x + "," + min_y + "," + max_x + "," + max_y + "," + epoch_limite_inferior + "," + epoch_limite_superior );
	}
//	update_scroller = false;
}

void draw () {
  // valor minimo: 1389000511
  // valor maximo: 1390175797
  // 1401591600 = 0:0:0 1/6/2014
  // 86400 son los segundos en un dia
  int intervalo = 86400;
	if (locked) {
		catsClicked = 1;
	}
  // Zoom
   if(catsClicked != 0){
      background(255);
      noStroke();
      image(raster, 0, 0, width_imagen, height_imagen);
      textSize(10);
      String[] total;
      total = split(lugargps, ",");
      int k = 0;
	for (k=0; k < total.length; k++) {
        //pieces = split(lugargps, ",");
        pieces = split(total[k], ":");
	float mapX = float(pieces[0]);
        float mapY = float(pieces[1]);
        x = map(mapY, w_start, w_end, mapX1, mapX2);
        y = map(mapX,  h_start, h_end, mapY1, mapY2);
        hm_events.put(lugargps, x + ":" + y + ":" + pieces[2]);
        Set set = hm_events.entrySet();
        Iterator i = set.iterator();
		while(i.hasNext()) {
			Map.Entry me = (Map.Entry)i.next();
			String lonlat = me.getValue().toString();
			String[] sub_pieces = split(lonlat, ":");
			float x1, y1;
			if (epoch_setup) {
				if ((min_epoch == 0) || (min_epoch > int(sub_pieces[2]))) {
					if (sub_pieces[2] != "undefined") {
						min_epoch = int(sub_pieces[2]);
					}
				}
				if ((max_epoch == 0) || (max_epoch < int(sub_pieces[2]))) {
					if (sub_pieces[2] != "undefined") {
						max_epoch = int(sub_pieces[2]);
					}
				}
//console.log(min_epoch + "," + sub_pieces[2]);
			}
			if ((int(sub_pieces[2]) > epoch_limite_inferior) && (int(sub_pieces[2]) < epoch_limite_superior)) {
				x1 = sub_pieces[0];
				y1 = sub_pieces[1];
				strokeWeight(10);
			//color c2 = color(255,0,0, 10);
				fill(255,0,0,130)
				ellipse(x1, y1, 10, 10);
			}
			catsClicked = 0;//resets the variable back to an inactive state
		}
	}
	epoch_setup = false;
	hs1.display();
	hs2.display();
	if (locked) {
          	fill(0,0,255,127);
		rect(xOffset, yOffset, mouseX-xOffset,mouseY-yOffset);
	}
	}
	if (update_scroller) {
		hs1.update();
		hs2.update();
		hs1.display();
		hs2.display();
		catsClicked = 1;
		tmp_pos_destino = hs1.getPos() - 589;
		tmp_pos_origen = hs2.getPos() - 589;
		if (tmp_pos_origen < 0) {
			tmp_pos_origen = 0;
		}
		if (tmp_pos_destino < 0) {
			tmp_pos_destino = 0;
		}
		epoch_limite_inferior = (map(tmp_pos_origen, 0, 198, min_epoch, max_epoch));
		epoch_limite_superior = (map(tmp_pos_destino, 0, 198, min_epoch, max_epoch));
		//"1390507200 < 1390518000"
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


