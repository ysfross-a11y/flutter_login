<?php
header("Content-Type: application/json");
include "koneksi.php";

// Ambil JSON dari Flutter
$raw = file_get_contents("php://input");
$data = json_decode($raw, true);

$username = $data['username'] ?? '';
$password = $data['password'] ?? '';

if ($username == '' || $password == '') {
    echo json_encode([
        "success" => false,
        "message" => "Username atau password kosong"
    ]);
    exit;
}

// DEBUG (hapus setelah berhasil)
// file_put_contents("log.txt", $raw);

$stmt = $conn->prepare(
    "SELECT * FROM admin WHERE username = ? AND password = ?"
);
$stmt->bind_param("ss", $username, $password);
$stmt->execute();
$result = $stmt->get_result();

if ($result->num_rows > 0) {
    echo json_encode([
        "success" => true,
        "message" => "Login berhasil"
    ]);
} else {
    echo json_encode([
        "success" => false,
        "message" => "Username atau password salah"
    ]);
}

$stmt->close();
$conn->close();
