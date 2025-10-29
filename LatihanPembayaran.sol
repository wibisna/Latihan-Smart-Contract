// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title LatihanPembayaran
 * @dev Contract pembayaran dengan ReentrancyGuard untuk keamanan maksimal
 * @notice Contract ini dilengkapi dengan proteksi terhadap reentrancy attack
 */
contract LatihanPembayaran {
    address public owner;
    bool private locked; // ReentrancyGuard state

    // Events
    event PembayaranDiterima(address indexed dari, uint256 jumlah);
    event Penarikan(address indexed ke, uint256 jumlah);
    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    // Modifiers
    modifier onlyOwner() {
        require(msg.sender == owner, "NOT_OWNER");
        _;
    }

    /**
     * @dev Proteksi terhadap reentrancy attack
     * Mencegah fungsi dipanggil ulang sebelum eksekusi selesai
     */
    modifier nonReentrant() {
        require(!locked, "Reentrancy terdeteksi");
        locked = true;
        _;
        locked = false;
    }

    constructor() {
        owner = msg.sender;
        locked = false;
        emit OwnershipTransferred(address(0), msg.sender);
    }

    /**
     * @dev Menerima pembayaran dari siapa saja
     * @notice Kirim ETH dengan memanggil fungsi ini
     */
    function bayar() external payable {
        require(msg.value > 0, "Jumlah harus > 0");
        emit PembayaranDiterima(msg.sender, msg.value);
    }

    /**
     * @dev Melihat saldo contract
     * @return Saldo dalam Wei
     */
    function getSaldo() external view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Menarik sejumlah ETH ke owner (hanya owner)
     * @param jumlah Jumlah Wei yang akan ditarik
     * @notice Dilindungi dengan nonReentrant modifier
     */
    function tarik(uint256 jumlah) external onlyOwner nonReentrant {
        require(jumlah > 0, "Jumlah harus > 0");
        require(jumlah <= address(this).balance, "Saldo tidak cukup");
        
        // Menggunakan call untuk keamanan dan fleksibilitas
        (bool success, ) = payable(owner).call{value: jumlah}("");
        require(success, "Transfer gagal");
        
        emit Penarikan(owner, jumlah);
    }

    /**
     * @dev Menarik semua saldo ke owner
     * @notice Fungsi emergency untuk withdraw semua ETH
     */
    function tarikSemua() external onlyOwner nonReentrant {
        uint256 saldo = address(this).balance;
        require(saldo > 0, "Tidak ada saldo");
        
        (bool success, ) = payable(owner).call{value: saldo}("");
        require(success, "Transfer gagal");
        
        emit Penarikan(owner, saldo);
    }

    /**
     * @dev Transfer ownership ke address baru
     * @param newOwner Address owner baru
     * @notice Pastikan address baru benar, proses ini tidak bisa diundo
     */
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Owner tidak boleh address 0");
        require(newOwner != owner, "Owner baru sama dengan owner lama");
        
        address oldOwner = owner;
        owner = newOwner;
        
        emit OwnershipTransferred(oldOwner, newOwner);
    }

    /**
     * @dev Renounce ownership (hapus owner selamanya)
     * @notice HATI-HATI! Setelah ini, tidak ada yang bisa tarik dana
     */
    function renounceOwnership() external onlyOwner {
        address oldOwner = owner;
        owner = address(0);
        
        emit OwnershipTransferred(oldOwner, address(0));
    }

    /**
     * @dev Menerima ETH langsung tanpa memanggil fungsi
     * @notice Anda bisa kirim ETH langsung ke contract address
     */
    receive() external payable {
        emit PembayaranDiterima(msg.sender, msg.value);
    }

    /**
     * @dev Fallback function jika ada data yang dikirim
     */
    fallback() external payable {
        emit PembayaranDiterima(msg.sender, msg.value);
    }
}