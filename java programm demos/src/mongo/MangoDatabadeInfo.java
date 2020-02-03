package mongo;

import com.mongodb.DB;
import com.mongodb.MongoClient;

public class MangoDatabadeInfo {

	public static void main(String[] args) {
		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
			DB database = mongoClient.getDB("myMongoDb");
			mongoClient.getDatabaseNames().forEach(System.out::println);

		} catch (Exception e) {
			System.out.println(e);
		}
	}

}
