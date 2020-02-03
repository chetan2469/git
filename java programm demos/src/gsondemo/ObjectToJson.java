package gsondemo;

import com.google.gson.Gson;

public class ObjectToJson {
	
	public static void main(String[] args) {
		
		Car c = new Car();
		c.brand="BMW";
		c.doors = 2;
		
		Gson gson = new Gson();
		
		String s = gson.toJson(c);
		
		System.out.println(s);
				

	}

}
