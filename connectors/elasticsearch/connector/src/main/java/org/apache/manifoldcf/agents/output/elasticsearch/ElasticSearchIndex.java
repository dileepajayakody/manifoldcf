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

package org.apache.manifoldcf.agents.output.elasticsearch;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.PrintWriter;

import org.apache.commons.httpclient.methods.PutMethod;
import org.apache.commons.httpclient.HttpClient;
import org.apache.commons.httpclient.methods.RequestEntity;
import org.apache.commons.io.FilenameUtils;
import org.apache.commons.io.IOUtils;
import org.apache.manifoldcf.core.common.Base64;
import org.apache.manifoldcf.core.interfaces.ManifoldCFException;

public class ElasticSearchIndex extends ElasticSearchConnection
{

  private class IndexRequestEntity implements RequestEntity
  {

    private InputStream inputStream;

    public IndexRequestEntity(InputStream inputStream)
      throws ManifoldCFException
    {
      this.inputStream = inputStream;
    }

    public long getContentLength()
    {
      return -1;
    }

    public String getContentType()
    {
      return "application/x-www-form-urlencoded";
    }

    public boolean isRepeatable()
    {
      return false;
    }

    public void writeRequest(OutputStream out) throws IOException
    {
      PrintWriter pw = new PrintWriter(out);
      try
      {
        pw.print("{");
        //pw.print("\"fieldName\" : ");
        //pw.print("\"" + documentURI + "\"" + ",");
        //pw.print("\"fileName\" : ");
        //pw.print("\"" + fileName + "\"" + ",");
        pw.print("\"binaryValue\" : \"");
        Base64 base64 = new Base64();
        base64.encodeStream(inputStream, pw);
        pw.print("\"");
        pw.print("}");
      } catch (ManifoldCFException e)
      {
        throw new IOException(e.getMessage());
      } finally
      {
        IOUtils.closeQuietly(pw);
      }
    }
  }

  public ElasticSearchIndex(HttpClient client, String documentURI, InputStream inputStream,
      ElasticSearchConfig config) throws ManifoldCFException
  {
    super(config, client);
    
    String idField;
    try
    {
      idField = java.net.URLEncoder.encode(documentURI,"utf-8");
    }
    catch (java.io.UnsupportedEncodingException e)
    {
      throw new ManifoldCFException(e.getMessage(),e);
    }

    StringBuffer url = getApiUrl(config.getIndexType() + "/" + idField, false);
    PutMethod put = new PutMethod(url.toString());
    RequestEntity entity = new IndexRequestEntity(inputStream);
    put.setRequestEntity(entity);
    call(put);
    if ("true".equals(checkJson(jsonStatus)))
      return;
    String error = checkJson(jsonException);
    setResult(Result.ERROR, error);
    System.err.println(getResponse());
  }

}
