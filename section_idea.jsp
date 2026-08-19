<%@ page contentType="text/html;charset=euc-kr" pageEncoding="euc-kr" %>
<%@ page import="java.sql.*, java.util.*" %>
<%@ page import="java.net.URLEncoder" %>

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
Map<String, String> imageName2Map = new HashMap<>();


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

    String sql = "SELECT c.category_id, c.category_name, s.subcategory_id, s.subcategory_name, i.item_id, i.item_title, i.image_name, i.image_name2 " +
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
		String imageName2 = rs.getString("image_name2");

        subcategoryIdMap.put(subcategory, subcategoryId);
        categoryNameMap.putIfAbsent(categoryId, categoryName);
        categoryMap.putIfAbsent(categoryId, new LinkedHashMap<>());
        categoryMap.get(categoryId).putIfAbsent(subcategory, new ArrayList<>());

        if (item != null) {
			categoryMap.get(categoryId).get(subcategory).add(item);
			itemIdMap.put(item, itemId);
			if (imageName != null) imageNameMap.put(item, imageName);
			if (imageName2 != null) imageName2Map.put(item, imageName2); // ← 이 부분 추가
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
<%!
public String getTextColorStyle(String imageName) {
    if (imageName == null) return "";
    String lower = imageName.toLowerCase();

    // 밝은 이미지일 경우 검정 글씨 적용
    if (lower.contains("ceramic") || 
        lower.contains("drain") || 
        lower.contains("terracotta") || 
        lower.contains("plastic") || 
        lower.contains("cement") || 
        lower.contains("prop")||
		lower.contains("spring")||
		lower.contains("summer")||
		lower.contains("fall")||
		lower.contains("winter")){
        return "color: black;";
    }

    return "color: white;";
}
%>


<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="euc-kr">
  <title>키움백과</title>
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
    body {
      margin: 0;
      padding: 0;
    }
    a {
      text-decoration: none;
      color: inherit;
    }

    .tabs-wrapper {
	  width: 100%;
	  max-width: 1600px;
	  padding: 20px;
	  margin: 0 auto;
	  border-radius: 50px 50px 0 0;
	  background-color: #ffffff;
	  /*  테두리 제거 */
	  border: none;
	  box-sizing: border-box;
	}

    .tabs {
      display: flex;
      background-color: #eef4ea;
      border-radius: 50px 50px 0 0;
      margin: 0;
      padding: 5px 10px;
      font-size: 28px;
      width: 100%;
      height: 135px;
      padding-left: 0;
      padding-right: 0;
    }

    .tab-button {
      flex: 1;
      text-align: center;
      padding: 20px;
      cursor: pointer;
      border: none;
      background-color: transparent;
      color: #333;
      font-size: 28px;
      border-radius: 50px 50px 0 0;
      height: 100%;
      font-family: 'GmarketSansTTFMedium';
    }

    .tab-button.active {
      background-color: #60af46;
      color: white;
      width: 427px;
      height: 127px;
      margin-top: -5px;
    }

    .tab-button:not(.active) {
      width: 100%;
    }

    .tab-button:focus {
      outline: none;
    }

    /* 그리고 탭 타이틀 여백 줄이기 */
	.tab-title {
	  font-size: 36px;
	  text-align: center;
	  color: #333;
	  margin-top: 30px; /* 너무 딱 붙지 않게 약간만 띄움 */
	  margin-bottom: 40px;
	  font-family: 'GmarketSansTTFBold';
	}

    /*  탭 바로 아래 이어지는 초록 테두리 wrapper */
	.green-frame-wrapper {
	  margin-top: -180px;
	  margin-left: calc(50% - 755px); /*  기존보다 5px 왼쪽으로 조정 */
	  width: 1510px;                 /* 고정된 프레임 너비 */
	  padding: 220px 25px 145px;     /*  위쪽 공간 확보, 아래 그대로 */
	  border: 1.5px solid #60af46;
	  border-top: none;
	  border-radius: 0 0 50px 50px;
	  background-color: white;
	  box-sizing: border-box;
	}

	.green-card-container {
	  display: flex;
	  justify-content: space-between;  /*  카드들 좌우 간격 자동 정렬 */
	  align-items: flex-start;
                      /*  카드 간의 여백 */
	  padding-top: 0px;                /*  상단 여백 제거 */
	  margin-top: 0px;
	}

    .big-box-container {
	  display: flex;
	  flex-wrap: nowrap;
	  width: max-content;
	  padding: 20px 40px;
	  gap: 40px;
	  height: 550px;
	  margin: 0 auto;
	  box-sizing: border-box;
	}


    .box {
      width: 415px;
      height: 513px;
      background-color: #eef4ea;
      border-radius: 50px;
      text-align: center;
      padding: 60px 20px;
      position: relative;
      display: flex;
      flex-direction: column;
      justify-content: flex-start;
	  margin-top: 30px;
    }

    .text-top {
      font-size: 34px;
      color: #333;
      margin-bottom: 10px;
      font-family: 'GmarketSansTTFMedium';
      line-height: 1.2;
      text-align: left;
      margin-left: 20px;
    }

	.text-bottom {
	  position: absolute;
	  bottom: 20px;
	  left: 40px;
	  font-size: 50px;
	  font-family: 'GmarketSansTTFLight';
	  line-height: 1.2;
	  color: white; /* 기본은 흰색 */
	}

	.text-bottom.black-text {
	  color: black;  /* 검정 글씨용 추가 클래스 */
	}



    .box .arrow {
      position: absolute;
      bottom: 50px;
      right: 67px;
      width: 75px;
      height: 57px;
      cursor: pointer;
    }

    .tab-content {
      display: none;
      padding: 20px;
      background-color: white;
      border-radius: 10px;
      margin: 20px;
    }

    .tab-content.active {
      display: block;
    }

    .checklist-wrapper {
      display: flex;
      justify-content: flex-start;  /* 위에서부터 하나씩 쌓이게 함 */
      gap: 40px;
      margin-top: 60px;
    }

    .checklist-box {
      width: 735px;
      height: 740px;
      border: 2px solid #60af46;
      border-radius: 50px;
      padding: 20px;
      display: flex;
      flex-direction: column;
	  justify-content: flex-start;  /* 위에서부터 하나씩 쌓이게 함 */
      margin-top: 100px;
    }

    .checklist-header {
      display: flex;
      align-items: center;
      justify-content: flex-start;
      width: 100%;
      margin-bottom: 40px;
    }

    .checklist-header-content {
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 10px;
      width: 100%;
    }

    .checklist-title {
      font-size: 34px;
      color: Black;
      font-family: 'GmarketSansTTFMedium';
      flex-grow: 1;
      margin-left: 15px;
      margin-top: 45px;
    }

    .checklist-icon {
      width: 80px;
      height: 80px;
      margin-left: 135px;
      margin-top: 25px;
    }

    .details-link {
      font-size: 22px;
      color: Black;
      text-decoration: none;
      margin-right: 50px;
      margin-top: 45px;
      white-space: nowrap;
      font-family: 'GmarketSansTTFLight';
    }

    .details-link:hover {
      text-decoration: underline;
    }

    .checklist-item {
      background-color: #eef4ea;
      padding: 15px;
      margin: 20px 0;
      border-radius: 30px;
      font-size: 32px;
      color: #333;
      transition: background-color 0.3s ease;
      width: 660px;
      height: 140px;
      padding-left: 40px;
      padding-top: 60px;
      margin-left: 9px;
	  
    }

    .checklist-item a {
      text-decoration: none;
      color: #333;
      font-family: 'GmarketSansTTFLight';
    }
	.tab-content {
	  display: none;
	}

	.tab-content.active {
	  display: block;
	}
.image-box {
  width: 100%;
  height: 100%;
  background-size: cover;
  background-position: center;
  border-radius: 20px;
}
.image-box img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  border-radius: 20px;
}
.box.image-cover {
  position: relative;
  background-size: cover;
  background-position: center;
}

