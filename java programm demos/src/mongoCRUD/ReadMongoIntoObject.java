package mongoCRUD;

import com.mongodb.BasicDBObjectBuilder;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;

public class ReadMongoIntoObject {
	
	private static User createUser() {
		User u = new User();
		u.set_id(2);
		u.setName("Rajesh");
		u.setCollege("VIIT");
		u.setCompany("Chedo");
		return u;
	}
	
	private static DBObject createDBObject(User user) {
		BasicDBObjectBuilder docBuilder = BasicDBObjectBuilder.start();
								
		docBuilder.append("_id", user.get_id());
		docBuilder.append("name", user.getName());
		docBuilder.append("company", user.getCollege());
		docBuilder.append("college", user.getCompany());
		return docBuilder.get();
	}
	
	public static void main(String[] args) {
		
		
		User user = createUser();
		DBObject doc = createDBObject(user);
		
		MongoClient mongo = new MongoClient("localhost", 27017);
		DB db = mongo.getDB("chedo");
		
		DBCollection col = db.getCollection("emp");
		
		DBObject query = BasicDBObjectBuilder.start().add("_id", user.get_id()).get();
		DBCursor cursor = col.find(query);
		while(cursor.hasNext()){
			System.out.println(cursor.next());
		}
		
	}

}
