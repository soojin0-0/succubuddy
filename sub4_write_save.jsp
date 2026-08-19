<%
String path = application.getRealPath("/uploads");
System.out.println("실제 업로드 경로: " + path);
%>
<%@ page import="java.io.*, java.sql.*, java.util.*, java.nio.file.*" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>

<%
request.setCharacterEncoding("euc-kr");

String loginId = (String)session.getAttribute("sid");
String username = "";
String title = "", content = "", category = "", password = "", writer = "", imageFileName = "";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

try {
  Class.forName("org.gjt.mm.mysql.Driver");
  conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

  // 사용자 이름 가져오기
  pstmt = conn.prepareStatement("SELECT username FROM user WHERE user_id = ?");
  pstmt.setString(1, loginId);
  rs = pstmt.executeQuery();
  if (rs.next()) {
    username = rs.getString("username");
  }
  rs.close();
  pstmt.close();

  // multipart 처리
  boolean isMultipart = request.getContentType() != null && request.getContentType().toLowerCase().startsWith("multipart/");
  if (isMultipart) {
    Collection<Part> parts = request.getParts();

    for (Part part : parts) {
      String fieldName = part.getName();
      if (fieldName.equals("title")) title = request.getParameter("title");
      else if (fieldName.equals("writer")) writer = request.getParameter("writer");
      else if (fieldName.equals("category")) category = request.getParameter("category");
      else if (fieldName.equals("content")) content = request.getParameter("content");
      else if (fieldName.equals("password")) password = request.getParameter("password");
      else if (fieldName.equals("image") && part.getSize() > 0) {
        String submittedName = Paths.get(part.getSubmittedFileName()).getFileName().toString();
        String baseName = submittedName.substring(0, submittedName.lastIndexOf('.'));
        String extension = submittedName.substring(submittedName.lastIndexOf('.'));

        String uploadPath = application.getRealPath("/uploads");
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) uploadDir.mkdirs();

        File file = new File(uploadPath, submittedName);
        int counter = 1;
        while (file.exists()) {
          submittedName = baseName + "_" + counter + extension;
          file = new File(uploadPath, submittedName);
          counter++;
        }

        part.write(file.getAbsolutePath());
        imageFileName = submittedName;
      }
    }
  }

  // 저장
  if (title != null && writer != null) {
    pstmt = conn.prepareStatement("INSERT INTO sub4_write (title, content, user_id, password, category, views, reg_date, image_name) VALUES (?, ?, ?, ?, ?, 0, NOW(), ?)");
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, writer);
    pstmt.setString(4, password);
    pstmt.setString(5, category);
    pstmt.setString(6, imageFileName);
    pstmt.executeUpdate();
    pstmt.close();

    out.println("<script>alert('이건 새로 바뀐 메시지야!'); location.href='sub4.jsp?section=market';</script>");
    return;
  }

} catch (Exception e) {
  e.printStackTrace();
  out.println("<script>alert('오류: " + e.getMessage() + "'); history.back();</script>");
} finally {
  if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>
