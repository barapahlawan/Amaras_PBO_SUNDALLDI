<%-- 
    Document   : Donasi
    Created on : 22 May 2025, 12.57.12
    Author     : ACER
--%>

<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="id">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Yayasan Amaras - Donasi</title>
    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        
        body {
            background: white;
            color: #333;
            min-height: 100vh;
        }
        
        .header {
            background: linear-gradient(to right, #1a56a2, #4285f4);
            color: white;
            padding: 15px 20px;
            display: flex;
            justify-content: space-between;
            align-items: center;
            box-shadow: 0 2px 10px rgba(0,0,0,0.1);
            position: relative;
            z-index: 100;
        }
        
        .logo-container {
            display: flex;
            align-items: center;
        }
        
        .logo {
            width: 40px;
            height: 40px;
            margin-right: 15px;
            background: white;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: #4fc3f7;
            font-weight: bold;
        }
        
        .title {
            font-size: 24px;
            font-weight: bold;
        }
        
        .logo-text h1 {
            font-size: 1.5rem;
            font-weight: bold;
            margin-bottom: 0;
        }

        .logo-text h2 {
            font-size: 1rem;
            font-weight: normal;
        }
        
        .nav {
            display: flex;
            gap: 20px;
        }
        
        .nav-link {
            color: white;
            text-decoration: none;
            padding: 8px 16px;
            border-radius: 20px;
            transition: background 0.3s ease;
            position: relative;
            z-index: 101;
        }
        
        .nav-link:hover {
            background: rgba(255,255,255,0.2);
        }
        
        .container {
            max-width: 1300px;
            margin: 30px auto;
            padding: 0 20px;
            position: relative;
            z-index: 10;
        }
        
          .background-image {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            opacity: 0.1;
            z-index: -1;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .background-decorations {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            z-index: 1;
            pointer-events: none;
            overflow: hidden;
        }
        
        .background-decorations::before {
            content: '';
            position: absolute;
            top: 20%;
            right: 10%;
            width: 200px;
            height: 200px;
            background: rgba(255,255,255,0.1);
            border-radius: 50%;
            transform: rotate(45deg);
        }
        
        .background-decorations::after {
            content: '';
            position: absolute;
            bottom: 20%;
            left: 5%;
            width: 150px;
            height: 150px;
            background: rgba(255,255,255,0.08);
            border-radius: 30% 70% 70% 30% / 30% 30% 70% 70%;
        }
        
        .main-card {
            background: rgba(255,255,255,0.95);
            border-radius: 20px;
            padding: 40px 30px;
            box-shadow: 0 20px 40px rgba(0,0,0,0.1);
            backdrop-filter: blur(10px);
            border: 1px solid rgba(255,255,255,0.2);
            position: relative;
            z-index: 10;
        }
        
        .main-title {
            text-align: center;
            color: #1976d2;
            font-size: 36px;
            font-weight: bold;
            margin-bottom: 10px;
        }
        
        .subtitle {
            text-align: center;
            margin-bottom: 40px;
            color: #666;
            font-size: 16px;
        }
        
        .section-title {
            text-align: center;
            margin: 30px 0 20px;
            color: #1976d2;
            font-weight: bold;
            font-size: 18px;
        }
        
        .donation-options {
            display: grid;
            grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
            gap: 15px;
            margin-bottom: 20px;
        }
        
        .donation-button {
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            padding: 15px 10px;
            text-align: center;
            cursor: pointer;
            transition: all 0.3s ease;
            font-weight: 600;
            color: #1976d2;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
            z-index: 20;
            user-select: none;
        }
        
        .donation-button:hover {
            border-color: #1976d2;
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.2);
            transform: translateY(-3px);
        }
        
        .donation-button.active {
            background: linear-gradient(135deg, #4fc3f7, #29b6f6);
            color: white;
            border-color: #1976d2;
            box-shadow: 0 8px 25px rgba(79, 195, 247, 0.4);
        }
        
        .custom-amount {
            margin: 20px 0 40px;
            width: 100%;
            position: relative;
            z-index: 20;
        }
        
        .custom-input {
            display: flex;
            align-items: center;
            background: white;
            border: 2px solid #e0e0e0;
            border-radius: 15px;
            padding: 0 20px;
            width: 100%;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            transition: all 0.3s ease;
        }
        
        .custom-input:focus-within {
            border-color: #1976d2;
            box-shadow: 0 4px 15px rgba(25, 118, 210, 0.2);
        }
        
        .currency {
            font-weight: bold;
            color: #1976d2;
        }
        
        .amount-input {
            border: none;
            padding: 15px 10px;
            font-size: 16px;
            flex-grow: 1;
            outline: none;
            background: transparent;
        }
        
        .payment-section-title {
            text-align: center;
            margin: 30px 0 20px;
            color: #1976d2;
            font-weight: bold;
            font-size: 18px;
        }
        
        .payment-section {
            margin-bottom: 30px;
            position: relative;
            z-index: 20;
        }
        
        .section-header {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
            padding: 15px 20px;
            background: linear-gradient(135deg, #f8f9ff, #e8f4fd);
            border-radius: 12px;
            color: #1976d2;
            font-weight: 600;
            border: 1px solid rgba(25, 118, 210, 0.1);
        }
        
        .section-icon {
            width: 24px;
            height: 24px;
            margin-right: 10px;
            background: #1976d2;
            border-radius: 6px;
            display: flex;
            align-items: center;
            justify-content: center;
            color: white;
            font-size: 14px;
        }
        
        /* Transfer Bank - Vertical */
        .bank-options-horizontal {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .bank-option {
            display: flex;
            align-items: center;
            padding: 18px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
            z-index: 30;
            user-select: none;
        }
        
        .bank-option:hover {
            border-color: #1976d2;
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.2);
            transform: translateY(-2px);
        }
        
        .bank-option.selected {
            border-color: #1976d2;
            background: linear-gradient(135deg, #e3f2fd, #f3e5f5);
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.3);
        }
        
        .bank-option input[type="radio"] {
            width: 20px;
            height: 20px;
            margin-right: 15px;
            accent-color: #1976d2;
        }
        
        .bank-logo {
            width: 45px;
            height: 45px;
            margin-right: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: white;
            font-size: 12px;
        }
        
        .bank-info {
            display: flex;
            flex-direction: column;
        }
        
        .bank-name {
            font-weight: 600;
            color: #333;
            font-size: 16px;
            margin-bottom: 4px;
        }
        
        .bank-account {
            font-size: 13px;
            color: #666;
            background: rgba(0,0,0,0.05);
            padding: 3px 8px;
            border-radius: 6px;
            display: inline-block;
            font-weight: 500;
        }
        
        /* E-Wallet - Vertical */
        .ewallet-options {
            display: flex;
            flex-direction: column;
            gap: 12px;
        }
        
        .ewallet-option {
            display: flex;
            align-items: center;
            padding: 18px 20px;
            border: 2px solid #e0e0e0;
            border-radius: 12px;
            cursor: pointer;
            transition: all 0.3s ease;
            background: white;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            position: relative;
            z-index: 30;
            user-select: none;
        }
        
        .ewallet-option:hover {
            border-color: #1976d2;
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.2);
            transform: translateY(-2px);
        }
        
        .ewallet-option.selected {
            border-color: #1976d2;
            background: linear-gradient(135deg, #e3f2fd, #f3e5f5);
            box-shadow: 0 8px 25px rgba(25, 118, 210, 0.3);
        }
        
        .ewallet-option input[type="radio"] {
            width: 20px;
            height: 20px;
            margin-right: 15px;
            accent-color: #1976d2;
        }
        
        .ewallet-logo {
            width: 45px;
            height: 45px;
            margin-right: 15px;
            border-radius: 8px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-weight: bold;
            color: white;
            font-size: 12px;
        }
        
        .ewallet-info {
            display: flex;
            flex-direction: column;
        }
        
        .ewallet-name {
            font-weight: 600;
            color: #333;
            font-size: 16px;
            margin-bottom: 4px;
        }
        
        .ewallet-number {
            font-size: 14px;
            color: #666;
            background: rgba(0,0,0,0.05);
            padding: 4px 10px;
            border-radius: 6px;
            display: inline-block;
            font-weight: 600;
            letter-spacing: 0.5px;
        }
        
        /* Bank Colors */
        .bca { background: linear-gradient(135deg, #1e88e5, #1565c0); }
        .mandiri { background: linear-gradient(135deg, #ffa726, #ff9800); }
        .bni { background: linear-gradient(135deg, #ff7043, #ff5722); }
        .gopay { background: linear-gradient(135deg, #00c853, #4caf50); }
        .ovo { background: linear-gradient(135deg, #673ab7, #9c27b0); }
        .dana { background: linear-gradient(135deg, #2196f3, #1976d2); }
        
        .submit-button {
            width: 100%;
            background: linear-gradient(135deg, #1a56a2, #4285f4);
            color: white;
            border: none;
            border-radius: 15px;
            padding: 20px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
            margin-top: 30px;
            display: flex;
            align-items: center;
            justify-content: center;
            gap: 10px;
            transition: all 0.3s ease;
            box-shadow: 0 8px 25px rgba(79, 195, 247, 0.3);
            position: relative;
            z-index: 20;
            user-select: none;
        }
        
        .submit-button:hover {
            background: linear-gradient(135deg, #29b6f6, #1976d2);
            box-shadow: 0 12px 35px rgba(79, 195, 247, 0.4);
            transform: translateY(-3px);
        }
        
        .submit-button:active {
            transform: translateY(-1px);
            box-shadow: 0 6px 20px rgba(79, 195, 247, 0.3);
        }
        
        .arrow-icon {
            font-size: 20px;
            font-weight: bold;
            transition: transform 0.3s ease;
        }
        
        .submit-button:hover .arrow-icon {
            transform: translateX(5px);
        }
        
        /* Responsive Design */
        @media (max-width: 768px) {
            .container {
                margin: 20px auto;
                padding: 0 15px;
            }
            
            .main-card {
                padding: 30px 20px;
                border-radius: 15px;
            }
            
            .donation-options {
                grid-template-columns: repeat(2, 1fr);
            }
            
            .main-title {
                font-size: 28px;
            }
            
            .bank-options-horizontal {
                gap: 10px;
            }
        }
    </style>
</head>
<body>
    <div class="background-decorations"></div>
    
    <div class="header">
        <div class="logo-container">
             <img src="logo.png" alt="Yayasan Amaras Logo" height="50" style="border-radius: 8px;">
             <div class="logo-text">
                <h1>YAYASAN AMARAS</h1>
                <h2>HARAPAN BANGSA</h2>
            </div>
             
        </div>
        <div class="nav">
            <a href="dashboard.jsp" class="nav-link">Beranda</a>
            <a href="index.jsp" class="nav-link">Keluar</a>
        </div>
    </div>
    
    <div class="container">

        <div class="main-card">
            <div class="background-image">
            <img src="logo.png" alt="Yayasan Amaras Logo" height="400">
            </div>
            <h1 class="main-title">Mari Berdonasi!</h1>
            <p class="subtitle">Isi form di bawah ini untuk memberikan donasi kepada Yayasan Amaras</p>
            
            <div class="section-title">Pilih Jumlah Donasi</div>
            <div class="donation-options">
                <div class="donation-button" onclick="selectDonation(this, 50000)">Rp. 50.000</div>
                <div class="donation-button" onclick="selectDonation(this, 100000)">Rp. 100.000</div>
                <div class="donation-button" onclick="selectDonation(this, 200000)">Rp. 200.000</div>
                <div class="donation-button" onclick="selectDonation(this, 500000)">Rp. 500.000</div>
                <div class="donation-button" onclick="selectDonation(this, 1000000)">Rp. 1.000.000</div>
                <div class="donation-button" onclick="selectDonation(this, 'custom')">Jumlah Lain</div>
            </div>
            
            <div class="custom-amount">
                <div class="custom-input">
                    <span class="currency">Rp.</span>
                    <input type="number" placeholder="Masukkan jumlah donasi" class="amount-input" id="customAmount" min="1000"/>
                </div>
            </div>
            
            <div class="payment-section-title">Pilih Metode Pembayaran</div>
            
            <!-- Transfer Bank Section -->
            <div class="payment-section">
                <div class="section-header">
                    <div class="section-icon">🏦</div>
                    Transfer Bank
                </div>
                
                <div class="bank-options-horizontal">
                    <div class="bank-option" onclick="selectPayment('bca', this)">
                        <input type="radio" id="bca" name="payment" value="bca">
                        <div class="bank-logo bca">BCA</div>
                        <div class="bank-info">
                            <div class="bank-name">Bank Central Asia</div>
                            <div class="bank-account">VA: 1234567890</div>
                        </div>
                    </div>
                    
                    <div class="bank-option" onclick="selectPayment('mandiri', this)">
                        <input type="radio" id="mandiri" name="payment" value="mandiri">
                        <div class="bank-logo mandiri">MDR</div>
                        <div class="bank-info">
                            <div class="bank-name">Bank Mandiri</div>
                            <div class="bank-account">VA: 9876543210</div>
                        </div>
                    </div>
                    
                    <div class="bank-option" onclick="selectPayment('bni', this)">
                        <input type="radio" id="bni" name="payment" value="bni">
                        <div class="bank-logo bni">BNI</div>
                        <div class="bank-info">
                            <div class="bank-name">Bank Negara Indonesia</div>
                            <div class="bank-account">VA: 5432109876</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <!-- E-Wallet Section -->
            <div class="payment-section">
                <div class="section-header">
                    <div class="section-icon">💳</div>
                    E-Wallet
                </div>
                
                <div class="ewallet-options">
                    <div class="ewallet-option" onclick="selectPayment('gopay', this)">
                        <input type="radio" id="gopay" name="payment" value="gopay">
                        <div class="ewallet-logo gopay">GP</div>
                        <div class="ewallet-info">
                            <div class="ewallet-name">GoPay</div>
                            <div class="ewallet-number">+62 812-3456-7890</div>
                        </div>
                    </div>
                    
                    <div class="ewallet-option" onclick="selectPayment('ovo', this)">
                        <input type="radio" id="ovo" name="payment" value="ovo">
                        <div class="ewallet-logo ovo">OVO</div>
                        <div class="ewallet-info">
                            <div class="ewallet-name">OVO</div>
                            <div class="ewallet-number">+62 813-9876-5432</div>
                        </div>
                    </div>
                    
                    <div class="ewallet-option" onclick="selectPayment('dana', this)">
                        <input type="radio" id="dana" name="payment" value="dana">
                        <div class="ewallet-logo dana">DANA</div>
                        <div class="ewallet-info">
                            <div class="ewallet-name">DANA</div>
                            <div class="ewallet-number">+62 814-5678-1234</div>
                        </div>
                    </div>
                </div>
            </div>
            
            <button class="submit-button" onclick="processDonation()">
                <span>Proses Donasi</span>
                <span class="arrow-icon">→</span>
            </button>
        </div>
    </div>
    
    <form id="donationForm" action="donasiServlet" method="POST" style="display:none;">
        <input type="hidden" id="jumlah_donasi" name="jumlah_donasi">
        <input type="hidden" id="metode_pembayaran" name="metode_pembayaran">
    </form>

    <script>
        // Global variables to track selections
        let selectedPayment = null;
        let selectedAmount = null;

        // Payment method names mapping
        const paymentNames = {
            'bca': 'Bank Central Asia (BCA)',
            'mandiri': 'Bank Mandiri',
            'bni': 'Bank Negara Indonesia (BNI)',
            'gopay': 'GoPay',
            'ovo': 'OVO',
            'dana': 'DANA'
        };
        
        // Function to select donation amount
        function selectDonation(element, amount) {
            try {
                // Remove active class from all donation buttons
                document.querySelectorAll('.donation-button').forEach(btn => {
                    btn.classList.remove('active');
                });
                
                // Add active class to selected button
                element.classList.add('active');
                selectedAmount = amount;
                
                // Update input field
                const customInput = document.getElementById('customAmount');
                if (amount !== 'custom') {
                    customInput.value = amount;
                } else {
                    customInput.value = '';
                    customInput.focus();
                }
                
                console.log('Selected amount:', selectedAmount);
            } catch (error) {
                console.error('Error in selectDonation:', error);
            }
        }
        
        // Function to select payment method
        function selectPayment(paymentMethod, element) {
            try {
                // Remove selection from all payment options
                document.querySelectorAll('.bank-option, .ewallet-option').forEach(option => {
                    option.classList.remove('selected');
                });
                
                // Add selection to clicked option
                const radioElement = document.getElementById(paymentMethod);
                if (radioElement) {
                    radioElement.checked = true;
                }
                element.classList.add('selected');
                selectedPayment = paymentMethod;
                
                console.log('Selected payment:', selectedPayment);
            } catch (error) {
                console.error('Error in selectPayment:', error);
            }
        }

        // Function to process donation
       function processDonation() {
    try {
        const amountInput = document.getElementById('customAmount');

        // Pastikan kalau klik preset tapi input belum keisi, kita isi secara manual
        if (!amountInput.value || parseInt(amountInput.value) === 0) {
            // Cek tombol yang aktif
            const activeButton = document.querySelector('.donation-button.active');
            if (activeButton) {
                const valueText = activeButton.textContent.replace(/[^\d]/g, '');
                amountInput.value = parseInt(valueText);
            }
        }

        const amount = parseInt(amountInput.value) || 0;

        if (!amount || amount <= 0) {
            alert('❌ Silakan masukkan jumlah donasi yang valid!');
            amountInput.focus();
            return;
        }

        if (amount < 1000) {
            alert('❌ Jumlah donasi minimal Rp. 1.000');
            amountInput.focus();
            return;
        }

        const checkedRadio = document.querySelector('input[name="payment"]:checked');
        const paymentMethod = checkedRadio ? checkedRadio.value : null;

        if (!paymentMethod) {
            alert('❌ Silakan pilih metode pembayaran!');
            return;
        }

        const formatter = new Intl.NumberFormat('id-ID');
        const formattedAmount = formatter.format(amount);

        const paymentNames = {
            'bca': 'Bank Central Asia (BCA)',
            'mandiri': 'Bank Mandiri',
            'bni': 'Bank Negara Indonesia (BNI)',
            'gopay': 'GoPay',
            'ovo': 'OVO',
            'dana': 'DANA'
        };
        const paymentName = paymentNames[paymentMethod] || paymentMethod;

        const confirmMessage = `🎉 KONFIRMASI DONASI\n\n` +
            `Apakah Anda yakin ingin melanjutkan?`;

        if (confirm(confirmMessage)) {
            document.getElementById('jumlah_donasi').value = amount;
            document.getElementById('metode_pembayaran').value = paymentMethod;
            document.getElementById('donationForm').submit();
        }

    } catch (error) {
        console.error('Error in processDonation:', error);
        alert('❌ Terjadi kesalahan. Silakan coba lagi.');
    }
}

        // Function to reset form
        function resetForm() {
            try {
                // Reset all selections
                document.querySelectorAll('.donation-button').forEach(btn => {
                    btn.classList.remove('active');
                });
                
                document.querySelectorAll('.bank-option, .ewallet-option').forEach(option => {
                    option.classList.remove('selected');
                });
                
                document.querySelectorAll('input[type="radio"]').forEach(radio => {
                    radio.checked = false;
                });
                
                document.getElementById('customAmount').value = '';
                
                selectedPayment = null;
                selectedAmount = null;
                
                console.log('Form reset successfully');
            } catch (error) {
                console.error('Error in resetForm:', error);
            }
        }
        
        // Handle custom input changes
        document.addEventListener('DOMContentLoaded', function() {
            const customAmountInput = document.getElementById('customAmount');
            
            // Handle custom input
            customAmountInput.addEventListener('input', function() {
                if (this.value) {
                    // Remove active class from preset buttons when typing custom amount
                    document.querySelectorAll('.donation-button').forEach(btn => {
                        btn.classList.remove('active');
                    });
                    selectedAmount = 'custom';
                    console.log('Custom amount entered:', this.value);
                }
            });
            
            // Format and validate input on blur
            customAmountInput.addEventListener('blur', function() {
                if (this.value) {
                    const number = parseInt(this.value.replace(/\D/g, ''));
                    if (!isNaN(number) && number > 0) {
                        this.value = number;
                    }
                }
            });
            
            // Prevent negative numbers and non-numeric input
            customAmountInput.addEventListener('keydown', function(e) {
                // Allow: backspace, delete, tab, escape, enter
                if ([46, 8, 9, 27, 13].indexOf(e.keyCode) !== -1 ||
                    // Allow: Ctrl+A, Ctrl+C, Ctrl+V, Ctrl+X
                    (e.keyCode === 65 && e.ctrlKey === true) ||
                    (e.keyCode === 67 && e.ctrlKey === true) ||
                    (e.keyCode === 86 && e.ctrlKey === true) ||
                    (e.keyCode === 88 && e.ctrlKey === true)) {
                    return;
                }
                // Ensure that it's a number and stop the keypress
                if ((e.shiftKey || (e.keyCode < 48 || e.keyCode > 57)) && (e.keyCode < 96 || e.keyCode > 105)) {
                    e.preventDefault();
                }
            });
        });

        console.log('Donation page JavaScript loaded successfully');
    </script>
</body>
</html>