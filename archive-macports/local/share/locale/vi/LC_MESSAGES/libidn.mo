��    ;      �  O   �        �   	  c   �  �     a   �  K   �  �   D  '  A     i	     �	  *   �	  �  �	  -   �  &   �     �  .     )   E  )   o  -   �  I   �               >  "   L      o  &   �  -   �  -   �          3  #   C  6   g     �     �     �     �     �  &     O   +  -   {     �     �  #   �  "   �  %     "   4  %   W     }     �     �     �     �     �  5   �     3     G     [     r     �  !  �  �   �  o   ~  �   �  �   �  R   $    w  J  �  #   �     �  0     �  A  =   �  K        \  C   {  @   �  7      F   8  m     $   �          2  ?   M  L   �  1   �  H     8   U  +   �  "   �  0   �  T         c   1   ~      �      �      �   5   �   `   &!  3   �!     �!     �!  .   �!  /   	"  2   9"  /   l"  2   �"  +   �"     �"     #     /#     H#     Z#  T   a#     �#     �#     �#      �#     $     7   6   )      -   &                     (   *   8                      1   ;         "   
          $           9   4                              3          +   2          5              /                     :   !                    0   #   %   	      ,   '                .              --allow-unassigned   Toggle IDNA AllowUnassigned flag (default off)
      --usestd3asciirules  Toggle IDNA UseSTD3ASCIIRules flag (default off)
       --debug              Print debugging information
      --quiet              Silent operation
       --no-tld             Don't check string for TLD specific rules
                             Only for --idna-to-ascii and --idna-to-unicode
   -h, --help               Print help and exit
  -V, --version            Print version and exit
   -n, --nfkc               Normalize string according to Unicode v3.2 NFKC
   -p, --profile=STRING     Use specified stringprep profile instead
                             Valid stringprep profiles: `Nameprep',
                             `iSCSI', `Nodeprep', `Resourceprep', 
                             `trace', `SASLprep'
   -s, --stringprep         Prepare string according to nameprep profile
  -d, --punycode-decode    Decode Punycode
  -e, --punycode-encode    Encode Punycode
  -a, --idna-to-ascii      Convert to ACE according to IDNA (default mode)
  -u, --idna-to-unicode    Convert from ACE according to IDNA
 Cannot allocate memory Charset `%s'.
 Code points prohibited by top-level domain Command line interface to the internationalized domain name library.

All strings are expected to be encoded in the preferred charset used
by your locale.  Use `--debug' to find out what this charset is.  You
can override the charset used by setting environment variable CHARSET.

