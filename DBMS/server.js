const express = require('express');
const { Pool } = require('pg');
const cors = require('cors');

// Nạp thông tin cấu hình từ file JSON
const dbConfig = require('./config.json');

const app = express();
app.use(cors());

// Sử dụng thông tin cấu hình vừa nạp để kết nối Database
const pool = new Pool(dbConfig);

app.get('/api/map-data', async (req, res) => {
  try {
    // Truy vấn cả 5 bảng kèm theo các cột thuộc tính bổ sung
    const queries = [
      pool.query(`SELECT gid AS id, 'Ranh giới' as type, ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_Translate(geom, -350000, 0), 3405), 4326))::json AS geometry FROM bounds`),
      pool.query(`SELECT gid AS id, 'Tòa nhà' as type, nature, company, ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_Translate(geom, -350000, 0), 3405), 4326))::json AS geometry FROM building`),
      pool.query(`SELECT gid AS id, 'Đường sá' as type, nblanes, ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_Translate(geom, -350000, 0), 3405), 4326))::json AS geometry FROM road`),
      pool.query(`SELECT gid AS id, 'Bãi rác' as type, ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_Translate(geom, -350000, 0), 3405), 4326))::json AS geometry FROM garbadge`),
      pool.query(`SELECT gid AS id, 'Chỉ dẫn' as type, ST_AsGeoJSON(ST_Transform(ST_SetSRID(ST_Translate(geom, -350000, 0), 3405), 4326))::json AS geometry FROM "instruction-generated"`)
    ];

    const results = await Promise.all(queries);
    const features = [];

    const processRows = (rows, type) => {
      rows.forEach(row => {
        if (row.geometry) {
          let properties = { id: row.id, type: type };

          // Nhúng thêm thuộc tính chi tiết cho Frontend đọc
          if (type === 'Tòa nhà') {
            properties.nature = row.nature;
            properties.company = row.company;
          }
          if (type === 'Đường sá') {
            properties.nblanes = row.nblanes;
          }

          features.push({ type: 'Feature', geometry: row.geometry, properties: properties });
        }
      });
    };

    // Đẩy dữ liệu vào mảng theo thứ tự
    processRows(results[0].rows, 'Ranh giới');
    processRows(results[1].rows, 'Tòa nhà');
    processRows(results[2].rows, 'Đường sá');
    processRows(results[3].rows, 'Bãi rác');
    processRows(results[4].rows, 'Chỉ dẫn');

    res.json({ type: 'FeatureCollection', features: features });
  } catch (err) {
    console.error("Lỗi Database:", err);
    res.status(500).send('Lỗi Server');
  }
});

app.listen(3000, () => {
  console.log('API Server đang chạy tại http://localhost:3000/api/map-data');
});