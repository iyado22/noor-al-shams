<?php
header("Content-Type: application/json");
include(__DIR__ . "/../../includes/conf.php");

$stmt = null;

try {
    // Check if database connection exists
    if (!isset($conn) || $conn->connect_error) {
        throw new Exception("Database connection failed");
    }

    $sql = "SELECT message FROM announcements WHERE is_active = 1 ORDER BY created_at DESC LIMIT 5";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        throw new Exception("Failed to prepare SQL statement: " . $conn->error);
    }

    if (!$stmt->execute()) {
        throw new Exception("SQL execution error: " . $stmt->error);
    }

    $result = $stmt->get_result();
    $announcements = [];

    while ($row = $result->fetch_assoc()) {
        $announcements[] = $row;
    }

    echo json_encode([
        "status" => "success",
        "data" => $announcements
    ]);
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => $e->getMessage()
    ]);
} finally {
    // Safe cleanup
    if ($stmt && !$stmt->close()) {
        error_log("Failed to close statement");
    }
    if (isset($conn) && !$conn->close()) {
        error_log("Failed to close connection");
    }
}
?>