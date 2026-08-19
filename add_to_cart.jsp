<%@ page contentType="text/html;charset=euc-kr" %>
<%@ page import="java.sql.*" %>

<%
    // 로그인한 사용자 확인
    String userId = (String) session.getAttribute("user_id");
    if (userId == null) {
%>
    <script>
        alert("로그인이 필요합니다!");
        location.href = "login.jsp";
    </script>
<%
        return;
    }

    // 파라미터 값 받기
    String productId = request.getParameter("product_id");
    int quantity = Integer.parseInt(request.getParameter("quantity"));

    // DB 연결 정보
    String DB_URL = "jdbc:mysql://localhost:3306/succu";
    String DB_ID = "multi";
    String DB_PASSWORD = "abcd";

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    try {
        Class.forName("org.gjt.mm.mysql.Driver");
        conn = DriverManager.getConnection(DB_URL, DB_ID, DB_PASSWORD);

        // 장바구니에 같은 상품이 있는지 확인
        String checkQuery = "SELECT quantity FROM cart WHERE user_id = ? AND product_id = ?";
        pstmt = conn.prepareStatement(checkQuery);
        pstmt.setString(1, userId);
        pstmt.setString(2, productId);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // 이미 장바구니에 존재하면 수량 업데이트
            int newQuantity = rs.getInt("quantity") + quantity;
            String updateQuery = "UPDATE cart SET quantity = ? WHERE user_id = ? AND product_id = ?";
            pstmt = conn.prepareStatement(updateQuery);
            pstmt.setInt(1, newQuantity);
            pstmt.setString(2, userId);
            pstmt.setString(3, productId);
            pstmt.executeUpdate();
        } else {
            // 새로운 상품이면 INSERT
            String insertQuery = "INSERT INTO cart (user_id, product_id, quantity) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(insertQuery);
            pstmt.setString(1, userId);
            pstmt.setString(2, productId);
            pstmt.setInt(3, quantity);
            pstmt.executeUpdate();
        }
%>
        <script>
            alert("장바구니에 상품이 추가되었습니다!");
            location.href = "shopping_list.jsp"; // 장바구니 페이지로 이동
        </script>
<%
    } catch (Exception e) {
        out.println("<script>alert('장바구니 추가 중 오류 발생: " + e.getMessage() + "'); history.back();</script>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException ignored) {}
        if (pstmt != null) try { pstmt.close(); } catch (SQLException ignored) {}
        if (conn != null) try { conn.close(); } catch (SQLException ignored) {}
    }
%>
