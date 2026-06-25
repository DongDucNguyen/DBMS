-- ------------------------------------------
-- 1. Bảng books
-- ------------------------------------------

-- Kiểm tra Index: idx_books_approval_hidden
-- Chạy câu lệnh này, cột 'key' sẽ trả về idx_books_approval_hidden, 'type' là ref
EXPLAIN SELECT id, name, approvalStatus, isHidden 
FROM books 
WHERE approvalStatus = 'APPROVED' AND isHidden = 0;

-- Kiểm tra Index: idx_books_viewCount
-- Chạy câu lệnh này, Extra sẽ KHÔNG CÓ 'Using filesort', hệ thống sẽ dùng index để sort
EXPLAIN SELECT id, name, viewCount 
FROM books 
ORDER BY viewCount DESC LIMIT 10;

-- Kiểm tra Index: idx_books_createdAt_releaseDate
-- Tương tự, sắp xếp sách mới nhất không bị filesort
EXPLAIN SELECT id, name, createdAt, releaseDate 
FROM books 
ORDER BY createdAt DESC, releaseDate DESC LIMIT 10;

-- Kiểm tra Index: idx_books_submittedByUserId
-- Dùng mô phỏng truy vấn kiểm tra quyền chủ sở hữu
EXPLAIN SELECT * 
FROM books 
WHERE submittedByUserId = 1;


-- ------------------------------------------
-- 2. Bảng comments
-- ------------------------------------------

-- Kiểm tra Index: idx_comments_bookId
-- Dùng để mô phỏng Group By tính rating trung bình
EXPLAIN SELECT bookId, ROUND(AVG(rating), 1) AS avgRating, COUNT(id) AS totalReview
FROM comments 
GROUP BY bookId;

EXPLAIN SELECT * FROM comments WHERE bookId = 1;


-- ------------------------------------------
-- 3. Bảng listeningaudiobook
-- ------------------------------------------

-- Kiểm tra Index: idx_listeningaudiobook_user_book
EXPLAIN SELECT * 
FROM listeningaudiobook 
WHERE userId = 1 AND bookId = 1;

-- Kiểm tra Index: idx_listeningaudiobook_lastListenedAt
EXPLAIN SELECT * 
FROM listeningaudiobook 
ORDER BY lastListenedAt DESC LIMIT 10;


-- ------------------------------------------
-- 4. Bảng userfavorites
-- ------------------------------------------

-- Kiểm tra Index: idx_userfavorites_user_book (Mô phỏng check toggle)
EXPLAIN SELECT * 
FROM userfavorites 
WHERE userId = 1 AND bookId = 1;

-- Kiểm tra Index: idx_userfavorites_bookId (Mô phỏng đếm số người thích sách)
EXPLAIN SELECT COUNT(*) 
FROM userfavorites 
WHERE bookId = 1;


-- ------------------------------------------
-- 5. Bảng usersubscriptions
-- ------------------------------------------

-- Kiểm tra Index: idx_usersubscriptions_userId_endDate
-- Dùng trong kiểm tra plan còn hiệu lực
EXPLAIN SELECT * 
FROM usersubscriptions 
WHERE userId = 1 AND endDate >= CURRENT_TIMESTAMP();


-- ------------------------------------------
-- 6. Bảng authorsofbooks & categoriesofbooks
-- ------------------------------------------

-- Kiểm tra các Index bảng liên kết trung gian
EXPLAIN SELECT * FROM authorsofbooks WHERE BookId = 1;
EXPLAIN SELECT * FROM authorsofbooks WHERE AuthorId = 1;

EXPLAIN SELECT * FROM categoriesofbooks WHERE BookId = 1;
EXPLAIN SELECT * FROM categoriesofbooks WHERE CategoryId = 1;


-- ------------------------------------------
-- 7. Bảng audiochapter
-- ------------------------------------------

-- Kiểm tra Index: idx_audiochapter_bookId
-- Đây chính là câu lệnh bạn nên thử để thấy sự khác biệt so với SELECT *
EXPLAIN SELECT * FROM audiochapter WHERE bookId = 1;

-- ==========================================
-- GỢI Ý ĐỌC KẾT QUẢ EXPLAIN
-- ==========================================
-- 1. Cột `type`:
--    + `ALL`    : Tồi nhất (Full table scan - như bạn đã thấy khi không dùng WHERE)
--    + `index`  : Quét toàn bộ Index tree
--    + `ref`    : Tốt (Tìm kiếm dựa trên giá trị Index khớp)
--    + `const`/`eq_ref`: Tốt nhất (Chỉ 1 record duy nhất được tìm thấy - vd dùng PK)
-- 
-- 2. Cột `possible_keys`: Các index mà SQL có thể cân nhắc sử dụng.
-- 3. Cột `key`: Index thực sự được SQL chọn để chạy. Nếu nó hiện tên index ta vừa tạo là thành công.
-- 4. Cột `Extra`:
--    + `Using index` : Cực kỳ tốt (Covering index - data được lấy trực tiếp từ index mà không cần đọc bảng).
--    + `Using filesort`: Database phải tạo mảng tạm và tự sort lại -> Cần tránh (Index sắp xếp của chúng ta đã khắc phục điều này).
