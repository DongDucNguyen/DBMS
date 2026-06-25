// Khởi tạo bản đồ 
var map = L.map('map').setView([16.0, 106.0], 5);

// 1. Dùng Base Map CartoDB (Màu xám sáng, trông rất chuyên nghiệp và làm nổi bật dữ liệu)
var lightMap = L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; OpenStreetMap &copy; CARTO',
    maxZoom: 20
}).addTo(map);

var satelliteMap = L.tileLayer('https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}', {
    attribution: 'Tiles &copy; Esri'
});

// 2. Định nghĩa các Layer Group cho từng loại dữ liệu để bật/tắt
var boundsLayer = L.geoJSON(null, {
    style: { color: "#8b5cf6", weight: 3, dashArray: "5, 10", fillOpacity: 0.05 }
});

var roadLayer = L.geoJSON(null, {
    style: function (feature) {
        // Đường càng nhiều làn xe thì vẽ càng đậm
        let weight = feature.properties.nblanes ? feature.properties.nblanes * 1.5 : 3;
        return { color: "#475569", weight: weight, opacity: 0.9 };
    },
    onEachFeature: function (feature, layer) {
        let lanes = feature.properties.nblanes || 'Không rõ';
        layer.bindPopup(`
            <div class="popup-title">🛣️ Tuyến Đường</div>
            <div class="popup-row"><span class="popup-label">Mã ID:</span> ${feature.properties.id}</div>
            <div class="popup-row"><span class="popup-label">Số làn xe:</span> ${lanes}</div>
        `);
    }
});

var buildingLayer = L.geoJSON(null, {
    style: { color: "#ea580c", weight: 1, fillColor: "#f97316", fillOpacity: 0.5 },
    onEachFeature: function (feature, layer) {
        let nature = feature.properties.nature || 'Chưa cập nhật';
        let company = feature.properties.company || 'Trống';
        layer.bindPopup(`
            <div class="popup-title">🏢 Tòa Nhà / Cơ Sở</div>
            <div class="popup-row"><span class="popup-label">Mã ID:</span> ${feature.properties.id}</div>
            <div class="popup-row"><span class="popup-label">Loại hình:</span> ${nature}</div>
            <div class="popup-row"><span class="popup-label">Đơn vị sử dụng:</span> ${company}</div>
        `);
    }
});

var instructionLayer = L.geoJSON(null, {
    style: { color: "#10b981", weight: 4, dashArray: "8, 8" },
    onEachFeature: function (feature, layer) {
        layer.bindPopup(`<div class="popup-title">📍 Tuyến Chỉ Dẫn</div><div class="popup-row"><span class="popup-label">Mã ID:</span> ${feature.properties.id}</div>`);
    }
});

var garbageLayer = L.geoJSON(null, {
    pointToLayer: function (feature, latlng) {
        // Đổi icon marker mặc định thành chấm tròn nổi bật
        return L.circleMarker(latlng, {
            radius: 7, fillColor: "#ef4444", color: "#b91c1c", weight: 2, opacity: 1, fillOpacity: 0.9
        });
    },
    onEachFeature: function (feature, layer) {
        layer.bindPopup(`<div class="popup-title">🗑️ Điểm Tập Kết Rác</div><div class="popup-row"><span class="popup-label">Mã ID:</span> ${feature.properties.id}</div>`);
    }
});

// 3. Thêm Bảng Điều Khiển (Control Panel) góc trên bên phải
var baseMaps = { "Bản đồ Đơn sắc": lightMap, "Bản đồ Vệ tinh": satelliteMap };
var overlayMaps = {
    "🔲 Ranh giới khu vực": boundsLayer,
    "🏢 Các tòa nhà": buildingLayer,
    "🛣️ Hệ thống giao thông": roadLayer,
    "📍 Tuyến chỉ dẫn (Path)": instructionLayer,
    "🗑️ Điểm tập kết rác": garbageLayer
};
L.control.layers(baseMaps, overlayMaps, { collapsed: false }).addTo(map);

// 4. Gọi API và tự động phân luồng dữ liệu vào các layer tương ứng
fetch('http://localhost:3000/api/map-data')
    .then(response => response.json())
    .then(data => {
        let hasData = false;
        data.features.forEach(feature => {
            hasData = true;
            switch (feature.properties.type) {
                case 'Ranh giới': boundsLayer.addData(feature); break;
                case 'Tòa nhà': buildingLayer.addData(feature); break;
                case 'Đường sá': roadLayer.addData(feature); break;
                case 'Chỉ dẫn': instructionLayer.addData(feature); break;
                case 'Bãi rác': garbageLayer.addData(feature); break;
            }
        });

        // Hiển thị mặc định 4 lớp lên bản đồ
        boundsLayer.addTo(map);
        roadLayer.addTo(map);
        buildingLayer.addTo(map);
        garbageLayer.addTo(map);

        // Tự động căn chỉnh Camera bản đồ bao trọn toàn bộ khu vực
        if (hasData) {
            let allLayersGroup = new L.featureGroup([boundsLayer, buildingLayer, roadLayer, garbageLayer]);
            map.fitBounds(allLayersGroup.getBounds(), { padding: [50, 50] });
        }
    })
    .catch(error => console.error('Lỗi khi tải dữ liệu API:', error));