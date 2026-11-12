CREATE TABLE `ai_models` (
	`id` text PRIMARY KEY NOT NULL,
	`provider_id` text NOT NULL,
	`model_id` text NOT NULL,
	`display_name` text,
	`source` text NOT NULL,
	`enabled` integer DEFAULT false NOT NULL,
	`verification_status` text DEFAULT 'unverified' NOT NULL,
	`verified_at` integer,
	`verification_error` text,
	`supports_vision` integer,
	`supports_embeddings` integer,
	`context_length` integer,
	`input_price_per_1m` real,
	`output_price_per_1m` real,
	`last_test_latency_ms` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`provider_id`) REFERENCES `provider_configs`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `ai_models_provider_model_uq` ON `ai_models` (`provider_id`,`model_id`);--> statement-breakpoint
CREATE TABLE `ai_usage_logs` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text,
	`conversation_id` text,
	`capability` text NOT NULL,
	`provider_id` text,
	`model` text,
	`attempt` integer DEFAULT 1 NOT NULL,
	`fallback_used` integer DEFAULT false NOT NULL,
	`status` text NOT NULL,
	`error_code` text,
	`latency_ms` integer,
	`input_tokens` integer,
	`output_tokens` integer,
	`cost_estimate` real,
	`stream` integer DEFAULT false NOT NULL,
	`source` text DEFAULT 'public' NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `usage_created_idx` ON `ai_usage_logs` (`created_at`);--> statement-breakpoint
