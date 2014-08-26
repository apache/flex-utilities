/**
 *    Copyright (c) 2009, Adobe Systems, Incorporated
 *    All rights reserved.
 *
 *    Redistribution  and  use  in  source  and  binary  forms, with or without
 *    modification,  are  permitted  provided  that  the  following  conditions
 *    are met:
 *
 *      * Redistributions  of  source  code  must  retain  the  above copyright
 *        notice, this list of conditions and the following disclaimer.
 *      * Redistributions  in  binary  form  must reproduce the above copyright
 *        notice,  this  list  of  conditions  and  the following disclaimer in
 *        the    documentation   and/or   other  materials  provided  with  the
 *        distribution.
 *      * Neither the name of the Adobe Systems, Incorporated. nor the names of
 *        its  contributors  may be used to endorse or promote products derived
 *        from this software without specific prior written permission.
 *
 *    THIS  SOFTWARE  IS  PROVIDED  BY THE  COPYRIGHT  HOLDERS AND CONTRIBUTORS
 *    "AS IS"  AND  ANY  EXPRESS  OR  IMPLIED  WARRANTIES,  INCLUDING,  BUT NOT
 *    LIMITED  TO,  THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
 *    PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER
 *    OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT,  INCIDENTAL,  SPECIAL,
 *    EXEMPLARY,  OR  CONSEQUENTIAL  DAMAGES  (INCLUDING,  BUT  NOT  LIMITED TO,
 *    PROCUREMENT  OF  SUBSTITUTE   GOODS  OR   SERVICES;  LOSS  OF  USE,  DATA,
 *    OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
 *    LIABILITY,  WHETHER  IN  CONTRACT,  STRICT  LIABILITY, OR TORT (INCLUDING
 *    NEGLIGENCE  OR  OTHERWISE)  ARISING  IN  ANY  WAY  OUT OF THE USE OF THIS
 *    SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */
package com.adobe.ac.pmd.metrics.maven.generators;

/*
 * Copyright 2004-2005 The Apache Software Foundation.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import java.util.ResourceBundle;

import org.apache.maven.plugin.logging.Log;
import org.codehaus.doxia.sink.Sink;

/**
 * Base abstract class for NCSSReport classes.<br>
 * It holds essentially helper methods on top of the Sink Doxia object.
 *
 * @author <a href="jeanlaurent@NOSPAMgmail.com>Jean-Laurent de Morlhon</a>
 * @version $Id: AbstractNcssReportGenerator.java 3286 2007-02-08 20:18:51Z
 *          jeanlaurent $
 */
public class NcssReportGeneratorBase
{

    private final ResourceBundle bundle;
    private final Log            log;
    private final Sink           sink;

    /**
     * build a new NcssReportGenerator.
     *
     * @param sinkToBeSet the sink which will be used for reporting.
     * @param bundleToBeSet the correct RessourceBundle to be used for reporting.
     * @param logToBeSet the log object enabling logging within maven plugins.
     */
    protected NcssReportGeneratorBase( final Sink sinkToBeSet,
                                       final ResourceBundle bundleToBeSet,
                                       final Log logToBeSet )
    {
        bundle = bundleToBeSet;
        sink = sinkToBeSet;
        log = logToBeSet;
    }

    /**
     * Getter for the Log instance.
     *
     * @return the current log instance associated with this report generator.
     */
    public Log getLog()
    {
        return this.log;
    }

    /**
     * Getter for the RessourceBundle.
     *
     * @return the current ResourceBundle associated with this report generator.
     */
    public ResourceBundle getResourceBundle()
    {
        return this.bundle;
    }

    /**
     * Getter for the Sink instance.
     *
     * @return the current instance of Sink associated with this report
     *         generator.
     */
    public Sink getSink()
    {
        return this.sink;
    }

    /**
     * sink helper to write cell containing code.
     *
     * @param text the text to write within a cell and within code tags.
     */
    protected void codeCellHelper( final String text )
    {
        sink.tableCell();
        sink.monospaced();
        sink.text( text );
        sink.monospaced_();
        sink.tableCell_();
    }

    /**
     * sink helper to write a "code" itemList.
     *
     * @param test the text to write within the code tags.
     */
    protected void codeItemListHelper( final String text )
    {
        sink.listItem();
        sink.monospaced();
        sink.text( text );
        sink.monospaced_();
        sink.listItem_();
    }

    /**
     * sink helper to end a section
     */
    protected void endSection()
    {
        sink.section1_();
    }

    /**
     * sink helper to write a simple table header cell.
     *
     * @param text the text to write within a table header cell.
     */
    protected void headerCellHelper( final String text )
    {
        sink.tableHeaderCell();
        sink.text( text );
        sink.tableHeaderCell_();
    }

    /**
     * sink helper to write a paragrah
     *
     * @param the text to write within the paragraph.
     */
    protected void paragraphHelper( final String text )
    {
        sink.paragraph();
        sink.text( text );
        sink.paragraph_();
    }

    /**
     * sink helper to start a section.
     *
     * @param locale the locale to be used to display text within the section
     *           start.
     * @param link the anchor link.
     * @param title the title of the anchor link.
     */
    protected void startSection( final String link,
                                 final String title )
    {
        sink.section1();
        sink.sectionTitle1();
        sink.anchor( bundle.getString( link ) );
        sink.text( bundle.getString( title ) );
        sink.anchor_();
        sink.sectionTitle1_();
    }

    /**
     * sink helper to write a subtitle
     *
     * @param text the text to write as a subtitle.
     */
    protected void subtitleHelper( final String text )
    {
        sink.paragraph();
        sink.bold();
        sink.text( text );
        sink.bold_();
        sink.paragraph_();
    }

    /**
     * sink helper to write a simple tabke cell.
     *
     * @param text the text to write within a table cell.
     */
    protected void tableCellHelper( final String text )
    {
        sink.tableCell();
        sink.text( text );
        sink.tableCell_();
    }
}