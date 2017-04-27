//Java implementation of Dan Shiffman's Evolutionary Steering Behaviours
//with some extra stuff on top

ArrayList<Vehicle> v;
ArrayList<PVector> food;
ArrayList<PVector> poison;


void setup() {
 size(640,360);
   
}

void draw() {
 background(0);
 PVector tmp = new PVector(0,0);
 v.seek(tmp);
 v.update();
 v.display();
}