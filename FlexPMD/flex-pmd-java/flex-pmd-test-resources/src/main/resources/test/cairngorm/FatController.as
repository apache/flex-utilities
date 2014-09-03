////////////////////////////////////////////////////////////////////////////////
//
//  Licensed to the Apache Software Foundation (ASF) under one or more
//  contributor license agreements.  See the NOTICE file distributed with
//  this work for additional information regarding copyright ownership.
//  The ASF licenses this file to You under the Apache License, Version 2.0
//  (the "License"); you may not use this file except in compliance with
//  the License.  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
////////////////////////////////////////////////////////////////////////////////
package com.portal.Control
{
import com.portal.control.events.LoadUserProfileEvent;
import com.portal.control.commands.LoadUserProfileCommand;
    import com.adobe.cairngorm.control.FrontController;
    import com.platform.control.commands.community.LoadFavoriteModulesCommand;
    import com.platform.control.commands.contentbrowsing.LoadBrowsableKnowledgeCommand;
    import com.platform.control.commands.contentbrowsing.UpdateBrowsableKnowledgeCommand;
    import com.platform.control.commands.core.InitializeApplicationCommand;
    import com.platform.control.commands.learnmanagement.LoadExerciseContentTreeCommand;
    import com.platform.control.commands.learnmanagement.LoadTrainingCenterStatisticCommand;
    import com.platform.control.commands.notifications.LoadNotificationsCommand;
    import com.platform.control.commands.personalrecord.LoadPersonalRecordCommand;
    import com.platform.control.commands.personalrecord.UpdatePersonalRecordCommand;
    import com.platform.control.events.community.LoadFavoriteModulesEvent;
    import com.platform.control.events.contentbrowsing.LoadBrowsableKnowledgeEvent;
    import com.platform.control.events.contentbrowsing.UpdateBrowsableKnowledgeEvent;
    import com.platform.control.events.core.InitializeApplicationEvent;
    import com.platform.control.events.learnmanagement.LoadExerciseContentTreeEvent;
    import com.platform.control.events.learnmanagement.LoadTrainingCenterStatisticEvent;
    import com.platform.control.events.notificationbox.LoadNotificationsEvent;
    import com.platform.control.events.personalrecord.LoadPersonalRecordEvent;
    import com.platform.control.events.personalrecord.UpdatePersonalRecordEvent;
    import com.portal.control.commands.AcceptFriendshipCommand;
    import com.portal.control.commands.CancelFriendshipCommand;
    import com.portal.control.commands.DismissNotificationCommand;
    import com.portal.control.commands.LoadKnowledgeTreeCommand;
    import com.portal.control.commands.LoadRecentActivitiesCommand;
    import com.portal.control.commands.RejectFriendshipCommand;
    import com.portal.control.commands.ReloadBuddiesCommand;
    import com.portal.control.commands.SaveMyProfileCommand;
    import com.portal.control.commands.SaveUserCommand;
    import com.portal.control.commands.SearchUsersCommand;
    import com.portal.control.commands.SendFeedbackCommand;
    import com.portal.control.commands.SendLogoutCommand;
    import com.portal.control.commands.ShowHelpCommand;
    import com.portal.control.commands.StartFriendshipCommand;
    import com.portal.control.commands.URLLoaderCommand;
    import com.portal.control.commands.XMLParseCommand;
    import com.portal.control.events.AcceptFriendshipEvent;
    import com.portal.control.events.CancelFriendshipEvent;
    import com.portal.control.events.DismissNotificationEvent;
    import com.portal.control.events.LoadKnowledgeTreeEvent;
    import com.portal.control.events.LoadRecentActivitiesEvent;
    import com.portal.control.events.RejectFriendshipEvent;
    import com.portal.control.events.ReloadBuddiesEvent;
    import com.portal.control.events.SaveMyProfileEvent;
    import com.portal.control.events.SaveUserEvent;
    import com.portal.control.events.SearchUsersEvent;
    import com.portal.control.events.SendFeedbackEvent;
    import com.portal.control.events.SendLogoutEvent;
    import com.portal.control.events.ShowHelpEvent;
    import com.portal.control.events.StartFriendshipEvent;
    import com.portal.control.events.URLLoaderEvent;
    import com.portal.control.events.XMLParseEvent;
    import com.ecs.control.events.LoadArticleEvent;
    import com.ecs.control.commands.LoadArticleCommand;
    import com.ecs.control.commands.LoadMagazineCommand;
    import com.ecs.control.events.LoadMagazineEvent;    
	import mx.binding.utils.BindingUtils;
	
    /**
     * The main cairngorm controller. This defines the connections between the events and the commands 
     */
   public class Controller extends FrontController
   {
      public function Controller()
      {
      	 BindingUtils.bindSetter(setContent, value, "content");
         addCommand(
            InitializeApplicationEvent.EVENT_TYPE,
            InitializeApplicationCommand );
         addCommand(
            StartFriendshipEvent.EVENT_NAME,
            StartFriendshipCommand );
          addCommand(
            LoadNotificationsEvent.EVENT_TYPE,
            LoadNotificationsCommand );
          addCommand(
            DismissNotificationEvent.EVENT_NAME,
            DismissNotificationCommand );
         addCommand(
            AcceptFriendshipEvent.EVENT_NAME,
            AcceptFriendshipCommand );
         addCommand(
            CancelFriendshipEvent.EVENT_NAME,
            CancelFriendshipCommand );
         addCommand(
            RejectFriendshipEvent.EVENT_NAME,
            RejectFriendshipCommand );
         addCommand(
            SearchUsersEvent.EVENT_NAME,
            SearchUsersCommand );
//         addCommand(
//            LoadBuddiesEvent.EVENT_TYPE,
//            LoadBuddiesCommand );
         addCommand(
            LoadKnowledgeTreeEvent.EVENT_NAME,
            LoadKnowledgeTreeCommand );
         addCommand(
            LoadExerciseContentTreeEvent.EVENT_NAME,
            LoadExerciseContentTreeCommand );
         addCommand(
            LoadBrowsableKnowledgeEvent.EVENT_NAME,
            LoadBrowsableKnowledgeCommand );
         addCommand(
            UpdateBrowsableKnowledgeEvent.EVENT_NAME,
            UpdateBrowsableKnowledgeCommand );
          addCommand(
            ShowHelpEvent.EVENT_NAME,
            ShowHelpCommand );
          addCommand(
            URLLoaderEvent.EVENT_NAME,
            URLLoaderCommand );
          addCommand(
            XMLParseEvent.EVENT_NAME,
            XMLParseCommand );
//          addCommand(
//            LoadAmbitiousUsersEvent.EVENT_TYPE,
//            LoadAmbitiousUsersCommand );
//          addCommand(
//            LoadNewUsersEvent.EVENT_TYPE,
//            LoadNewUsersCommand );
          addCommand(
            LoadFavoriteModulesEvent.EVENT_TYPE,
            LoadFavoriteModulesCommand );
          addCommand(
            SaveUserEvent.EVENT_NAME,
            SaveUserCommand );
          addCommand(
            SendLogoutEvent.EVENT_NAME,
            SendLogoutCommand );
          addCommand(
            SendFeedbackEvent.EVENT_NAME,
            SendFeedbackCommand );
          addCommand(
            LoadPersonalRecordEvent.EVENT_TYPE,
            LoadPersonalRecordCommand );
         addCommand(
            UpdatePersonalRecordEvent.EVENT_NAME,
            UpdatePersonalRecordCommand );
          addCommand(
            SaveMyProfileEvent.EVENT_NAME,
            SaveMyProfileCommand );
          addCommand(
            LoadUserProfileEvent.EVENT_NAME,
            LoadUserProfileCommand );
          addCommand(
            ReloadBuddiesEvent.EVENT_NAME,
            ReloadBuddiesCommand );
          addCommand(
            LoadRecentActivitiesEvent.EVENT_NAME,
            LoadRecentActivitiesCommand );
          addCommand(
            LoadTrainingCenterStatisticEvent.EVENT_NAME,
            LoadTrainingCenterStatisticCommand );
          addCommand(
             LoadMagazineEvent.EVENT_NAME,
             LoadMagazineCommand );
          addCommand(
             LoadArticleEvent.EVENT_NAME,
             LoadArticleCommand );
      }
   }
}