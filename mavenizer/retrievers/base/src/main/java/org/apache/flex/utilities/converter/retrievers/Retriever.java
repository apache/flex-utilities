package org.apache.flex.utilities.converter.retrievers;

import org.apache.flex.utilities.converter.retrievers.exceptions.RetrieverException;
import org.apache.flex.utilities.converter.retrievers.types.PlatformType;
import org.apache.flex.utilities.converter.retrievers.types.SDKType;

/**
 * Created by cdutz on 18.05.2014.
 */
public interface Retriever {

    void retrieve(PlatformType platformType, SDKType sdkType, String version) throws RetrieverException;

}
