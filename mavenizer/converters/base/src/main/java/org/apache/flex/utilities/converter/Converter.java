package org.apache.flex.utilities.converter;

import org.apache.flex.utilities.converter.exceptions.ConverterException;

import java.io.File;

/**
 * Created by cdutz on 18.04.2014.
 */
public interface Converter {

    void convert() throws ConverterException;

}
