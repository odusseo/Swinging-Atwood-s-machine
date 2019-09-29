void setup(){
size(640,640);
}
int cost=320;
double g=9.806;
double l=160;
double theta=PI/6;  //angolo pendolo no approssimazioni (rosso)
double omega=0;
double alfa=0;
double dt=0.001;
double t=0;
double amp=PI/6;  //angolo pendolo approssimazione piccoli angoli (verde)
double gamma;
float rad=sqrt((float)g/ (float)l);
void draw(){
clear();
background(255);
stroke(0,0,0);
ellipse(cost,cost,20,20);
stroke(0,0,0);
ellipse(cost,cost-160,10,10);
stroke(0,0,0);
line(0,cost,640,cost);
stroke(0,0,0);
line(cost,0,cost,640);
stroke(255,0,0);
line(cost,cost-160,cost,cost);
line(cost,160,cost+160*sin((float)theta),160+160*cos((float)theta));
ellipse(cost+160*sin((float)theta),160+160*cos((float)theta),10,10);
for(int i=0; i<100; i++){
  alfa=-(g/l)*sin((float)theta);
  theta=theta+omega*dt;
  omega=omega+alfa*dt;
}
gamma=amp*cos(rad*(float)t);
t=t+dt*100;
stroke(0,255,0);
line(cost,160,cost+160*sin((float)gamma),160+160*cos((float)gamma));
ellipse(cost+160*sin((float)gamma),160+160*cos((float)gamma),10,10);
delay((int)(dt*1000));
}
