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
package flex.samples.pdfgen_contact;

import java.io.IOException;

import javax.servlet.http.HttpServletRequest;

import org.w3c.dom.Document;

import flex.acrobat.pdf.XFAHelper;
import flex.messaging.FlexContext;
import flex.messaging.FlexSession;
import flex.messaging.util.UUIDUtils;

public class PDFService
{
    public PDFService()
    {
    }

    public Object generatePDF(Document dataset) throws IOException
    {
     	
        // Open shell PDF based on the servlet context (in this case, webapp root)
        String source = FlexContext.getServletContext().getRealPath("/pdfgen_contact/contact.pdf");
        XFAHelper helper = new XFAHelper();
        helper.open(source);

        // Import XFA dataset
        helper.importDataset(dataset);

        // Save new PDF as a byte array in the current session
        byte[] bytes = helper.saveToByteArray();
        String uuid = UUIDUtils.createUUID();
        FlexSession session = FlexContext.getFlexSession();
        session.setAttribute(uuid, bytes);

        // Close any resources
        helper.close();

        HttpServletRequest req = FlexContext.getHttpRequest();
        String contextRoot = "/lcds-samples";
        if (req != null)
            contextRoot = req.getContextPath();

        String r = contextRoot + "/dynamic-pdf?id=" + uuid + "&;jsessionid=" + session.getId();
        System.out.println(r);
        return r;
    }
}
