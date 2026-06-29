# setup-zsh

🌐 [English](README.md) | [Tiếng Việt](README_VI.md) | [简体中文](README_ZH.md)


Một bộ cấu hình Zsh nhẹ và cao cấp dành cho macOS giúp tích hợp highlight cú pháp, tô màu hiển thị danh sách tệp, prompt tối giản đẹp mắt và chiến lược **tự động gợi ý so khớp bất kỳ (substring autosuggestions)**.

Khác với các cấu hình tiêu chuẩn chỉ gợi ý các lệnh bắt đầu bằng các ký tự bạn đã nhập, bộ cấu hình này tìm kiếm **bất kỳ chuỗi con nào** trong lịch sử lệnh của bạn và định dạng chúng bằng một ký hiệu hoàn thành thanh lịch (`↳`).

## Tính năng nổi bật

- **Tự động gợi ý so khớp bất kỳ (Match-Any Autosuggestions)**: Tìm kiếm không phân biệt chữ hoa/chữ thường trong toàn bộ lịch sử của bạn để gợi ý bất kỳ lệnh nào chứa nội dung bạn đã nhập (ví dụ: gõ `GOOGLE` sẽ tự động gợi ý và khớp lệnh `curl -I google.com`).
- **Duyệt lịch sử so khớp chuỗi con (Substring History Cycling)**: Gõ bất kỳ từ khóa nào và nhấn phím **Mũi tên Lên / Xuống** để duyệt qua tất cả các lệnh trong lịch sử chứa từ khóa đó (không phân biệt hoa/thường).
- **Highlight cú pháp (Syntax Highlighting)**: Kiểm tra và highlight cú pháp thời gian thực (màu xanh lá cây cho các lệnh hợp lệ, màu đỏ cho các lệnh không hợp lệ).
- **Prompt tối giản kiểu Fish**: Prompt hiện đại, tinh gọn dạng `username (branch*) ❯` hiển thị nhánh Git hiện tại cùng trạng thái (clean/dirty) nếu bạn đang ở trong thư mục dự án Git, cùng mũi tên trạng thái chuyển sang màu hồng nếu lệnh trước đó bị lỗi.
- **Tự động chuyển thư mục (Auto-CD)**: Chuyển nhanh đến các thư mục bằng cách nhập trực tiếp đường dẫn thư mục mà không cần gõ lệnh `cd`.
- **Màu sắc thư mục nổi bật**: Cấu hình `LSCOLORS` tùy chỉnh giúp các tệp và thư mục hiển thị trực quan và sinh động trên cả nền giao diện sáng/tối.
- **Cấu hình mặc định tối ưu**: Kích hoạt tab-completion của Zsh, tự động lưu lịch sử lệnh, loại bỏ trùng lặp và tăng sức chứa lịch sử phiên lên 100,000 lệnh.

---

## Hướng dẫn sử dụng

### 1. Tự động gợi ý so khớp bất kỳ (Match-Any Autosuggestions)
Khi bạn gõ lệnh, Zsh sẽ tự động hiển thị gợi ý lệnh phù hợp gần đây nhất từ lịch sử lệnh của bạn dưới dạng văn bản mờ (ghost text).
- **So khớp tiền tố (Prefix Match)**: Nếu bạn gõ `curl`, gợi ý sẽ hiển thị ` -I google.com`. Nhấn `Tab` hoặc `Mũi tên phải` để áp dụng toàn bộ gợi ý.
- **So khớp chuỗi con (Substring Match)**: Nếu bạn gõ `google` (hoặc `GOOGLE` do không phân biệt chữ hoa/thường), gợi ý sẽ hiển thị ` ↳ curl -I google.com`.
  - Nhấn **`Tab`**, **`Mũi tên phải`**, hoặc **`Control + F`** để áp dụng toàn bộ gợi ý.
  - Nhấn **`Option + Mũi tên phải`** (hoặc `Alt + F`) để áp dụng gợi ý **từng từ một (word-by-word)**.
- **Duyệt qua nhiều kết quả phù hợp**: Nếu lệnh gợi ý không phải là lệnh bạn muốn, hãy nhấn phím **Mũi tên Lên** để thay thế dòng lệnh bằng kết quả khớp mới nhất và tiếp tục nhấn **Mũi tên Lên / Xuống** để duyệt qua tất cả các lệnh khớp trong lịch sử.

### 2. Tự động chuyển thư mục (Auto-CD)
Để chuyển thư mục nhanh hơn, chỉ cần gõ đường dẫn thư mục bất kỳ và nhấn `Enter`:
```bash
~/Downloads  # Tự động thực hiện lệnh cd ~/Downloads
..           # Tự động thực hiện lệnh cd ..
```

### 3. Prompt phong cách Fish
- Prompt hiển thị dưới dạng `username (branch*) ❯ `.
- Nếu nhánh Git hiện tại có thay đổi chưa commit, một dấu `*` màu hồng sẽ xuất hiện. Nếu có tệp đã được đưa vào khu vực chờ (staged changes), dấu `+` màu xanh lá cây sẽ xuất hiện.
- Mũi tên `❯` sẽ chuyển sang màu hồng nếu lệnh cuối cùng chạy thất bại.

---

## Cài đặt nhanh (Một dòng lệnh duy nhất)

Để thiết lập cấu hình Zsh trên một chiếc MacBook hoàn toàn mới (hoặc bất kỳ thiết bị macOS nào), chỉ cần mở Terminal và chạy lệnh sau:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/setup.sh | bash
```

*Lưu ý: Kịch bản cài đặt chỉ sử dụng các công cụ có sẵn trong hệ thống (`curl`, `unzip`, `zsh`) và không yêu cầu cài đặt Git hoặc Xcode Command Line Tools để tải xuống các plugin.*

Sau khi chạy xong kịch bản, áp dụng các thay đổi cho phiên terminal hiện tại của bạn:

```bash
source ~/.zshrc
```

---

## Gỡ cài đặt nhanh (Một dòng lệnh duy nhất)

Nếu bạn muốn gỡ bỏ cấu hình này và khôi phục cài đặt gốc:

```bash
curl -sSL https://raw.githubusercontent.com/openhoangnc/setup-zsh/main/uninstall.sh | bash
```

Lệnh duy nhất này sẽ thực hiện:
1. **Gỡ bỏ an toàn khối cấu hình setup-zsh** khỏi tệp `~/.zshrc` của bạn bằng cách sử dụng các thẻ đánh dấu khởi đầu/kết thúc thông minh, bảo toàn tất cả các cấu hình hoặc bí danh (alias) tự tạo khác của bạn. Nếu tệp `.zshrc` của bạn được tạo mới hoàn toàn và nay không còn nội dung gì khác, nó sẽ tự động bị xóa.
2. **Xóa bỏ thư mục plugin riêng biệt** nằm tại `~/.zsh/setup-zsh/` (đảm bảo không gây ảnh hưởng đến các thư mục `.zsh` tiêu chuẩn khác của bạn).

---

## Bản quyền (License)

Mã nguồn của kho lưu trữ này được phân phối theo [MIT License](LICENSE).

Bộ cài đặt này phân phối lại các plugin của bên thứ ba trong thư mục `plugins/`:
- **`zsh-syntax-highlighting`**: Được cấp phép theo [BSD 3-Clause License](plugins/zsh-syntax-highlighting/COPYING.md).
- **`zsh-autosuggestions`**: Được cấp phép theo [MIT License](plugins/zsh-autosuggestions/LICENSE).
