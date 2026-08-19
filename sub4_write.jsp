<%@ page contentType="text/html; charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.io.*, java.util.*" %>
<%@ page import="java.nio.file.Paths" %>
<%@ page import="javax.servlet.http.Part" %>
<%@ page import="java.io.*, java.nio.file.*" %>

<%! 
Map<String, Integer> subcategoryMap = new HashMap<>();

public String htmlEscape(String s) {
    if (s == null) return "";
    return s.replace("&", "&amp;")
            .replace("<", "&lt;")
            .replace(">", "&gt;")
            .replace("\"", "&quot;");
}

public int getSubcategoryId(String name) {
    Integer id = subcategoryMap.get(name);
    return (id != null) ? id : -1;
}
%>

<%
request.setCharacterEncoding("euc-kr");

String sid = (String) session.getAttribute("sid");
if (sid == null) {
    response.sendRedirect("login.jsp");
    return;
}

String title = request.getParameter("title") != null ? request.getParameter("title") : "";
String content = request.getParameter("content") != null ? request.getParameter("content") : "";
String password = request.getParameter("password") != null ? request.getParameter("password") : "";

String username = "";
String role = "";

Connection conn = null;
PreparedStatement pstmt = null;
ResultSet rs = null;

List<Map<String, String>> categoryList = new ArrayList<>();
Map<String, List<Map<String, String>>> subcategoryMapByCategory = new HashMap<>();

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    // 사용자 이름 조회
    pstmt = conn.prepareStatement("SELECT username, role FROM user WHERE user_id = ?");
    pstmt.setString(1, sid);
    rs = pstmt.executeQuery();
    if (rs.next()) {
       username = rs.getString("username");
       role = rs.getString("role");  // ← 여기를 추가해야 함
    }

    rs.close();
    pstmt.close();
	 //  관리자 아니면 접근 차단
    if (!"admin".equals(role)) {
        out.println("<script>alert('관리자만 접근할 수 있습니다.'); history.back();</script>");
        return;
    }

    // 상위 카테고리 목록
    pstmt = conn.prepareStatement("SELECT category_id, category_name FROM sub4_category ORDER BY category_name");
    rs = pstmt.executeQuery();
    while (rs.next()) {
        Map<String, String> map = new HashMap<>();
        map.put("id", rs.getString("category_id"));
        map.put("name", rs.getString("category_name"));
        categoryList.add(map);
    }
    rs.close();
    pstmt.close();

    // 하위 카테고리 목록
    pstmt = conn.prepareStatement("SELECT category_id, subcategory_id, subcategory_name FROM sub4_subcategory ORDER BY subcategory_name");
    rs = pstmt.executeQuery();
    while (rs.next()) {
        String catId = rs.getString("category_id");
        String subId = rs.getString("subcategory_id");
        String subName = rs.getString("subcategory_name");

        subcategoryMap.put(subName, Integer.parseInt(subId));

        Map<String, String> sub = new HashMap<>();
        sub.put("id", subId);
        sub.put("name", subName);

        subcategoryMapByCategory.computeIfAbsent(catId, k -> new ArrayList<>()).add(sub);
    }
    rs.close();
    pstmt.close();

} catch (Exception e) {
    e.printStackTrace(new java.io.PrintWriter(out));
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (pstmt != null) pstmt.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}

// JSON 변환 로직은 DB 조회 이후에 실행되어야 함
StringBuilder subcategoryJson = new StringBuilder("{");
for (Map.Entry<String, List<Map<String, String>>> entry : subcategoryMapByCategory.entrySet()) {
    subcategoryJson.append("\"").append(entry.getKey()).append("\": [");
    for (Map<String, String> sub : entry.getValue()) {
        subcategoryJson.append("{\"id\":\"").append(sub.get("id"))
                       .append("\", \"name\":\"").append(sub.get("name").replace("\"", "\\\"")).append("\"},");
    }
    if (subcategoryJson.charAt(subcategoryJson.length() - 1) == ',') {
        subcategoryJson.deleteCharAt(subcategoryJson.length() - 1);
    }
    subcategoryJson.append("],");
}
if (subcategoryJson.charAt(subcategoryJson.length() - 1) == ',') {
    subcategoryJson.deleteCharAt(subcategoryJson.length() - 1);
}
subcategoryJson.append("}");
%>

