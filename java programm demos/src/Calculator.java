

import java.awt.Button;
import java.awt.Checkbox;
import java.awt.CheckboxGroup;
import java.awt.Choice;
import java.awt.Frame;
import java.awt.Label;
import java.awt.List;
import java.awt.TextField;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class Calculator extends Frame implements ActionListener
{	
	Label l;
	Button b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13,b14,b15,b16,b17,b18,b19,b20;
	TextField t1;
	String s0,s1,s2;
	Calculator()
	{
		s0=s1=s2="";
		t1=new TextField();
		t1.setBounds(100,200,250,40);
		add(t1);
		
		b1=new Button("AC");
		b1.setBounds(100,250,50,50);
		add(b1);
		b1.addActionListener(this);
		
		b2=new Button("C");
		b2.setBounds(170,250,50,50);
		add(b2);
		b2.addActionListener(this);
		
		b3=new Button("%");
		b3.setBounds(240,250,50,50);
		add(b3);
		b3.addActionListener(this);
		
		b4=new Button("+");
		b4.setBounds(310,250,50,50);
		add(b4);
		b4.addActionListener(this);
		
		b5=new Button("9");
		b5.setBounds(100,330,50,50);
		add(b5);
		b5.addActionListener(this);
		
		b6=new Button("8");
		b6.setBounds(170,330,50,50);
		add(b6);
		b6.addActionListener(this);
		
		b7=new Button("7");
		b7.setBounds(240,330,50,50);
		add(b7);
		b7.addActionListener(this);
		
		b8=new Button("-");
		b8.setBounds(310,330,50,50);
		add(b8);
		b8.addActionListener(this);
		
		b9=new Button("6");
		b9.setBounds(100,410,50,50);
		add(b9);
		b9.addActionListener(this);
		
		b10=new Button("5");
		b10.setBounds(170,410,50,50);
		add(b10);
		b10.addActionListener(this);
		
		b11=new Button("4");
		b11.setBounds(240,410,50,50);
		add(b11);
		b11.addActionListener(this);
		
		b12=new Button("/");
		b12.setBounds(310,410,50,50);
		add(b12);
		b12.addActionListener(this);
		
		b13=new Button("3");
		b13.setBounds(100,490,50,50);
		add(b13);
		b13.addActionListener(this);
		
		b14=new Button("2");
		b14.setBounds(170,490,50,50);
		add(b14);
		b14.addActionListener(this);
		
		b15=new Button("1");
		b15.setBounds(240,490,50,50);
		add(b15);
		b15.addActionListener(this);
		
		b16=new Button("*");
		b16.setBounds(310,490,50,50);
		add(b16);
		b16.addActionListener(this);
		
		b17=new Button("");
		b17.setBounds(100,570,50,50);
		add(b17);
		b17.addActionListener(this);
		
		b18=new Button("0");
		b18.setBounds(170,570,50,50);
		add(b18);
		b18.addActionListener(this);
		
		b19=new Button(".");
		b19.setBounds(240,570,50,50);
		add(b19);
		b19.addActionListener(this);
		
		b20=new Button("=");
		b20.setBounds(310,570,50,50);
		add(b20);
		b20.addActionListener(this);
			
		
		setSize(800,800);
		setLocation(400,300);
		setLayout(null);
		setVisible(true);
	}
	
	public static void main(String arg[])
	{
		new Calculator();
	}

	@Override
	public void actionPerformed(ActionEvent e)
	{
	
		String s=e.getActionCommand();
		if((s.charAt(0)>='0'&& s.charAt(0)<='9')||s.charAt(0)=='.')
		{
			if (!s1.equals(""))
				s2=s2+s;
			else
				s0=s0+s;
		t1.setText(s0+s1+s2);
			
		}
		else if (s.charAt(0)=='C')
		{
			s0=s1=s2="";
			t1.setText(s0+s1+s2);
			
			
		}
		else if (s.equals("AC"))
		{
			s0=s1=s2="";
			t1.setText(s0+s1+s2);
			
			
		}
		else if(s.charAt(0) == '=')
		{
			double c=0;
			if(s1.equals("+"))
				c=(Double.parseDouble(s0)+Double.parseDouble(s2));
			else if(s1.equals("-"))
				c=(Double.parseDouble(s0)-Double.parseDouble(s2));
			else if(s1.equals("*"))
				c=(Double.parseDouble(s0)*Double.parseDouble(s2));
			else if(s1.equals("/"))
				c=(Double.parseDouble(s0)/Double.parseDouble(s2));
			else if(s1.equals("%"))
				c=(Double.parseDouble(s0)%Double.parseDouble(s2));
			
			String t=c+"";
			String d = null;
			if(t.contains("."))
			{
				t=t.substring(0,t.indexOf('.'))+t.substring(t.indexOf('.'),(t.indexOf('.')+3));
				System.out.println("_________________________contins .");
			}
			else {
				System.out.println("_________________________Not contins .");
			}
			
			s0=s1=s2="";
			t1.setText("");
			t1.setText(""+t);
			
			
		}
		else
		{
			
			if(s1.equals("")||s2.equals(""))
				s1=s;
			else
			{
				double c = 0;
				if(s1.equals("+"))
					c=(Double.parseDouble(s0)+Double.parseDouble(s2));
				else if(s1.equals("-"))
					c=(Double.parseDouble(s0)-Double.parseDouble(s2));
				else if(s1.equals("*"))
					c=(Double.parseDouble(s0)*Double.parseDouble(s2));
				else if(s1.equals("/"))
					c=(Double.parseDouble(s0)/Double.parseDouble(s2));
				else if(s1.equals("%"))
					c=(Double.parseDouble(s0)%Double.parseDouble(s2));
				String t=c+"";
				String d;
				if(t.contains("."))
				{
					d=t.substring(0,t.indexOf('.'))+t.substring(t.indexOf('.'),(t.indexOf('.')+3));
					System.out.println("_________________________contins .");
				}
				else {
					System.out.println("_________________________Not contins .");
				}
				
				s0=s1=s2="";
				t1.setText("");
				t1.setText(""+t);
				
				
			}
			
			t1.setText(s0+s1+s2);
		}
	}
}
