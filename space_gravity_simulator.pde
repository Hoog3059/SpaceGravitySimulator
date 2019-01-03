import java.lang.*;
import static javax.swing.JOptionPane.*;

PFont f;
File filename;
Scene scene;
PVector translation = new PVector(0, 0);
float scaling = 1;
float text_scrolling = 0;
float current_framerate;

void setup(){
    File file = new File(sketchPath() + "/data");
    File[] filenames = file.listFiles();

    filename = (File) showInputDialog(null, "Scene to load:", "Load scene", QUESTION_MESSAGE, null, filenames, filenames[0]);
    scene = load_scene_from_json_data(filename.getPath());
    
    fullScreen();
    frameRate(scene.framerate);  
    current_framerate = scene.framerate; 

    noStroke();
    f = createFont("Arial", 16, true);   
    scaling = 1;
    translation = new PVector(0, 0);
}

void draw(){
    background(0);

    pushMatrix();
    scale(scaling);
    translate(translation.x*scaling, translation.y*scaling);
    scene.draw_scene();
    popMatrix();

    pushMatrix();
    translate(0, text_scrolling);
    scene.draw_all_physics_data();
    popMatrix();
}

void keyPressed(){
    if (key == 'r'){
        scene = load_scene_from_json_data(filename.getPath());
    }else if (keyCode == BACKSPACE){
        setup();
    }else if(keyCode == UP){
        translation.y = translation.y + 10;
    }else if(keyCode == DOWN){
        translation.y = translation.y - 10;
    }else if(keyCode == LEFT){
        translation.x = translation.x + 10;
    }else if(keyCode == RIGHT){
        translation.x = translation.x - 10;
    }else if(key == '+'){
        scaling = scaling + 0.1;
    }else if(key == '-' ){
        scaling = scaling - 0.1;
    }else if(key == 'a'){
        text_scrolling = text_scrolling - 10;
    }else if(key == 'z' ){
        text_scrolling = text_scrolling + 10;
    }else if(key == 'c'){
        translation = new PVector(0, 0);
        scaling = 1;
        text_scrolling = 0;
    }else if(key == '.' && current_framerate / scene.framerate < 4){
        current_framerate = current_framerate * 2;
        frameRate(current_framerate);
    }else if(key == ',' && current_framerate / scene.framerate > 0.25){
        current_framerate = current_framerate / 2;
        frameRate(current_framerate);
    }    
}
