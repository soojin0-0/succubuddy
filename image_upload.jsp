<%@ page contentType="text/plain; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.io.*, javax.servlet.*, javax.servlet.http.*" %>
<%@ page import="org.apache.commons.fileupload.*, org.apache.commons.fileupload.disk.*, org.apache.commons.fileupload.servlet.*" %>
<%@ page import="org.apache.commons.io.FilenameUtils" %>
<%@ page import="java.util.List" %> <%-- 이 줄이 없으면 에러 --%>

<%
String uploadPath = application.getRealPath("/uploads");
File uploadDir = new File(uploadPath);
if (!uploadDir.exists()) uploadDir.mkdirs();

DiskFileItemFactory factory = new DiskFileItemFactory();
ServletFileUpload upload = new ServletFileUpload(factory);
upload.setHeaderEncoding("euc-kr");

String fileNameOnly = ""; // 반환할 파일명만 저장

try {
    List<FileItem> items = upload.parseRequest(request);
    for (FileItem item : items) {
        if (!item.isFormField() && item.getName() != null && !item.getName().equals("")) {
            String originalName = FilenameUtils.getName(item.getName());
            File uploadedFile = new File(uploadDir, originalName);
            int count = 1;
            while (uploadedFile.exists()) {
                String base = FilenameUtils.getBaseName(originalName);
                String ext = FilenameUtils.getExtension(originalName);
                uploadedFile = new File(uploadDir, base + "_" + count + "." + ext);
                count++;
            }
            item.write(uploadedFile);
            fileNameOnly = uploadedFile.getName(); // 오직 파일명만 반환!
        }
    }
    out.print(fileNameOnly); // 파일명만 반환!
} catch (Exception e) {
    e.printStackTrace();
    out.print("ERROR: " + e.getMessage());
}
%>