<style>
    @font-face {
      font-family: 'GmarketSansTTFMedium';
      src: url('fonts/GmarketSansTTFMedium.ttf') format('truetype');
    }
    @font-face {
      font-family: 'GmarketSansTTFBold';
      src: url('fonts/GmarketSansTTFBold.ttf') format('truetype');
    }
    @font-face {
      font-family: 'GmarketSansTTFLight';
      src: url('fonts/GmarketSansTTFLight.ttf') format('truetype');
    }
    @font-face {
      font-family: 'RixInooAriDuriPro';
      src: url('fonts/RixInooAriDuri_Pro Regular.otf') format('opentype');
    }
    body {
      width: 1920px;
      max-width: 100%;
      overflow-x: hidden;
    }
    .container {
      width: 1719px;
      height: 1481px;
      margin: 60px auto;
    }
    .container-title {
      text-align: center;
      margin: 40px 0 30px;
      font-size: 34px;
      font-family: 'GmarketSansTTFMedium';
    }
    .form-wrapper {
      width: 1500px;
      margin: 0 auto;
      background-color: #f1f6ed;
      border-radius: 20px;
      padding: 40px;
      box-sizing: border-box;
    }
    .form-title {
      font-size: 34px;
      margin-bottom: 30px;
      font-family: 'GmarketSansTTFMedium';
    }
    .form-row {
      display: flex;
      justify-content: space-between;
      gap: 20px;
      margin-bottom: 20px;
    }
    .form-input {
      width: 744px;
      height: 97px;
      background-color: #ffffff;
      border: none;
      border-radius: 15px;
      padding: 0 25px;
      font-size: 25px;
      font-family: 'GmarketSansTTFLight';
      color: #333;
      box-sizing: border-box;
    }
    select.form-input {
      background-image: url('images/arrow-big.png');
      background-repeat: no-repeat;
      background-position: right 25px center;
      background-size: 20px;
      appearance: none;
    }
    textarea {
      width: 100%;
      height: 700px;
      background-color: #ffffff;
      border: none;
      border-radius: 15px;
      padding: 20px;
      font-size: 30px;
      box-sizing: border-box;
      margin-bottom: 20px;
	  font-family: 'GmarketSansTTFLight';
    }
    .form-password-wrapper {
      display: flex;
      justify-content: flex-end;
      align-items: center;
      gap: 10px;
      margin-top: 15px;
    }
    .password-label {
      font-size: 28px;
	  font-family: 'GmarketSansTTFLight';
      color: #555;
    }
    .password-input {
      width: 248px;
      height: 76px;
      border-radius: 8px;
      padding: 0 10px;
      font-size: 14px;
      background-color: white;
      border: none;
	  font-family: 'GmarketSansTTFLight';
    }
    .file-upload-wrapper {
      width: 744px;
      height: 97px;
      background-color: #ffffff;
      border-radius: 15px;
      padding: 0 25px;
      display: flex;
      align-items: center;
      box-sizing: border-box;
      cursor: pointer;
    }
    input[type="file"] {
      display: none;
    }
    .file-icon {
      height: 40px;
      margin-right: 10px;
    }
    #file-name {
      flex-grow: 1;
      font-size: 26px;
	  font-family: 'GmarketSansTTFLight';
    }
    .file-remove {
      width: 18px;
      height: 18px;
      cursor: pointer;
    }
    .btn-group-outside {
      width: 1500px;
      margin: 30px auto 80px;
      display: flex;
      justify-content: flex-end;
      gap: 16px;
    }
    .btn {
      width: 243px;
      height: 99px;
      border-radius: 43px;
      font-size: 30px;
      background-color: #67b54d;
      color: white;
      cursor: pointer;
      border: none;
      font-family: 'GmarketSansTTFBold';
    }
    .btn:hover {
      background-color: #5da248;
    }
