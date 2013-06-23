/* $Id: IAuthorityConnector.java 988245 2010-08-23 18:39:35Z kwright $ */

/**
* Licensed to the Apache Software Foundation (ASF) under one or more
* contributor license agreements. See the NOTICE file distributed with
* this work for additional information regarding copyright ownership.
* The ASF licenses this file to You under the Apache License, Version 2.0
* (the "License"); you may not use this file except in compliance with
* the License. You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
package org.apache.manifoldcf.authorities.interfaces;

import org.apache.manifoldcf.core.interfaces.*;

import java.util.*;
import java.io.*;

/** An authority connector supplies an ACL of some kind for a given user.  This is necessary so that the search UI
* can find the documents that can be legally seen.
*
* An instance of this interface provides this functionality.  Authority connector instances are pooled, so that session
* setup does not need to be done repeatedly.  The pool is segregated by specific sets of configuration parameters.
*/
public interface IAuthorityConnector extends IConnector
{

  /** Obtain the access tokens for a given UserRecord.
  * This method is typically the one that is implemented by an authority,
  * unless the authority predates release 1.3.  In that case, the
  * ActiveDirectory credentials are pulled from the UserRecord and
  * are passed to the other variant of this method.
  *@param userRecord is the identifying user record.
  *@return the response tokens (according to the current authority).
  * (Should throws an exception only when a condition cannot be properly described within the authorization response object.)
  */
  public AuthorizationResponse getAuthorizationResponse(UserRecord userRecord)
    throws ManifoldCFException;

  /** Obtain the access tokens for a given Active Directory user name.
  * This method is typically not the one that an authority will implement;
  * instead, most authorities implement the UserRecord version, and have
  * this method call that one.
  *@param userName is the user name or identifier.
  *@return the response tokens (according to the current authority).
  * (Should throws an exception only when a condition cannot be properly described within the authorization response object.)
  */
  public AuthorizationResponse getAuthorizationResponse(String userName)
    throws ManifoldCFException;

  /** Obtain the default access tokens for a given user record.
  *@param userRecord is the identifying user record.
  *@return the default response tokens, presuming that the connect method fails.
  */
  public AuthorizationResponse getDefaultAuthorizationResponse(UserRecord userRecord);

  /** Obtain the default access tokens for a given user name.
  *@param userName is the user name or identifier.
  *@return the default response tokens, presuming that the connect method fails.
  */
  public AuthorizationResponse getDefaultAuthorizationResponse(String userName);

}
