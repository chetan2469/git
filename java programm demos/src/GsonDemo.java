import com.google.gson.Gson;

public class GsonDemo {
	
	public static void main(String[] args) {
		
		Bike b = new Bike("ZMR", "WW23", 35, 140);
		
		Gson gson = new Gson();

		String json = gson.toJson(b);
		
		System.out.println(json);
		
	}

}
