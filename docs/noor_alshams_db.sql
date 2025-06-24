-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 18, 2025 at 04:14 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `noor_alshams_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `announcements`
--

CREATE TABLE `announcements` (
  `id` int(11) NOT NULL,
  `message` text NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `created_by` int(11) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `announcements`
--

INSERT INTO `announcements` (`id`, `message`, `created_at`, `created_by`, `is_active`) VALUES
(1, '50% Sales on all products! ', '2025-06-04 03:49:57', 8, 0),
(2, '35% on Laser Hair Removal!', '2025-06-04 04:10:11', 8, 1),
(3, 'Eid Sales Coming Tomorrow!', '2025-06-04 04:11:54', 8, 1),
(4, '50% SALES', '2025-06-14 15:21:02', 8, 1);

-- --------------------------------------------------------

--
-- Table structure for table `appointments`
--

CREATE TABLE `appointments` (
  `id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL,
  `date` date NOT NULL,
  `time` time NOT NULL,
  `status` enum('pending','confirmed','completed','cancelled') NOT NULL DEFAULT 'pending',
  `created` timestamp NOT NULL DEFAULT current_timestamp(),
  `staff_id` int(11) DEFAULT NULL,
  `price` float NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `appointments`
--

INSERT INTO `appointments` (`id`, `client_id`, `service_id`, `date`, `time`, `status`, `created`, `staff_id`, `price`) VALUES
(7, 2, 1, '2027-10-01', '15:20:00', 'cancelled', '2025-05-07 15:59:35', 7, 0),
(18, 1, 1, '2025-05-15', '10:00:00', 'completed', '2025-05-17 09:05:19', 3, 0),
(20, 1, 3, '2025-05-15', '12:00:00', 'completed', '2025-05-17 09:05:19', 5, 0),
(21, 2, 4, '2025-05-15', '13:00:00', 'completed', '2025-05-17 09:05:19', 6, 0),
(23, 2, 3, '2025-05-16', '10:00:00', 'completed', '2025-05-17 09:05:19', 3, 0),
(24, 1, 4, '2025-05-16', '11:00:00', 'completed', '2025-05-17 09:05:19', 4, 0),
(25, 2, 5, '2025-05-16', '12:00:00', 'completed', '2025-05-17 09:05:19', 5, 0),
(26, 1, 1, '2025-05-16', '13:00:00', 'completed', '2025-05-17 09:05:19', 6, 0),
(27, 2, 5, '2025-05-16', '14:00:00', 'completed', '2025-05-17 09:05:19', 7, 0),
(34, 14, 4, '2025-06-13', '13:00:00', 'completed', '2025-06-13 03:28:48', 1, 70),
(35, 14, 4, '2025-06-14', '13:00:00', 'pending', '2025-06-13 03:52:05', 1, 70),
(36, 14, 4, '2025-06-15', '13:00:00', 'pending', '2025-06-13 03:52:09', 1, 70),
(37, 14, 4, '2025-06-16', '13:00:00', 'pending', '2025-06-13 03:52:12', 1, 70),
(38, 14, 4, '2025-06-17', '13:00:00', 'pending', '2025-06-13 03:52:15', 1, 70),
(39, 14, 4, '2025-06-18', '13:00:00', 'pending', '2025-06-13 03:52:18', 1, 70),
(40, 14, 4, '2025-06-19', '13:00:00', 'pending', '2025-06-13 03:52:37', 1, 70),
(41, 14, 4, '2025-06-20', '13:00:00', 'pending', '2025-06-13 03:52:42', 1, 70),
(42, 14, 4, '2025-06-21', '13:00:00', 'pending', '2025-06-13 03:52:44', 1, 70),
(43, 14, 4, '2025-06-22', '13:00:00', 'pending', '2025-06-13 03:52:47', 1, 70),
(44, 14, 4, '2025-06-23', '13:00:00', 'pending', '2025-06-13 03:52:50', 1, 70),
(45, 14, 4, '2025-06-24', '13:00:00', 'pending', '2025-06-13 03:52:54', 1, 70),
(47, 14, 4, '2025-06-24', '11:00:00', 'pending', '2025-06-16 09:16:58', 3, 70);

-- --------------------------------------------------------

--
-- Table structure for table `feedback`
--

