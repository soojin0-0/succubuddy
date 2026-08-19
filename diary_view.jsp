<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.text.SimpleDateFormat" %>
<%
request.setCharacterEncoding("euc-kr");

String diaryIdParam = request.getParameter("diary_id");
int diaryId = 0;
if (diaryIdParam != null && diaryIdParam.matches("\\d+")) {
    diaryId = Integer.parseInt(diaryIdParam);
}

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;

String title = "", content = "", regDate = "", imageName = "";

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu?useUnicode=true&characterEncoding=euc-kr", "multi", "abcd");

    ps = conn.prepareStatement("SELECT title, content, reg_date, image_name FROM diary WHERE diary_id = ?");
    ps.setInt(1, diaryId);
    rs = ps.executeQuery();

    if (rs.next()) {
        title = rs.getString("title");
        content = rs.getString("content").replaceAll("\n", "<br>");
        regDate = new SimpleDateFormat("yyyy.MM.dd").format(rs.getTimestamp("reg_date"));
        imageName = rs.getString("image_name");
    }

} catch (Exception e) {
    e.printStackTrace();
} finally {
    if (rs != null) try { rs.close(); } catch (Exception e) {}
    if (ps != null) try { ps.close(); } catch (Exception e) {}
    if (conn != null) try { conn.close(); } catch (Exception e) {}
}
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="euc-kr">
    <title>일기 상세보기</title>
    <style>
        .diary-wrapper {
            width: 80%;
            margin: 50px auto;
            background-color: #ffffff;
            padding: 50px;
            border-radius: 12px;
            box-shadow: 0 0 8px rgba(0, 0, 0, 0.05);
        }
        .diary-label {
            color: #aaa;
            font-size: 14px;
            margin-bottom: 10px;
        }
        .diary-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 5px;
        }
        .diary-date {
            font-size: 13px;
            color: #888;
            border-bottom: 1px solid #ddd;
            padding-bottom: 5px;
            margin-bottom: 30px;
        }
        .diary-content-label {
            text-align: center;
            font-size: 16px;
            color: #777;
            margin-bottom: 20px;
        }
        .diary-content {
            text-align: center;
            font-size: 16px;
            line-height: 1.7;
            margin-bottom: 30px;
        }
        .diary-image {
            display: block;
            margin: 0 auto;
            width: 60%;
            height: auto;
            max-height: 300px;
            object-fit: cover;
        }
    </style>
</head>
<body style="background-color:#f0f5ec;">
    <div class="diary-wrapper">
        <div class="diary-label">일기</div>
        <div class="diary-title"><%= title %></div>
        <div class="diary-date"><%= regDate %></div>

        <div class="diary-content-label">내용</div>
        <div class="diary-content"><%= content %></div>

        <% if (imageName != null && !imageName.trim().equals("")) { %>
            <img src="uploads/<%= imageName %>" alt="diary image" class="diary-image" />
        <% } %>
    </div>
</body>
</html>
