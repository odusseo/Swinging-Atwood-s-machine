void setup(){
  size(640,640);
}
int cost=320;
float M = 0.8;
float m = 1;
float g = 9.8;
float l=200;

float r = 160;
float theta = PI/2;

float dt = 0.001;

float p_theta;
float p_theta_v;
float p_r;
float p_r_v;
float theta_v;
float r_v;

void draw(){
  background(255);
  fill(0,0,0);
  //stroke(0,0,0);
  //ellipse(cost,cost,20,20);
  stroke(0,0,0);
  ellipse(cost,cost-160,10,10);
  stroke(0,0,0);
  ellipse(cost-l,cost-160,10,10);
  stroke(0,0,0);
  line(cost-l,cost-160,cost,cost-160);
  stroke(0,0,0);
  line(0,cost,640,cost);
  stroke(0,0,0);
  line(cost,0,cost,640);
  stroke(100);
  line(cost,cost-160,cost,cost);
  line(cost,160,cost+r*sin((float)theta),160+r*cos((float)theta));
  fill(0,255,255);
  ellipse(cost+r*sin((float)theta),160+r*cos((float)theta),10,10);
  line(cost-l,160,cost-l,cost+80-r);
  stroke(0,0,0);
  fill(255,0,0);
  ellipse(cost-l,cost+80-r,20,20);
  
  for(int i=0;i<100;i++){
  p_theta_v = -m*g*r*sin(theta);
  p_theta = p_theta + p_theta_v*dt;
  theta_v = p_theta / (m * r * r);
  theta = theta + theta_v * dt;
  p_r_v = (p_theta * p_theta) / (m * r * r * r) - M * g + m * g * cos(theta);
  p_r = p_r + p_r_v * dt;
  r_v = p_r / (M + m);
  r = r + r_v * dt;
  }
  
  delay((int)(dt));
}
