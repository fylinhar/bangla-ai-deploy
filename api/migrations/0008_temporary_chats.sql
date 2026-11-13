ALTER TABLE `conversations` ADD `temporary` integer DEFAULT false NOT NULL;--> statement-breakpoint
ALTER TABLE `conversations` ADD `agent_id` text;
