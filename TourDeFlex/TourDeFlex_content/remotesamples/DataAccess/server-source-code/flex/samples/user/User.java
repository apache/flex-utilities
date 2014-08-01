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
 * User.java
 * 
 * @author Holly Schinsky - Rich Desktop Solutions, Inc
 * 
 * Created: May 20, 2009
 *
 */

public class User {
	
	private String name;
	private String birthMonth;
	private String birthStone;
	
	public User() {

	}

	public User(String name, String birthMonth, String birthStone) {
		this.name = name;
		this.birthMonth = birthMonth;
		this.birthStone = birthStone;
	}

	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public void setBirthMonth(String birthMonth) {
		this.birthMonth = birthMonth;
	}
	public String getBirthMonth() {
		return birthMonth;
	}
	public void setBirthStone(String birthStone) {
		this.birthStone = birthStone;	
	}
	public String getBirthStone() {
		return birthStone;
	}
}


