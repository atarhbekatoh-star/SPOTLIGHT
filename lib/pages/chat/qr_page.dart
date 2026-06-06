import 'package:flutter/material.dart';

class QRPage extends StatefulWidget {
  const QRPage({super.key});

  @override
  State<QRPage> createState() => _QRPageState();
}

class _QRPageState extends State<QRPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isScanning = false;
  bool _scanned = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _startMockScan() {
    setState(() {
      _isScanning = true;
      _scanned = false;
    });
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          _isScanning = false;
          _scanned = true;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0D0D0F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF16161A),
        title: const Text('QR Code', style: TextStyle(color: Colors.white)),
        iconTheme: const IconThemeData(color: Colors.white),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: const Color(0xFFBB86FC),
          labelColor: const Color(0xFFBB86FC),
          unselectedLabelColor: Colors.white54,
          tabs: const [
            Tab(text: "My QR"),
            Tab(text: "Scan QR"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildMyQR(),
          _buildScanQR(),
        ],
      ),
    );
  }

  Widget _buildMyQR() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "Scan to add me!",
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.qr_code_2,
              size: 200,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 30),
          const Text(
            "@sandra_user",
            style: TextStyle(
              color: Color(0xFFBB86FC),
              fontSize: 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScanQR() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (!_scanned) ...[
            Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                border: Border.all(
                  color: _isScanning ? const Color(0xFFEFFF8A) : const Color(0xFFBB86FC),
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: _isScanning
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFFEFFF8A),
                      ),
                    )
                  : const Center(
                      child: Text(
                        "Align QR Code within frame",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.white70),
                      ),
                    ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: _isScanning ? null : _startMockScan,
              icon: const Icon(Icons.camera_alt),
              label: const Text("Tap to Scan"),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFBB86FC),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
            ),
          ] else ...[
            const Icon(Icons.check_circle, color: Color(0xFFEFFF8A), size: 80),
            const SizedBox(height: 20),
            const Text(
              "Found User!",
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const ListTile(
              leading: CircleAvatar(
                backgroundColor: Color(0xFFBB86FC),
                child: Icon(Icons.person, color: Colors.white),
              ),
              title: Text("Alex Doe", style: TextStyle(color: Colors.white)),
              subtitle: Text("@alexdoe", style: TextStyle(color: Colors.white70)),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _scanned = false;
                });
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF16161A),
                foregroundColor: Colors.white,
              ),
              child: const Text("Scan Another"),
            ),
          ]
        ],
      ),
    );
  }
}
