// Funciones y creación de objetos con polyhedron
module circulo(n, r, z) {
    angulo = (360)/n;
    points = [ for(i=[0:n]) if(i==n) [0,0,0] else [r*cos(angulo*i), r*sin(angulo*i), z]];

    faces = [ for(j=[0:n]) [j%n, (j+1)%n, n - 1] ]
        ;
        
    polyhedron(points, faces);
}

module cubo(x, y, z) {
CubePoints = [
  [  0,  0,  0 ],  //0
  [ x,  0,  0 ],  //1
  [ x,  y,  0 ],  //2
  [  0,  y,  0 ],  //3
  [  0,  0,  z ],  //4
  [ x,  0,  z ],  //5
  [ x,  y,  z ],  //6
  [  0,  y,  z ]]; //7
  
CubeFaces = [
  [0,1,2,3],  // bottom
  [4,5,1,0],  // front
  [7,6,5,4],  // top
  [5,6,2,1],  // right
  [6,7,3,2],  // back
  [7,4,0,3]]; // left
    
    
   polyhedron( CubePoints, CubeFaces );
}

module cilindro(r, h){
     intersection_for(i = [0:90]){
             rotate([0,0,i])
             translate([-r/2,-r/2,-h/2])
             cubo(r,r,h);
         }
    
    
}

module prism(l, w, h){
       translate([0,0,0])polyhedron(
               points=[[0,0,0], [l,0,0], [l,w,0], [0,w,0], [0,w,h], [l,w,h]],
               faces=[[0,1,2,3],[5,4,3,2],[0,4,5,1],[0,3,4],[5,2,1]]
               );
   }


module esfera(r){
    union() {for(i = [0:180]){
        rotate([i,0,0])
        circulo(20, r, 0);
        }
    }
}
module cono(r,h){
    intersection_for(i = [0:360]){
        rotate([0,0,i])
        translate([-r/2,-r/2, -h/4])
        prism(r,r,h);
    }
    
}

module piramide(x,y,z){
    polyhedron(
  points=[ [x,y,0],[x,-y,0],[-x,-y,0],[-x,y,0], // the four points at base
           [0,0,z]  ],                                 // the apex point 
  faces=[ [0,1,4],[1,2,4],[2,3,4],[3,0,4],              // each triangle side
              [1,0,3],[2,1,3] ]                         // two triangles for square base
 );
}




//camara
difference(){
union(){
//foco
color("DarkSlateGray", 1.0)rotate([90,0,0])cilindro(2, 1);
//continuacion foco
    color("LightSlateGray", 1.0)difference(){
    translate([0,-1/4,0]) rotate([90,0,0])cilindro(3/2,3/2);
        translate([-1/2,-1.1,-1/2])cubo(1,1,1);}
//lente
        color("silver", 1.0)translate([0,-1/2,0])esfera(2/3);
//bloque central
color("DarkSlateGray", 1.0)translate([-5/4,1/2,-5/4])cubo(5/2,3/2,5/2);
//bloque lateral 1
color("DarkSlateGray", 1.0)translate([5/4, 3/4 - 0.15, -5/4 +0.1 ])cubo(1, 3/2 - 0.2, 5/2 - 0.2);
//bloque lateral 2
color("DarkSlateGray", 1.0)translate([-5/4 - 1, 3/4 - 0.15, -5/4 +0.1 ])cubo(1, 3/2 - 0.2, 5/2 - 0.2);
//prisma superior
color("DarkSlateGray", 1.0)translate([-5/4, 1/2, 5/4])
intersection(){
    prism(5/2,3/2,1/2);
    cubo(5/2,3/2,1/4);}
//mango
color("DarkSlateGray", 1.0)translate([-2, 1 ,0])cilindro(1,5/2 - 0.2);
//ruedita
color("SlateGray", 1.0)translate([-2,1,5/4])
difference(){
    
    cono(2/3,1/2);
    translate([-1/2,-1/2,0])cubo(1,1,1);
    }
//flash
    color("white", 1.0)translate([-1, 1/2, 1])rotate([90,0,0])piramide(1/6,1/6,1/6);
        
}
//corte esquina
color("DarkSlateGray", 1.0)translate([-2, 2 + 0.1 - 1/4, 0])rotate([0, 0, 30])translate([-1, -1/4, -2])cubo(2,1/2,4);
}


   
    
    