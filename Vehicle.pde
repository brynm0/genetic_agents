//Java port of P5.js code written by Dan Shiffman

class Vehicle {
  PVector acc, vel, pos;
  float maxspeed, maxforce;
  int r;
  float health;

  //mutation rate
  float mr;
  float mutationLimits;

  float[] dna;

  Vehicle(float _x, float _y, float[] _dna) {
    acc = new PVector(0, 0);
    vel = new PVector(0, -2);
    pos = new PVector(_x, _y);
    r = 4;
    maxspeed = 5;
    maxforce = 0.2;
    health = 1;
    dna = new float[4];
    mutationLimits = 10;

    if (_dna == null) {
      for (int i = 0; i < dna.length/2; i++) {
        dna[i] = random(-2, 2);
      }
      for (int i = dna.length/2; i < dna.length; i++) {
        dna[i] = random(0, 100);
      }
    } else {
      for (int i = 0; i < dna.length/2; i++) {
        dna[i] = _dna[i];
        if (random(1) < mr) {
          dna[i] += random(-(mutationLimits/100), mutationLimits/100);
        }
      }
      for (int i = dna.length/2; i < dna.length; i++) {
        dna[i] = _dna[i];
        if (random(1) < mr) {
          this.dna[i] += random(-mutationLimits, mutationLimits);
        }
      }
    }
  }

  void update() {
    health -= 0.005;

    vel.add(acc);
    vel.limit(maxspeed);
    pos.add(vel);
    acc.mult(0);
  }


  //remember to complete this function
  void applyForce (PVector force) {
    acc.add(force);
  }

  void behaviors(ArrayList<PVector> good, ArrayList<PVector> bad) {
    PVector steerG = this.eat(good, 0.2, this.dna[2]);
    PVector steerB = eat
  }

  Vehicle clone() {
    if (random(1) < 0.002) {
      Vehicle v = new Vehicle(this.pos.x + random(-5, 5), this.pos.y + random(-5, 5), this.dna);
      return  v;
    } else {
      return null;
    }
  }

  PVector eat(ArrayList<PVector> list, float nutrition, float perception) {
    double record = Double.POSITIVE_INFINITY;
    PVector closest = new PVector();
    for (int i = list.size() - 1; i>=0; i--) {
      float d = pos.dist(list.get(i));
      if (d < this.maxspeed) {
        list.remove(i);
        this.health += nutrition;
      } else {
        if (d < record && d < perception) {
          record = d;
          closest = list.get(i);
        }
      }
    }
    if (closest != null) {
      return this.seek(closest);
    }
    return new PVector(0, 0);
  }

  PVector seek(PVector target) {
    //craig reynolds' seek function
    //steer = desired - velocity
    PVector desired = PVector.sub(target, pos);
    desired.setMag(this.maxspeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }

  boolean dead() {
    return (health <= 0);
  }



  void display() {
    float theta = vel.heading() + PI/2;
    fill(127);
    stroke(200);
    strokeWeight(1);
    translate(pos.x, pos.y);
    rotate(theta);
    beginShape();
    vertex(0, -r * 2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape(CLOSE);
  }

  void boundaries() {
    float d = 25;
    PVector desired = null;
    if (pos.x < d) {
      desired = new PVector(maxspeed, vel.y);
    } else if (pos.x > width - d) {
      desired = new PVector(-maxspeed, vel.y);
    }

    if (pos.y < d) {
      desired = new PVector(vel.x, maxspeed);
    } else if (pos.y > height - d) {
      desired = new PVector(vel.x, -maxspeed);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(maxspeed);
      PVector steer = PVector.sub(desired, vel);
      steer.limit(maxforce);
      applyForce(steer);
    }
  }
}