package mongo;

import com.google.gson.Gson;

import gsondemo.Car;
import gsondemo.GsonOperation;

public class StudData {
	
	void toObject()
	{
		String json = "{\"_id\": {\"$oid\": \"5e2543851dc646698269a673\"}, \"name\": \"ninad\", \"company\": \"abc\", \"college\": \"vit\"}";

		Gson gson = new Gson();

		Stud s = gson.fromJson(json, Stud.class);
		
		System.out.println(s.name);
		System.out.println(s.company);
	}
	
	
	public static void main(String[] args) {
		
		StudData g = new StudData();
		g.toObject();
		
	}

}
