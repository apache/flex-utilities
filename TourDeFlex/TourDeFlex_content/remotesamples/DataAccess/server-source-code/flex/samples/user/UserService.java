/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package flex.samples.user;

/**
 * UserService.java
 * 
 * @author Holly Schinsky - Rich Desktop Solutions, Inc
 * 
 * Created: May 20, 2009
 *
 */
public class UserService {
	private static String JANUARY = "January";
	private static String FEBRUARY = "February";
	private static String MARCH = "March";
	private static String APRIL = "April";
	private static String MAY = "May";
	private static String JUNE = "June";
	private static String JULY = "July";
	private static String AUGUST = "August";
	private static String SEPTEMBER = "September";
	private static String OCTOBER = "October";
	private static String NOVEMBER = "November";
	private static String DECEMBER = "December";
	
	private static String ADD = "Add";
	private static String SUBTRACT = "Subtract";
	private static String MULTIPLY = "Multiply";
	private static String DIVIDE = "Divide";
	
	public User getBirthStone(User user) throws Exception {
		if (user.getBirthMonth().equals(JANUARY))
			user.setBirthStone("Garnet");
		else if (user.getBirthMonth().equals(FEBRUARY))
			user.setBirthStone("Amethyst");
		else if (user.getBirthMonth().equals(MARCH))
			user.setBirthStone("Aquamarine");
		else if (user.getBirthMonth().equals(APRIL))
			user.setBirthStone("Diamond");
		else if (user.getBirthMonth().equals(MAY))
			user.setBirthStone("Emerald");
		else if (user.getBirthMonth().equals(JUNE))
			user.setBirthStone("Alexandrite");
		else if (user.getBirthMonth().equals(JULY))
			user.setBirthStone("Ruby");
		else if (user.getBirthMonth().equals(AUGUST))
			user.setBirthStone("Peridot");
		else if (user.getBirthMonth().equals(SEPTEMBER))
			user.setBirthStone("Sapphire");
		else if (user.getBirthMonth().equals(OCTOBER))
			user.setBirthStone("Opal");
		else if (user.getBirthMonth().equals(NOVEMBER))
			user.setBirthStone("Topaz");
		else if (user.getBirthMonth().equals(DECEMBER))
			user.setBirthStone("Turquoise");
	
		return user;
	}
	
    public String sayHello()
    {
    	return "Hello from Java!";
    }
   
    public String getMathResult(String operation, int a, int b)
    {
    	String result = null;
    	try {
	    	if (operation.equals(ADD)) {
	    	    result = String.valueOf(a+b);
	    	}
	    	else if (operation.equals(SUBTRACT)) {
	    	    result = String.valueOf(a-b);
	    	}
	    	else if (operation.equals(MULTIPLY)) {
	    	    result = String.valueOf(a*b);
	    	}
	    	else if (operation.equals(DIVIDE)) {
	    	    result = String.valueOf(a/b);
	    	}
    	}
    	catch (Exception ex) {
    		result = "NaN";
    	}
    	return result;
    }
    public String addString(int a, int b)
    {
        return String.valueOf(a+b);
    }
}
