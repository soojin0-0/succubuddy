<%@ page contentType="application/json;charset=euc-kr" %>
<%@ page import="java.sql.*, org.json.simple.*" %>
<%
String level = request.getParameter("level");
String size = request.getParameter("size");
JSONArray arr = new JSONArray();
Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");
    String sql = "SELECT pot_id, pot_name, extra_price FROM pot WHERE level=? AND size=? ORDER BY pot_name";
    ps = conn.prepareStatement(sql);
    ps.setString(1, level);
    ps.setString(2, size);
    rs = ps.executeQuery();
    while (rs.next()) {
        JSONObject obj = new JSONObject();
        obj.put("pot_id", rs.getString("pot_id"));
        obj.put("pot_name", rs.getString("pot_name"));
        obj.put("extra_price", rs.getInt("extra_price"));
        arr.add(obj);
    }
} catch(Exception e) { }
finally { if(rs!=null)rs.close(); if(ps!=null)ps.close(); if(conn!=null)conn.close();}
out.print(arr.toJSONString());
%>
