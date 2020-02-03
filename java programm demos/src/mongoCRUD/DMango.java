package mongoCRUD;

import org.bson.Document;

import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

public class DMango {

	public static void main(String[] args) {

		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
			DB database = mongoClient.getDB("chedo");

			DBCollection collection = database.getCollection("emp");
			
			BasicDBObject searchQuery = new BasicDBObject();
			
			searchQuery.put("name", "suraj");
			 
			collection.remove(searchQuery);

		} catch (Exception e) {
			System.out.println(e);
		}

	}

}
