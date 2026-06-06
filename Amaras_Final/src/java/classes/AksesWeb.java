package classes;

public class AksesWeb {
    private String fullname;
    private String email;
    private String password;
    private String confirmPassword;
    
    public AksesWeb(String email, String password) {
        this.email = email;
        this.password = password;
    }
    
    public AksesWeb(String fullname, String email, String password, String confirmPassword) {
        this.fullname = fullname;
        this.email = email;
        this.password = password;
        this.confirmPassword = confirmPassword;
    }

    public String getFullname() {
        return fullname;
    }

    public void setFullname(String fullname) {
        this.fullname = fullname;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getEmail() {
        return email;
    }    
    
    public void setPassword(String password) {
        this.password = password;
    }

    public String getPassword() {
        return password;
    }
    
    public String login() {
        String status = "Login berhasil";
        try {
            JDBC db = new JDBC();
            
            // Cek email
            String cekEmailQuery = "SELECT email FROM pengguna WHERE email = ?";
            String cekEmail = db.getData(cekEmailQuery, "email", email);
            
            if (cekEmail == null) {
                status = "Email salah";
                return status;
            }
            
            // Cek password berdasarkan email
            String cekPasswordQuery = "SELECT password FROM pengguna WHERE email = ?";
            String cekPassword = db.getData(cekPasswordQuery, "password", email);
            
            // Cek apakah password sama
            if (cekPassword == null || !cekPassword.trim().equals(password.trim())) {
                status = "Password salah";
                return status;
            }
            
            // Jika user admin (contoh email admin)
            if ("admin@admin.com".equalsIgnoreCase(email.trim())) {
                status = "admin";
            } else {
                status = "Login berhasil";
            }
            
        } catch(Exception e){
            status = "Terjadi kesalahan sistem";
            e.printStackTrace();
        }
        return status;  
    }

    public String register() {
        String statusR = "Register berhasil";
        try {
            JDBC db = new JDBC();
            
            if (email == null || email.trim().isEmpty()) {
                return "Email tidak boleh kosong";
            }
            if (password == null || password.trim().isEmpty()) {
                return "Password tidak boleh kosong";
            }
            if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
                return "Konfirmasi password tidak boleh kosong";
            }
            
            String cekEmailQuery = "SELECT email FROM pengguna WHERE email = ?";
            String cekEmail = db.getData(cekEmailQuery, "email", email);
            
            if (cekEmail != null) {
                return "Email sudah terdaftar";
            }
            
            if (!password.equals(confirmPassword)) {
                return "Password dan konfirmasi password tidak sama";
            }
            
            String insertQuery = "INSERT INTO pengguna (fullname, email, password) VALUES (?, ?, ?)";
            boolean berhasil = db.runQuery(insertQuery, fullname, email, password);
            
            if (!berhasil) {
                statusR = "Gagal menyimpan data ke database";
            }
            
        } catch (Exception e) {
            statusR = "Terjadi kesalahan sistem: " + e.getMessage();
            e.printStackTrace();
        }
        return statusR;
    }
    public static void main(String[] args) {
    // Coba register user baru
    AksesWeb user = new AksesWeb("Bara Pahlawan", "bara@example.com", "123456", "123456");
    System.out.println("Register: " + user.register());
    
    // Coba login user yang sudah didaftarkan
    AksesWeb loginUser = new AksesWeb("bara@example.com", "123456");
    System.out.println("Login: " + loginUser.login());
}
}


