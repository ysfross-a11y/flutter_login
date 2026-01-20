<?php
$host = "localhost";
$user = "root";
$password = "";
$dbname = "company_db";

$conn = new mysqli($host, $user, $password, $dbname);

if ($conn->connect_error) {
    die(json_encode(['error' => 'Connection failed: '.$conn->connect_error]));
}
?>
