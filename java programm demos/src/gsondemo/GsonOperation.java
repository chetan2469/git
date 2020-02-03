package gsondemo;

import com.google.gson.Gson;

public class GsonOperation {

	void toObject() {
		String json = "{\"brand\":\"Porsche\", \"doors\": 4}";

		Gson gson = new Gson();

		Car car = gson.fromJson(json, Car.class);

		System.out.println(car.brand);
		System.out.println(car.doors);
	}

	public static void main(String[] args) {

		GsonOperation g = new GsonOperation();
		g.toObject();

	}

}
