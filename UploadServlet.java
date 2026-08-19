@WebServlet("/UploadServlet")
@MultipartConfig(location = "/uploads", maxFileSize = 10485760, maxRequestSize = 20971520, fileSizeThreshold = 1048576)
public class UploadServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // File upload 처리
        String title = request.getParameter("title");
        String content = request.getParameter("content");
        String writer = request.getParameter("writer");
        String category = request.getParameter("category");
        String password = request.getParameter("password");

        Part filePart = request.getPart("image");  // "image"는 input file의 name 속성
        String imageFileName = null;
		out.println("111111");
        // 업로드된 파일 처리
        if (filePart != null && filePart.getSize() > 0) {
			out.println("222222");
            imageFileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("/") + "uploads" + File.separator + imageFileName;
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) {
                uploadDir.mkdirs();
            }
            filePart.write(uploadPath);
        }
	   out.println("33333");
        // DB에 데이터 저장
        Connection conn = null;
        PreparedStatement pstmt = null;
        try {
            Class.forName("org.gjt.mm.mysql.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

            String sql = "INSERT INTO diary (title, content, writer, category, password, has_image, image_filename, reg_date) VALUES (?, ?, ?, ?, ?, ?, ?, NOW())";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, title);
            pstmt.setString(2, content);
            pstmt.setString(3, writer);
            pstmt.setString(4, category);
            pstmt.setString(5, password);
            pstmt.setBoolean(6, imageFileName != null);
            pstmt.setString(7, imageFileName);

            pstmt.executeUpdate();
            response.sendRedirect("sub4.jsp");  // 성공적으로 저장 후 이동할 페이지
        } catch (Exception e) {
            e.printStackTrace();
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "서버 오류가 발생했습니다.");
        } finally {
            if (conn != null) try { conn.close(); } catch (Exception e) {}
        }
    }
}