.slider-wrapper {
  overflow: hidden;
  width: 100%;
}

#slide-container {
  display: flex;
  transition: transform 0.3s ease-in-out;
  gap: 10px;
  width: fit-content;
}

/* 슬라이드 버튼 위치 및 스타일 */

/* 슬라이더 래퍼 */
.slider-wrapper {
  overflow-x: auto;
  overflow-y: hidden;
  scroll-snap-type: x proximity;
  -webkit-overflow-scrolling: touch;
  scroll-behavior: smooth;
  width: 100%;
  padding-bottom: 20px; /* 유지 */
  scrollbar-width: thin; /* Firefox */
  scrollbar-color: rgba(80, 80, 80, 0.6) transparent;
}

/* 슬라이드 컨테이너 */
.scroll-snap {
  display: flex;
  gap: 12px;
  padding-bottom: 10px;
  width: max-content;
}

/* 개별 이미지 카드 */
.snap-item {
  flex: 0 0 auto;            /*  줄바꿈 방지 */
  scroll-snap-align: start;
}

/* 스크롤바 디자인 (WebKit 브라우저) */
.slider-wrapper::-webkit-scrollbar {
  height: 10px !important;
  background: transparent !important;
}
.slider-wrapper::-webkit-scrollbar-track {
  background: transparent !important;
  border-radius: 10px !important;
}
.slider-wrapper::-webkit-scrollbar-thumb {
  background-color: rgba(80, 80, 80, 0.6) !important;
  border-radius: 10px !important;
  border: none !important;
}
.slider-wrapper::-webkit-scrollbar-button {
  display: none !important;
}


