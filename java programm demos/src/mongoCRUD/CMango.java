package mongoCRUD;

import org.bson.Document;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class CMango {

	public static void main(String[] args) {
		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
			
			DB database = mongoClient.getDB("chedo");

			DBCollection collection = database.getCollection("emp");
			
			BasicDBObject document = new BasicDBObject();
			document.put("_id", "1111112222333");
			document.put("name", "suraj");
			document.put("company", "ppp");
			document.put("college", "vit");
			
			collection.insert(document);

		} catch (Exception e) {
			System.out.println(e);
		}
	}

}