CREATE TABLE `feedback` (
  `id` int(11) NOT NULL,
  `booking_id` int(11) NOT NULL,
  `client_id` int(11) NOT NULL,
  `rating` float NOT NULL,
  `comment` text DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `feedback`
--

INSERT INTO `feedback` (`id`, `booking_id`, `client_id`, `rating`, `comment`, `created_at`) VALUES
(1, 7, 1, 7, 'Waited much long after the appointment time.', '2025-05-17 06:33:50'),
(48, 27, 1, 5, 'Absolutely loved it!', '2025-05-17 09:07:45'),
(49, 18, 2, 4, 'Great experience!', '2025-05-17 09:07:45'),
(51, 20, 2, 3, 'Could have been better.', '2025-05-17 09:07:45'),
(52, 21, 1, 5, 'Perfect service.', '2025-05-17 09:07:45'),
(54, 23, 1, 5, 'Super professional staff!', '2025-05-17 09:07:45'),
(55, 24, 2, 3, 'Expected more attention.', '2025-05-17 09:07:45'),
(56, 25, 1, 5, 'Will book again!', '2025-05-17 09:07:45'),
(57, 26, 2, 4, 'Relaxing session.', '2025-05-17 09:07:45'),
(58, 21, 2, 8, 'Great!', '2025-06-13 11:56:35'),
(59, 21, 2, 8, 'Great!', '2025-06-13 11:57:03'),
(60, 21, 2, 8, 'Great!', '2025-06-13 11:57:18'),
(61, 21, 2, 8, 'Great!', '2025-06-13 11:58:17'),
(62, 21, 2, 8, 'Great!', '2025-06-13 12:08:22'),
(63, 21, 2, 8, 'Great!', '2025-06-13 12:10:41'),
(64, 21, 2, 8, 'Great!', '2025-06-13 12:12:01'),
(65, 21, 2, 8, 'Great!', '2025-06-13 12:13:35'),
(66, 21, 2, 8, 'Great!', '2025-06-13 12:22:03'),
(67, 21, 2, 8, 'Great!', '2025-06-13 12:24:06'),
(68, 21, 2, 8, 'Great!', '2025-06-13 12:28:18'),
(69, 21, 2, 8, 'Great!', '2025-06-13 12:29:01'),
(70, 21, 2, 8, 'Great!', '2025-06-13 12:29:52'),
(71, 34, 14, 8, 'Great!', '2025-06-13 12:31:42'),
(72, 34, 14, 8, 'Great!', '2025-06-13 12:36:02'),
(74, 34, 14, 8, 'Great!', '2025-06-13 12:46:30'),
(75, 34, 14, 8, 'Great!', '2025-06-13 12:48:07'),
(76, 34, 14, 8, 'Great!', '2025-06-13 12:48:33'),
(77, 34, 14, 8, 'Great!', '2025-06-13 12:51:00'),
(78, 34, 14, 8, 'Great!', '2025-06-13 12:53:24');

-- --------------------------------------------------------

--
-- Table structure for table `messages`
--

CREATE TABLE `messages` (
  `id` int(11) NOT NULL,
  `sender_id` int(11) NOT NULL,
  `receiver_id` int(11) NOT NULL,
  `message` text NOT NULL,
  `sent_at` datetime DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `messages`
--

INSERT INTO `messages` (`id`, `sender_id`, `receiver_id`, `message`, `sent_at`, `is_read`) VALUES
(1, 14, 8, 'Hi user #8! I\'m user #14...', '2025-06-15 05:34:21', 1),
(2, 14, 1, 'Hi user #1! I\'m user #14...', '2025-06-15 05:40:11', 1),
(3, 14, 2, 'Hi user #2! I\'m user #14...', '2025-06-15 05:40:21', 0),
(4, 14, 8, 'This is the second message in our conversation, right?', '2025-06-15 05:56:37', 1),
(5, 8, 14, 'I guess yeah LOL', '2025-06-15 05:56:55', 1),
(6, 8, 14, 'So..', '2025-06-15 06:34:32', 1),
(7, 8, 14, 'What are your plans for today?', '2025-06-15 06:34:42', 1);

-- --------------------------------------------------------

--
-- Table structure for table `notifications`
--

CREATE TABLE `notifications` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `title` varchar(255) NOT NULL,
  `message` text NOT NULL,
  `created_at` datetime DEFAULT current_timestamp(),
  `is_read` tinyint(1) DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notifications`
--

INSERT INTO `notifications` (`id`, `user_id`, `title`, `message`, `created_at`, `is_read`) VALUES
(1, 14, 'Booking Pending', 'Your booking for  on2026-12-12 at13:00 is under review.', '2025-06-13 05:21:11', 0),
(2, 14, 'Booking Updated', 'Your booking for Henna Design on2026-12-12 at13:00:00 has been updated to be on 2026-12-12 at 11:00.', '2025-06-13 05:26:17', 0),
(3, 14, 'Booking Updated', 'Your booking for Henna Design on2026-12-12 at11:00:00 has been updated to be on 2027-10-1 at 15:20.', '2025-06-13 05:27:16', 0),
(4, 14, 'Booking Pending', 'Your booking for Henna Design on2027-10-01 at15:20:00 is under review.', '2025-06-13 05:36:30', 0),
(5, 14, 'Booking Pending', 'Your booking for  on at is under review.', '2025-06-13 05:38:08', 0),
(6, 14, 'Booking Pending', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 is under review.', '2025-06-13 05:39:28', 0),
(7, 14, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 has been cancelled.', '2025-06-13 05:42:30', 0),
(8, 14, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 has been cancelled.', '2025-06-13 05:43:08', 0),
(9, 14, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 has been cancelled.', '2025-06-13 05:43:09', 0),
(10, 14, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 has been cancelled.', '2025-06-13 05:43:10', 0),
(11, 14, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2025-05-15 at10:00:00 has been cancelled.', '2025-06-13 05:46:10', 0),
(12, 1, 'Booking Pending', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 is under review.', '2025-06-13 06:12:13', 0),
(13, 1, 'Booking Completed', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 has been completed.', '2025-06-13 06:12:33', 0),
(14, 1, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 has been cancelled.', '2025-06-13 06:14:28', 0),
(15, 1, 'Booking Completed', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 has been completed.', '2025-06-13 06:15:17', 0),
(16, 2, 'Booking Completed', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 has been completed.', '2025-06-13 06:15:17', 0),
(17, 14, 'Booking Pending', 'Your booking for  on2025-6-13 at13:00 is under review.', '2025-06-13 06:28:48', 1),
(18, 2, 'Booking Cancelled', 'Your booking for Laser Hair Removal on2027-10-01 at15:20:00 has been cancelled.', '2025-06-13 06:30:53', 0),
(19, 14, 'Booking Pending', 'Your booking for  on2025-6-14 at13:00 is under review.', '2025-06-13 06:52:05', 0),
(20, 14, 'Booking Pending', 'Your booking for  on2025-6-15 at13:00 is under review.', '2025-06-13 06:52:09', 0),
(21, 14, 'Booking Pending', 'Your booking for  on2025-6-16 at13:00 is under review.', '2025-06-13 06:52:12', 0),
(22, 14, 'Booking Pending', 'Your booking for  on2025-6-17 at13:00 is under review.', '2025-06-13 06:52:15', 0),
(23, 14, 'Booking Pending', 'Your booking for  on2025-6-18 at13:00 is under review.', '2025-06-13 06:52:18', 0),
(24, 14, 'Booking Pending', 'Your booking for  on2025-6-19 at13:00 is under review.', '2025-06-13 06:52:37', 0),
(25, 14, 'Booking Pending', 'Your booking for  on2025-6-20 at13:00 is under review.', '2025-06-13 06:52:42', 0),
(26, 14, 'Booking Pending', 'Your booking for  on2025-6-21 at13:00 is under review.', '2025-06-13 06:52:44', 0),
(27, 14, 'Booking Pending', 'Your booking for  on2025-6-22 at13:00 is under review.', '2025-06-13 06:52:47', 0),
(28, 14, 'Booking Pending', 'Your booking for  on2025-6-23 at13:00 is under review.', '2025-06-13 06:52:50', 0),
(29, 14, 'Booking Pending', 'Your booking for  on2025-6-24 at13:00 is under review.', '2025-06-13 06:52:54', 0),
(30, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 14:56:35', 0),
(31, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 14:57:03', 0),
(32, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 14:57:18', 0),
(33, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 14:58:17', 0),
(34, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 15:08:22', 0),
(35, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 15:10:41', 0),
(36, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 15:12:01', 0),
(37, 2, 'New Feedback Received', 'New feedback from : Great!', '2025-06-13 15:13:35', 0),
(38, 2, 'New Feedback Received', 'New feedback from Muhammad Shukri: Great!', '2025-06-13 15:24:06', 0),
(39, 2, 'New Feedback Received', 'New feedback from Muhammad Shukri: Great!', '2025-06-13 15:28:18', 0),
(40, 2, 'New Feedback Received', 'New feedback from Muhammad Shukri: Great!', '2025-06-13 15:29:01', 0),
(41, 2, 'New Feedback Received', 'New feedback from Muhammad Shukri: Great!', '2025-06-13 15:29:52', 0),
(42, 14, 'Booking Completed', 'Your booking for Henna Design on2025-06-13 at13:00:00 has been completed.', '2025-06-13 15:31:36', 0),
(43, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:31:42', 0),
(44, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:42:46', 0),
(45, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:46:30', 0),
(46, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:48:07', 0),
(47, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:48:33', 0),
(48, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:51:00', 0),
(49, 14, 'New Feedback Received', 'New feedback from Iyad Itoum: Great!', '2025-06-13 15:53:24', 0),
(50, 8, 'New Message', 'You have received a new message from Iyad Itoum: Hi user #8! I\'m user #14...', '2025-06-15 05:34:21', 0),
(51, 1, 'New Message', 'You have received a new message from Iyad Itoum: Hi user #1! I\'m user #14...', '2025-06-15 05:40:11', 0),
(52, 2, 'New Message', 'You have received a new message from Iyad Itoum: Hi user #2! I\'m user #14...', '2025-06-15 05:40:21', 0),
(53, 8, 'New Message', 'You have received a new message from Iyad Itoum: This is the second message in our conversation, right?', '2025-06-15 05:56:37', 0),
(54, 14, 'New Message', 'You have received a new message from Test Admin: I guess yeah LOL', '2025-06-15 05:56:55', 0),
(55, 14, 'New Message', 'You have received a new message from Test Admin: So..', '2025-06-15 06:34:32', 0),
(56, 14, 'New Message', 'You have received a new message from Test Admin: What are your plans for today?', '2025-06-15 06:34:42', 0),
(57, 14, 'Test Notification 35', 'This is a test notification #35', '2025-06-15 16:54:53', 0),
(58, 14, 'Test Notification 36', 'This is a test notification #36', '2025-06-15 16:54:53', 0),
(59, 14, 'Test Notification 37', 'This is a test notification #37', '2025-06-15 16:54:53', 0),
(60, 14, 'Test Notification 38', 'This is a test notification #38', '2025-06-15 16:54:53', 0),
(61, 14, 'Test Notification 39', 'This is a test notification #39', '2025-06-15 16:54:53', 0),
(62, 14, 'Test Notification 40', 'This is a test notification #40', '2025-06-15 16:54:53', 0),
(63, 14, 'Test Notification 41', 'This is a test notification #41', '2025-06-15 16:54:53', 0),
(64, 14, 'Test Notification 42', 'This is a test notification #42', '2025-06-15 16:54:53', 0),
(65, 14, 'Test Notification 43', 'This is a test notification #43', '2025-06-15 16:54:53', 0),
(66, 14, 'Test Notification 44', 'This is a test notification #44', '2025-06-15 16:54:53', 0),
(67, 14, 'Test Notification 45', 'This is a test notification #45', '2025-06-15 16:54:53', 0),
(68, 14, 'Test Notification 46', 'This is a test notification #46', '2025-06-15 16:54:53', 0),
(69, 14, 'Test Notification 47', 'This is a test notification #47', '2025-06-15 16:54:53', 0),
(70, 14, 'Test Notification 48', 'This is a test notification #48', '2025-06-15 16:54:53', 0),
(71, 14, 'Test Notification 49', 'This is a test notification #49', '2025-06-15 16:54:53', 0),
(72, 14, 'Test Notification 50', 'This is a test notification #50', '2025-06-15 16:54:53', 0),
(73, 14, 'Test Notification 51', 'This is a test notification #51', '2025-06-15 16:54:53', 0),
(91, 8, 'Staff Check-In', 'Staff member Test Staff checked in on 2025-06-16 at 09:20:02.', '2025-06-16 09:20:02', 0),
(92, 3, 'Check-In Notification', 'Staff member Test Staffhas checked-in on 2025-06-16 at 09:20:02.', '2025-06-16 09:20:02', 0),
(93, 8, 'Staff Check-In', 'Staff member Test Staff checked in on 2025-06-16 at 09:20:25.', '2025-06-16 09:20:25', 0),
(94, 3, 'Check-In Notification', 'Staff member Test Staffhas checked-in on 2025-06-16 at 09:20:25.', '2025-06-16 09:20:25', 0),
(95, 8, 'Staff Check-Out', 'Staff member Test Staff checked-out on 2025-06-16 at 09:28:34.', '2025-06-16 09:28:34', 0),
(96, 3, 'Check-Out Notification', 'Staff member Test Staff has checked-out on 2025-06-16 at 09:28:34.', '2025-06-16 09:28:34', 0),
(97, 14, 'Booking Pending', 'Your booking for Henna Design on2025-6-24 at11:00 is under review.', '2025-06-16 12:16:58', 0),
(98, 8, 'New Booking Request', 'A new booking has been made by Iyad Itoum for Henna Design on 2025-6-24 at 11:00. Please review and confirm.', '2025-06-16 12:16:58', 0),
(99, 3, 'New Appointment Assigned', 'You have been assigned to an appointment on 2025-06-24 at 11:00:00.', '2025-06-16 12:43:58', 0);

-- --------------------------------------------------------

--
-- Table structure for table `services`
--

CREATE TABLE `services` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `description` text NOT NULL,
  `price` decimal(6,2) NOT NULL,
  `duration` int(11) NOT NULL,
  `image_path` varchar(100) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services`
--

INSERT INTO `services` (`id`, `name`, `description`, `price`, `duration`, `image_path`, `is_active`) VALUES
(1, 'Laser Hair Removal', 'Lower body laser hair removal', 235.00, 55, 'uploads/Screenshot 2024-11-08 151840.png', 1),
(3, 'Facial Treatment', 'Deep cleansing', 120.00, 65, '', 1),
(4, 'Henna Design', 'Traditional henna hand art', 70.00, 45, '', 1),
(5, 'Pedicare', 'Pedicare session done seamlessly by our experts! 	', 80.00, 20, '', 1),
(8, 'Nails Polishing', 'Flawless nail polishing treatment for glowing nails!', 130.00, 45, 'uploads/Screenshot 2024-11-08 151840.png', 1);

-- --------------------------------------------------------

--
-- Table structure for table `staff_details`
--

CREATE TABLE `staff_details` (
  `id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `salary_per_hour` decimal(8,2) NOT NULL,
  `notes` text DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_details`
--

INSERT INTO `staff_details` (`id`, `staff_id`, `salary_per_hour`, `notes`) VALUES
(1, 3, 750.00, 'Test'),
(2, 4, 60.00, 'Henna & design specialist'),
(3, 5, 55.00, 'Facial treatment specialist'),
(4, 6, 65.00, 'Laser expert'),
(5, 7, 50.00, 'Junior stylist'),
(6, 9, 58.00, 'Recently hired'),
(7, 11, 57.00, 'Part-time shift'),
(8, 12, 59.00, 'Specializes in coloring');

-- --------------------------------------------------------

--
-- Table structure for table `staff_services`
--

CREATE TABLE `staff_services` (
  `staff_id` int(11) NOT NULL,
  `service_id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `staff_services`
--

INSERT INTO `staff_services` (`staff_id`, `service_id`) VALUES
(1, 1),
(1, 4),
(2, 3),
(3, 1),
(4, 3),
(4, 4);

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

CREATE TABLE `users` (
  `id` int(11) NOT NULL,
  `full_name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `dob` date NOT NULL,
  `role` enum('client','staff','admin') DEFAULT 'client',
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `verify_code` varchar(10) DEFAULT NULL,
  `is_verified` tinyint(1) DEFAULT 0,
  `phone` varchar(20) NOT NULL,
  `is_active` tinyint(1) DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`id`, `full_name`, `email`, `password`, `dob`, `role`, `created_at`, `verify_code`, `is_verified`, `phone`, `is_active`) VALUES
(1, 'mo', 'muhammadsh.icloud@gmail.com', '$2y$10$GOtkY5Ycus9xS7ENYeQROuF8lKjtH3K7pt7OrpvVgVbWbTMwyF/YG', '1990-12-12', 'client', '2025-05-04 12:13:18', NULL, 1, '0598267948', 1),
(2, 'Muhammad Shukri', 'test@gmail.com', '$2y$10$GGVupDrRhiWcrkBasdg2qOzjHQN5oAAuudYPZ032dk6kb1pOZxDsO', '0000-00-00', 'client', '2025-05-05 03:57:44', NULL, 1, '0598267944', 1),
(3, 'Test Staff', 'staff@example.com', 'testpassword', '1990-01-01', 'staff', '2025-05-08 02:51:09', NULL, 1, '0000000000', 1),
(4, 'Lana Khalil', 'lana.khalil@example.com', 'dummy_pass_1', '1990-05-14', 'staff', '2025-05-08 07:09:25', NULL, 1, '0591234567', 1),
(5, 'Maya Odeh', 'maya.odeh@example.com', 'dummy_pass_2', '1992-08-22', 'staff', '2025-05-08 07:09:25', NULL, 1, '0599876543', 1),
(6, 'Noura Hasan', 'noura.hasan@example.com', 'dummy_pass_3', '1988-11-03', 'staff', '2025-05-08 07:09:25', NULL, 1, '0594447777', 1),
(7, 'Rania Samir', 'rania.samir@example.com', 'dummy_pass_4', '1995-01-30', 'staff', '2025-05-08 07:09:25', NULL, 1, '0591122334', 1),
(8, 'Test Admin', 'admin@example.com', '123321', '0000-00-00', 'admin', '2025-05-11 02:29:08', NULL, 1, '', 1),
(9, 'Majd Abo Alia', 'mj@test.com', '$2y$10$NIYQ1kidlUpVQG4PXzDMeegARTYncC/q0Gs8fAGrv.hXBpy2yzu36', '1998-12-31', 'staff', '2025-05-17 16:40:29', NULL, 1, '0598267958', 1),
(11, 'Majd Abo Salem', 'mj1@test.com', '$2y$10$BGJjw5C3nRg7qGjb9dHwmeb0XVrLSP1Ckp0iztc7BWji95od1pH2q', '1998-12-31', 'staff', '2025-05-17 16:47:25', NULL, 1, '0598267966', 1),
(12, 'Majd Abo Salemaaaa', 'm323j1@test.com', '$2y$10$OwBBpY3Z5DHi/THUq2AIwOaG3neTqVN8Xq6J4RQ5y9h8wbTzhvPIa', '1998-12-31', 'staff', '2025-05-17 16:50:12', NULL, 1, '0598267923', 1),
(14, 'Iyad Itoum', 'iyado.itoum@gmail.com', '$2y$10$XLpmO5L4IAer2CViuNIPNeFn5eAS1TEIIBUfwac1otcOpxVSAlW4C', '2002-04-29', 'client', '2025-06-12 12:03:23', NULL, 1, '0599685794', 1);

-- --------------------------------------------------------

--
-- Table structure for table `user_activity_log`
--

CREATE TABLE `user_activity_log` (
  `id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `action` varchar(255) NOT NULL,
  `timestamp` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_activity_log`
--

INSERT INTO `user_activity_log` (`id`, `user_id`, `action`, `timestamp`) VALUES
(1, 14, 'Logged in', '2025-06-12 15:15:53'),
(2, 14, 'Logged in', '2025-06-12 15:16:30'),
(3, 14, 'Logged in', '2025-06-12 16:03:33'),
(4, 8, 'Logged in', '2025-06-12 17:32:23'),
(5, 8, 'Logged in', '2025-06-12 17:36:30'),
(6, 8, 'Logged in', '2025-06-12 17:54:56'),
(7, 14, 'Logged in', '2025-06-12 20:48:31'),
(8, 14, 'Logged in', '2025-06-13 14:38:07'),
(9, 14, 'Logged in', '2025-06-13 14:38:58'),
(10, 14, 'Logged in', '2025-06-13 14:45:42'),
(11, 8, 'Logged in', '2025-06-14 11:50:23'),
(12, 14, 'Logged in', '2025-06-15 05:31:52'),
(13, 8, 'Logged in', '2025-06-15 05:46:20'),
(14, 14, 'Logged in', '2025-06-15 05:47:27'),
(15, 8, 'Logged in', '2025-06-15 05:49:27'),
(16, 8, 'Logged in', '2025-06-15 16:48:34'),
(17, 8, 'Logged in', '2025-06-16 12:15:04');

-- --------------------------------------------------------

--
-- Table structure for table `work_log`
--

CREATE TABLE `work_log` (
  `id` int(11) NOT NULL,
  `staff_id` int(11) NOT NULL,
  `check_in` datetime NOT NULL,
  `check_out` datetime DEFAULT NULL,
  `duration_minutes` int(11) DEFAULT NULL,
  `date` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `work_log`
--

INSERT INTO `work_log` (`id`, `staff_id`, `check_in`, `check_out`, `duration_minutes`, `date`) VALUES
(1, 5, '2025-06-01 11:17:58', '2025-06-01 11:21:06', 176, '0000-00-00'),
(2, 4, '2025-06-01 09:00:00', '2025-06-01 12:00:00', 180, '0000-00-00'),
(3, 12, '2025-06-01 11:31:11', '2025-06-01 11:40:06', 8, '0000-00-00'),
(6, 3, '2025-06-16 09:20:25', '2025-06-16 09:28:34', 8, '0000-00-00'),
(7, 3, '2025-05-18 08:34:00', '2025-05-18 11:39:00', 185, '0000-00-00'),
(8, 3, '2025-05-08 09:04:00', '2025-05-08 17:18:00', 494, '0000-00-00'),
(9, 3, '2025-05-05 09:32:00', '2025-05-05 17:02:00', 450, '0000-00-00'),
(10, 3, '2025-04-18 08:15:00', '2025-04-18 18:13:00', 598, '0000-00-00'),
(11, 3, '2025-06-09 09:38:00', '2025-06-09 19:22:00', 584, '0000-00-00'),
(12, 3, '2025-06-05 08:28:00', '2025-06-05 17:34:00', 546, '0000-00-00'),
(13, 3, '2025-05-04 08:15:00', '2025-05-04 13:25:00', 310, '0000-00-00'),
(14, 3, '2025-05-04 08:42:00', '2025-05-04 16:53:00', 491, '0000-00-00'),
(15, 3, '2025-05-05 10:20:00', '2025-05-05 16:29:00', 369, '0000-00-00'),
(16, 3, '2025-05-16 11:01:00', '2025-05-16 17:18:00', 377, '0000-00-00'),
(17, 3, '2025-05-24 10:37:00', '2025-05-24 15:48:00', 311, '0000-00-00'),
(18, 3, '2025-05-08 11:43:00', '2025-05-08 19:10:00', 447, '0000-00-00'),
(19, 3, '2025-05-14 10:00:00', '2025-05-14 16:15:00', 375, '0000-00-00'),
(20, 3, '2025-04-30 10:59:00', '2025-04-30 17:21:00', 382, '0000-00-00'),
(21, 3, '2025-05-02 10:25:00', '2025-05-02 17:57:00', 452, '0000-00-00'),
(22, 3, '2025-05-08 11:35:00', '2025-05-08 20:49:00', 554, '0000-00-00'),
(23, 3, '2025-04-18 10:50:00', '2025-04-18 17:14:00', 384, '0000-00-00'),
(24, 3, '2025-06-13 08:23:00', '2025-06-13 14:12:00', 349, '0000-00-00'),
(25, 4, '2025-04-18 08:18:00', '2025-04-18 13:40:00', 322, '0000-00-00'),
(26, 4, '2025-06-05 11:28:00', '2025-06-05 17:38:00', 370, '0000-00-00'),
(27, 4, '2025-05-09 09:46:00', '2025-05-09 17:28:00', 462, '0000-00-00'),
(28, 4, '2025-05-26 10:32:00', '2025-05-26 18:55:00', 503, '0000-00-00'),
(29, 4, '2025-06-06 09:14:00', '2025-06-06 17:48:00', 514, '0000-00-00'),
(30, 4, '2025-05-17 09:52:00', '2025-05-17 15:04:00', 312, '0000-00-00'),
(31, 4, '2025-05-27 08:10:00', '2025-05-27 17:42:00', 572, '0000-00-00'),
(32, 4, '2025-06-12 10:34:00', '2025-06-12 15:01:00', 267, '0000-00-00'),
(33, 4, '2025-04-23 09:16:00', '2025-04-23 12:19:00', 183, '0000-00-00'),
(34, 4, '2025-05-25 10:33:00', '2025-05-25 18:43:00', 490, '0000-00-00'),
(35, 4, '2025-06-05 09:48:00', '2025-06-05 17:14:00', 446, '0000-00-00'),
(36, 4, '2025-06-08 11:12:00', '2025-06-08 14:55:00', 223, '0000-00-00'),
(37, 4, '2025-05-29 11:45:00', '2025-05-29 16:02:00', 257, '0000-00-00'),
(38, 4, '2025-05-22 11:48:00', '2025-05-22 17:55:00', 367, '0000-00-00'),
(39, 4, '2025-04-27 09:10:00', '2025-04-27 13:28:00', 258, '0000-00-00'),
(40, 4, '2025-04-28 10:28:00', '2025-04-28 15:30:00', 302, '0000-00-00'),
(41, 4, '2025-05-24 11:46:00', '2025-05-24 15:44:00', 238, '0000-00-00'),
(42, 4, '2025-05-12 08:04:00', '2025-05-12 17:31:00', 567, '0000-00-00'),
(43, 4, '2025-05-04 11:09:00', '2025-05-04 20:54:00', 585, '0000-00-00'),
(44, 4, '2025-05-19 10:15:00', '2025-05-19 18:39:00', 504, '0000-00-00'),
(45, 5, '2025-05-11 08:16:00', '2025-05-11 13:46:00', 330, '0000-00-00'),
(46, 5, '2025-05-17 09:33:00', '2025-05-17 18:11:00', 518, '0000-00-00'),
(47, 5, '2025-05-13 08:18:00', '2025-05-13 16:33:00', 495, '0000-00-00'),
(48, 5, '2025-05-13 10:37:00', '2025-05-13 19:52:00', 555, '0000-00-00'),
(49, 5, '2025-05-13 09:46:00', '2025-05-13 17:31:00', 465, '0000-00-00'),
(50, 5, '2025-06-06 11:36:00', '2025-06-06 18:44:00', 428, '0000-00-00'),
(51, 5, '2025-05-27 08:46:00', '2025-05-27 16:42:00', 476, '0000-00-00'),
(52, 5, '2025-05-01 09:41:00', '2025-05-01 15:53:00', 372, '0000-00-00'),
(53, 5, '2025-05-18 10:35:00', '2025-05-18 17:22:00', 407, '0000-00-00'),
(54, 5, '2025-05-16 08:44:00', '2025-05-16 18:37:00', 593, '0000-00-00'),
(55, 5, '2025-04-27 09:46:00', '2025-04-27 14:10:00', 264, '0000-00-00'),
(56, 5, '2025-06-12 11:10:00', '2025-06-12 18:47:00', 457, '0000-00-00'),
(57, 5, '2025-06-03 08:36:00', '2025-06-03 18:27:00', 591, '0000-00-00'),
(58, 5, '2025-05-10 11:50:00', '2025-05-10 15:10:00', 200, '0000-00-00'),
(59, 5, '2025-06-01 09:34:00', '2025-06-01 16:28:00', 414, '0000-00-00'),
(60, 5, '2025-04-27 10:47:00', '2025-04-27 17:14:00', 387, '0000-00-00'),
(61, 5, '2025-04-28 08:58:00', '2025-04-28 18:32:00', 574, '0000-00-00'),
(62, 5, '2025-05-27 11:15:00', '2025-05-27 18:26:00', 431, '0000-00-00'),
(63, 12, '2025-06-03 11:19:00', '2025-06-03 15:29:00', 250, '0000-00-00'),
(64, 12, '2025-06-01 09:06:00', '2025-06-01 15:04:00', 358, '0000-00-00'),
(65, 12, '2025-05-09 10:03:00', '2025-05-09 18:21:00', 498, '0000-00-00'),
(66, 12, '2025-06-11 08:41:00', '2025-06-11 18:22:00', 581, '0000-00-00'),
(67, 12, '2025-05-23 11:43:00', '2025-05-23 17:06:00', 323, '0000-00-00'),
(68, 12, '2025-05-25 08:38:00', '2025-05-25 16:55:00', 497, '0000-00-00'),
(69, 12, '2025-05-11 08:31:00', '2025-05-11 13:03:00', 272, '0000-00-00'),
(70, 12, '2025-05-16 09:04:00', '2025-05-16 17:54:00', 530, '0000-00-00'),
(71, 12, '2025-05-22 10:57:00', '2025-05-22 17:27:00', 390, '0000-00-00'),
(72, 12, '2025-05-18 10:37:00', '2025-05-18 19:41:00', 544, '0000-00-00'),
(73, 12, '2025-06-10 08:01:00', '2025-06-10 17:08:00', 547, '0000-00-00'),
(74, 12, '2025-04-22 10:39:00', '2025-04-22 16:45:00', 366, '0000-00-00'),
(75, 12, '2025-05-08 11:37:00', '2025-05-08 16:48:00', 311, '0000-00-00'),
(76, 12, '2025-04-18 10:24:00', '2025-04-18 15:42:00', 318, '0000-00-00'),
(77, 12, '2025-04-19 08:21:00', '2025-04-19 13:24:00', 303, '0000-00-00'),
(78, 12, '2025-06-12 10:59:00', '2025-06-12 13:59:00', 180, '0000-00-00'),
(79, 12, '2025-05-02 11:30:00', '2025-05-02 19:23:00', 473, '0000-00-00'),
(80, 12, '2025-05-16 11:26:00', '2025-05-16 15:51:00', 265, '0000-00-00'),
(81, 12, '2025-06-14 09:20:00', '2025-06-14 14:55:00', 335, '0000-00-00'),
(82, 12, '2025-05-25 09:31:00', '2025-05-25 14:55:00', 324, '0000-00-00'),
(83, 12, '2025-05-19 09:51:00', '2025-05-19 14:19:00', 268, '0000-00-00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `announcements`
--
ALTER TABLE `announcements`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_created_by` (`created_by`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_announcements_created_by` (`created_by`),
  ADD KEY `idx_announcements_is_active` (`is_active`);

--
-- Indexes for table `appointments`
--
ALTER TABLE `appointments`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_date` (`date`),
  ADD KEY `idx_status` (`status`),
  ADD KEY `idx_client_id` (`client_id`),
  ADD KEY `idx_service_id` (`service_id`),
  ADD KEY `idx_staff_id` (`staff_id`),
  ADD KEY `idx_appointments_client_id` (`client_id`),
  ADD KEY `idx_appointments_service_id` (`service_id`),
  ADD KEY `idx_appointments_staff_id` (`staff_id`),
  ADD KEY `idx_appointments_status` (`status`);

--
-- Indexes for table `feedback`
--
ALTER TABLE `feedback`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_feedback_booking_id` (`booking_id`),
  ADD KEY `idx_feedback_client_id` (`client_id`);

--
-- Indexes for table `messages`
--
ALTER TABLE `messages`
  ADD PRIMARY KEY (`id`),
  ADD KEY `sender_id` (`sender_id`),
  ADD KEY `receiver_id` (`receiver_id`);

--
-- Indexes for table `notifications`
--
ALTER TABLE `notifications`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `services`
--
ALTER TABLE `services`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_services_is_active` (`is_active`);

--
-- Indexes for table `staff_details`
--
ALTER TABLE `staff_details`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_staff_details_staff_id` (`staff_id`);

--
-- Indexes for table `staff_services`
--
ALTER TABLE `staff_services`
  ADD PRIMARY KEY (`staff_id`,`service_id`),
  ADD KEY `idx_staff_services_service_id` (`service_id`);

--
-- Indexes for table `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `email` (`email`),
  ADD KEY `idx_role` (`role`),
  ADD KEY `idx_is_active` (`is_active`),
  ADD KEY `idx_is_active_users` (`is_active`),
  ADD KEY `idx_users_role` (`role`),
  ADD KEY `idx_users_is_active` (`is_active`);

--
-- Indexes for table `user_activity_log`
--
ALTER TABLE `user_activity_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `user_id` (`user_id`);

--
-- Indexes for table `work_log`
--
ALTER TABLE `work_log`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_work_log_staff_id` (`staff_id`),
  ADD KEY `idx_work_log_date` (`date`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `announcements`
--
ALTER TABLE `announcements`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `appointments`
--
ALTER TABLE `appointments`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=48;

--
-- AUTO_INCREMENT for table `feedback`
--
ALTER TABLE `feedback`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=79;

--
-- AUTO_INCREMENT for table `messages`
--
ALTER TABLE `messages`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `notifications`
--
ALTER TABLE `notifications`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=100;

--
-- AUTO_INCREMENT for table `services`
--
ALTER TABLE `services`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `staff_details`
--
ALTER TABLE `staff_details`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `users`
--
ALTER TABLE `users`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `user_activity_log`
--
ALTER TABLE `user_activity_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=18;

--
-- AUTO_INCREMENT for table `work_log`
--
ALTER TABLE `work_log`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=84;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `announcements`
--
ALTER TABLE `announcements`
  ADD CONSTRAINT `announcements_ibfk_1` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`);

--
-- Constraints for table `appointments`
--
ALTER TABLE `appointments`
  ADD CONSTRAINT `fk_service` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_staff` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_user` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `feedback`
--
ALTER TABLE `feedback`
  ADD CONSTRAINT `feedback_ibfk_1` FOREIGN KEY (`booking_id`) REFERENCES `appointments` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `feedback_ibfk_2` FOREIGN KEY (`client_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `messages`
--
ALTER TABLE `messages`
  ADD CONSTRAINT `messages_ibfk_1` FOREIGN KEY (`sender_id`) REFERENCES `users` (`id`),
  ADD CONSTRAINT `messages_ibfk_2` FOREIGN KEY (`receiver_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `notifications`
--
ALTER TABLE `notifications`
  ADD CONSTRAINT `notifications_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `staff_details`
--
ALTER TABLE `staff_details`
  ADD CONSTRAINT `staff_details_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `staff_services`
--
ALTER TABLE `staff_services`
  ADD CONSTRAINT `staff_services_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `staff_services_ibfk_2` FOREIGN KEY (`service_id`) REFERENCES `services` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `user_activity_log`
--
ALTER TABLE `user_activity_log`
  ADD CONSTRAINT `user_activity_log_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`);

--
-- Constraints for table `work_log`
--
ALTER TABLE `work_log`
  ADD CONSTRAINT `work_log_ibfk_1` FOREIGN KEY (`staff_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