To process a string that starts with `-', for example `-foo', use `--'
to signal the end of parameters, as in `idn --quiet -a -- -foo'.

Mandatory arguments to long options are mandatory for short options too.
 Conflicting bidirectional properties in input Error in stringprep profile definition Flag conflict with profile Forbidden leading or trailing minus sign (`-') Forbidden unassigned code points in input Input already contain ACE prefix (`xn--') Input does not start with ACE prefix (`xn--') Internationalized Domain Name (IDN) convert STRINGS, or standard input.

 Invalid input Malformed bidirectional string Missing input No top-level domain found in input Non-digit/letter/hyphen in input Output would be too large or too small Output would exceed the buffer space provided Prohibited bidirectional code points in input Prohibited code points in input Punycode failed String not idempotent under ToASCII String not idempotent under Unicode NFKC normalization String preparation failed String size limit exceeded Success System dlopen failed System iconv failed Try `%s --help' for more information.
 Type each input string on a line by itself, terminated by a newline character.
 Unicode normalization failed (internal error) Unknown error Unknown profile Usage: %s [OPTION]... [STRINGS]...
 could not convert from %s to UTF-8 could not convert from UCS-4 to UTF-8 could not convert from UTF-8 to %s could not convert from UTF-8 to UCS-4 could not do NFKC normalization idna_to_ascii_4z: %s idna_to_unicode_8z4z (TLD): %s idna_to_unicode_8z4z: %s input error malloc only one of -s, -e, -d, -a, -u or -n can be specified punycode_decode: %s punycode_encode: %s stringprep_profile: %s tld_check_4z (position %lu): %s tld_check_4z: %s Project-Id-Version: libidn-1.25
Report-Msgid-Bugs-To: bug-libidn@gnu.org
POT-Creation-Date: 2012-12-11 16:12+0100
PO-Revision-Date: 2012-05-26 08:08+0700
Last-Translator: Trần Ngọc Quân <vnwildman@gmail.com>
Language-Team: Vietnamese <translation-team-vi@lists.sourceforge.net>
Language: vi
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Plural-Forms: nplurals=1; plural=0;
X-Generator: LocFactoryEditor 1.7b3
X-Poedit-Language: Vietnamese
X-Poedit-Country: VIET NAM
X-Poedit-SourceCharset: utf-8
       --allow-unassigned   Bật/tắt cờ IDNA AllowUnassigned (mặc định là tắt)
      --usestd3asciirules  Bật/tắt cờ IDNA UseSTD3ASCIIRules (mặc định là tắt)
       --debug              In ra thông tin gỡ lỗi
      --quiet              Không xuất thông điệp
   -t, --no-tld              Không kiểm tra chuỗi cho quy tắc đặc trưng TLD
                             Chỉ dành cho "--idna-to-ascii" và "--idna-to-unicode"
   -h, --help               In ra trợ giúp, rồi thoát
  -V, --version            In ra số thứ tự phiên bản, rồi thoát
   -n, --nfkc               Tiêu chuẩn hoá chuỗi tùy theo Unicode v3.2 NFKC
   -p, --profile=CHUỖI     Dùng hồ sơ stringprep đã ghi rõ thay vào đó
                             Các hồ sơ stringprep hợp lệ: `Nameprep',
                             `iSCSI', `Nodeprep', `Resourceprep', 
                             `trace', `SASLprep'
   -s, --stringprep         Chuẩn bị chuỗi tùy theo hồ sơ nameprep
  -d, --punycode-decode    Giải mã Punycode
  -e, --punycode-encode    Mã hoá Punycode
  -a, --idna-to-ascii      Chuyển đổi sang ACE tùy theo IDNA (chế độ mặc định)
  -u, --idna-to-unicode    Chuyển đổi từ ACE tùy theo IDNA
 Không thể cấp phát bộ nhớ Bộ ký tự "%s".
 Điểm mã bị cấm bởi miền cấp đầu Giao diện dòng lệnh với thư viện tên miền đã quốc tế hoá.

Mọi chuỗi nên được mã hoá theo bộ ký tự đã thích trong miền địa phương
của bạn. Hãy dùng tùy chọn "--debug" (gỡ lỗi) để tìm biết bộ ký tự nào.
Bạn cũng có thể ghi đè lên bộ ký tự này bằng cách đặt biến môi trường
CHARSET.

Để xử lý một chuỗi bắt đầu với "-", v.d. "-foo", dùng "--" để ngụ ý kết thúc các tham số, như trong "idn --quiet -a -- -foo".

Mọi đối số bắt buộc phải sử dụng với tùy chọn dài cũng bắt buộc với tùy chọn ngắn.
 Dữ liệu nhập chứa tài sản hai hướng xung đột Lỗi trong lời định nghĩa hồ sơ stringprep (chuẩn bị chuỗi) Cờ xung dột với hồ sơ Không cho phép dấu gạch nối (`-') đi trước hay theo sau Dữ liệu nhập chứa mã điểm không được gán cấm Dữ liệu nhập đã chứa tiền tố ACE (`xn--') Dữ liệu nhập không bắt đầu bằng tiền tố ACE (`xn--') Chuyển đổi các chuỗi sang IDN (tên miền đã quốc tế hoá), hoặc đầu vào tiêu chuẩn.
 Dữ liệu nhập không hợp lệ Chuỗi hai hướng dạng sai Thiếu dữ liệu nhập Không tìm thấy miền cấp đầu trong dữ liệu nhập Dữ liệu nhập chứa ký tự khác chữ số/chữ/dấu gạch nối Dữ liệu xuất sẽ quá lớn hay quá nhỏ Dữ liệu xuất sẽ vượt quá sức chứa đệm đã cung cấp Dữ liệu nhập chứa điểm mã hai hướng cấm Dữ liệu nhập chứa điểm mã cấm Lỗi punycode (mã yếu đuối) Chuỗi không tránh nhân lên dưới ToASCII Chuỗi không phải tránh nhân lên dưới sự tiêu chuẩn hoá NFKC Unicode Lỗi chuẩn bị chuỗi Giới hạn kích cỡ chuỗi bị vượt quá Thành công Lỗi dlopen hệ thống Lỗi iconv hệ thống Thử lệnh "%s --help" để xem thêm thông tin.
 Gõ mỗi chuỗi nhập trên một đường riêng, kết thúc bằng ký tự dòng mới.
 Lỗi tiêu chuẩn hoá Unicode (lỗi nội bộ) Lỗi không rõ Hồ sơ lạ Sử dụng: %s [TÙY_CHỌN]... [CHUỖI]...
 không thể chuyển đổi từ %s sang UTF-8 không thể chuyển đổi từ UCS-4 sang UTF-8 không thể chuyển đổi từ UTF-8 sang %s không thể chuyển đổi từ UTF-8 sang UCS-4 không thể tiêu chuẩn hoá kiểu NFKC idna_to_ascii_4z: %s idna_to_unicode_8z4z (TLD): %s idna_to_unicode_8z4z: %s lỗi đầu vào malloc chỉ có thể chỉ ra một trong số các đối số -s, -e, -d, -a, -u hay -n punycode_decode: %s punycode_encode: %s stringprep_profile: %s tld_check_4z (vị trí %lu): %s tld_check_4z: %s 