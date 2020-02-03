package mongoCRUD;

import org.bson.Document;

import com.google.gson.Gson;
import com.mongodb.BasicDBObject;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;

import mongo.Stud;

public class Rmango {

	public static void main(String[] args) {

		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
		
			DB database = mongoClient.getDB("chedo");

			DBCollection collection = database.getCollection("emp");
			
			BasicDBObject searchQuery = new BasicDBObject();

		//	searchQuery.put("name", "ninad");

			DBCursor cursor = collection.find();

			while (cursor.hasNext()) {
				System.out.println(cursor.next().get("_id"));

			}
		} catch (Exception e) {
			System.out.println(e);
		}

	}

}
