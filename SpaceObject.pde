public class SpaceObject {
    // Zie Excel bestand voor de berekening.
    float G = 160000.0;

    String name = "Object";
    PVector location = new PVector(0, 0);
    float width = 0;
    float height = 0;
    float mass = 0;
    boolean is_static;
    boolean is_destroyed = false;

    PVector velocity = new PVector(0, 0);
    boolean trace_path = false;

    ArrayList<PVector> path = new ArrayList<PVector>();
    int max_nr_path = 0;
    ArrayList<SpaceObject> has_gravitational_influence_from = new ArrayList<SpaceObject>();
    ArrayList<SpaceObject> objects_to_draw_all_vectors = new ArrayList<SpaceObject>(); 
    boolean do_draw_all_vectors = false;
    float k_v;
    float k_g;   

    public SpaceObject (String o_name, float x, float y, float o_width, float o_height, float o_mass, boolean object_is_static){
        name = o_name;
        location = new PVector(x, y);
        width = o_width;
        height = o_height;
        mass = o_mass;
        is_static = object_is_static;
    }

    public SpaceObject (float x, float y, float o_width, float o_height, float o_mass, boolean object_is_static) {
        this("Object", x, y, o_width, o_height, o_mass, object_is_static);
    }

    private float calculate_distance_to_object(SpaceObject body){
        // Stelling van Pythagoras om de afstand tussen de twee objecten te bepalen.
        return sqrt(pow(body.location.x - location.x, 2) + pow(body.location.y - location.y, 2));
    }

    private PVector calculate_acceleration_vector(SpaceObject body){
        float r = calculate_distance_to_object(body);

        // m1 * a = G * ( (m1 * m2) / r^2 )     --> m1 naar de andere kant
        // a = G * ( (m1 * m2) / r^2 ) / m1  
        float a = G*((mass*body.mass)/pow(r, 2))/mass;

        float x = body.location.x - location.x;
        float y = body.location.y - location.y;
        
        // Driehoeken zijn gelijkvormig, dus er zit een verhouding tussen de grootten van de zijdes.   
        return new PVector((a*x/r), (a*y/r));  
    }
    
    public float calculate_orbital_angle(SpaceObject body){
        if (location.y > body.location.y){
            if(location.x > body.location.x){
                //1
                return atan((location.y - body.location.y)/(location.x - body.location.x));
            }else{
                //2
                return PI - atan((location.y - body.location.y)/(location.x - body.location.x));
            }
        }else{
            if(location.x > body.location.x){
                //3
                return atan((location.y - body.location.y)/(location.x - body.location.x));
            }else{
                //4
                return -PI - atan((location.y - body.location.y)/(location.x - body.location.x));
            }
        }
    }

    public PVector calculate_orbital_velocity(SpaceObject body, boolean clockwise){
        float r = calculate_distance_to_object(body);   
         
        // v = sqrt( G * mp / r)   
        float v = clockwise ? -sqrt(G*body.mass/r) : sqrt(G*body.mass/r);   
        float a = calculate_orbital_angle(body); 
        float angle; 
         
        if (location.x >= body.location.x){  
            angle = -(0.5*PI - a); 
        }else{
            angle = (0.5*PI - a); 
        }  
        
        float y = v*sin(angle);  
        float x = v*cos(angle);
        
        if (location.x >= body.location.x){
            return new PVector(x, y);
        }else{
            return new PVector(-x, -y);
        }       
    }

    public void add_gravity_effect(SpaceObject body){
        if (!is_static){
            PVector a = calculate_acceleration_vector(body);
            velocity.add(a); 
        } 
    }

    public void draw_object(){
        if(!is_static){
            location.add(velocity);
        }
        
        ellipse(location.x, location.y, width, height);

        if (trace_path){
            path.add(new PVector(location.x, location.y));  
        }        
    }
    
    public void draw_path(int max_nr_lines){
        stroke(255, 255, 255, 25);
        if(trace_path){
            for(int i = path.size() - 1; i >= path.size() - max_nr_lines; i--){
                if (i - 1 > 0){
                    line(path.get(i).x, path.get(i).y, path.get(i-1).x, path.get(i-1).y);
                }                
            }
            if (path.size() > max_nr_lines){
                path = new ArrayList<PVector>(path.subList(path.size() - max_nr_lines, path.size()));
            }
        }else{
            path.clear();
        }       
        noStroke(); 
    }
    
    public void draw_velocity_vectors(float k){
        stroke(244, 182, 66);
        line(location.x, location.y, location.x + velocity.x*k, location.y + velocity.y*k);
        noStroke();
    }
    
    public void draw_gravitational_vectors(float k, SpaceObject body){
        stroke(244, 66, 200);
        PVector a = calculate_acceleration_vector(body);
        line(location.x, location.y, location.x + a.x*k, location.y + a.y*k); 
        noStroke();
    }

    public void draw_all_vectors(float k_v, float k_g, SpaceObject[] bodies){
        draw_velocity_vectors(k_v);
        for (SpaceObject body : bodies) {
            draw_gravitational_vectors(k_g, body);
        }        
    }

    public void check_for_collision(SpaceObject body){
        if (!is_destroyed && !body.is_destroyed){ 
            float r = calculate_distance_to_object(body);   
            if (r < (width/2 + body.width/2)){
                println(name + " has collided with " + body.name); 
                  
                if (mass > body.mass){
                    combine(body);
                    body.destroy();   
                }else if (mass < body.mass){
                    destroy(); 
                }else{ 
                    combine(body);
                    body.destroy();
                    destroy();
                }
            }
        }        
    }

    public void check_for_collisions(SpaceObject[] bodies){
        for (SpaceObject body : bodies) {
            check_for_collision(body);   
        }  
    }  
  
    public void destroy(){  
        is_destroyed = true;    
        width = 0;    
        height = 0;    
        mass = 0;  
        is_static = true;  
        velocity = new PVector(0, 0);  
        trace_path = false;  
        name = name + " (Destroyed)";  
    }

    public void combine(SpaceObject body){
        name = name + " (+" + body.name;        
        mass = mass + body.mass;
    }
}

