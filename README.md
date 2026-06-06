<div align="center">
  <img src="https://github.com/user-attachments/assets/426cf5be-090b-450c-a16f-9982762a1095" alt="Yayasan Amaras Logo" width="200">

  # Situs Web Yayasan Amaras
  
  **Platform Digital Interaktif untuk Berbagi Kebaikan dan Pelayanan Sosial**

  *Proyek Tugas Besar Pemrograman Berorientasi Objek (CAK2KAB4)*  
  *Fakultas Informatika, Universitas Telkom (2025)*
</div>

---

## 📖 Latar Belakang

Yayasan Amaras adalah sebuah lembaga sosial yang aktif melayani masyarakat melalui tiga kegiatan utama: Posyandu, Kelompok Belajar Masyarakat (KBM), dan Sekolah Lansia. 

Untuk menjangkau masyarakat yang lebih luas, kami membangun website interaktif ini agar informasi, interaksi, dan proses donasi dapat dilakukan dengan mudah, cepat, dan terstruktur. Melalui platform digital ini, kami berharap dapat meningkatkan transparansi donasi serta profesionalisme yayasan.

---

## ✨ Fitur Utama

Website ini dilengkapi dengan berbagai fitur fungsional yang siap memudahkan donatur maupun admin:

* **Login & Register:** Memungkinkan pengguna (Donatur atau Admin) untuk membuat akun dan masuk ke dalam sistem menggunakan identitas yang valid.
* **Profil Yayasan:** Menampilkan informasi terkini mengenai visi, misi, dan kegiatan yayasan yang dikelola dan diperbarui langsung oleh Admin.
* **Profil Donatur:** Halaman khusus bagi donatur yang sudah registrasi untuk melihat informasi akunnya.
* **Formulir Donasi:** Fasilitas praktis bagi donatur untuk menyalurkan dana dengan pilihan metode Transfer Bank atau E-Wallet.
* **Riwayat & Cetak Donasi:** Fitur transparansi untuk melihat dan mencetak seluruh data histori transaksi donasi yang telah dilakukan.
* **Komentar:** Wadah interaksi di mana donatur yang telah berdonasi dapat memberikan dukungan moral atau saran, yang akan dipantau oleh Admin.
* **Total Donasi Real-Time:** Menampilkan akumulasi jumlah donasi secara otomatis di halaman utama setiap kali ada donasi yang masuk.
* **FAQ / Help Center:** Tombol bantuan yang akan mengarahkan pengguna secara langsung ke WhatsApp Admin yayasan.

---

## 💻 Penerapan OOP (Object-Oriented Programming)

Proyek ini dirancang dengan mengintegrasikan konsep OOP untuk struktur kode yang rapi dan optimal:

* **Encapsulation:** Penggunaan *identifier private* pada berbagai atribut kelas, seperti atribut nama, email, dan password pada kelas User.
* **Inheritance:** Kelas Donatur dan Admin merupakan pewarisan (spesialisasi) dari kelas dasar User. Kelas TransferBank dan EWallet juga mewarisi dari kelas TransaksiDonasi.
* **Interface:** Implementasi interface `Pembayaran` yang digunakan pada sistem proses transaksi donasi.
* **Association & Composition:** Relasi terstruktur antar komponen, seperti relasi *One-to-One* antara Admin dan Profile Yayasan. Serta relasi komposisi pada RiwayatDonasi yang memanfaatkan data Donatur.

---
<div align="center">

## 👥 Tim SUNDALLDI

Proyek ini dikembangkan oleh **Kelompok 6 (IF-47-04)**:

| Nama | NIM | Tugas / Tanggung Jawab |
| :--- | :--- | :--- |
| Muhammad Akbar Putra Pahlawan | 103012330227 | Login & Register |
| Galuh Ambar Setiana | 103012300182 | Profil, Riwayat, & Cetak Donasi |
| Alicia Mazza | 103012330089 | Profile Yayasan Amaras |
| Alexandra Yohana Daris Naibaho | 103012330136 | Form Donasi |
| Gloriana Valdrina Sanampe | 103012300396 | Komentar & Fitur FAQ |
| Nabilah Putri Desky | 103012300343 | Fitur Jumlah Donasi |

**© 2025 SUNDALLDI**

</div>
