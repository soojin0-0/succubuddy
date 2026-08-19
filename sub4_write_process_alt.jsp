<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>

<%
request.setCharacterEncoding("euc-kr");

String sid = (String) session.getAttribute("sid");
if (sid == null) {
    response.sendRedirect("login.jsp");
    return;
}

String title = "", content = "", subcategoryId = "", password = "", fileName = "";

boolean isMultipart = ServletFileUpload.isMultipartContent(request);
if (isMultipart) {
    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("euc-kr");

    List<FileItem> items = upload.parseRequest(request);
    for (FileItem item : items) {
        if (item.isFormField()) {
            String fieldName = item.getFieldName();
            String fieldValue = item.getString("euc-kr");
            switch (fieldName) {
                case "title": title = fieldValue; break;
                case "content": content = fieldValue; break;
                case "subcategory_id": subcategoryId = fieldValue; break;
                case "password": password = fieldValue; break;
            }
        } else if (!item.getName().isEmpty()) {
            // 1. 저장 폴더: WebContent/uploads
            String uploadPath = application.getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

            // 2. 파일 이름 중복 방지
            String originalName = FilenameUtils.getName(item.getName());
            File uploadFile = new File(uploadDir, originalName);
            int count = 1;
            while (uploadFile.exists()) {
                String base = FilenameUtils.getBaseName(originalName);
                String ext = FilenameUtils.getExtension(originalName);
                String newName = base + "_" + count + "." + ext;
                uploadFile = new File(uploadDir, newName);
                count++;
            }

            // 3. 파일 저장
            item.write(uploadFile);
            fileName = uploadFile.getName();  // DB에 저장할 파일명
        }
    }
}

// 4. DB 저장 처리
Connection conn = null;
PreparedStatement pstmt = null;
try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    if (subcategoryId != null && !subcategoryId.trim().equals("")) {
        pstmt = conn.prepareStatement(
            "INSERT INTO sub4_items (subcategory_id, item_title, item_content, password, image_name, reg_date, views) " +
            "VALUES (?, ?, ?, ?, ?, NOW(), 0)"
        );
        pstmt.setInt(1, Integer.parseInt(subcategoryId));
        pstmt.setString(2, title);
        pstmt.setString(3, content);
        pstmt.setString(4, password);
        pstmt.setString(5, fileName);
        pstmt.executeUpdate();
        pstmt.close();
    }

    conn.close();
    response.sendRedirect("sub4.jsp");

} catch (Exception e) {
    e.printStackTrace();
    response.setContentType("text/html;charset=euc-kr");
    PrintWriter outWriter = response.getWriter();
    String msg = e.getMessage() != null ? e.getMessage().replace("\"", "\\\"") : "알 수 없는 오류";
    outWriter.println("<script>alert('DB 오류: " + msg + "'); history.back();</script>");
}
%>