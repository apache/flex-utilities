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
package com.adobe.ac.pmd.rules.parsley.utils;

import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Map;

import com.adobe.ac.pmd.rules.parsley.utils.MetaDataTag.Location;

public final class ParsleyMetaData
{
   private ParsleyMetaData()
   {
      super();
   }
 
   private static final String                     KEY                  = "key";

   private static final String                     BUNDLE               = "bundle";

   private static final String                     ORDER                = "order";

   private static final String                     SINGLETON            = "singleton";

   private static final String                     LAZY                 = "lazy";

   private static final String                     MESSAGE_PROPERTIES   = "messageProperties";

   private static final String                     PROPERTY             = "property";

   private static final String                     TARGET_PROPERTY      = "targetProperty";

   private static final String                     SCOPE                = "scope";

   private static final String                     REQUIRED             = "required";

   private static final String                     ERROR_EVENT          = "errorEvent";

   private static final String                     COMPLETE_EVENT       = "completeEvent";

   private static final String                     SELECTOR2            = "selector";

   private static final String                     MESSAGE_PROPERTY     = "messageProperty";

   private static final String                     TYPE                 = "type";

   private static final String                     NAMES                = "names";

   private static final String                     ID_PROPERTY          = "id";

   private static final String                     METHOD               = "method";

   private static final MetaDataTag.Location[]     CLASS_LOCATION       = new MetaDataTag.Location[]
                                                                        { MetaDataTag.Location.CLASS_DECLARATION };

   private static final MetaDataTag.Location[]     FUNCTION_LOCATION    = new MetaDataTag.Location[]
                                                                        { MetaDataTag.Location.FUNCTION };

   private static final MetaDataTag.Location[]     ATTR_FCTION_LOCATION = new MetaDataTag.Location[]
                                                                        { MetaDataTag.Location.ATTRIBUTE,
               MetaDataTag.Location.FUNCTION                           };

   private static final MetaDataTag.Location[]     ATTRIBUTE_LOCATION   = new MetaDataTag.Location[]
                                                                        { MetaDataTag.Location.ATTRIBUTE };

   public static final MetaDataTag                 ASYNC_INIT           = new MetaDataTag( "AsyncInit",
                                                                                           new String[]
                                                                                           { COMPLETE_EVENT,
               ERROR_EVENT                                                                },
                                                                                           CLASS_LOCATION );

