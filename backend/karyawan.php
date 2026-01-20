<?php
header('Content-Type: application/json');
include "koneksi.php";

$method = $_SERVER['REQUEST_METHOD'];

if ($method == 'GET') {
    $result = $conn->query("SELECT * FROM karyawan");
    $rows = [];
    while ($row = $result->fetch_assoc()) {
        $rows[] = $row;
    }
    echo json_encode($rows);
} elseif ($method == 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $stmt = $conn->prepare("INSERT INTO karyawan (nama, posisi, gaji) VALUES (?, ?, ?)");
    $stmt->bind_param("ssd", $data['nama'], $data['posisi'], $data['gaji']);
    echo json_encode(['success' => $stmt->execute()]);
} elseif ($method == 'PUT') {
    $data = json_decode(file_get_contents('php://input'), true);
    $stmt = $conn->prepare("UPDATE karyawan SET nama=?, posisi=?, gaji=? WHERE id=?");
    $stmt->bind_param("ssdi", $data['nama'], $data['posisi'], $data['gaji'], $data['id']);
    echo json_encode(['success' => $stmt->execute()]);
} elseif ($method == 'DELETE') {
    $id = $_GET['id'];
    $stmt = $conn->prepare("DELETE FROM karyawan WHERE id=?");
    $stmt->bind_param("i", $id);
    echo json_encode(['success' => $stmt->execute()]);
}

$conn->close();
?>