CREATE INDEX `usage_user_created_idx` ON `ai_usage_logs` (`user_id`,`created_at`);--> statement-breakpoint
CREATE INDEX `usage_model_idx` ON `ai_usage_logs` (`model`);--> statement-breakpoint
CREATE TABLE `app_settings` (
	`key` text PRIMARY KEY NOT NULL,
	`value` text NOT NULL,
	`updated_by` text,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE TABLE `audit_logs` (
	`id` text PRIMARY KEY NOT NULL,
	`actor_id` text,
	`actor_email` text,
	`actor_role` text,
	`action` text NOT NULL,
	`target_type` text,
	`target_id` text,
	`details` text,
	`ip` text,
	`user_agent` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `audit_created_idx` ON `audit_logs` (`created_at`);--> statement-breakpoint
CREATE INDEX `audit_actor_idx` ON `audit_logs` (`actor_id`);--> statement-breakpoint
CREATE TABLE `capability_mappings` (
	`capability` text PRIMARY KEY NOT NULL,
	`primary_model_id` text,
	`fallback_model_ids` text DEFAULT '[]' NOT NULL,
	`updated_by` text,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`primary_model_id`) REFERENCES `ai_models`(`id`) ON UPDATE no action ON DELETE set null
);
--> statement-breakpoint
CREATE TABLE `connection_tests` (
	`id` text PRIMARY KEY NOT NULL,
	`provider_id` text NOT NULL,
	`ok` integer NOT NULL,
	`http_status` integer,
	`latency_ms` integer,
	`model_count` integer,
	`error` text,
	`created_by` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`provider_id`) REFERENCES `provider_configs`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `connection_tests_provider_idx` ON `connection_tests` (`provider_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `conversations` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`title` text NOT NULL,
	`archived` integer DEFAULT false NOT NULL,
	`capability` text DEFAULT 'chat' NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `conversations_user_idx` ON `conversations` (`user_id`,`updated_at`);--> statement-breakpoint
CREATE TABLE `files` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`conversation_id` text,
	`r2_key` text NOT NULL,
	`name` text NOT NULL,
	`mime` text NOT NULL,
	`kind` text NOT NULL,
	`size` integer NOT NULL,
	`status` text NOT NULL,
	`extracted_text` text,
	`extract_error` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `files_user_idx` ON `files` (`user_id`);--> statement-breakpoint
CREATE TABLE `memories` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`content` text NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `memories_user_idx` ON `memories` (`user_id`);--> statement-breakpoint
CREATE TABLE `messages` (
	`id` text PRIMARY KEY NOT NULL,
	`conversation_id` text NOT NULL,
	`user_id` text NOT NULL,
	`role` text NOT NULL,
	`content` text DEFAULT '' NOT NULL,
	`status` text DEFAULT 'complete' NOT NULL,
	`model` text,
	`error` text,
	`attachments` text DEFAULT '[]' NOT NULL,
	`input_tokens` integer,
	`output_tokens` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`conversation_id`) REFERENCES `conversations`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE INDEX `messages_conversation_idx` ON `messages` (`conversation_id`,`created_at`);--> statement-breakpoint
CREATE TABLE `plans` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`name_bn` text NOT NULL,
	`daily_request_limit` integer NOT NULL,
	`monthly_request_limit` integer NOT NULL,
	`daily_token_limit` integer NOT NULL,
	`max_upload_mb` integer NOT NULL,
	`is_default` integer DEFAULT false NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE TABLE `provider_configs` (
	`id` text PRIMARY KEY NOT NULL,
	`name` text NOT NULL,
	`kind` text DEFAULT 'omniroute' NOT NULL,
	`base_url` text NOT NULL,
	`enabled` integer DEFAULT true NOT NULL,
	`timeout_ms` integer DEFAULT 30000 NOT NULL,
	`max_retries` integer DEFAULT 2 NOT NULL,
	`rate_limit_per_minute` integer DEFAULT 60 NOT NULL,
	`priority` integer DEFAULT 0 NOT NULL,
	`last_test_ok` integer,
	`last_test_id` text,
	`created_by` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE TABLE `provider_secrets` (
	`provider_id` text PRIMARY KEY NOT NULL,
	`ciphertext` text NOT NULL,
	`iv` text NOT NULL,
	`key_version` integer DEFAULT 1 NOT NULL,
	`last4` text NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`provider_id`) REFERENCES `provider_configs`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `push_campaigns` (
	`id` text PRIMARY KEY NOT NULL,
	`title` text NOT NULL,
	`body` text NOT NULL,
	`link` text,
	`audience` text NOT NULL,
	`status` text DEFAULT 'sending' NOT NULL,
	`cursor` text,
	`target_count` integer DEFAULT 0 NOT NULL,
	`sent_count` integer DEFAULT 0 NOT NULL,
	`failed_count` integer DEFAULT 0 NOT NULL,
	`removed_count` integer DEFAULT 0 NOT NULL,
	`last_error` text,
	`sent_by` text,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE TABLE `push_devices` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`token` text NOT NULL,
	`platform` text NOT NULL,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`last_seen_at` integer,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE UNIQUE INDEX `push_devices_token_unique` ON `push_devices` (`token`);--> statement-breakpoint
CREATE INDEX `push_devices_user_idx` ON `push_devices` (`user_id`);--> statement-breakpoint
CREATE TABLE `rate_counters` (
	`bucket` text NOT NULL,
	`window_start` integer NOT NULL,
	`count` integer DEFAULT 0 NOT NULL,
	PRIMARY KEY(`bucket`, `window_start`)
);
--> statement-breakpoint
CREATE TABLE `user` (
	`id` text PRIMARY KEY NOT NULL,
	`firebase_uid` text,
	`email` text NOT NULL,
	`name` text DEFAULT '' NOT NULL,
	`email_verified` integer DEFAULT false NOT NULL,
	`role` text DEFAULT 'user' NOT NULL,
	`status` text DEFAULT 'active' NOT NULL,
	`birth_year` integer,
	`plan_id` text,
	`last_seen_at` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE UNIQUE INDEX `user_firebase_uid_unique` ON `user` (`firebase_uid`);--> statement-breakpoint
CREATE UNIQUE INDEX `user_email_unique` ON `user` (`email`);--> statement-breakpoint
CREATE INDEX `user_role_idx` ON `user` (`role`);--> statement-breakpoint
CREATE TABLE `user_preferences` (
	`user_id` text PRIMARY KEY NOT NULL,
	`response_language` text DEFAULT 'bn' NOT NULL,
	`response_style` text DEFAULT 'simple' NOT NULL,
	`dialect` text DEFAULT 'standard' NOT NULL,
	`memory_enabled` integer DEFAULT false NOT NULL,
	`ui_language` text DEFAULT 'bn' NOT NULL,
	`theme` text DEFAULT 'system' NOT NULL,
	`notifications_enabled` integer DEFAULT true NOT NULL,
	`updated_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL,
	FOREIGN KEY (`user_id`) REFERENCES `user`(`id`) ON UPDATE no action ON DELETE cascade
);
--> statement-breakpoint
CREATE TABLE `user_reports` (
	`id` text PRIMARY KEY NOT NULL,
	`user_id` text NOT NULL,
	`message_id` text NOT NULL,
	`conversation_id` text NOT NULL,
	`category` text NOT NULL,
	`note` text,
	`status` text DEFAULT 'open' NOT NULL,
	`resolved_by` text,
	`resolved_at` integer,
	`created_at` integer DEFAULT (unixepoch('subsec') * 1000) NOT NULL
);
--> statement-breakpoint
CREATE INDEX `reports_status_idx` ON `user_reports` (`status`,`created_at`);