/* Firefox 대응 */
.slider-wrapper {
  scrollbar-width: thin;
  scrollbar-color: rgba(80, 80, 80, 0.6) transparent;
}

/* 드래그 중 링크 클릭 비활성화 */
a.no-click {
  pointer-events: none;
}

/* 이미지나 텍스트 선택 방지 */
.slider-wrapper, .box, .box * {
  user-select: none;
}
.slider-wrapper, .slider-wrapper * {
  user-select: none;
  pointer-events: auto; /* 내부 요소도 이벤트 전달 허용 */
}


  </style>
  <script>
    function showTab(tabId) {
      document.querySelectorAll('.tab-content').forEach(el => el.classList.remove('active'));
      document.getElementById(tabId).classList.add('active');
      document.querySelectorAll('.tab-button').forEach(btn => btn.classList.remove('active'));
      document.querySelector('[data-tab="' + tabId + '"]').classList.add('active');
    }
  </script>
</head>
<body>
  <div class="tabs-wrapper">
    <div class="tabs">
      <% int tabIndex = 0;
         for (Integer categoryId : categoryMap.keySet()) {
           String category = categoryNameMap.get(categoryId);
           String tabId = "tab" + tabIndex; %>
        <button class="tab-button <%= tabIndex == 0 ? "active" : "" %>" data-tab="<%= tabId %>" onclick="showTab('<%= tabId %>')">
          <%= category %>
        </button>
      <% tabIndex++; } %>
    </div>
  </div>

  <% tabIndex = 0;
     for (Map.Entry<Integer, Map<String, List<String>>> categoryEntry : categoryMap.entrySet()) {
       Integer categoryId = categoryEntry.getKey();
       String categoryKey = categoryNameMap.get(categoryId);
       String tabId = "tab" + tabIndex;

       if (selectedCategory != null && !selectedCategory.equals(categoryKey)) continue;

       Map<String, List<String>> subMap = categoryEntry.getValue();
       String displayTitle = categoryDisplayMap.getOrDefault(categoryKey, categoryKey);
       String introText = categoryIntroMap.getOrDefault(categoryKey, "");
       String introSubTitle = categoryIntroTitleMap.getOrDefault(categoryKey, "");
  %>
  <div class="tab-content <%= (selectedCategory == null && tabIndex == 0) || (selectedCategory != null && selectedCategory.equals(categoryKey)) ? "active" : "" %>" id="<%= tabId %>">
    <div class="tab-title"><%= displayTitle %></div>
    <% List<String> introItems = subMap.get(introSubTitle);
       if (introItems != null) { %>
    <div class="green-frame-wrapper" style="overflow: visible;">
	  <div class="slider-wrapper scrollable">
		<div class="big-box-container scroll-snap" id="slide-container">
		  <% for (String pest : introItems) {
				 String image = imageNameMap.get(pest);
				 if ((image == null || image.trim().equals("")) && !imageName2Map.containsKey(pest)) continue;
			%>
			  <div class="box image-cover snap-item" style="background-image: url('/uploads/<%= image %>');">
				<a href="kiwoom_detail.jsp?item_id=<%= itemIdMap.get(pest) %>">
				  <div class="text-bottom" style="<%= getTextColorStyle(image) %>"><%= pest %></div>
				</a>
			  </div>
			<% } %>

		</div>
	  </div>
	</div>

    <% } %>

    <div class="checklist-wrapper">
      <% for (Map.Entry<String, List<String>> subEntry : subMap.entrySet()) {
           String subName = subEntry.getKey();
           if (subName.equals(introSubTitle)) continue;
      %>
      <div class="checklist-box">
        <div class="checklist-header">
          <div class="checklist-header-content">
            <img src="images/<%= subNameToImage(subName) %>" alt="아이콘" class="checklist-icon">
            <div class="checklist-title"><%= subName %></div>
           <a href="#" class="details-link" onclick="<% if (subcategoryIdMap.containsKey(subName)) { %>loadKiwoomById(<%= subcategoryIdMap.get(subName) %>)<% } %>">자세히 ></a>


          </div>
        </div>
       <%
		  List<String> items = subEntry.getValue();
		  int itemCount = 0;
		  for (String item : items) {
			if (itemCount >= 3) break; //  최대 3개까지만
			itemCount++;
		%>
        <div class="checklist-item">
          <a href="kiwoom_detail.jsp?item_id=<%= itemIdMap.get(item) %>"><%= item %></a>
        </div>
        <% } %>
      </div>
      <% } %>
    </div>
  </div>
  <% tabIndex++; } %>

