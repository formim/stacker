// Half - baked Stacking game.  I've spent too much time on this already

class Block {
  float xpos, ypos, blockwidth;
  float blockheight = 40;
  color c;
  
  Block(float x, float y, float z){ 
    xpos = x;
    ypos = y;
    blockwidth = z;
    c = color(random(255), random(255), random(255));
  }
  
  void display(){
    noStroke();
    fill(c);
    rect(xpos, ypos, blockwidth, blockheight); // Height is 40.  
  }
  
}

int score = 0;
float speed = 2;
boolean game = true;
Block moving = new Block(0, 760, 150);
ArrayList<Block> placed = new ArrayList<Block>();

void setup(){
  size(400, 800);
}

void update(){
 moving.xpos = moving.xpos + speed;
 // Update the moving box coordinates and bounce off the walls.
 if (moving.xpos + moving.blockwidth > width || moving.xpos < 0){
   speed = speed * -1;
 }
 moving.display();
 if (placed.size() > 0){
   for (int i = 0; i < placed.size(); i = i+1){
     placed.get(i).display();
   }
 }
}  

void printScore(){
  textSize(30);
  text("Score: " + score, 20, 50);
  fill(0);
}

void printOver(){
  fill(0);
  textSize(30);
  text("Game Over!", 20, 50);
  fill(0);
  textSize(30);
  text("Final Score: " + (score - 2), 20, 80);
}

void stackBlock(){
  /*
  if (placed.size() > 0){ 
    moving.blockwidth = moving.blockwidth - abs(moving.xpos - placed.get(placed.size()-1).xpos);
  } */
  placed.add(moving);
  Block last = placed.get(placed.size()-1); // Used to be the moving block. Now top of the 'stack,' and
                                            // the new moving block hasn't been created yet.
  float xa1 = last.xpos;
  float xa2 = last.xpos + last.blockwidth;
  if (placed.size() > 1 ){
   float xb1 = placed.get(placed.size() - 2).xpos;
   float xb2 = placed.get(placed.size() - 2).xpos + placed.get(placed.size() - 2).blockwidth;
   // we have the 'ends' of both blocks. Consider that the moving block is (was) the same size as the block beneath it.
   if (xa2 <= xb1 || xa1 >= xb2){
     // OUT OF BOUNDS, FAILED TO STACK - GAME OVER
     speed = 0;
     game = false;
   }
   else if (xa1 < xb1 && xa2 > xb1){
     // Overhanging left;
     //moving = new Block(last.xpos, last.ypos-40, last.blockwidth - (xb1 - xa1));
     last.blockwidth = last.blockwidth - (xb1 - xa1);
     last.xpos = placed.get(placed.size() - 2).xpos;
   }
   else if (xa2 > xb2 && xa1 < xb2){
     // Overhanging right;
     //moving = new Block(last.xpos + (xa2 - xb2), last.ypos-40, last.blockwidth - (xa2 - xb2));
     last.blockwidth = last.blockwidth - (xa2 - xb2);
   }
  }
  if (game){ moving = new Block(last.xpos, last.ypos - 40, last.blockwidth); }
  score = score + 1;
  // Preserve the direction of speed
  if (speed < 0){ speed -= 1; }
  if (speed > 0){ speed += 1; }
}           

void draw(){
  background(255);
  update();
  if (!game){ printOver(); }
  else { printScore(); }
}

void keyPressed(){
  if (game){ stackBlock(); }
}
