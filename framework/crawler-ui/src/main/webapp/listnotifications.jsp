<%@ include file="adminHeaders.jsp" %>

<%

/* $Id$ */

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
%>

<%
try
{
  // Check if authorized
  if (!adminprofile.checkAllowed(threadContext,IAuthorizer.CAPABILITY_VIEW_CONNECTIONS))
  {
    variableContext.setParameter("target","index.jsp");
%>
    <jsp:forward page="unauthorized.jsp"/>
<%
  }
  // Get the notification connection manager handle
  INotificationConnectionManager manager = NotificationConnectionManagerFactory.make(threadContext);
  INotificationConnectorManager connectorManager = NotificationConnectorManagerFactory.make(threadContext);
  INotificationConnection[] connections = manager.getAllConnections();
%>

<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<meta http-equiv="X-UA-Compatible" content="IE=edge"/>

<html xmlns="http://www.w3.org/1999/xhtml">
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
  <link rel="StyleSheet" href="style.css" type="text/css" media="screen"/>
  <title>
    <%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.ApacheManifoldCFListNotificationConnections")%>
  </title>

  <script type="text/javascript">
  <!--

function Delete(connectionName)
{
  if (confirm("<%=Messages.getBodyJavascriptString(pageContext.getRequest().getLocale(),"listnotifications.DeleteNotificationConnection")%> '"+connectionName+"'?"))
  {
    document.listconnections.op.value="Delete";
    document.listconnections.connname.value=connectionName;
    document.listconnections.submit();
  }
}

  //-->
  </script>

</head>

<body class="standardbody">

  <table class="page">
    <tr><td colspan="2" class="banner"><jsp:include page="banner.jsp" flush="true"/></td></tr>
    <tr>
      <td class="navigation"><jsp:include page="navigation.jsp" flush="true"/></td>
      <td class="window">
        <p class="windowtitle"><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.ListOfNotificationConnections")%></p>
        <form class="standardform" name="listconnections" action="execute.jsp" method="POST">
          <input type="hidden" name="op" value="Continue"/>
          <input type="hidden" name="type" value="transformation"/>
          <input type="hidden" name="connname" value=""/>

          <table class="datatable">
            <tr>
              <td class="separator" colspan="5"><hr/></td>
            </tr>
            <tr class="headerrow">
              <td class="columnheader"></td>
              <td class="columnheader"><nobr><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.Name")%></nobr></td>
              <td class="columnheader"><nobr><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.Description")%></nobr></td>
              <td class="columnheader"><nobr><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.ConnectionType")%></nobr></td>
              <td class="columnheader"><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.Max")%></td>
            </tr>
<%
  int i = 0;
  while (i < connections.length)
  {
    INotificationConnection connection = connections[i++];

    String name = connection.getName();
    String description = connection.getDescription();
    if (description == null)
      description = "";
    String className = connection.getClassName();
    String connectorName = connectorManager.getDescription(className);
    if (connectorName == null)
      connectorName = className + Messages.getString(pageContext.getRequest().getLocale(),"listnotifications.uninstalled");;
    int maxCount = connection.getMaxConnections();

%>
            <tr <%="class=\""+((i%2==0)?"evendatarow":"odddatarow")+"\""%>>
              <td class="columncell">
                <nobr>
                  <a href='<%="viewnotification.jsp?connname="+org.apache.manifoldcf.core.util.URLEncoder.encode(name)%>' alt='<%=Messages.getAttributeString(pageContext.getRequest().getLocale(),"listnotifications.View")+" "+org.apache.manifoldcf.ui.util.Encoder.attributeEscape(name)%>'><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.View")%></a>
                  <a href='<%="editnotification.jsp?connname="+org.apache.manifoldcf.core.util.URLEncoder.encode(name)%>' alt='<%=Messages.getAttributeString(pageContext.getRequest().getLocale(),"listnotifications.Edit")+" "+org.apache.manifoldcf.ui.util.Encoder.attributeEscape(name)%>'><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.Edit")%></a>
                  <a href="javascript:void()" onclick='<%="javascript:Delete(\""+org.apache.manifoldcf.ui.util.Encoder.attributeJavascriptEscape(name)+"\")"%>' alt='<%=Messages.getAttributeString(pageContext.getRequest().getLocale(),"listnotifications.Delete")+" "+org.apache.manifoldcf.ui.util.Encoder.attributeEscape(name)%>'><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.Delete")%></a>
                </nobr>
              </td>
              <td class="columncell"><%=org.apache.manifoldcf.ui.util.Encoder.bodyEscape(name)%></td>
              <td class="columncell"><%=org.apache.manifoldcf.ui.util.Encoder.bodyEscape(description)%></td>
              <td class="columncell"><%=org.apache.manifoldcf.ui.util.Encoder.bodyEscape(connectorName)%></td>
              <td class="columncell"><%=Integer.toString(maxCount)%></td>
            </tr>
<%
  }
%>
            <tr>
              <td class="separator" colspan="5"><hr/></td>
            </tr>
            <tr><td class="message" colspan="5"><a href="editnotification.jsp" alt="<%=Messages.getAttributeString(pageContext.getRequest().getLocale(),"listnotifications.AddANotificationConnection")%>"><%=Messages.getBodyString(pageContext.getRequest().getLocale(),"listnotifications.AddaNewNotificationConnection")%></a></td></tr>
          </table>

<%
}
catch (ManifoldCFException e)
{
  e.printStackTrace();
  variableContext.setParameter("text",e.getMessage());
  variableContext.setParameter("target","index.jsp");
%>
  <jsp:forward page="error.jsp"/>
<%
}
%>
        </form>
      </td>
    </tr>
  </table>

</body>

</html>
