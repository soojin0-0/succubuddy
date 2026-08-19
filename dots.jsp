<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%
request.setCharacterEncoding("euc-kr");

String selectedCategory = request.getParameter("category");
String selectedSubcategory = request.getParameter("subcategory");

Connection conn = null;
PreparedStatement ps = null;
ResultSet rs = null;
Map<Integer, Map<String, List<String>>> categoryMap = new LinkedHashMap<>();
Map<Integer, String> categoryNameMap = new LinkedHashMap<>();
Map<String, String> categoryDisplayMap = new LinkedHashMap<>();
Map<String, String> categoryIntroMap = new LinkedHashMap<>();
Map<String, String> categoryIntroTitleMap = new LinkedHashMap<>();
Map<String, Integer> subcategoryIdMap = new HashMap<>();
Map<String, Integer> itemIdMap = new HashMap<>();
Map<String, String> imageNameMap = new HashMap<>();

categoryDisplayMap.put("다육의 건강 진단", "병충해와 대처 방법");
categoryDisplayMap.put("다육의 일상 관리", "화분 고르는 방법");
categoryDisplayMap.put("다육의 시즌별 관리", "사계절 관리 방법");
categoryDisplayMap.put("다육의 물과 영양 관리", "물주기 매뉴얼");

categoryIntroMap.put("다육의 건강 진단", "다육 병충해");
categoryIntroMap.put("다육의 일상 관리", "화분 고르는 방법");
categoryIntroMap.put("다육의 시즌별 관리", "사계절 관리 방법");
categoryIntroMap.put("다육의 물과 영양 관리", "물주기 매뉴얼");

categoryIntroTitleMap.put("다육의 건강 진단", "병충해 대처법");
categoryIntroTitleMap.put("다육의 일상 관리", "화분 고르는 방법");
categoryIntroTitleMap.put("다육의 시즌별 관리", "사계절 관리 방법");
categoryIntroTitleMap.put("다육의 물과 영양 관리", "물주기 매뉴얼");

try {
    Class.forName("org.gjt.mm.mysql.Driver");
    conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/succu", "multi", "abcd");

    String sql = "SELECT c.category_id, c.category_name, s.subcategory_id, s.subcategory_name, i.item_id, i.item_title, i.image_name " +
                 "FROM sub4_category c " +
                 "JOIN sub4_subcategory s ON c.category_id = s.category_id " +
                 "LEFT JOIN sub4_items i ON s.subcategory_id = i.subcategory_id ";

    if (selectedSubcategory != null && !selectedSubcategory.trim().equals("")) {
        sql += " WHERE s.subcategory_id = ?";
    }
    sql += " ORDER BY c.category_id, s.subcategory_id, i.item_id";

    ps = conn.prepareStatement(sql);
    if (selectedSubcategory != null && !selectedSubcategory.trim().equals("")) {
        ps.setInt(1, Integer.parseInt(selectedSubcategory));
    }
    rs = ps.executeQuery();

    while (rs.next()) {
        int categoryId = rs.getInt("category_id");
        String categoryName = rs.getString("category_name");
        String subcategory = rs.getString("subcategory_name");
        int subcategoryId = rs.getInt("subcategory_id");
        String item = rs.getString("item_title");
        int itemId = rs.getInt("item_id");
        String imageName = rs.getString("image_name");

        subcategoryIdMap.put(subcategory, subcategoryId);
        categoryNameMap.putIfAbsent(categoryId, categoryName);
        categoryMap.putIfAbsent(categoryId, new LinkedHashMap<>());
        categoryMap.get(categoryId).putIfAbsent(subcategory, new ArrayList<>());

        if (item != null) {
            categoryMap.get(categoryId).get(subcategory).add(item);
            itemIdMap.put(item, itemId);
            if (imageName != null) imageNameMap.put(item, imageName);
        }
    }
} catch (Exception e) {
    e.printStackTrace();
} finally {
    try { if (rs != null) rs.close(); } catch (Exception e) {}
    try { if (ps != null) ps.close(); } catch (Exception e) {}
    try { if (conn != null) conn.close(); } catch (Exception e) {}
}
%>

