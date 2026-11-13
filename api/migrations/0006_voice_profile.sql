ALTER TABLE `user` ADD `avatar` text;--> statement-breakpoint
CREATE TABLE `voice_providers` (
	`id` text PRIMARY KEY NOT NULL,
	`kind` text NOT NULL,
	`name` text NOT NULL,
	`enabled` integer DEFAULT true NOT NULL,
	`priority` integer DEFAULT 10 NOT NULL,
	`voice_id` text DEFAULT '' NOT NULL,
	`model` text DEFAULT '' NOT NULL,
	`region` text DEFAULT '' NOT NULL,
	`base_url` text DEFAULT '' NOT NULL,
	`language` text DEFAULT 'bn-BD' NOT NULL,
	`speed` real DEFAULT 1 NOT NULL,
	`last_test_ok` integer,
	`last_test_error` text,
	`last_tested_at` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);--> statement-breakpoint
CREATE TABLE `voice_secrets` (
	`provider_id` text PRIMARY KEY NOT NULL,
	`ciphertext` text NOT NULL,
	`iv` text NOT NULL,
	`key_version` integer DEFAULT 1 NOT NULL,
	`last4` text NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`provider_id`) REFERENCES `voice_providers`(`id`) ON UPDATE no action ON DELETE cascade
);
