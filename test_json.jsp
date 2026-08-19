<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="org.json.simple.parser.JSONParser" %>
<%@ page import="org.json.simple.JSONObject" %>
<%
    JSONParser parser = new JSONParser();
    String jsonStr = "{\"name\":\"성공\"}";
    JSONObject obj = (JSONObject) parser.parse(jsonStr);
    out.println("파싱 결과: " + obj.get("name"));
%>