<!-- sub4.jsp 맨 아래쪽에 추가 -->
<script>
function loadKiwoomById(subcategoryId) {
  const url = `/succu/section_kiwoom.jsp?subcategory_id=` + encodeURIComponent(subcategoryId);
  const xhr = new XMLHttpRequest();
  xhr.overrideMimeType("text/html;charset=EUC-KR");
  xhr.open("GET", url, true);
  xhr.onreadystatechange = function () {
    if (xhr.readyState === 4 && xhr.status === 200) {
      const tempDiv = document.createElement("div");
      tempDiv.innerHTML = xhr.responseText;

      const contentBox = document.getElementById("diary-content");
      if (contentBox) {
        contentBox.innerHTML = tempDiv.innerHTML;
      } else {
        document.body.innerHTML = tempDiv.innerHTML;
      }
    }
  };
  xhr.send();
}
document.body.addEventListener('click', function (e) {
  const target = e.target.closest('.detail-link');
  if (target) {
    e.preventDefault();
    const itemId = target.dataset.id;
    console.log(" 클릭된 item_id:", itemId); // 디버깅용 로그

    fetch(`kiwoom_detail.jsp?item_id=${itemId}`)
      .then(res => res.text())
      .then(html => {
        document.getElementById("diary-content").innerHTML = html;
      })
      .catch(err => console.error(" AJAX 실패:", err));
  }
});

</script>
<script>
document.addEventListener('DOMContentLoaded', function () {
  const sliders = document.querySelectorAll('.slider-wrapper');

  sliders.forEach((slider) => {
    // === 마우스 휠 수평 스크롤 ===
    slider.addEventListener('wheel', (event) => {
      if (event.deltaY !== 0) {
        event.preventDefault();
        slider.scrollLeft += event.deltaY;
      }
    }, { passive: false });

    // === 마우스 드래그 스크롤 ===
    let isDown = false;
    let startX, scrollLeftStart;

    slider.addEventListener('mousedown', (e) => {
      isDown = true;
      startX = e.pageX;
      scrollLeftStart = slider.scrollLeft;
      slider.classList.add('dragging');
      slider.querySelectorAll('a').forEach(a => a.classList.add('no-click'));
    });

    slider.addEventListener('mouseleave', () => {
      isDown = false;
      slider.classList.remove('dragging');
      slider.querySelectorAll('a').forEach(a => a.classList.remove('no-click'));
    });

    slider.addEventListener('mouseup', () => {
      isDown = false;
      slider.classList.remove('dragging');
      slider.querySelectorAll('a').forEach(a => a.classList.remove('no-click'));
    });

    slider.addEventListener('mousemove', (e) => {
      if (!isDown) return;
      e.preventDefault();
      const x = e.pageX;
      const walk = (x - startX) * 1.5;
      slider.scrollLeft = scrollLeftStart - walk;
    });

    // 클릭 방지 로직
    let clickPrevented = false;
    slider.addEventListener('mousedown', () => {
      clickPrevented = false;
    });
    slider.addEventListener('mousemove', () => {
      clickPrevented = true;
    });
    slider.addEventListener('click', (e) => {
      if (clickPrevented) {
        e.preventDefault();
        e.stopPropagation();
      }
    }, true);
  });
});
</script>

</body>

</html>