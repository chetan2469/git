

public class Bike {
	
	String name,model;
	
	int milage,topSpeed;
	
	
	
	public Bike(String name, String model, int milage, int topSpeed) {
		super();
		this.name = name;
		this.model = model;
		this.milage = milage;
		this.topSpeed = topSpeed;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getModel() {
		return model;
	}
	public void setModel(String model) {
		this.model = model;
	}
	public int getMilage() {
		return milage;
	}
	public void setMilage(int milage) {
		this.milage = milage;
	}
	public int getTopSpeed() {
		return topSpeed;
	}
	public void setTopSpeed(int topSpeed) {
		this.topSpeed = topSpeed;
	}
	
	

}
