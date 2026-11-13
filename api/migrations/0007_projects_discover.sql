ALTER TABLE `conversations` ADD `project_id` text;--> statement-breakpoint
CREATE TABLE `projects` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`name` text NOT NULL,
	`instructions` text DEFAULT '' NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);--> statement-breakpoint
CREATE INDEX `projects_user_idx` ON `projects` (`user_id`);--> statement-breakpoint
CREATE TABLE `discover_agents` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`enabled` integer DEFAULT true NOT NULL,
	`model` text DEFAULT '' NOT NULL,
	`instructions` text DEFAULT '' NOT NULL,
	`sources` text DEFAULT '[]' NOT NULL,
	`interval_minutes` integer DEFAULT 120 NOT NULL,
	`max_posts` integer DEFAULT 6 NOT NULL,
	`base_url` text DEFAULT '' NOT NULL,
	`last_run_at` integer,
	`last_run_ok` integer,
	`last_run_message` text,
	`running_since` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);--> statement-breakpoint
CREATE TABLE `discover_agent_secrets` (
	`agent_id` text PRIMARY KEY NOT NULL,
	`ciphertext` text NOT NULL,
	`iv` text NOT NULL,
	`key_version` integer DEFAULT 1 NOT NULL,
	`last4` text NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`agent_id`) REFERENCES `discover_agents`(`id`) ON UPDATE no action ON DELETE cascade
);--> statement-breakpoint
CREATE TABLE `discover_posts` (
	`id` text PRIMARY KEY NOT NULL,
	`agent_id` text,
	`kind` text DEFAULT 'news' NOT NULL,
	`title` text NOT NULL,
	`summary` text DEFAULT '' NOT NULL,
	`prompt` text DEFAULT '' NOT NULL,
	`source_name` text,
	`source_url` text,
	`image_url` text,
	`hidden` integer DEFAULT false NOT NULL,
	`pinned` integer DEFAULT false NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`agent_id`) REFERENCES `discover_agents`(`id`) ON UPDATE no action ON DELETE set null
);--> statement-breakpoint
CREATE INDEX `discover_posts_created_idx` ON `discover_posts` (`created_at`);--> statement-breakpoint
CREATE UNIQUE INDEX `discover_posts_source_idx` ON `discover_posts` (`source_url`);
