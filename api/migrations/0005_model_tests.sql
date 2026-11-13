ALTER TABLE `ai_models` ADD `last_test_ok` integer;--> statement-breakpoint
ALTER TABLE `ai_models` ADD `last_test_reason` text;--> statement-breakpoint
ALTER TABLE `ai_models` ADD `last_test_error` text;--> statement-breakpoint
ALTER TABLE `ai_models` ADD `last_tested_at` integer;
