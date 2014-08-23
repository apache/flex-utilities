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
package flex.samples.product2;

import java.util.List;
import java.util.Collection;
import java.util.Map;

import flex.data.DataSyncException;
import flex.data.assemblers.AbstractAssembler;

/**
 * ProductAssembler.java
 * 
 * @author Holly Schinsky - Rich Desktop Solutions, Inc
 * 
 * This class acts as a custom assembler for the data service to use in performing
 * custom implementations of the methods needed. It overrides methods found in the
 * AbstractAssembler default implementation to perform more specific operations for
 * the given application.
 * 
 * Created: May 18, 2009
 *
 */
public class ProductAssembler extends AbstractAssembler {
	private String uniqueId = null;
	private ProductDAO dao = new ProductDAO();
	
	public Collection fill(List fillParameters)
    {
		// Note: in this example, the fill is implemented with an extra parameter to make sure the current user
		// running the sample in Tour de Flex gets their own results. Many times you will write a fill method
		// that has no fill parameters and simply returns all the results. On the client side then you would
		// only use an empty fill() method call.
		if (fillParameters.size() == 0)
		{
			return dao.findAll();
		}
		else {
			String queryName = (String) fillParameters.get(0);
			if (queryName.equals("by-uid"))
			{
				uniqueId = (String) fillParameters.get(1);
				if (uniqueId != null)
				{
					List l = dao.findByUid(uniqueId);
					if (l.size() == 0)
					{
						// This is the first time in for this unique user, let's create some for them...
						dao.create(new Product(0,"Nokia 3100 Pink","Nokia_3100_pink.gif","3000", 139.0E0,"Light up the night with a glow-in-the-dark cover - when it is charged with light you can easily find your phone in the dark. When you get a call, the Nokia 3100 phone flashes in tune with your ringing tone. And when you snap on a Nokia Xpress-on gaming cover, you will get luminescent light effects in time to the gaming action.",30,uniqueId));	
						dao.create(new Product(1,"Nokia 6010","Nokia_6010.gif","6000",99.0E0,"Easy to use without sacrificing style, the Nokia 6010 phone offers functional voice communication supported by text messaging, multimedia messaging, mobile internet, games and more.",21,uniqueId));
						dao.create(new Product(2,"Nokia 3100 Blue","Nokia_3100_blue.gif","9000", 109.0E0,"Light up the night with a glow-in-the-dark cover - when it is charged with light you can easily find your phone in the dark. When you get a call, the Nokia 3100 phone flashes in tune with your ringing tone. And when you snap on a Nokia Xpress-on gaming cover, you will get luminescent light effects in time to the gaming action.",99,uniqueId));
						dao.create(new Product(3,"Nokia 3220","Nokia_3220.gif","3000",199.0E0,"The Nokia 3220 phone is a fresh new cut on some familiar ideas - animate your MMS messages with cute characters, see the music with lights that flash in time with your ringing tone, download wallpapers and screensavers with matching color schemes for the interface.",20,uniqueId));
						dao.create(new Product(4,"Nokia 3650","Nokia_3650.gif","3000",200.0E0,"Messaging is more personal, versatile and fun with the Nokia 3650 camera phone.  Capture experiences as soon as you see them and send the photos you take to you friends and family.",11,uniqueId));
						dao.create(new Product(5,"Nokia 6820","Nokia_6820.gif","6000",299.99E0,"Messaging just got a whole lot smarter. The Nokia 6820 messaging device puts the tools you need for rich communication - full messaging keyboard, digital camera, mobile email, MMS, SMS, and Instant Messaging - right at your fingertips, in a small, sleek device.",8,uniqueId));
						dao.create(new Product(6,"Nokia 6670","Nokia_6670.gif","6000",319.99E0,"Classic business tools meet your creative streak in the Nokia 6670 imaging smartphone. It has a Netfront Web browser with PDF support, document viewer applications for email attachments, a direct printing application, and a megapixel still camera that also shoots up to 10 minutes of video.",2,uniqueId));
					}
					// re-do the find to get the ones just created and return them
					l = dao.findByUid(uniqueId);
					return l;
				}
			}
		}
		return super.fill(fillParameters); // throws a nice error
    }
	
	public Object getItem(Map map) {
		return dao.getProduct(((Integer) map.get("productId")).intValue());
	}

	public void createItem(Object item) {
		dao.create((Product) item);
	}

	public void updateItem(Object newVersion, Object prevVersion, List changes) {
		int productId = ((Product) newVersion).getProductId();
		try
		{
			dao.update((Product) newVersion);
		}
		catch (ConcurrencyException e)
		{
			System.err.println("*** Throwing DataSyncException when trying to update product id=" + productId);
			throw new DataSyncException(dao.getProduct(productId), changes);
		}
	}

	public void deleteItem(Object item) {
		try
		{
			dao.delete((Product) item);
		}
		catch (ConcurrencyException e)
		{
            int productId = ((Product) item).getProductId();
			System.err.println("*** Throwing DataSyncException when trying to delete product id=" + productId);
			throw new DataSyncException(dao.getProduct(productId), null);
		}
	}
	
}