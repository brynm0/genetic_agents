//Java implementation of Dan Shiffman's Evolutionary Steering Behaviours
//with some extra stuff on top

ArrayList<Vehicle> v;
ArrayList<PVector> food;
ArrayList<PVector> poison;
int VEHICLES_COUNT, FOOD_COUNT, POISON_COUNT;
float FOOD_CHANCE, POISON_CHANCE;
void setup() {
  size(640, 360);

  VEHICLES_COUNT = 5;
  FOOD_COUNT = 40;
  POISON_COUNT = 20;
  FOOD_CHANCE = 0.1;
  POISON_CHANCE = 0.01;
  v = new ArrayList<Vehicle>(VEHICLES_COUNT);
  for (int i = 0; i < VEHICLES_COUNT; i++) {
    float x = random(width);
    float y = random(height);
    Vehicle currentVehicle = new Vehicle(x, y, null);
    v.add(currentVehicle);
  }

  food = new ArrayList<PVector>(FOOD_COUNT);
  for (int i = 0; i < FOOD_COUNT; i++) {
    float x = random(width);
    float y = random(height);
    food.add(i, new PVector(x, y));
  }

  poison = new ArrayList<PVector>(POISON_COUNT);
  for (int i = 0; i < POISON_COUNT; i++) {
    float x = random(width);
    float y = random(height);
    poison.add(i, new PVector(x, y));
  }
}

void mouseDragged() {
  v.add(new Vehicle(mouseX, mouseY, null));
}

void draw() {
  background(51);
  if (random(1) < FOOD_CHANCE) {
    float x = random(width);
    float y = random(height);
    food.add(new PVector(x, y));
  }

  if (random(1) < POISON_CHANCE) {
    float x = random(width); 
    float y = random(height);
    poison.add(new PVector(x, y));
  }

  for (int i = 0; i < food.size(); i++) {
    fill(0, 255, 0);
    noStroke();
    ellipse(food.get(i).x, food.get(i).y, 4, 4);
  }
  for (int i = 0; i < poison.size(); i++) {
    fill(255, 0, 0);
    noStroke();
    ellipse(poison.get(i).x, poison.get(i).y, 4, 4);
  }

  for (int i = v.size() - 1; i >= 0; i--) {
    v.get(i).boundaries();
    v.get(i).display();

    v.get(i).behaviors(food, poison);
    v.get(i).update();

    Vehicle newVehicle = v.get(i).clone();
    if (newVehicle != null) {
      v.add(newVehicle);
    }
    if (v.get(i).dead()) {
      float x = v.get(i).pos.x;
      float y = v.get(i).pos.y;
      food.add(new PVector(x, y));
      v.remove(i);
    }
  }
}