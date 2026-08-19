<%@ page import="java.io.*, java.sql.*, java.util.*, org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html;charset=euc-kr" %>

<%
request.setCharacterEncoding("euc-kr");

String savePath = application.getRealPath("/uploads");
int maxSize = 10 * 1024 * 1024;

DiskFileItemFactory factory = new DiskFileItemFactory();
factory.setSizeThreshold(1024 * 1024);
factory.setRepository(new File(System.getProperty("java.io.tmpdir")));

ServletFileUpload upload = new ServletFileUpload(factory);
upload.setHeaderEncoding("euc-kr");

String diaryIdStr = "";
int diaryId = 0;
String newTitle = "";
String content = "";
String newImageName = null;
String oldImageName = null;

Connection conn = null;
PreparedStatement pstmt = null;

try {
    List<FileItem> items = upload.parseRequest(request);

    for (FileItem item : items) {
        if (item.isFormField()) {
            String fieldName = item.getFieldName();
            String value = item.getString("euc-kr");

            if (fieldName.equals("diary_id")) diaryIdStr = value;
            else if (fieldName.equals("newTitle")) newTitle = value;
            else if (fieldName.equals("content")) content = value;
        } else {
            String fileName = new File(item.getName()).getName();
            if (!fileName.isEmpty()) {
                String ext = fileName.substring(fileName.lastIndexOf("."));
                newImageName = UUID.randomUUID().toString() + ext;

                File uploadedFile = new File(savePath + File.separator + newImageName);
                item.write(uploadedFile);
            }
        }
    }

    diaryId = Integer.parseInt(diaryIdStr);

    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 기존 이미지 이름 가져오기
    pstmt = conn.prepareStatement("SELECT image_name FROM sub4_write WHERE diary_id = ?");
    pstmt.setInt(1, diaryId);
    ResultSet rs = pstmt.executeQuery();
    if (rs.next()) oldImageName = rs.getString("image_name");
    rs.close(); pstmt.close();

    // 기존 이미지 삭제 (새 이미지가 업로드 되었을 경우에만)
    if (newImageName != null && oldImageName != null && !oldImageName.equals("")) {
        File oldFile = new File(savePath + File.separator + oldImageName);
        if (oldFile.exists()) oldFile.delete();
    }

    // DB 업데이트
    String sql = "UPDATE sub4_write SET title = ?, content = ?" + (newImageName != null ? ", image_name = ?" : "") + " WHERE diary_id = ?";
    pstmt = conn.prepareStatement(sql);
    pstmt.setString(1, newTitle);
    pstmt.setString(2, content);
    if (newImageName != null) {
        pstmt.setString(3, newImageName);
        pstmt.setInt(4, diaryId);
    } else {
        pstmt.setInt(3, diaryId);
    }

    int result = pstmt.executeUpdate();
    pstmt.close(); conn.close();

    if (result > 0) {
        out.println("<script>alert('게시물이 수정되었습니다.'); location.href='sub4_text.jsp?diary_id=" + diaryId + "';</script>");
    } else {
        out.println("<script>alert('수정 중 오류가 발생했습니다.'); history.back();</script>");
    }

} catch (Exception e) {
    e.printStackTrace();
    out.println("<script>alert('예외 발생: " + e.getMessage().replace("'", "") + "'); history.back();</script>");
}
%>