   public static final MetaDataTag                 COMMAND_COMPLETE     = new MetaDataTag( "CommandComplete",
                                                                                           new String[]
                                                                                           {},
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 DESTROY              = new MetaDataTag( "Destroy",
                                                                                           new String[]
                                                                                           { METHOD },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 FACTORY              = new MetaDataTag( "Factory",
                                                                                           new String[]
                                                                                           { METHOD },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 INIT                 = new MetaDataTag( "Init",
                                                                                           new String[]
                                                                                           { METHOD },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 INJECT               = new MetaDataTag( "Inject",
                                                                                           new String[]
                                                                                           { ID_PROPERTY,
               REQUIRED                                                                   },
                                                                                           ATTR_FCTION_LOCATION );

   public static final MetaDataTag                 INJECT_CONSTRUCTOR   = new MetaDataTag( "InjectConstructor",
                                                                                           new String[]
                                                                                           {},
                                                                                           CLASS_LOCATION );

   public static final MetaDataTag                 INTERNAL             = new MetaDataTag( "Internal",
                                                                                           new String[]
                                                                                           {},
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 MANAGED_EVENTS       = new MetaDataTag( "ManagedEvents",
                                                                                           new String[]
                                                                                           { NAMES,
               SCOPE                                                                      },
                                                                                           CLASS_LOCATION );

   public static final MetaDataTag                 MESSAGE_BINDING      = new MetaDataTag( "MessageBinding",
                                                                                           new String[]
                                                                                           { TYPE,
               MESSAGE_PROPERTY,
               SELECTOR2,
               SCOPE,
               TARGET_PROPERTY                                                            },
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 MESSAGE_DISPATCHER   = new MetaDataTag( "MessageDispatcher",
                                                                                           new String[]
                                                                                           { PROPERTY,
               SCOPE                                                                      },
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 MESSAGE_ERROR        = new MetaDataTag( "MessageError",
                                                                                           new String[]
                                                                                           { TYPE,
               SELECTOR2,
               SCOPE,
               METHOD                                                                     },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 MESSAGE_HANDLER      = new MetaDataTag( "MessageHandler",
                                                                                           new String[]
                                                                                           { TYPE,
               MESSAGE_PROPERTIES,
               SELECTOR2,
               SCOPE,
               METHOD                                                                     },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 MESSAGE_INTERCEPTOR  = new MetaDataTag( "MessageInterceptor",
                                                                                           new String[]
                                                                                           { TYPE,
               SELECTOR2,
               SCOPE,
               METHOD                                                                     },
                                                                                           FUNCTION_LOCATION );

   public static final MetaDataTag                 OBJECT_DEFINITION    = new MetaDataTag( "ObjectDefinition",
                                                                                           new String[]
                                                                                           { LAZY,
               SINGLETON,
               ID_PROPERTY,
               ORDER                                                                      },
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 RESOURCE_BINDING     = new MetaDataTag( "ResourceBinding",
                                                                                           new String[]
                                                                                           { BUNDLE,
               KEY,
               PROPERTY                                                                   },
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 SELECTOR             = new MetaDataTag( "Selector",
                                                                                           new String[]
                                                                                           {},
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag                 TARGET               = new MetaDataTag( "Target",
                                                                                           new String[]
                                                                                           {},
                                                                                           ATTRIBUTE_LOCATION );

   public static final MetaDataTag[]               ALL_TAGS             =
                                                                        { INJECT,
               INJECT_CONSTRUCTOR,
               MANAGED_EVENTS,
               MESSAGE_BINDING,
               MESSAGE_DISPATCHER,
               MESSAGE_ERROR,
               MESSAGE_HANDLER,
               MESSAGE_INTERCEPTOR,
               COMMAND_COMPLETE,
               ASYNC_INIT,
               INIT,
               DESTROY,
               RESOURCE_BINDING,
               FACTORY,
               OBJECT_DEFINITION,
               TARGET,
               INTERNAL                                                };

   private static final Map< String, MetaDataTag > TAG_MAP              = new LinkedHashMap< String, MetaDataTag >();

   static
   {
      TAG_MAP.put( INJECT.getName(),
                   INJECT );
      TAG_MAP.put( COMMAND_COMPLETE.getName(),
                   COMMAND_COMPLETE );
      TAG_MAP.put( INJECT_CONSTRUCTOR.getName(),
                   INJECT_CONSTRUCTOR );
      TAG_MAP.put( MANAGED_EVENTS.getName(),
                   MANAGED_EVENTS );
      TAG_MAP.put( MESSAGE_BINDING.getName(),
                   MESSAGE_BINDING );
      TAG_MAP.put( MESSAGE_DISPATCHER.getName(),
                   MESSAGE_DISPATCHER );
      TAG_MAP.put( MESSAGE_ERROR.getName(),
                   MESSAGE_ERROR );
      TAG_MAP.put( MESSAGE_HANDLER.getName(),
                   MESSAGE_HANDLER );
      TAG_MAP.put( MESSAGE_INTERCEPTOR.getName(),
                   MESSAGE_INTERCEPTOR );
      TAG_MAP.put( ASYNC_INIT.getName(),
                   ASYNC_INIT );
      TAG_MAP.put( INIT.getName(),
                   INIT );
      TAG_MAP.put( DESTROY.getName(),
                   DESTROY );
      TAG_MAP.put( RESOURCE_BINDING.getName(),
                   RESOURCE_BINDING );
      TAG_MAP.put( FACTORY.getName(),
                   FACTORY );
      TAG_MAP.put( OBJECT_DEFINITION.getName(),
                   OBJECT_DEFINITION );
      TAG_MAP.put( TARGET.getName(),
                   TARGET );
      TAG_MAP.put( INTERNAL.getName(),
                   INTERNAL );
   }

   public static MetaDataTag getTag( final String name )
   {
      return TAG_MAP.get( name );
   }

   public static boolean isParsleyMetaData( final String name )
   {
      return TAG_MAP.containsKey( name );
   }
   
   public static Map< String, MetaDataTag > getPossibleMetaDataFromLocation( Location location )
   {
      Map< String, MetaDataTag > tags = new HashMap< String, MetaDataTag >();
      
      for ( MetaDataTag metaDataTag : ALL_TAGS )
      {
         if ( metaDataTag.getPlacedOn().contains( location ) )
         {
            tags.put( metaDataTag.getName(), metaDataTag );
         }
      }
      return tags;
   }
}