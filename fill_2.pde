GifRecorder recorder = new GifRecorder(this, 60, 3);
ArrayList<Square> square = new ArrayList<Square>();

int timer;
int max_count = 8;
int count = 0;
int type = 1;
int square_length;
float h = random(255);
float s = random(200);
float next_s_x;
float next_s_y;
float next_p_x;
float next_p_y;
float next_e_x;
float next_e_y;
float next_c_1;
float next_c_2;
float reset_x = 0;

void setup() {
  size(400, 250);
  smooth();
  colorMode(HSB,255);
  rectMode(CORNERS);
  square.add(new Square(0, 0, 400, 250, 255));
}

void draw() {
  stroke(255);
  
  //draw
  if(count < max_count){
    for(int i = 0; i < square.size(); i++){
      square.get(i).draw();
    }
  }
  
  //reset
  if(count == max_count){
    if(timer == 0){
      h = random(255);
      s = random(200);
    }
    fill(h, s, 255);
    reset_x = reset_x + (timer * 3);
    rect(0,0,reset_x, 300);
  }
  
  //update
  if(timer == 20){
    type += 1;
    
    square_length = square.size();
    
    //update square
    if(count < max_count){
      for(int i = 0; i < square_length; i++){
        next_s_x = square.get(i).base_s_x;
        next_s_y = square.get(i).base_s_y;
        next_p_x = square.get(i).target_e_x;
        next_p_y = square.get(i).target_e_y;
        next_e_y = square.get(i).base_e_y;
        next_e_x = square.get(i).base_e_x;
        next_c_1 = square.get(i).target_c;
        next_c_2 = square.get(i).base_c;
        
        if(type % 4 == 1){
          square.add(new Square(next_p_x, next_s_y, next_e_x, next_e_y, next_c_2));
        }
        if(type % 4 == 2){
          square.add(new Square(next_s_x, next_p_y, next_e_x, next_e_y, next_c_2));
        }
        if(type % 4 == 3){
          square.add(new Square(next_s_x ,next_s_y, next_p_x, next_e_y, next_c_2));
        }
        if(type % 4 == 0){
          square.add(new Square(next_s_x, next_s_y, next_e_x, next_p_y, next_c_2));
        }
      }
      
      for(int i = 0; i < square_length; i++){
        square.remove(i);
      }
    }
    
    //reset square
    if(count == max_count){
      square.clear();
      
      next_s_x = 0;
      next_s_y = 0;
      next_e_x = width;
      next_e_y = height;
      next_c_1 = 255;
      count = -1;
      square.add(new Square(next_s_x, next_s_y, next_e_x, next_e_y, next_c_1));
    }
    
    count ++;
    timer = -1; 
    reset_x = 0;
  }
  
  timer++;
  recorder.onDraw();
}

class Square{
  float base_s_x;
  float base_s_y;
  float base_e_x;
  float base_e_y;
  float base_width;
  float base_height;
  float base_c;
  float target_s_x;
  float target_s_y;
  float target_p_x;
  float target_p_y;
  float target_e_x;
  float target_e_y;
  float target_c;
  
  Square(float s_x, float s_y, float e_x, float e_y, float c){
    base_s_x = s_x;
    base_s_y = s_y;
    base_e_x = e_x;
    base_e_y = e_y;
    
    base_width = abs(e_x - s_x);
    base_height = abs(e_y - s_y);
    
    base_c = c;
    
    //left to right
    if(type % 4 == 0){
      target_s_x = base_s_x;
      target_s_y = base_s_y;
      target_p_x = base_s_x;
      target_p_y = base_e_y;
      target_e_x = base_width * 0.615384615 + base_s_x;
      target_e_y = target_p_y;
    }
    
    //top to bottom
    if(type % 4 == 1){
      target_s_x = base_s_x;
      target_s_y = base_s_y;
      target_p_x = base_e_x;
      target_p_y = base_s_y;
      target_e_x = target_p_x;
      target_e_y = base_height * 0.6153846151 + base_s_y;
    }
    
    //right to left
    if(type % 4 == 2){
      target_s_x = base_e_x;
      target_s_y = base_e_y;
      target_p_x = base_e_x;
      target_p_y = base_s_y;
      target_e_x = base_s_x + (base_width * 0.384615385);
      target_e_y = target_p_y;
    }
    
    //bottom to top
    if(type % 4 == 3){
      target_s_x = base_e_x;
      target_s_y = base_e_y;
      target_p_x = base_s_x;
      target_p_y = base_e_y;
      target_e_x = target_p_x;
      target_e_y = base_s_y + (base_height * 0.384615385);
    }
    print(count);
    target_c = 235 - (20 * (count + 1));
  }
  
  void draw(){
    fill(h, s, base_c);
    rect(base_s_x, base_s_y, base_e_x, base_e_y);
    fill(h, s, target_c);
    rect(target_s_x, target_s_y, target_p_x, target_p_y);
    update();
  }
  
  void update(){
    
    //left to right
    if(type % 4 == 0){
      target_p_x = (target_e_x - target_p_x) * 0.4 + target_p_x;
    }
    
    //right to left
    if(type % 4 == 2){
      target_p_x = target_p_x - (target_p_x - target_e_x) * 0.4;
    }
    
    //top to bottom
    if(type % 4 == 1){
      target_p_y = (target_e_y - target_p_y)* 0.4 + target_p_y;
    }
    
    //bottom to top
    if(type % 4 == 3){
      target_p_y = target_p_y - (target_p_y - target_e_y) * 0.4;
    }
  }
}

void mouseClicked() {
  recorder.recordForSeconds("out.gif", 12);
}

