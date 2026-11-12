CREATE TABLE `client_errors` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text,
	`platform` text NOT NULL,
	`app_version` text,
	`route` text,
	`message` text NOT NULL,
	`stack` text,
	`fatal` integer DEFAULT false NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `client_errors_created_idx` ON `client_errors` (`created_at`);--> statement-breakpoint
ALTER TABLE `user_reports` ADD `admin_note` text;