package mongo;

import com.mongodb.MongoClient;
import com.mongodb.client.MongoCollection;
import com.mongodb.client.MongoDatabase;
import org.bson.Document;

public class JavaMongo {
	public static void main(String[] args) {
		try {
			MongoClient mongoClient = new MongoClient("localhost", 27017);
			MongoDatabase db = mongoClient.getDatabase("chedo");
			MongoCollection<Document> table = db.getCollection("emp");
			Document doc = new Document("name", "Abc");
			doc.append("id", 12);
			table.insertOne(doc);
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}