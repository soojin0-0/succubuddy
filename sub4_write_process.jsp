<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>

<%
request.setCharacterEncoding("euc-kr");

String sid = (String) session.getAttribute("sid");
if (sid == null) {
    response.sendRedirect("login.jsp");
    return;
}

String title = "", content = "", category = "", subcategoryId = "", password = "", fileName = "";

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
                case "category": category = fieldValue; break;
                case "subcategory_id": subcategoryId = fieldValue; break;
                case "password": password = fieldValue; break;
            }
        } else if (!item.getName().isEmpty()) {
            String uploadPath = application.getRealPath("/uploads");
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdirs();

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

            item.write(uploadFile);
            fileName = uploadFile.getName();
        }
    }
}

Connection conn = null;
PreparedStatement pstmt = null;
try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 기존 sub4_write 테이블에 저장
    pstmt = conn.prepareStatement(
        "INSERT INTO sub4_write (title, content, user_id, password, category, views, reg_date, image_name) VALUES (?, ?, ?, ?, ?, 0, NOW(), ?)"
    );
    pstmt.setString(1, title);
    pstmt.setString(2, content);
    pstmt.setString(3, sid);
    pstmt.setString(4, password);
    pstmt.setString(5, category);
    pstmt.setString(6, fileName);
    pstmt.executeUpdate();
    pstmt.close();

    // 추가로 sub4_items 테이블에도 저장
    if (subcategoryId != null && !subcategoryId.trim().equals("")) {
        pstmt = conn.prepareStatement(
            "INSERT INTO sub4_items (subcategory_id, item_title, item_content, user_id) VALUES (?, ?, ?, ?)"
        );
        pstmt.setInt(1, Integer.parseInt(subcategoryId));
        pstmt.setString(2, title);
        pstmt.setString(3, content);
        pstmt.setString(4, sid);
        pstmt.executeUpdate();
        pstmt.close();
    }

    conn.close();

    // 리다이렉트는 카테고리에 따라 이동
    if (category.equals("키움백과")) {
        response.sendRedirect("sub4.jsp");
    } else if (category.equals("궁금톡톡")) {
        response.sendRedirect("sub4.jsp");
    } else if (category.equals("나눔창고")) {
        response.sendRedirect("sub4.jsp");
    } else if (category.equals("성장일지")) {
        response.sendRedirect("sub4.jsp");
    } else {
        response.sendRedirect("sub4.jsp");
    }

} catch (Exception e) {
    e.printStackTrace();
    response.setContentType("text/html;charset=euc-kr");
    PrintWriter outWriter = response.getWriter();
    String msg = e.getMessage().replace("\"", "\\\"");
    outWriter.println("<script>alert('DB 오류: " + msg + "'); history.back();</script>");
}
%>
