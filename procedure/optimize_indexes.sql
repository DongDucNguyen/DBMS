-- 1. Bảng `books`
-- Tối ưu hóa các câu lệnh lọc sách đã duyệt và không bị ẩn (Dùng rất nhiều trong các views như vw_newestbooks, vw_trendingbooks, vw_userfavoritebooks, vw_bookdetails,...)
CREATE INDEX idx_books_approval_hidden ON books(approvalStatus, isHidden);

-- Tối ưu hóa sắp xếp sách theo lượt xem giảm dần (Dùng trong vw_trendingbooks, sp_GetBooksByAuthor)
CREATE INDEX idx_books_viewCount ON books(viewCount DESC);

-- Tối ưu hóa sắp xếp sách theo ngày tạo và ngày phát hành (Dùng trong vw_newestbooks, vw_pendingbooks)
CREATE INDEX idx_books_createdAt_releaseDate ON books(createdAt DESC, releaseDate DESC);

-- Tối ưu hóa tra cứu sách theo người đăng (Dùng trong sp_DeleteBook, sp_EditBook, vw_pendingbooks)
CREATE INDEX idx_books_submittedByUserId ON books(submittedByUserId);


-- 2. Bảng `comments`
-- Tối ưu hóa việc JOIN và GROUP BY để tính trung bình rating, tổng review theo bookId
CREATE INDEX idx_comments_bookId ON comments(bookId);


-- 3. Bảng `listeningaudiobook`
-- Tối ưu hóa kiểm tra lịch sử nghe của user với một sách cụ thể (Dùng trong sp_UpsertListeningHistory)
CREATE INDEX idx_listeningaudiobook_user_book ON listeningaudiobook(userId, bookId);

-- Tối ưu hóa sắp xếp lịch sử nghe theo thời gian (Dùng trong vw_listeninghistory)
CREATE INDEX idx_listeningaudiobook_lastListenedAt ON listeningaudiobook(lastListenedAt DESC);


-- 4. Bảng `userfavorites`
-- Tối ưu hóa tra cứu danh sách yêu thích của user (Dùng trong sp_ToggleFavorite)
CREATE INDEX idx_userfavorites_user_book ON userfavorites(userId, bookId);

-- Tối ưu hóa khi join từ userfavorites sang books và khi xóa sách (Dùng trong vw_userfavoritebooks, sp_DeleteBook)
CREATE INDEX idx_userfavorites_bookId ON userfavorites(bookId);


-- 5. Bảng `usersubscriptions`
-- Tối ưu hóa việc kiểm tra gói đăng ký còn hạn của user (Dùng trong vw_userprofile)
CREATE INDEX idx_usersubscriptions_userId_endDate ON usersubscriptions(userId, endDate);


-- 6. Bảng `authorsofbooks`
-- Tối ưu hóa JOIN giữa books và author (Thường xuyên join ở hầu hết các view)
CREATE INDEX idx_authorsofbooks_bookId ON authorsofbooks(BookId);
CREATE INDEX idx_authorsofbooks_authorId ON authorsofbooks(AuthorId);


-- 7. Bảng `categoriesofbooks`
-- Tối ưu hóa JOIN giữa books và category (Dùng trong vw_newestbooks, vw_pendingbooks, vw_trendingbooks, vw_bookdetails)
CREATE INDEX idx_categoriesofbooks_bookId ON categoriesofbooks(BookId);
CREATE INDEX idx_categoriesofbooks_categoryId ON categoriesofbooks(CategoryId);


-- 8. Bảng `audiochapter`
-- Tối ưu hóa xóa chapter khi xóa sách theo bookId (Dùng trong sp_DeleteBook)
CREATE INDEX idx_audiochapter_bookId ON audiochapter(bookId);
