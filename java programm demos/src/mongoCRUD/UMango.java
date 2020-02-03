package mongoCRUD;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;

public class UMango {
	public static void main(String[] args) {
		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
			DB database = mongoClient.getDB("chedo");

			DBCollection collection = database.getCollection("emp");

			BasicDBObject newDoc = new BasicDBObject();

			newDoc.put("name", "Suraj");
			newDoc.put("college", "VIIT");
			newDoc.put("marks", "99");

			BasicDBObject searchQuery = new BasicDBObject().append("name", "Suraj");

			collection.update(searchQuery, newDoc);

		} catch (Exception e) {
			System.out.println(e);
		}
	}
}