public void draw_physics_data(SpaceObject[] bodies, float set_framerate){
    textFont(f, 16);
    String framerate_indicator = "";
    if (current_framerate / set_framerate == 0.5){
        framerate_indicator = "<";
    }else if (current_framerate / set_framerate == 0.25){
        framerate_indicator = "<<";
    }else if (current_framerate / set_framerate == 2){
        framerate_indicator = ">";
    }else if (current_framerate / set_framerate == 4){
        framerate_indicator = ">>";
    }

    String physics_data = (int) frameRate + " FPS " + framerate_indicator + "\n";
    physics_data += String.format("G: %f\n\n", bodies[0].G);
    
    for (SpaceObject body : bodies) {
        physics_data += String.format("%s:\n", body.name);
        physics_data += String.format("  Location:  %f, %f\n", body.location.x, body.location.y);
        physics_data += String.format("  Velocity:  %f, %f\n", body.velocity.x, body.velocity.y);

        float combined_velocity = sqrt(pow(body.velocity.x, 2) + pow(body.velocity.y, 2));
        physics_data += String.format("  Com. Velocity: %f\n", combined_velocity);

        physics_data += String.format("  Mass:      %f\n", body.mass);
        physics_data += String.format("  Is Static: %s\n", body.is_static);
        for (SpaceObject g_body : bodies){
            if(!g_body.equals(body)){
                PVector g_vector = body.calculate_acceleration_vector(g_body);
                float g_attraction = sqrt(pow(g_vector.x, 2) + pow(g_vector.y, 2));
                physics_data += String.format("  Gravitational attraction to %s: %s\n", g_body.name, g_attraction);
            }            
        }
        physics_data += "\n";
    }

    text(physics_data, 5, 16);
}
