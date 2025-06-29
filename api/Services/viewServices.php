<?php
include(__DIR__ . '/../../includes/conf.php');
header("Content-Type: application/json");

$stmt = null;

try {
    // Check if database connection exists
    if (!isset($conn) || $conn->connect_error) {
        throw new Exception("Database connection failed");
    }

    $page_num = isset($_GET['page']) && is_numeric($_GET['page']) ? intval($_GET['page']) : 1;
    $limit = 10;
    $offset = ($page_num - 1) * $limit;

    $sql = "SELECT * FROM services WHERE is_active = 1 LIMIT ? OFFSET ?";
    $stmt = $conn->prepare($sql);

    if (!$stmt) {
        throw new Exception("Failed to prepare SQL statement: " . $conn->error);
    }

    if (!$stmt->bind_param("ii", $limit, $offset)) {
        throw new Exception("Failed to bind parameters: " . $stmt->error);
    }

    if (!$stmt->execute()) {
        throw new Exception("SQL execution error: " . $stmt->error);
    }

    $result = $stmt->get_result();

    if ($result->num_rows > 0) {
        $services = [];

        while ($row = $result->fetch_assoc()) {
            $services[] = $row;
        }
        echo json_encode(["status" => "success", "services" => $services]);
    } else {
        echo json_encode(["status" => "error", "message" => "No services found"]);
    }
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