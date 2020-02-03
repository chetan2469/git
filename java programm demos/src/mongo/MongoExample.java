package mongo;

import java.net.UnknownHostException;
import java.util.Scanner;

import com.mongodb.BasicDBObjectBuilder;
import com.mongodb.DB;
import com.mongodb.DBCollection;
import com.mongodb.DBCursor;
import com.mongodb.DBObject;
import com.mongodb.MongoClient;
import com.mongodb.WriteResult;
import mongo.User;

public class MongoExample {

	public static void main(String[] args) throws UnknownHostException {
		
		
	
		User user = createUser();
		DBObject doc = createDBObject(user);
		
		MongoClient mongo = new MongoClient("localhost", 27017);
		DB db = mongo.getDB("journaldev");
		
		DBCollection col = db.getCollection("users");
		
		//create user
		WriteResult result = col.insert(doc);
		System.out.println(result.getUpsertedId());
		System.out.println(result.getN());
		System.out.println(result.isUpdateOfExisting());
		
		//read example
		DBObject query = BasicDBObjectBuilder.start().add("_id", user.getId()).get();
		DBCursor cursor = col.find(query);
		while(cursor.hasNext()){
			System.out.println(cursor.next());
		}
		
		//update example
		user.setName("Pankaj Kumar");
		doc = createDBObject(user);
		result = col.update(query, doc);
		System.out.println(result.getUpsertedId());
		System.out.println(result.getN());
		System.out.println(result.isUpdateOfExisting());
		
		//delete example
		result = col.remove(query);
		System.out.println(result.getUpsertedId());
		System.out.println(result.getN());
		System.out.println(result.isUpdateOfExisting());
		
		//close resources
		mongo.close();
	}

	private static DBObject createDBObject(User user) {
		BasicDBObjectBuilder docBuilder = BasicDBObjectBuilder.start();
								
		docBuilder.append("_id", user.getId());
		docBuilder.append("name", user.getName());
		docBuilder.append("role", user.getRole());
		docBuilder.append("isEmployee", user.isEmployee());
		return docBuilder.get();
	}

	private static User createUser() {
		Scanner sc = new Scanner(System.in);
		User u = new User();
		
		System.out.println("Enter id");
		u.setId(sc.nextInt());
		
		System.out.println("Enter Name");
		u.setName(sc.next());
		
		u.setEmployee(true);
		u.setRole("CEO");
		return u;
	}
	
	

}