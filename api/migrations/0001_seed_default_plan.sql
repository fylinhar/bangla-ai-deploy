-- Default plan for new users. Admins can change these limits in the admin dashboard (Plans & limits).
INSERT OR IGNORE INTO plans (id, name, name_bn, daily_request_limit, monthly_request_limit, daily_token_limit, max_upload_mb, is_default)
VALUES ('pln_free', 'Free', 'ফ্রি', 50, 1000, 200000, 10, 1);
