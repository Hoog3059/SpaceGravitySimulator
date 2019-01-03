public class Scene {
    int framerate;
    SpaceObject[] objects;
    SpaceObject[] objects_to_draw_physics_data;

    public Scene () {
        
    }

    public void draw_scene(){
        for (SpaceObject object : objects) { 
            for (SpaceObject g : object.has_gravitational_influence_from) {  
                object.add_gravity_effect(g); 
            }

            object.draw_object();

            for (SpaceObject inner_object : objects){
                if (inner_object != object){
                    object.check_for_collision(inner_object);
                }
            }

            if(object.trace_path){
                object.draw_path(object.max_nr_path);
            }

            if(object.do_draw_all_vectors){
                object.draw_all_vectors(object.k_v, object.k_g, object.objects_to_draw_all_vectors.toArray(new SpaceObject[0]));
            }
        }
    }

    public void draw_all_physics_data(){
        draw_physics_data(objects_to_draw_physics_data, framerate);        
    }
}

Scene load_scene_from_json_data(String filename){
    Scene output = new Scene(); 

    HashMap<String, SpaceObject> bodies = new HashMap<String, SpaceObject>();
    ArrayList<SpaceObject> draw_physics_data = new ArrayList<SpaceObject>();
    JSONObject json = loadJSONObject(filename);
    JSONArray objects = json.getJSONArray("Objects");

    for (int i = 0; i < objects.size(); ++i) {
        JSONObject object = objects.getJSONObject(i);

        String name = object.getString("name");
        float x = object.getFloat("location.x");
        float y = object.getFloat("location.y");
        float width = object.getFloat("width");
        float height = object.getFloat("height");
        float mass = object.getFloat("mass");
        boolean is_static = object.getBoolean("is_static");
        PVector velocity = new PVector(object.getFloat("velocity.x"), object.getFloat("velocity.y"));
        boolean trace_path = object.getBoolean("trace_path");
        int max_nr_path = object.getInt("max_nr_path");
        boolean do_draw_all_vectors = object.getJSONObject("draw_all_vectors").getBoolean("do");
        float k_g = object.getJSONObject("draw_all_vectors").getFloat("k_g");
        float k_v = object.getJSONObject("draw_all_vectors").getFloat("k_v");
        boolean do_draw_physics_data = object.getBoolean("draw_physics_data");

        float G_value = json.getFloat("G");
        
        SpaceObject body = new SpaceObject(name, x, y, width, height, mass, is_static);

        body.G = G_value;
        body.velocity = velocity;
        body.trace_path = trace_path;
        body.max_nr_path = max_nr_path;
        body.do_draw_all_vectors = do_draw_all_vectors;
        body.k_g = k_g;
        body.k_v = k_v;
        bodies.put(name, body);

        if(do_draw_physics_data){
            draw_physics_data.add(body);
        }
    }
    for (HashMap.Entry<String, SpaceObject> key_body : bodies.entrySet()) { 
        for (int i = 0; i < objects.size(); ++i) { 
            JSONObject object = objects.getJSONObject(i); 

            if(key_body.getKey().equals(object.getString("name"))) { 
                JSONArray has_g_inf_from = object.getJSONArray("gravity_influence_from"); 

                for (int i2 = 0; i2 < has_g_inf_from.size(); i2++) { 
                    String g_object = has_g_inf_from.getString(i2); 

                    /*SpaceObject body = key_body.getValue(); 
                    body.has_gravitational_influence_from.add(bodies.get(g_object)); 
                    bodies.replace(key_body.getKey(), body);*/
                    key_body.getValue().has_gravitational_influence_from.add(bodies.get(g_object)); 
                }

                JSONArray g_vectors_from = object.getJSONObject("draw_all_vectors").getJSONArray("g_vectors_from");

                for (int i2 = 0; i2 < g_vectors_from.size(); i2++) {
                    String v_object = g_vectors_from.getString(i2);

                    key_body.getValue().objects_to_draw_all_vectors.add(bodies.get(v_object));
                }

                String use_orbital_velocity_from = object.getString("use_orbital_velocity_to");
                if(!use_orbital_velocity_from.equals("")){
                    key_body.getValue().velocity = key_body.getValue().calculate_orbital_velocity(bodies.get(use_orbital_velocity_from), object.getBoolean("orbit_is_clockwise"));                    
                }
                break;
            }
        }
    }

    output.framerate = json.getInt("FPS");
    output.objects = bodies.values().toArray(new SpaceObject[0]);
    output.objects_to_draw_physics_data = draw_physics_data.toArray(new SpaceObject[0]);
    return output;
};
