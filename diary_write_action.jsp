<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.io.*, java.util.*, java.util.regex.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>
<%
request.setCharacterEncoding("euc-kr");

String sid = (String) session.getAttribute("sid");
if (sid == null) {
    response.sendRedirect("login.jsp");
    return;
}

String title = "", content = "", category_id = "", mode = "", diary_id = "", existingImage = "";
List<String> uploadedFileNames = new ArrayList<>();

boolean isMultipart = ServletFileUpload.isMultipartContent(request);

if (isMultipart) {
    DiskFileItemFactory factory = new DiskFileItemFactory();
    factory.setRepository(new File(System.getProperty("java.io.tmpdir")));
    ServletFileUpload upload = new ServletFileUpload(factory);
    upload.setHeaderEncoding("euc-kr");

    List<FileItem> items = upload.parseRequest(request);
    String contentHtml = "";
    for (FileItem item : items) {
        if (item.isFormField()) {
            String fieldName = item.getFieldName();
            String fieldValue = item.getString("euc-kr");
            if (fieldName.equals("title")) title = fieldValue;
            else if (fieldName.equals("category_id")) category_id = fieldValue;
            else if (fieldName.equals("content")) contentHtml = fieldValue;
            else if (fieldName.equals("mode")) mode = fieldValue;
            else if (fieldName.equals("diary_id")) diary_id = fieldValue;
            else if (fieldName.equals("existing_image")) existingImage = fieldValue;
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
            uploadedFileNames.add(uploadFile.getName());
        }
    }

    // 이미지 src 교체
    String finalContent = contentHtml;
    int imgIdx = 0;
    Pattern p = Pattern.compile("src=\"data:[^\"]+\"");
    Matcher m = p.matcher(finalContent);
    StringBuffer sb = new StringBuffer();
    while (m.find() && imgIdx < uploadedFileNames.size()) {
        m.appendReplacement(sb, "src=\"/uploads/" + uploadedFileNames.get(imgIdx++) + "\"");
    }
    m.appendTail(sb);
    finalContent = sb.toString();

    // 대표 이미지 추출
    String imageName = null;
    Pattern imgPattern = Pattern.compile("src=\"/uploads/([^\"]+)\"");
    Matcher imgMatcher = imgPattern.matcher(finalContent);
    if (imgMatcher.find()) {
        imageName = imgMatcher.group(1);
    }

    // 기존 이미지 유지 (edit 모드일 때)
    if ((imageName == null || imageName.trim().equals("")) && existingImage != null && !existingImage.trim().equals("")) {
        imageName = existingImage;
    }

    // DB 저장 또는 수정
    Connection conn = null;
    PreparedStatement pstmt = null;
    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

        if (category_id != null && !category_id.trim().equals("")) {
            if ("edit".equals(mode) && diary_id != null && diary_id.matches("\\d+")) {
                pstmt = conn.prepareStatement(
                    "UPDATE diary SET category_id = ?, title = ?, content = ?, image_name = ? WHERE diary_id = ? AND user_id = ?"
                );
                pstmt.setInt(1, Integer.parseInt(category_id));
                pstmt.setString(2, title);
                pstmt.setString(3, finalContent);
                pstmt.setString(4, imageName);
                pstmt.setInt(5, Integer.parseInt(diary_id));
                pstmt.setString(6, sid);
            } else {
                pstmt = conn.prepareStatement(
                    "INSERT INTO diary (user_id, category_id, title, content, image_name) VALUES (?, ?, ?, ?, ?)"
                );
                pstmt.setString(1, sid);
                pstmt.setInt(2, Integer.parseInt(category_id));
                pstmt.setString(3, title);
                pstmt.setString(4, finalContent);
                pstmt.setString(5, imageName);
            }
            pstmt.executeUpdate();
        }
        conn.close();
        response.sendRedirect("sub4.jsp?section=pencil&page=1");

    } catch (Exception e) {
        e.printStackTrace();
        response.setContentType("text/html;charset=euc-kr");
        PrintWriter outWriter = response.getWriter();
        String msg = e.getMessage();
        if (msg == null) msg = "알 수 없는 오류";
        msg = msg.replace("\\", "\\\\").replace("'", "\\'").replace("\"", "\\\"");
        outWriter.println("<script>alert('DB 오류: " + msg + "'); history.back();</script>");
    }
}
%>
