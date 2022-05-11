int N = 2000;

float[] angles = new float[N];
float[] cn = new float[N];
FloatList X = new FloatList();
FloatList Y = new FloatList();

float angle = 0;
float speed = 0.005;


Fasore[] fasori = new Fasore[N]; 

void setup() {
  size(1000, 1000);
  frameRate(60);
  colorMode(HSB,360);
  
  String[] lines = loadStrings("output.txt");
  for(int i=0;i<N;i+=1){
    String[] parts = lines[i].split(";");
    fasori[i] = new Fasore(float(parts[0]),float(parts[1]),float(parts[2]));
  }
}

void draw() {
  background(10);
  float sumX = 0;
  float sumY = 0;
  colorMode(RGB,256);
  stroke(255, 255, 255);
  strokeWeight(1);
  //Draws the arrows and calculates the new positions
  for (int i=0; i<N; i++) {
    if(fasori[i].speed == 0) continue;
    float len = 750 * fasori[i].modulo;
    float fromX = width/2 + sumX;
    float fromY = height/2 + sumY;
    float xDist = len*cos(fasori[i].argomento);
    float yDist = len*sin(fasori[i].argomento);
    float toX = fromX + xDist;
    float toY = fromY + yDist;
    arrow(fromX,fromY, toX, toY, fasori[i].argomento, len);
    sumX += xDist;
    sumY += yDist;
    //Il fasore i-esimo ruota ad una velocità i*omega (omega = speed)
    fasori[i].argomento += fasori[i].speed * speed;
  }
  X.append(width/2 + sumX);
  Y.append(height/2 + sumY);
  
  //Drawing lines between the previus ending point of the arrows
  colorMode(HSB,360,360,360);
  for (int i=0; i<X.size()-1; i++) {
    float angle = atan2(Y.get(i)-height/2,X.get(i)-width/2);
    if(angle<0){
      angle += 2*PI;
    }
    stroke((angle*180/PI)%360,360,360);
    strokeWeight(1.5);
    line(X.get(i), Y.get(i), X.get(i+1), Y.get(i+1));
  }
  
  //Video Capturing
  //saveFrame("frames/"+N+"/####.tif");
}

//Draws an arrow
void arrow(float x1, float y1, float x2, float y2, float angle, float size) {
  line(x1, y1, x2, y2);
  float delta = (180-25)*PI/180;
  float l = size/15;
  stroke((angle*180/PI)%360,360,360);
  triangle(x2+l*cos(angle + delta), y2+l*sin(angle + delta), x2+l*cos(angle - delta), y2+l*sin(angle - delta), x2, y2);
}

//Defines the complex phasor
class Fasore{
  float speed,modulo,argomento;
  Fasore(float speed,float modulo,float argomento){
    this.speed = speed;
    this.modulo = modulo;
    this.argomento = argomento;
  }
}
