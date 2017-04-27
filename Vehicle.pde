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
    float mr = 0.01;
    acc = new PVector(0, 0);
    vel = new PVector(0, 0);
    pos = new PVector(_x, _y);
    r = 4;
    maxspeed = 1;
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


  void applyForce (PVector force) {
    acc.add(force);
  }

  void behaviors(ArrayList<PVector> good, ArrayList<PVector> bad) {
    PVector steerG = eat(good, 0.2, dna[2]);
    PVector steerB = eat(bad, -1, dna[3]);
    steerG.mult(dna[0]);
    steerB.mult(dna[1]);

    applyForce(steerG);
    applyForce(steerB);
  }

  Vehicle clone() {
    if (random(1) < 0.002) {
      Vehicle v = new Vehicle(this.pos.x, this.pos.y, this.dna);
      return  v;
    } else {
      return null;
    }
  }

  PVector eat() {
  }

  PVector seek(PVector target) 
  {
    //craig reynolds' seek function
    //steer = desired - velocity
    PVector desired = PVector.sub(target, pos);
    desired.setMag(this.maxspeed);
    PVector steer = PVector.sub(desired, vel);
    steer.limit(maxforce);
    return steer;
  }

  boolean dead() 
  {
    return (health <= 0);
  }




  this.display = function() 
  {
    // Draw a triangle rotated in the direction of velocity
    float angle = this.vel.heading() + PI / 2;
    translate(this.pos.x, this.pos.y);
    rotate(angle);
    var gr = color(0, 255, 0);
    var rd = color(255, 0, 0);
    var col = lerpColor(rd, gr, this.health);
    fill(col);
    stroke(col);
    strokeWeight(1);
    beginShape();
    vertex(0, -this.r * 2);
    vertex(-this.r, this.r * 2);
    vertex(this.r, this.r * 2);
    endShape(CLOSE);
  }


  void boundaries() {
    float d = 25;
    PVector desired = null;
    if (this.pos.x < d) {
      desired = new PVector(this.maxspeed, this.vel.y);
    } else if (this.pos.x > width - d) {
      desired = new PVector(-this.maxspeed, this.vel.y);
    }

    if (this.pos.y < d) {
      desired = new PVector(this.vel.x, this.maxspeed);
    } else if (this.pos.y > height - d) {
      desired = new PVector(this.vel.x, -this.maxspeed);
    }

    if (desired != null) {
      desired.normalize();
      desired.mult(this.maxspeed);
      PVector steer = PVector.sub(desired, this.vel);
      steer.limit(this.maxforce);
      this.applyForce(steer);
    }
  }
}