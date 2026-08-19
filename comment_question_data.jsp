<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<meta charset="euc-kr">
<%@ page import="java.sql.*, java.util.*" %>
<%
    String loginId = (String) session.getAttribute("sid");
    if (loginId == null || loginId.equals("")) {
        return; // 로그인 안 되어 있으면 그냥 빈 응답 반환
    }

    int currentPage = 1;
    int pageSize = 4;
    int totalPage = 1;
    int totalCount = 0;

    String pageParam = request.getParameter("page");
    if (pageParam != null && pageParam.matches("\\d+")) {
        currentPage = Integer.parseInt(pageParam);
    }

    List<Map<String, String>> curiousPosts = new ArrayList<>();

    Connection conn = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

        // 총 게시물 수 계산
        String countSql = "SELECT COUNT(*) FROM sub4_write WHERE category = '궁금톡톡' AND user_id = ?";
        ps = conn.prepareStatement(countSql);
        ps.setString(1, loginId);
        rs = ps.executeQuery();
        if (rs.next()) {
            totalCount = rs.getInt(1);
            totalPage = (int) Math.ceil((double) totalCount / pageSize);
        }
        rs.close();
        ps.close();

        int offset = (currentPage - 1) * pageSize;
        String listSql = "SELECT diary_id, title, image_name FROM sub4_write WHERE category = '궁금톡톡' AND user_id = ? ORDER BY reg_date DESC LIMIT ? OFFSET ?";
        ps = conn.prepareStatement(listSql);
        ps.setString(1, loginId);
        ps.setInt(2, pageSize);
        ps.setInt(3, offset);
        rs = ps.executeQuery();

        while (rs.next()) {
            Map<String, String> post = new HashMap<>();
            post.put("item_id", rs.getString("diary_id"));
            post.put("title", rs.getString("title"));
            post.put("image", rs.getString("image_name"));
            curiousPosts.add(post);
        }
        rs.close();
        ps.close();
        conn.close();
    } catch (Exception e) {
        e.printStackTrace();
    }
%>

<!-- 궁금톡톡 게시물 영역 -->
<% for (Map<String, String> p : curiousPosts) { %>
    <div class="board-item">
        <% if (p.get("image") != null && !p.get("image").trim().equals("")) { %>
            <img src="/uploads/<%= p.get("image") %>" alt="썸네일">
        <% } %>
        <div class="board-title">
            <a href="sub4_text.jsp?diary_id=<%= p.get("item_id") %>&category=궁금톡톡"><%= p.get("title") %></a>
        </div>
    </div>
<% } %>

<!-- 페이지네이션 -->
<div class="pagination">
    <button class="page-btn <%= (currentPage == 1 ? "disabled" : "") %>" data-page="<%= currentPage - 1 %>">&lt;</button>
    <% for (int i = 1; i <= totalPage; i++) { %>
        <button class="page-btn <%= (i == currentPage ? "active" : "") %>" data-page="<%= i %>"><%= i %></button>
    <% } %>
    <button class="page-btn <%= (currentPage == totalPage ? "disabled" : "") %>" data-page="<%= currentPage + 1 %>">&gt;</button>
</div>
