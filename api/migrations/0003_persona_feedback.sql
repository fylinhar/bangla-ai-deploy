CREATE TABLE `message_feedback` (
	`message_id` text PRIMARY KEY NOT NULL,
	`conversation_id` text NOT NULL,
	`user_id` text NOT NULL,
	`rating` integer NOT NULL,
	`reason` text,
	`model` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`message_id`) REFERENCES `messages`(`id`) ON UPDATE no action ON DELETE cascade,
	FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `message_feedback_created_idx` ON `message_feedback` (`created_at`);--> statement-breakpoint
CREATE INDEX `message_feedback_user_idx` ON `message_feedback` (`user_id`);--> statement-breakpoint
ALTER TABLE `conversations` ADD `pinned` integer DEFAULT false NOT NULL;