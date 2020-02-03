import com.google.gson.Gson;

public class FromJsonToObj {
	
	public static void main(String[] args) {
		
		Gson gson = new Gson();

		String json = "{\"name\":\"ZMR\",\"model\":\"WW23\",\"milage\":35,\"topSpeed\":140}\n" + 
				"";
		
		Bike b = gson.fromJson(json,Bike.class);
		
		System.out.println(b.name);
		
	}

}