</style>

  <div class="container">
    <div class="container-title">다육탐구생활</div>
    <form action="/succu/sub4_write_process_alt.jsp" method="post" enctype="multipart/form-data">
	<input type="hidden" name="subcategory_id" value="1">  <!-- ★ 임시로 1 넣음, 실제는 DB에서 동적으로 처리 -->

      <div class="form-wrapper">
        <div class="form-title">글 쓰기</div>
        <div class="form-row">
          <input type="text" name="title" class="form-input" placeholder="제목" value="<%= htmlEscape(title) %>" required>
          <input type="text" class="form-input" value="<%= username %>" readonly title="작성자">
          <input type="hidden" name="writer" value="<%= sid %>">
        </div>

        <div class="form-row">
        <select id="category-select" class="form-input" title="상위 카테고리 선택">
		  <option value="">상위 카테고리 선택</option>
		  <% for (Map<String, String> cat : categoryList) { %>
			<option value="<%= cat.get("id") %>"><%= cat.get("name") %></option>
		  <% } %>
		</select>

		<select name="subcategory_id" id="subcategory-select" class="form-input" title="하위 카테고리 선택" required>
		  <option value="">하위 카테고리 선택</option>
		</select>



          <div class="file-upload-wrapper" onclick="document.getElementById('imageFiles').click();">
		  <img src="images/Attach.png" class="file-icon" alt="파일첨부 아이콘" />
		  <span id="file-name">파일을 선택하세요</span>
		  <img src="images/cross.png" class="file-remove" id="file-remove" onclick="removeFile(event)" alt="파일 삭제">
		  <input type="file" id="imageFiles" name="images" accept="image/*" multiple style="display:none;">
		  </div>

        </div>

        <textarea name="content" placeholder="내용 입력" required><%= htmlEscape(content) %></textarea>

        <div class="form-password-wrapper">
          <label class="password-label" for="pw">비밀번호</label>
          <input type="password" id="pw" name="password" class="password-input" value="<%= htmlEscape(password) %>" required>
        </div>
      </div>

      <div class="btn-group-outside">
        <button type="button" class="btn cancel-btn" onclick="history.back()">등록 취소</button>
        <button type="submit" class="btn submit-btn">등록</button>
      </div>
    </form>
  </div>

<script>
  // 파일 제거 함수
  function removeFile(e) {
    e.stopPropagation();
    const input = document.getElementById("imageFiles");
    input.value = '';
    document.getElementById("file-name").innerText = "파일을 선택하세요";
    document.getElementById("file-remove").style.display = "none";
  }

  document.addEventListener("DOMContentLoaded", function () {
    // 파일 input과 연결
    const input = document.getElementById("imageFiles");
    input.addEventListener("change", function () {
      if (input.files.length > 0) {
        const names = Array.from(input.files).map(f => f.name).join(", ");
        document.getElementById("file-name").innerText = names;
        document.getElementById("file-remove").style.display = "inline";
      } else {
        document.getElementById("file-name").innerText = "파일을 선택하세요";
        document.getElementById("file-remove").style.display = "none";
      }
    });

    // 하위 카테고리 자동 갱신
    const subcategoryMap = <%= subcategoryJson.toString() %>;
    const categorySelect = document.getElementById("category-select");
    const subcategorySelect = document.getElementById("subcategory-select");

    categorySelect.addEventListener("change", function () {
      const categoryId = this.value;
      subcategorySelect.innerHTML = '<option value="">하위 카테고리 선택</option>';
      if (subcategoryMap[categoryId]) {
        subcategoryMap[categoryId].forEach(item => {
          const option = document.createElement("option");
          option.value = item.id;
          option.textContent = item.name;
          subcategorySelect.appendChild(option);
        });
      }
    });
  });
</script>

