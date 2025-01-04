<?php
header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST');
header('Access-Control-Allow-Headers: Content-Type');

$likes_file = 'likes.json';

function get_client_info() {
    return array(
        'timestamp' => gmdate('c'),
        'browser' => get_browser_name($_SERVER['HTTP_USER_AGENT']),
        'platform' => get_platform($_SERVER['HTTP_USER_AGENT']),
        'country' => get_country()
    );
}

function get_browser_name($user_agent) {
    if (strpos($user_agent, 'Firefox')) return 'Firefox';
    if (strpos($user_agent, 'Chrome')) return 'Chrome';
    if (strpos($user_agent, 'Safari')) return 'Safari';
    if (strpos($user_agent, 'Edge')) return 'Edge';
    return 'Other';
}

function get_platform($user_agent) {
    if (strpos($user_agent, 'Windows')) return 'Windows';
    if (strpos($user_agent, 'Mac')) return 'MacOS';
    if (strpos($user_agent, 'Linux')) return 'Linux';
    if (strpos($user_agent, 'iPhone') || strpos($user_agent, 'iPad')) return 'iOS';
    if (strpos($user_agent, 'Android')) return 'Android';
    return 'Other';
}

function get_country() {
    $ip = $_SERVER['REMOTE_ADDR'];
    // In a real implementation, you would use a GeoIP service here
    return 'Unknown';
}

if ($_SERVER['REQUEST_METHOD'] === 'GET') {
    if (file_exists($likes_file)) {
        echo file_get_contents($likes_file);
    } else {
        echo json_encode(['error' => 'No likes data found']);
    }
} elseif ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $data = json_decode(file_get_contents('php://input'), true);
    $song_id = $data['song_id'] ?? '';
    $action = $data['action'] ?? 'like';

    if ($song_id && file_exists($likes_file)) {
        $likes_data = json_decode(file_get_contents($likes_file), true);
        
        if (isset($likes_data['songs'][$song_id])) {
            if ($action === 'like') {
                $likes_data['songs'][$song_id]['likes']++;
                $likes_data['songs'][$song_id]['interactions'][] = get_client_info();
            } else {
                // Unlike - decrease count but don't go below 0
                $likes_data['songs'][$song_id]['likes'] = max(0, $likes_data['songs'][$song_id]['likes'] - 1);
                // Remove the last interaction
                array_pop($likes_data['songs'][$song_id]['interactions']);
            }
            
            file_put_contents($likes_file, json_encode($likes_data, JSON_PRETTY_PRINT));
            echo json_encode(['success' => true, 'likes' => $likes_data['songs'][$song_id]['likes']]);
        } else {
            echo json_encode(['error' => 'Song not found']);
        }
    } else {
        echo json_encode(['error' => 'Invalid request']);
    }
}
?> 