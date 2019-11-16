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
package org.apache.flex.utilities.converter.retrievers.utils;

import org.apache.commons.lang3.StringUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ProgressBar {

    private static final Logger LOG = LoggerFactory.getLogger(ProgressBar.class);

    protected long total;

    public ProgressBar(long total) {
        this.total = total;
        drawOutput(0l);
    }

    public void updateProgress(long current) {
        drawOutput(current);
    }

    protected void drawOutput(long current) {
        final int transferredPercent = (int) Math.round(
                ((double) current / (double) total) * (double) 100);
        final int segmentsTransferred = transferredPercent / 2;
        final int segmentsRest = 50 - segmentsTransferred;
        LOG.info("\r" + String.format(" %3d", transferredPercent) + "% [" +
                StringUtils.repeat("=", segmentsTransferred) +
                ((segmentsRest > 0) ? ">" + StringUtils.repeat(" ", segmentsRest - 1) : "") + "] ");
    }

}
