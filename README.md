
# Smart Contract: Latihan Pembayaran

Smart contract sederhana untuk latihan pembayaran menggunakan Solidity dengan fitur keamanan ReentrancyGuard.

## 🎯 Fitur

- ✅ Menerima pembayaran dari siapa saja
- ✅ Owner dapat menarik dana
- ✅ Transfer ownership
- ✅ ReentrancyGuard protection
- ✅ Receive ETH langsung ke contract
- ✅ Event logging untuk tracking

## 🛠️ Tech Stack

- **Solidity**: ^0.8.0
- **Development**: Remix IDE
- **Testing**: Ganache + MetaMask
- **Security**: ReentrancyGuard pattern

## 📋 Prerequisites

- MetaMask browser extension
- Ganache (untuk local testing)
- Node.js (opsional, untuk Hardhat)

## 🚀 Deployment

### Remix IDE

1. Buka [Remix IDE](https://remix.ethereum.org)
2. Upload file `contracts/LatihanPembayaran.sol`
3. Compile dengan Solidity compiler ^0.8.0
4. Deploy via "Deploy & Run Transactions"
5. Select "Injected Provider - MetaMask"
6. Connect ke Ganache network
7. Klik "Deploy"

### Hardhat (Opsional)

```bash
npm install
npx hardhat compile
npx hardhat run scripts/deploy.js --network ganache
```

## 📖 Cara Menggunakan

### 1. Kirim Pembayaran

```javascript
// Panggil fungsi bayar() dengan value > 0
contract.bayar({ value: ethers.utils.parseEther("1.0") })
```

### 2. Cek Saldo

```javascript
const saldo = await contract.getSaldo();
console.log("Saldo:", ethers.utils.formatEther(saldo), "ETH");
```

### 3. Tarik Dana (Owner Only)

```javascript
// Tarik 0.5 ETH
await contract.tarik(ethers.utils.parseEther("0.5"));
```

### 4. Tarik Semua Saldo

```javascript
await contract.tarikSemua();
```

## 🔐 Security Features

- **ReentrancyGuard**: Proteksi terhadap reentrancy attack
- **Access Control**: Fungsi withdrawal hanya bisa dipanggil owner
- **Safe Transfer**: Menggunakan `call{}` alih-alih `transfer()`
- **Input Validation**: Semua input divalidasi sebelum eksekusi
- **Event Logging**: Semua transaksi penting emit event

## 🧪 Testing

### Manual Testing (Remix)

1. Deploy contract
2. Kirim ETH dengan fungsi `bayar()`
3. Cek saldo dengan `getSaldo()`
4. Test withdrawal dengan `tarik()`
5. Test dengan multiple accounts

### Unit Testing (Hardhat)

```bash
npx hardhat test
```

## 📊 Contract Functions

| Function | Visibility | Description |
|----------|-----------|-------------|
| `bayar()` | external payable | Menerima pembayaran |
| `getSaldo()` | external view | Lihat saldo contract |
| `tarik(uint256)` | external (owner) | Tarik sejumlah ETH |
| `tarikSemua()` | external (owner) | Tarik semua saldo |
| `transferOwnership(address)` | external (owner) | Transfer ownership |
| `renounceOwnership()` | external (owner) | Hapus ownership |

## 📈 Gas Costs (Estimate)

| Function | Gas Cost |
|----------|----------|
| Deploy | ~380,000 |
| bayar() | ~50,000 |
| tarik() | ~38,000 |
| tarikSemua() | ~38,000 |

## ⚠️ Known Limitations

- Contract tidak mendukung ERC20 tokens (hanya ETH)
- Tidak ada batasan minimum/maksimum pembayaran
- Tidak ada time-lock untuk withdrawal

## 🤝 Contributing

Contributions are welcome! Please:

1. Fork repository
2. Create feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'Add AmazingFeature'`)
4. Push to branch (`git push origin feature/AmazingFeature`)
5. Open Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 👨‍💻 Author

**Your Name**
- GitHub: [@yourusername](https://github.com/yourusername)

## 🙏 Acknowledgments

- OpenZeppelin for security best practices
- Remix IDE team
- Ethereum community

## 📞 Contact

For questions or suggestions, please open an issue or contact [your@email.com](mailto:your@email.com)

---

⭐ Star this repo if you find it helpful!