<%!
public String subNameToImage(String name) {
    if (name.equals("건강 체크리스트")) return "sub4_kium1-1.png";
    if (name.equals("스트레스 징후")) return "sub4_kium1-2.png";
    if (name.equals("흙 선택과 배합")) return "sub4_kium2-1.png";
    if (name.equals("분갈이와 가지치기")) return "sub4_kium2-2.png";
    if (name.equals("휴면기와 활성기")) return "sub4_kium3-1.png";
    if (name.equals("온도와 습도")) return "sub4_kium3-2.png";
    if (name.equals("영양소")) return "sub4_kium4-1.png";
    if (name.equals("도구")) return "sub4_kium4-2.png";
    return "icon.png";
}

public int getSubcategoryIdByName(String name, Map<String, Integer> map) {
    if (map.containsKey(name)) {
        return map.get(name);
    } else {
        return 0;
    }
}
%>

<html>
<head>
<style>
.slider-wrapper {
  overflow: hidden;
  width: 100%;
  max-width: 1510px;
  margin: 0 auto;
  position: relative;
  box-sizing: border-box;
  padding-bottom: 50px; /* 도트 영역 확보 */
}
.slider-track {
  display: flex;
  transition: transform 0.5s ease;
  gap: 30px;
  padding: 10px 0;
  will-change: transform;
}
.slide {
  flex: 0 0 auto;
  width: 415px;
  box-sizing: border-box;
}
.dots {
  text-align: center;
  margin-top: 15px;
  position: absolute;
  bottom: 0;
  width: 100%;
  left: 0;
  z-index: 2;
}
.dots .dot {
  display: inline-block;
  width: 12px;
  height: 12px;
  border-radius: 50%;
  background-color: #ccc;
  margin: 0 6px;
  cursor: pointer;
}
.dots .dot.active {
  background-color: #60af46;
}
</style>
</head>
<body>
<% int shownCount = 0; %>
<div class="slider-wrapper">
  <div class="slider-track">
    <% for (String pest : introItems) {
         String image = imageNameMap.get(pest);
         if (image == null || image.trim().equals("")) continue;
    %>
    <div class="slide">
      <div class="box image-cover" style="background-image: url('/uploads/<%= image %>'); width: 415px;">
        <a href="kiwoom_detail.jsp?item_id=<%= itemIdMap.get(pest) %>">
          <div class="text-bottom"><%= pest %></div>
        </a>
      </div>
    </div>
    <% shownCount++; } %>
  </div>
  <div class="dots"></div>
</div>
<script>
document.addEventListener("DOMContentLoaded", function () {
  const sliderWrappers = document.querySelectorAll('.slider-wrapper');

  sliderWrappers.forEach(wrapper => {
    const track = wrapper.querySelector('.slider-track');
    const slides = wrapper.querySelectorAll('.slide');
    const dotsContainer = wrapper.querySelector('.dots');

    const slidesPerPage = 3;
    const slideWidth = 415 + 30;
    const totalPages = Math.ceil(slides.length / slidesPerPage);
    let currentPage = 0;

    if (totalPages > 1) {
      for (let i = 0; i < totalPages; i++) {
        const dot = document.createElement('span');
        dot.classList.add('dot');
        if (i === 0) dot.classList.add('active');
        dot.dataset.index = i;
        dotsContainer.appendChild(dot);
      }

      dotsContainer.addEventListener('click', function (e) {
        if (!e.target.classList.contains('dot')) return;
        const index = parseInt(e.target.dataset.index);
        currentPage = index;
        const offset = index * slideWidth * slidesPerPage;
        track.style.transform = `translateX(-${offset}px)`;
        dotsContainer.querySelectorAll('.dot').forEach(dot => dot.classList.remove('active'));
        e.target.classList.add('active');
      });
    }
  });
});
</script>

</body>
</html>